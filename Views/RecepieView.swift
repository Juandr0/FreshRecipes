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
    @State var filterQuery = ""
    @State var signedIn = false
    @State var excludeRecepie = false

    @State var isFilterViewCollapsed = true
    @State var filterListExcluded = [String]()
    let currentUser = Auth.auth().currentUser
    
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Text(isFilterViewCollapsed ? "Klicka här för att filtrera din sökning" : "Klicka här för att gömma dina filter")
                        .onTapGesture {
                            self.isFilterViewCollapsed.toggle()
                        }
                    Image(systemName: "magnifyingglass" )
                        .rotationEffect(.degrees(isFilterViewCollapsed ? 0 : 45))
                        .animation(isFilterViewCollapsed ? .easeInOut(duration: 0.1)  : .default)
                        .onTapGesture {
                            self.isFilterViewCollapsed.toggle()
                        }
                    Spacer()
                }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                if !isFilterViewCollapsed {
                    VStack{
                        HStack{
                            TextField("Skriv här för att lägga till ett nytt filter", text: $filterQuery)
                                .padding(.leading,20)
  
                            Spacer()
                            Button(action: {
                                if (filterQuery != "") {
                                    filterListExcluded.append(filterQuery.lowercased())
                                    filterQuery = ""
                                }
                            }){
                                Image(systemName: "minus.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.red)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20))
                            }
                          
                     
                            Spacer()
                        }
                        if (filterQuery != "" && filterListExcluded.isEmpty) {
                            Text("Skriv in sökordet och klicka på knappen för att exkludera ingredienser eller hela maträtter från din sökning. Skriv exempelvis 'fisk' eller 'flygande jacob'")
                                .foregroundColor(.gray)
                        }
                        List(){
                            if !filterListExcluded.isEmpty {
                                ForEach(filterListExcluded, id: \.self) {ingredient in
                                    HStack{
                                       
                                        Image(systemName: "hand.thumbsdown.fill")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.red)
                                        Text(ingredient.prefix(1).capitalized + ingredient.dropFirst())
                                        Spacer()
                                        Button(action: {
                                            filterListExcluded.removeAll(where: {$0 == ingredient})
                                        }){
                                            Image(systemName: "minus.circle")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.red)                
                                        }
                                    }
                                }
                            }
                        }.listStyle(.inset)
                            .listRowBackground(Color.accentColor)
                            Spacer()
                    }.padding(.leading, 20)
                }
                List() {
                    ForEach(recepies.allRecepies.filter {
                        //Filters what's displayed by using the searchQuery. I.e: User types "kyckling" in the searchbar and since it gets a match in the ingredientslist of 'flygande jacob', it will display this dish
                            self.searchQuery.isEmpty ? true :
                                $0.name.localizedCaseInsensitiveContains(self.searchQuery) || $0.ingredients.description.localizedCaseInsensitiveContains(self.searchQuery) || $0.allergenics.description.localizedCaseInsensitiveContains(self.searchQuery)
                    }, id: \.self) {recepie in
                            
                            //Recepies that contains filtered out words is removed here
                        if (!recepie.allergenics.contains(where: { filterListExcluded.contains($0) }) && !recepie.ingredients.contains(where: { filterListExcluded.contains($0) }) &&
                            !filterListExcluded.contains(recepie.name.lowercased()))
                        {
                            
                            //Displays the recepies
                                NavigationLink(destination: RecepieInstructionView(recepies: recepies, currentRecepie: recepie)){
                                    RecepiesListView(recepies: recepies, db: db, recepie: recepie)
                                }
                                .navigationTitle("Recept")
                        }
                    }
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    .listStyle(.inset)
                    .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always) , prompt: "Sök på maträtter eller ingredienser")
            }
        }

    }
    

}
    


struct RecepiesListView: View{

