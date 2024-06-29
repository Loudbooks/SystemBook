// ProcessListDTO.swift created by Loudbook on 6/27/24.

import Foundation

struct ProcessListDTO: Decodable {
    let checked: Int64
    let processes: [ProcessDTO]
}
