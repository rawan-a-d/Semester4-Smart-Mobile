//
//  ContentView.swift
//  CameraApp
//
//  Created by Rawan Abou Dehn on 16/04/2021.
// https://www.youtube.com/watch?v=Y-65T0YBOm4

import SwiftUI

struct ContentView: View {
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var image: UIImage?
    
    var body: some View {
        
        NavigationView {
            VStack {
                Image(uiImage: image ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .frame(width: 300, height: 300)
                
                Button("Choose Picture") {
                    self.showSheet = true
                }.padding()
                .actionSheet(isPresented: $showSheet) {
                    ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [.default(Text("Photo Library")) {
                        // open photo library
                        self.showImagePicker = true
                        self.sourceType = .photoLibrary
                    },
                    .default(Text("Camera")) {
                        // open camera
                        self.showImagePicker = true
                        self.sourceType = .camera
                    },
                    .cancel()
                    
                    
                    ])
                }
            }
            .navigationTitle("Camera Demo")
        }
        .sheet(isPresented: $showImagePicker) {
            //Text("MODAL")
            ImagePicker(image:
                            $image, isShown: $showImagePicker, sourceType: self.sourceType)
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
