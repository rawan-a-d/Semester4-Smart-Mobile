//
//  ContentView.swift
//  Moonshot
//
//  Created by Rawan Abou Dehn on 31/03/2021.
//

import SwiftUI

struct ContentView: View {
    //let astronauts = Bundle.main.decode("astronauts.json")
    
    // lists using generics
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var isShowingDate = true
    
    var body: some View {
        //Text("\(astronauts.count)")
                
        NavigationView {
            List(missions) { mission in
                // go to mission details when a row is pressed
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        //.aspectRatio(contentMode: .fit)
                        // or
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        //Text(mission.launchDate ?? "N/A")
                        
                        // toggles between showing launch dates and showing crew names.
                        Text(isShowingDate ? mission.formattedLaunchDate : mission.formattedCrew)
                            .lineLimit(1) // use only one line
                    }
                }
                
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingDate.toggle()
                }) {
                    Text("Date/Crew")
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
