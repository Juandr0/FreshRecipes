//
//  RecepieInstructionView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-06.
//

import Foundation
import SwiftUI

struct RecepieInstructionView: View {
    let currentRecepie : Recepie
    @State var isCollapsed = true

    
    var body : some View {
     
        VStack {
            Text("\(currentRecepie.name)")
                .font(.title)

            AsyncImage(url: URL(string: currentRecepie.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "takeoutbag.and.cup.and.straw")
           
            }
            .frame( height: 150)
            .cornerRadius(5)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            HStack {
                Spacer()
                Spacer()
                Text("Allergiinformation")
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.isCollapsed.toggle()
                    }.padding(.bottom, 10)
                Image(systemName: "triangle.tophalf.filled" )
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(isCollapsed ? 90 : 180))
                    .animation(.default)
                    .onTapGesture {
                        self.isCollapsed.toggle()
                    }
                Spacer()
                
                HStack {
                    Image(systemName: "clock")
                    Text("\(currentRecepie.cookingtimeMinutes) min")
                } .padding(.trailing, 20)
            }
            
            if !isCollapsed {
                ForEach (currentRecepie.allergenics, id: \.self) { text in
                    HStack{
                        Spacer()
                        Text(text)
                        Spacer()
                    }
                }
            }
        }
        
    
   
      
            
        Section() {
            List (currentRecepie.instructions, id: \.self) {text in
                Text(text)
            }.listStyle(.plain)
            Spacer()
        }
       
    }
    
    

    
}

