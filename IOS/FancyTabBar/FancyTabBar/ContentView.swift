//
//  ContentView.swift
//  FancyTabBar
//
//  Created by Rawan Abou Dehn on 22/03/2021.
//

import SwiftUI

struct ContentView: View {
	@State private var index = 0 // track which button is pressed
	
    var body: some View {
//        Text("Hello, world!")
//            .padding()
		VStack { // vertical stack
			// stack views on top of each other
			ZStack { // render view/color based on index
				if(index == 0) {
					Color.black.opacity(0.05)
				}
				else if(index == 1) {
					Color.yellow.opacity(0.05)
				}
				else if(index == 2) {
					Color.blue.opacity(0.05)
				}
				else if(index == 3) {
					Color.orange.opacity(0.05)
				}
				
				Text("Hello")
				
			}
			
			//Spacer() // add some space
			//CircleTab()
			CircleTab(index: $index) // pass variable to CircleTab (two way binding)

		}
		.edgesIgnoringSafeArea(.top)
		//.background(Color.black.opacity(0.05)
						//.edgesIgnoringSafeArea(.top)) // fill all the way to the top
    }
}

// deifines what is shown in the previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		// sshow content view
        ContentView()
    }
}
