// DataTransferObject.swift created by Loudbook on 7/2/24.

import Foundation

struct DataTransferObject: Codable {
    var identifier: String
    var content: String
    
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding message: \(error)")
            return nil
        }
    }
    
    static func fromJSON(_ jsonString: String) -> DataTransferObject? {
        let decoder = JSONDecoder()
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
                
        do {
            let message = try decoder.decode(DataTransferObject.self, from: jsonData)
            return message
        } catch {
            print("Error decoding message: \(error)")
            return nil
        }
    }
}

