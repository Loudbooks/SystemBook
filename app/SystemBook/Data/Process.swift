// Process.swift created by Loudbook on 6/25/24.

import Foundation

struct Process: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let running: Bool
    let enabled: Bool
    let cpu: Double
    let memory: String
    let runningTime: String
}
