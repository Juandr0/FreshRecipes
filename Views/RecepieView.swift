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
    
    var body: some View {
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
        }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
}


//struct RecepieView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecepieView()
//    }
//}
