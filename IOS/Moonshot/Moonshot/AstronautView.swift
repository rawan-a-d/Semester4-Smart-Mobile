//
//  AstronautView.swift
//  Moonshot
//
//  Created by Rawan Abou Dehn on 01/04/2021.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    // defined here because it is not needed in MissionView
    var missions: [Mission] = Bundle.main.decode("missions.json") // current astronaut's missions
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    // missions
                    ForEach(self.missions) { mission in
                            HStack {
                                // image
                                Image(mission.image)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule()
                                    .stroke(Color.primary,
                                            lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading) {
                                    // name
                                    Text(mission.displayName)
                                        .font(.headline)
                                    // date
                                    Text(mission.formattedLaunchDate)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 25)

                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    
    init(astronaut: Astronaut) {
        self.astronaut = astronaut
        
        // array for the crew
        var matches = [Mission]()
        
        // gather missions
        for item in self.missions {
            var crew = item.crew
            if crew.first(
                // where name of crew == astronaut id
                where: { $0.name == astronaut.id}) != nil {
                // add mission to array
                matches.append(item)
            }
        }
        
        self.missions = matches
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
