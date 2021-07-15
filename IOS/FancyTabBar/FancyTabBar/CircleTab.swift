//
//  CircleTab.swift
//  FancyTabBar
//
//  Created by Rawan Abou Dehn on 22/03/2021.
//

import SwiftUI

// SwiftUI Views
struct CircleTab: View {
	// Track which button is pressed
	//@State private var index = 0
	@Binding var index : Int // Binding is used to connect this value with the one in ContentView
	
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
		
		// Horizontal Stacks
		HStack {
			Button(action: { // on click
				index = 0
			}, label: {
				///*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
				VStack {
					if(self.index != 0) { // 0
						Image("home").foregroundColor(.black)
							.padding()
					}
					else { // if home
						Image("home")
							.foregroundColor(.white)
							.padding()
							.background(Color.red)
							.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//							.offset(y: -10) // move a bit up
//							.padding(.bottom, -10) // move down :)
						Text("Home")
							.foregroundColor(Color.black.opacity(0.7))
							//.font(.custom("Halvatica", size: 12))
							.font(.system(size: 13))
					}
					
				}
			})
			Spacer(minLength: 5) // add some space between them
			Button(action: {
				index = 1
			}, label: {
				VStack {
					if(self.index != 1) { // 0
						Image("search").foregroundColor(.black)
							.padding()
					}
					else { // if home
						Image("search")
							.foregroundColor(.white)
							.padding()
							.background(Color.red)
							.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//							.offset(y: -10) // move a bit up
//							.padding(.bottom, -10) // move down :)
						Text("Search")
							.foregroundColor(Color.black.opacity(0.7))
							.font(.system(size: 13))
					}
				}
			})
			Spacer(minLength: 5)
			Button(action: {
				index = 2
			}, label: {
				VStack {
					if(self.index != 2) { // 0
						Image("heart").foregroundColor(.black)
							.padding()
					}
					else { // if home
						Image("heart")
							.foregroundColor(.white)
							.padding()
							.background(Color.red)
							.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//							.offset(y: -10) // move a bit up
//							.padding(.bottom, -10) // move down :)
						Text("Likes")
							.foregroundColor(Color.black.opacity(0.7))
							.font(.system(size: 13))
					}
				}
			})
			Spacer(minLength: 5)
			Button(action: {
				index = 3
			}, label: {
				VStack {
					if(self.index != 3) { // 0
						Image("person").foregroundColor(.black)
							.padding()
					}
					else { // if home
						Image("person")
							.foregroundColor(.white)
							.padding()
							.background(Color.red)
							.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//							.offset(y: -10) // move a bit up
//							.padding(.bottom, -10) // move down :)
						Text("Person")
							.foregroundColor(Color.black.opacity(0.7))
							.font(.system(size: 13))
					}
				}
			})
		}
		//.padding(.vertical, 5)
		.padding(.horizontal, 25)
		//.padding(.horizontal, 10)

		.background(Color.white)
		.animation(.spring()) // animate
    }
}

struct CircleTab_Previews: PreviewProvider {
    static var previews: some View {
        //CircleTab()
		ContentView()
    }
}
