// WebsocketManager.swift created by Loudbook on 6/26/24.

import Foundation
import SocketIO
import SwiftUI
import Gzip

class WebsocketManager: ObservableObject {
    private let manager: URLSessionWebSocketTask
    private let monitoringProcess: Process? = nil
    
    @Published var processes: [Process] = []
    @Published var isLoading: Bool = true

    typealias MessageCallback = (URLSessionWebSocketTask.Message) -> Void
    private var handlers: [MessageCallback] = []
    
    init(address: String) {
        self.manager = URLSession.shared.webSocketTask(with: URL(string: address)!)
        manager.resume()

        listenForMessages()
        
        print("Intiation run")
        
        addMessageHandler { message in
            switch message {
            case .string(_):
                return
            case .data(let data):
                let decompressedData = try! data.gunzipped()
                let str = String(decoding: decompressedData, as: UTF8.self)
                
                let dto = self.stringToDTO(input: str)
                if dto == nil {
                    return
                }
                
                let dtoFinal = dto!
                
                switch dtoFinal.identifier {
                case "LIST":
                    let newProcessList = self.stringToProcess(input: dtoFinal.content)
                    
                    DispatchQueue.main.async {
                        self.processes = newProcessList

                        withAnimation {
                            self.isLoading = false
                        }
                    }
                default:
                    return
                }
            @unknown default:
                return
            }
        }
        
        Task {
            await requestProcesses()
        }
    }
    
    func listenForMessages() {
        manager.receive { result in
            switch result {
            case .success(let message):
                self.notifyHandlers(data: message)
                self.listenForMessages()
            case .failure(let error):
                print("Failed with error: " + error.localizedDescription)
            }
        }
    }
    
    func addMessageHandler(_ handler: @escaping MessageCallback) {
        handlers.append(handler)
    }
    
    func removeMessageHandler(_ handler: @escaping MessageCallback) {
        if let index = handlers.firstIndex(where: { $0 as AnyObject === handler as AnyObject }) {
            handlers.remove(at: index)
        }
    }
    
    func sendString(identifier: String, message: String, completionHandler: @escaping ((any Error)?) -> Void) {
        let dto = DataTransferObject(identifier: identifier, content: message)
        let jsonString = try! JSONEncoder().encode(dto)
        let compressedData = try! jsonString.gzipped()

        manager.send(URLSessionWebSocketTask.Message.data(compressedData), completionHandler: completionHandler)
    }
    
    private func notifyHandlers(data: URLSessionWebSocketTask.Message) {
        for handler in handlers {
            handler(data)
        }
    }
    
    private func stringToDTO(input: String) -> DataTransferObject? {
        return DataTransferObject.fromJSON(input)
    }
    
    private func stringToProcess(input: String) -> [Process] {
        let data = input.data(using: .utf8)!
        let processListDTO: ProcessListDTO = try! JSONDecoder().decode(ProcessListDTO.self, from: data)
        
        return processListDTO.processes.map({
            Process.fromDTO(processDTO: $0)
        })
    }
    
    func requestProcesses() async {
        await withCheckedContinuation { continuation in
            self.sendString(identifier: "LIST", message: "") { response in
                continuation.resume()
            }
        }
    }
}
