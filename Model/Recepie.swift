//
//  Recepie.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-31.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Recepie : Codable, Identifiable{
    
    @DocumentID var id            : String?
    var name                      : String
    var portions                  : Int
    var ingredients               : [String]
    var allergenics               : [String]
    var instructions              : [String]
    var cookingtimeMinutes        : Int
    var isAdded                   : Bool  //Ska tas bort
    var imageUrl                  : String
    
    

    
//    func FetchAllergenics () {
//
//    }
}
