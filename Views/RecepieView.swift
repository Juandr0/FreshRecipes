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
    @ObservedObject var recepies : RecepiesList

    @State var searchQuery = ""
    @State var signedIn = false
    let currentUser = Auth.auth().currentUser
    
    
    var body: some View {
        NavigationView {
            VStack {
                List() {
                    ForEach(recepies.allRecepies.filter {
                        
                        //Filters what's displayed by using the searchQuery. I.e: User types "kyckling" in the searchbar and since it gets a match in the ingredientslist of 'flygande jacob', it will display this dish
                        self.searchQuery.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchQuery) || $0.ingredients.description.localizedCaseInsensitiveContains(self.searchQuery) || $0.allergenics.description.localizedCaseInsensitiveContains(self.searchQuery)
                    }, id: \.self) {recepie in
                        NavigationLink(destination: RecepieInstructionView(currentRecepie: recepie)){
                            RecepiesListView(recepies: recepies, db: db, recepie: recepie)
                        }
                        .navigationTitle("Recept")
                    }
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    .listStyle(.inset)
                    .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always) , prompt: "Sök på maträtter eller ingredienser")
            }
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
    

}
    


struct RecepiesListView: View{
    
    
    @ObservedObject var recepies : RecepiesList
    @State var isRecepieAddedToDb = false
    @State var searchQuery = ""
    
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
                                    //Removes item from cart
                                    let searchString = recepie.id
                                    if let currentUser {
                                        
                                    var docRef = db.collection("users").document(currentUser.uid).collection("userItems")
                                        
                                        if recepies.addedRecepieID.contains(searchString!){
                                            
                                        //dessa rader måste vara problemet
//                                        for recepieIngredient in recepie.ingredients {
//                                            for addedIngredient in recepies.userItems{
//                                                 if recepieIngredient == addedIngredient.itemName{
//                                                     docRef.document(addedIngredient.id!).delete()
//                                                 }
//                                             }
//                                         }
                                          
                                            //Uppdaterad version av koden ovan, kör denna framöver och se om buggen har försvunnit
                                            //Note: Samma fel.

                                            for recepieIngredient in recepie.ingredients {
                                                if let index = recepies.userItems.firstIndex(where: { $0.itemName == recepieIngredient }) {
                                                    if index >= 0 && index < recepies.userItems.count {
                                                        docRef.document(recepies.userItems[index].id!).delete()
                                                    } else {
                                                        print("Index out of range")
                                                    }
                                                } else {
                                                    print("Item not found")
                                                }
                                            }
                                      
                                          
                                            
                                        print("DeleteLoop FB ITEMS Complete")
                                                db.collection("users").document(currentUser.uid).collection("addedRecepieID").document(recepie.id!).delete()
                                                isRecepieAddedToDb = false
                                        print("recepie ID removed from DB")
                                         
                                        }
                                  
                                     else {

                                           var docRef = db.collection("users").document(currentUser.uid)
                                            docRef.collection("addedRecepieID").document(recepie.id!).setData([:])
                                
                                            for recepieIngredient in recepie.ingredients {
                                                let newItem = Item(itemName: recepieIngredient)
                                                docRef.collection("userItems").document().setData([
                                                
                                                    "itemName" : newItem.itemName,
                                                    "isBought" : newItem.isBought

                                                ])
                                            }
                                           
                                            isRecepieAddedToDb = true
                                         print("added items Complete")
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
            .padding(EdgeInsets(top: 30, leading: 0, bottom: 20, trailing: 0))
           
    }
    
    func checkForRecepie() {
        isRecepieAddedToDb = recepies.addedRecepieID.contains(recepie.id!)
    }
    
    
    }




//struct RecepieView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecepieView()
//    }
//}
