// ProcessDTO.swift created by Loudbook on 6/27/24.

import Foundation

struct ProcessDTO: Decodable {
    let name: String
    let description: String
    let running: Bool
    let enabled: Bool
    let cpu: String
    let memory: String
    let time: String
}
