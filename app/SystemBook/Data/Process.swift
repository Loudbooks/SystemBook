// Process.swift created by Loudbook on 6/25/24.

import Foundation

struct Process: Identifiable {
    let id = UUID()
    
    let name: String
    let description: String
    let running: Bool
    let enabled: Bool
    let cpu: String
    let memory: String
    let time: String
    
    static func fromDTO(processDTO: ProcessDTO) -> Process {
        return Process(
            name: processDTO.name, description: processDTO.description, running: processDTO.running, enabled: processDTO.enabled, cpu: processDTO.cpu, memory: processDTO.memory, time: processDTO.time
            )
    }
}
