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
    
    
    var db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser

    
    init () {
        FetchData()
        listenToFirestore()
        listenToUserRecepies() 
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
    
    
    
    func FetchData() {
        db.collection("recepies").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let result = Result {
                        try document.data(as: Recepie.self)
                    }
                
                    switch result {
                    case .success(let newRecepie) :
                        self.allRecepies.append(newRecepie)
                    case .failure(let err) :
                        print("\(err)")
                    }
                    
                    }
                }
            }
        }
    
    
    func listenToFirestore()  {
        if let currentUser  {
            db.collection("users").document(currentUser.uid).collection("addedRecepieID").addSnapshotListener{snapshot, err in
                guard let snapshot = snapshot else {return}
                if let err = err {
                    print ("error getting documents \(err)")

                } else {
                    if self.addedRecepieID.count >= 0 {
                        self.addedRecepieID.removeAll()
                    }
                    for document in snapshot.documents {
                        self.addedRecepieID.append(document.documentID)
                        }
                    }
                }
            }
        }
    }

    
   

    
        

        
    
    

