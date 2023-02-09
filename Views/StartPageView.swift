//
//  StartPageView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI
import Firebase

struct StartPageView: View {
    @StateObject var recepies = RecepiesList()
    let db = Firestore.firestore()
    
    var body: some View {
        
        TabView {
            RecepieView(recepies : recepies)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Recepies")
                }
    
            VStack {
                ShoppingListView(recepies : recepies)
            }
                    .tabItem{
                        Image(systemName: "list.clipboard")
                        Text("Shopping list")
                  
            }
        }
        
        
        
        //        NavigationView {
        //
        //            VStack {
        //                Text("Fresh Recepies")
        //                    .font(.title3)
        //                Spacer()
        //                NavigationLink(destination: RecepieView()) {
        //                    HStack{
        //                        Text("Recept")
        //                        Spacer()
        //                        Image(systemName: "fork.knife")
        //                    }
        //                }
        //
        //                NavigationLink(destination: ShoppingListView()) {
        //                    HStack{
        //                        HStack {
        //                            Text("Inköpslista")
        //                            Spacer()
        //                            Image(systemName: "list.clipboard")
        //                        }
        //                    }
        //                }
        //               Spacer()
        //
        //            }
        //            .padding(15)
        //            .buttonStyle(.borderedProminent)
        //            .controlSize(.large)
        //            .font(.title2)
        //            .onAppear{
        //
        //
        //
        ////                db.collection("recepies").document().setData([
        ////                    "name" : nyttRecept.name,
        ////                    "portions" : nyttRecept.portions,
        ////                    "ingredients" : nyttRecept.ingredients,
        ////                    "allergenics" : nyttRecept.allergenics,
        ////                    "instructions" : nyttRecept.instructions,
        ////                    "cookingtimeMinutes" : nyttRecept.cookingtimeMinutes
        ////                ])
        //            }
        //        }
        //        .navigationTitle("Text")
        //    }
    }
    
    
    //struct StartPageView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        StartPageView()
    //    }
    //}
}
