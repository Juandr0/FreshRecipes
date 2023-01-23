//
//  StartPageView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI

struct StartPageView: View {
    var body: some View {
        
        VStack {
            Spacer()
            Button(action: {
                
            }) {
                HStack {
                    Text("Recept")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "fork.knife")
                }
            
                
            }
            
            Spacer()
            Button(action: {
                
            }) {
                HStack {
                    Text("Inköpslista")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "list.clipboard")
                } 
    
            }
            Spacer()
        }
       
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        
    }
}


//struct StartPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartPageView()
//    }
//}
