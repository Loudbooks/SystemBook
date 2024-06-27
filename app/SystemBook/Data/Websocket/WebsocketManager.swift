// WebsocketManager.swift created by Loudbook on 6/26/24.

import Foundation
import SocketIO
import SwiftUI

class WebsocketManager: ObservableObject {
    private let manager: URLSessionWebSocketTask
    private let monitoringProcess: Process? = nil
    
    @Published var processes: [Process] = []
    
    typealias MessageCallback = (URLSessionWebSocketTask.Message) -> Void
    private var handlers: [MessageCallback] = []
    
    init(address: String) {
        self.manager = URLSession.shared.webSocketTask(with: URL(string: address)!)
        manager.resume()
        
        manager.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                self.notifyHandlers(data: message)
            case .failure(let error):
                print("Failed with error: " + error.localizedDescription)
            }
        })
        
        print("Intiation run")
        
        addMessageHandler { message in
            switch message {
            case .string(let text):
                let newProcessList = self.stringToProcess(input: text)
                
                DispatchQueue.main.async {
                    self.processes = newProcessList
                }
                return
            case .data(_):
                return
            @unknown default:
                return
            }
            
        }
        
        sendString(message: "LIST")
    }
    
    func addMessageHandler(_ handler: @escaping MessageCallback) {
        handlers.append(handler)
    }
    
    func removeMessageHandler(_ handler: @escaping MessageCallback) {
        if let index = handlers.firstIndex(where: { $0 as AnyObject === handler as AnyObject }) {
            handlers.remove(at: index)
        }
    }
    
    func sendString(message: String) {
        manager.send(URLSessionWebSocketTask.Message.string(message)) { _ in
            
        }
    }
    
    private func notifyHandlers(data: URLSessionWebSocketTask.Message) {
        for handler in handlers {
            handler(data)
        }
    }
    
    private func stringToProcess(input: String) -> [Process] {
        let data = input.data(using: .utf8)!
        let processListDTO: ProcessListDTO = try! JSONDecoder().decode(ProcessListDTO.self, from: data)
                
        return processListDTO.processes.map({
            Process.fromDTO(processDTO: $0)
        })
    }
}