    @ObservedObject var recepies : RecepiesList
    @State var isRecepieAddedToDb = false
    @State var isRecepieFavouriteMarked = false
    @State var searchQuery = ""
    @State var doesItemExist = false
    
    
    let currentUser = Auth.auth().currentUser
    let db : Firestore
    let recepie : Recepie
    
    
    var body : some View {
        Section {
            VStack {
                HStack {
                    if isRecepieFavouriteMarked {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 15, height: 15)
                }
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
                                    let docRef = db.collection("users").document(currentUser.uid).collection("userItems")
                                    if recepies.addedRecepieID.contains(searchString!){
                                        for recipeItem in recepie.ingredientsAsItem! {
                                            if let userIndex = recepies.userItems.firstIndex(where: { $0.itemName == recipeItem.itemName }) {
                                                if userIndex < recepies.userItems.count {
                                                    let userItem = recepies.userItems[userIndex]
                                                    if userItem.itemQuantity > recipeItem.itemQuantity! {
                                                        let newValue = userItem.itemQuantity - recipeItem.itemQuantity!
                                                        db.collection("users").document(currentUser.uid).collection("userItems").document(userItem.id!).updateData([
                                                            "itemQuantity": newValue
                                                        ])
                                                        print("Det finns mer av \(recipeItem.itemName) än receptet, kvantiteten med \(String(describing: recipeItem.itemQuantity))")
                                                    } else {
                                                        docRef.document(userItem.id!).delete()
                                                    }
                                                } else {
                                                    print("Index out of range")
                                                }
                                            } else {
                                                print("Item not found")
                                            }
                                        }

                                        print("DeleteLoop FB ITEMS Complete")
                                        
                                        if recepie.id != nil {
                                            db.collection("users").document(currentUser.uid).collection("addedRecepieID").document(recepie.id!).delete()
                                            isRecepieAddedToDb = false
                                            print("recepie ID removed from DB")
                                        } else {
                                            print("Error: recepie.id is nil")
                                        }
                                        
                                        
                                        
                                    }
                                    //Adds items to the cart
                                    else {

                                        let docRef = db.collection("users").document(currentUser.uid)
                                        docRef.collection("addedRecepieID").document(recepie.id!).setData([:])
                                        
                                        for recepieItem in recepie.ingredientsAsItem! {
                                            doesItemExist = recepies.checkIfItemIsAdded(searchWord: recepieItem.itemName.lowercased())
                                            if !doesItemExist {
                                                let newItem = Item(itemName: recepieItem.itemName,
                                                                   itemQuantity: recepieItem.itemQuantity!,
                                                                   itemMeasurement: recepieItem.itemMeasurement!,
                                                                   isBought: false)
                                                docRef.collection("userItems").document().setData([
                                                    
                                                    "itemMeasurement" : newItem.itemMeasurement,
                                                    "itemQuantity" : newItem.itemQuantity,
                                                    "itemName" : newItem.itemName,
                                                    "isBought" : newItem.isBought
                                                    
                                                ])
                                            } else {
                                                print("\(recepieItem.itemName) - Finns redan, adderar kvantiteten med \(String(describing: recepieItem.itemQuantity))")

                                                    for recipe in recepies.userItems {
                                                        if recipe.itemName.lowercased() == recepieItem.itemName.lowercased() {
                                                            let newValue = recipe.itemQuantity + recepieItem.itemQuantity!
                                                            db.collection("users").document(currentUser.uid).collection("userItems").document(recipe.id!).updateData([
                                                                "itemQuantity" : newValue
                                                            ])
                                                        }
                                                    }
                                                doesItemExist = false
                                            }
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
                        }.onAppear{
                            checkForRecepie()
                            checkForFavorite()
                        }
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 30, leading: 0, bottom: 20, trailing: 0))
        
    }
    
    
    func checkForRecepie() {
        isRecepieAddedToDb = recepies.addedRecepieID.contains(recepie.id!)
    }
    
    func checkForFavorite() {
        if currentUser != nil {
            let recepieID = recepie.id
            if recepies.favoriteItems.contains(recepieID ?? "0"){
                isRecepieFavouriteMarked = true
            } else {
                isRecepieFavouriteMarked = false
            }
        }
    }
    
}


//struct RecepieView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecepieView()
//    }
//}
