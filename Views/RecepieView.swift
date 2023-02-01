//
//  RecepieView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI
import Firebase

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}

struct RecepieView: View {
    let db = Firestore.firestore()
    @StateObject var recepiesList = RecepiesList()
    @State var searchInput = ""
    
    var body: some View {
        
        VStack {
            TextField("Sök på ingredienser och maträtter..", text: $searchInput)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
            //Skapa en picker eller liknande här som agerar drop down för filtrering av ingredienser
   
            List() {
                
                ForEach(recepiesList.recepies) {recepie in
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
                                                //Set isAdded to !isAdded
                                                
                                                print("Add to cart")
                                            }){
                                                Image(systemName: recepie.isAdded ? "minus.circle" : "cart")
                                                
                                            }
                                            .frame(width: 50)
                                            .buttonStyle(.bordered)
                                            .background(recepie.isAdded ? Color.red : Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 15))
                                        }
                                    }
                                }
                            }
                    }
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



//struct RecepieView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecepieView()
//    }
//}
