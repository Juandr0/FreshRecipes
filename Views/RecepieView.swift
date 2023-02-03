//
//  RecepieView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}

struct RecepieView: View {
    let db = Firestore.firestore()
    @StateObject var recepies = RecepiesList()

    @State var searchInput = ""
    @State var signedIn = false
    let currentUser = Auth.auth().currentUser
    
    
    
    var body: some View {
        
        VStack {
            TextField("Sök på ingredienser och maträtter..", text: $searchInput)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            //Skapa en picker eller liknande här som agerar drop down för filtrering av ingredienser
            
            List() {
                ForEach(recepies.allRecepies) {recepie in
                    RecepiesListView(recepies: recepies, db: db, recepie: recepie)
                }
            }
            
        }.padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
            .listStyle(.insetGrouped)
        
            .onAppear{
                //init recept
                
                
                //                db.collection("recepies").document().setData( [
                //                    "name" : nyttRecept.name,
                //                    "portions" : nyttRecept.portions,
                //                    "ingredients" : nyttRecept.ingredients,
                //                    "allergenics" : nyttRecept.allergenics,
                //                    "instructions" : nyttRecept.instructions,
                //                    "cookingtimeMinutes" : nyttRecept.cookingtimeMinutes,
                //                    "isAdded" : nyttRecept.isAdded,
                //                    "imageUrl" : nyttRecept.imageUrl
                //
                //                ]
                //                )
                
                
            }
    }
}
    
 


struct RecepiesListView: View{
    
    
    @ObservedObject var recepies : RecepiesList
    @State var isRecepieAddedToDb = false
    
    let currentUser = Auth.auth().currentUser
    let db : Firestore
    let recepie : Recepie
    

    var body : some View {
            Section {
                VStack {
                    HStack {
                        Text(recepie.name)
                            .font(.title3)
                        Spacer()
                    }
                    HStack {
                        Button(action: {
                            //Send user to page that displays recepie,
                            print("Recepie info")
                        }){
                            AsyncImage(url: URL(string: recepie.imageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "takeoutbag.and.cup.and.straw")
                            }
                            .frame(width: 200, height: 100)
                            .cornerRadius(5)
                        }
                        
                        
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "clock")
                                Text("\(recepie.cookingtimeMinutes) min")
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    let searchString = recepie.id
                                    if recepies.addedRecepieID.contains(searchString!){
                                        if let currentUser {
                                            db.collection("users").document(currentUser.uid).collection("addedRecepieID").document(recepie.id!).delete()
                                                isRecepieAddedToDb = false
                                            print("removed from cart")
                                        }
                                      
                                    } else if !recepies.addedRecepieID.contains(searchString!){
                                        if let currentUser {
                                            db.collection("users").document(currentUser.uid).collection("addedRecepieID").document(recepie.id!).setData([:])
                                            isRecepieAddedToDb = true
                                            print("Added to cart")
                                        }
                                    }
                                }){
                                    Image(systemName: isRecepieAddedToDb ? "minus.circle" : "cart")
                                }
                                
                                .frame(width: 50, height: 35)
                                .buttonStyle(.bordered)
                                .background(isRecepieAddedToDb ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 2, trailing: 15))
                            }.onAppear(perform: checkForRecepie)
                        }
                    }
                }
            }
        }
    
    func checkForRecepie() {
        isRecepieAddedToDb = recepies.addedRecepieID.contains(recepie.id!)
    }
    
    
    }




struct RecepieView_Previews: PreviewProvider {
    static var previews: some View {
        RecepieView()
    }
}
