//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Rawan Abou Dehn on 31/03/2021.
//

import Foundation


// This extension convert a JSON object in a file into an array of a specific type (for example Astronaut)
//  if the file can’t be found, loaded, or decoded the app will crash.
extension Bundle {
    // decode method takes a file name and returns a list of Astronaut
    
    //func decode(_ file: String) -> [Astronaut] {
    func decode<T: Codable>(_ file: String) -> T { // using generics to load any kind of Codable data (T is a placeholder and means a List of the type, and it has to conform to Codable/Decodable)
        // find the file
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        // load that into data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        // pass to JSON decoder to decode it
        let decoder = JSONDecoder()
        
        // handle launchDate
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        // determines how it should decode dates
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        //guard let loaded = try? decoder.decode([Astronaut].self, from: data) else {
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        // return content
        return loaded
    }
}
