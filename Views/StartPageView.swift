//
//  StartPageView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI

struct StartPageView: View {
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text("Fresh Recepies")
                    .font(.title)
                Spacer()

                NavigationLink(destination: RecepieView()) {
                    HStack{
                        Text("Recept")
                        Spacer()
                        Image(systemName: "fork.knife")
                    }
                 
                }
          
                
                NavigationLink(destination: ShoppingListView()) {
                    HStack{
                        HStack {
                            Text("Inköpslista")
                            Spacer()
                            Image(systemName: "list.clipboard")
                           
                        }
                    }
                 
                }
               Spacer()
            }
            .padding(15)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .font(.title2)

        }
        .navigationTitle("Text")

        
    }
}


//struct StartPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartPageView()
//    }
//}
