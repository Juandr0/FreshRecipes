//
//  RecepiesList.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-31.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseAuth


class RecepiesList : ObservableObject {
    @Published var allRecepies = [Recepie]()
    @Published var addedRecepieID = [String]()
    @Published var userItems = [Item]()
    @Published var boughtItems = [Item]()
    @Published var favoriteItems = [String]()
    
    
    var db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser

    
    init () {
        fetchData2()
        listenToFirestore()
        listenToUserRecepies()
        listenToUserFavorites()
    }
    
 
    func listenToUserRecepies()  {
        if let currentUser  {
            db.collection("users").document(currentUser.uid).collection("userItems").addSnapshotListener{snapshot, err in
                guard let snapshot = snapshot else {return}
                if let err = err {
                    print ("error getting documents \(err)")

                } else {
                    
                    if !self.userItems.isEmpty {
                        self.userItems.removeAll()
                    }
                    for document in snapshot.documents {
                        let result = Result {
                            try document.data(as: Item.self)
                        }
                        
                        switch result {
                           case .success(let item) :
                            self.userItems.append(item)
                           
                           case .failure(let err) :
                               print("Error decoding item \(err)")
                           }
                        }
                    }
                }
            }
        print("function listenToUserRecepies finished")
        }
    
    
    
    
//    func FetchAddedRecepies() {
//        for addedID in addedRecepieID {
//            for recepie in allRecepies {
//                if recepie.id == addedID {
//                    for itemToBuy in recepie.ingredients {
//                        userItems.append(Item(itemName: itemToBuy))
//                    }
//                }
//            }
//        }
//    }
//
    
    func fetchData2() {
        let dispatchGroup = DispatchGroup()

        db.collection("recepies").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }

            guard let snapshot = snapshot else {
                print("snapshot is nil")
                return
            }

            for document in snapshot.documents {
                let recepieResult = Result {
                    try document.data(as: Recepie.self)
                }

                switch recepieResult {
                case .success(var newRecepie):
                    dispatchGroup.enter() // Enter the dispatch group before fetching ingredients data

                    let ingredientsCollectionRef = document.reference.collection("ingredientsAsItem")
                    ingredientsCollectionRef.getDocuments { (ingredientsSnapshot, ingredientsErr) in
                        if let ingredientsErr = ingredientsErr {
                            print("Error getting ingredients documents: \(ingredientsErr)")
                            return
                        }

                        guard let ingredientsSnapshot = ingredientsSnapshot else {
                            print("ingredients snapshot is nil")
                            return
                        }

                        var newIngredientsAsItem = [IngredientsItem]() // Create a new array for the ingredients

                        for ingredientDocument in ingredientsSnapshot.documents {
                            let ingredientResult = Result {
                                try ingredientDocument.data(as: IngredientsItem.self)
                            }

                            switch ingredientResult {
                            case .success(let newIngredient):
                                newIngredientsAsItem.append(newIngredient)
                                print("New ingredient fetched: \(newIngredient.itemName)")
                            case .failure(let err):
                                print("IngredientResult fail: \(err)")
                            }
                        }

                        newRecepie.ingredientsAsItem = newIngredientsAsItem // Update the recepie with the new ingredients
                        self.allRecepies.append(newRecepie) // Append the recepie to the array

                        dispatchGroup.leave() // Leave the dispatch group after fetching ingredients data
                    }

                case .failure(let err):
                    print("\(err)")
                }
            }

            dispatchGroup.notify(queue: .main) {
                print("Function FetchData2 finished")
            }
        }
    }


        
    
    
    func FetchData() {
        
        db.collection("recepies").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("snapshot is nil")
                return
            }
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Recepie.self)
                    }
                
                    switch result {
                    case .success(let newRecepie) :
                        //adda alla items här
                        //newRecepie.ingredientsAsItem
                        
                        self.allRecepies.append(newRecepie)
                    case .failure(let err) :
                        Swift.print("\(err)")
                    }
                    
                    }
                
            }
        print("function FetchData finished")
        }
    
    
    func listenToFirestore() {
        guard let currentUser = currentUser else {
            print("Current user is nil")
            return
        }
        
        db.collection("users").document(currentUser.uid).collection("addedRecepieID").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }
            
            if !self.addedRecepieID.isEmpty {
                self.addedRecepieID.removeAll()
            }
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    self.addedRecepieID.append(document.documentID)
                }
            }
        }
        
        print("Function listenToFirestore finished")
    }
    
    
    
    
    func listenToUserFavorites() {
        guard let currentUser = currentUser else {
            print("Current user is nil")
            return
        }
        
        db.collection("users").document(currentUser.uid).collection("favorites").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting favorites: \(error)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }
            
            if !self.favoriteItems.isEmpty {
                self.favoriteItems.removeAll()
            }
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    self.favoriteItems.append(document.documentID)
                }
            }
        }
        
        print("Function listenToFavoritesList finished")
    }
    

    }




//
//struct IngredientsItem : Identifiable, Codable, Hashable{
//
//    @DocumentID var id : String?
//    var itemName : String
//    var itemQuantity : Double?
//    var itemMeasurement : String?
//}

    
        

        
    
    

