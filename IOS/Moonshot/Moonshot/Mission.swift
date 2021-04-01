//
//  Mission.swift
//  Moonshot
//
//  Created by Rawan Abou Dehn on 31/03/2021.
//

import Foundation

/* struct CrewRole: Codable {
    let name: String
    let role: String
} */

struct Mission: Codable, Identifiable {
    // Nested Struct
    // this struct is specifiically made to hold data about missions, se we can put it inside Mission
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    //let launchDate: String? // optional
    let launchDate: Date? // optional
    let crew: [CrewRole]
    let description: String
    
    // Computed properties
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    // format the date as string
    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        }
        // if no launch date
        else {
            return "N/A"
        }
    }
    
    var formattedCrew: String {
        var crewString: String = ""
        for(index, member) in crew.enumerated() {
            crewString += member.name
            
            if(index != crew.count - 1) {
                crewString += ", "
            }
        }
        
        return crewString

//        let formatter = ListFormatter()
//        
//        return formatter.string(from: crew) ?? ""
    }
}
