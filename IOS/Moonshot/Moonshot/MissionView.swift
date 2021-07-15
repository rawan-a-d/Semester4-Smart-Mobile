//
//  MissionView.swift
//  Moonshot
//
//  Created by Rawan Abou Dehn on 01/04/2021.
//


import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    // crew
    let astronauts: [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7) // 70%
                        .padding(.top)
                    
                    // date
                    Text(self.mission.formattedLaunchDate != "N/A" ? self.mission.formattedLaunchDate : "")
                    
                    Text(self.mission.description)
                        .padding()
                    
                    // crew
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            
                            HStack {
                                // image
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule()
                                    .stroke(Color.primary,
                                            lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading) {
                                    // name
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    // role
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle()) // remove the blue color which is used for the name and image

                    }
                    
                    Spacer(minLength: 25)
                    
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        // array for the crew
        var matches = [CrewMember]()
        
        for member in mission.crew {
            // first(where: ): takes a condition and sends back the first array element that matches it
            if let match = astronauts.first(
                where: { $0.id == member.name}) {
                // add crewMember to array
                matches.append(CrewMember(role: member.role, astronaut: match))
            }
            else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
        
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
