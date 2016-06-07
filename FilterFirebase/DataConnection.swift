//
//  SubmitConnection.swift
//  enquetepr
//
//  Created by Wesley Mota on 13/05/16.
//  Copyright © 2016 WesleyMota. All rights reserved.
//

import Foundation
import Firebase

struct GroceryItem {
    
    var data: NSData = NSData()
    
    let key: String!
    let nome: String!
    let sobrenome: String!
    let ref: FIRDatabaseReference?
    
    // Initialize from arbitrary data
    init(nome: String, key: String = "", sobrenome: String) {
        self.key = key
        self.nome = nome
        self.sobrenome = sobrenome
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        nome = snapshot.value!["nome"] as! String!
        sobrenome = snapshot.value!["sobrenome"] as! String!
        ref = snapshot.ref
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "nome": nome,
            "sobrenome": sobrenome,
        ]
    }
    
}
