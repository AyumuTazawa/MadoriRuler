//
//  Databese.swift
//  MadoriRuler
//
//  Created by 田澤歩 on 2021/02/16.
//

import Foundation
import Firebase

class Database {
    
    var db: Firestore!
    
    func save(coordinate: CGPoint) {
        
        let x = Int(coordinate.x)
        let y = Int(coordinate.y)
        
        db = Firestore.firestore()
        db.collection("Coordinate").addDocument(data: [
            "x": x,
            "y": y
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
            }
        }
    }
    
    func fechData() {
        db = Firestore.firestore()
        db.collection("Coordinate").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }
    }
}
