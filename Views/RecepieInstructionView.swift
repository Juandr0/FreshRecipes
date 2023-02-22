//
//  RecepieInstructionView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-06.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct RecepieInstructionView: View {
    @ObservedObject var recepies : RecepiesList
    let currentRecepie : Recepie
    @State var isCollapsed = true
    @State var isRecepieFavouriteMarked = false

    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    var body : some View {
     
        VStack {
            HStack {
                Text("\(currentRecepie.name)")
                    .font(.title)
                    .padding(.leading, 20)
                Spacer()
            }
                
            ZStack{
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
                VStack{
                    FavoriteMark(recepies : recepies,
                                 isRecepieFavouriteMarked : $isRecepieFavouriteMarked,
                                 currentRecepie: currentRecepie)
                }
               
            }
            VStack{
                HStack {
                    Spacer()
                    Text("Allergiinformation")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.isCollapsed.toggle()
                        }
                    Image(systemName: "triangle.tophalf.filled" )
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(isCollapsed ? 90 : 180))
                        .animation(isCollapsed ? .easeInOut(duration: 0.1)  : .default)
                        .onTapGesture {
                            self.isCollapsed.toggle()
                        }
                    Spacer()
                    HStack {
                        Image(systemName: "clock")
                        Text("\(currentRecepie.cookingtimeMinutes) min")
                    } .padding(.trailing, 20)
                }
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
            List (currentRecepie.instructions, id: \.self) {text in
                Text(text)
            }.listStyle(.plain)
    }


    
}


struct FavoriteMark : View {
    @ObservedObject var recepies : RecepiesList
    @Binding var isRecepieFavouriteMarked : Bool
    let db = Firestore.firestore()
    let currentRecepie : Recepie
    let currentUser = Auth.auth().currentUser
    
    var body : some View {
            HStack{
                Spacer()
                Button(action: {
                    
                    if let currentUser {
                        isRecepieFavouriteMarked = !isRecepieFavouriteMarked
                        let docRef = db.collection("users").document(currentUser.uid).collection("favorites").document(currentRecepie.id!)

                        if isRecepieFavouriteMarked {
                            docRef.setData([:])
                            isRecepieFavouriteMarked = true
                        } else {
                            docRef.delete()
                            isRecepieFavouriteMarked = false
                            recepies.favoriteItems.removeAll(where: {$0 == currentRecepie.id})
                        }
                    }
                }) {
                    Image(systemName: isRecepieFavouriteMarked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .topTrailing)
                        .foregroundColor(.red)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 145, trailing: 0))
                }
                .contentShape(Rectangle())
            }.onAppear{
                checkForFavorite()
            }
    }
    
    
    func checkForFavorite() {
        if currentUser != nil {
            let recepieID = currentRecepie.id
            if recepies.favoriteItems.contains(recepieID ?? "0"){
                isRecepieFavouriteMarked = true
            }
        }
    }
    
}
