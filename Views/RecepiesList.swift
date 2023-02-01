//
//  RecepiesList.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-31.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift

class RecepiesList : ObservableObject {
    @Published var recepies = [Recepie]()
    var db = Firestore.firestore()
    
    init () {
        FetchData()
    }
    
    
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
                        self.recepies.append(newRecepie)
                    case .failure(let err) :
                        print("\(err)")
                    }
                    
//                    let newRecepie = Recepie(id: document.documentID,
//                                          name: document["name"] as! String,
//                                          portions: document["portions"] as! Int,
//                                          ingredients: document["ingredients"] as! [String],
//                                          allergenics: document["allergenics"] as! [String],
//                                          instructions: document["instructions"] as! [String],
//                                          cookingtimeMinutes: document["cookingtimeMinutes"] as! Int)
//
//                    self.recepies.append(newRecepie)
                    }
                }
            }
        }
        

        
    }
    

