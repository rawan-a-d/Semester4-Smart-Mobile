//
//  Astronaut.swift
//  Moonshot
//
//  Created by Rawan Abou Dehn on 31/03/2021.
//

import Foundation

// Codable: create struct from JSON (other aliases Encodable, Decodable)
// Identifiable: use an array of astronauts in a ForEach and use id to identify items
struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
