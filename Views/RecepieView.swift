//
//  RecepieView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI
import Firebase

extension String {
    func load() -> UIImage {
        do {
            //Converts string to URL
            guard let url = URL(string: self) else {
                return UIImage()
            }
            
            //Convert url to data
            let data: Data = try
            Data(contentsOf: url)
            
            //creates UIImage ojbect from data
            return UIImage(data: data)
            ?? UIImage()
            
        }catch {
            
        }
        return UIImage()
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
                            Text(recepie.name)
                                .font(.title3)
                            HStack {
                                Image(uiImage: "https://www.nrm.se/images/18.12fc790b170e43ac14850734/1586852594332/s%C3%A4des%C3%A4rla600x350.png".load())
                                    .resizable()
                                    .scaledToFit()

                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "clock")
                                        Text("\(recepie.cookingtimeMinutes) min")
                                        
                                    }

                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            //Send user to page that displays recepie,
                                            
                                            print("klick")
                                        }){
                                            Image(systemName: "cart")
                                        }
                                        .buttonStyle(.bordered)
                                        .background(.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                }
                                
                            }
                            
                  
                        }
                }
                
                //.listSectionSeparator(.visible)
            }//.padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
        }
    }
}


//struct RecepieView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecepieView()
//    }
//}
