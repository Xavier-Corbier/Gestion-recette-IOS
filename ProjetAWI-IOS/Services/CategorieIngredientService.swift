//
//  CategorieIngredientService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 27/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CategorieIngredientServiceObserver {
    func emit(to: [String])
}

class CategorieIngredientService {
    private let firestore = Firestore.firestore()
    private var tabObserver : [CategorieIngredientServiceObserver] = []
    private var tabCategorieIngredient : [String] {
        didSet {
            for observer in tabObserver {
                observer.emit(to: tabCategorieIngredient)
            }
        }
    }
    
    init(){
        self.tabCategorieIngredient = []
    }
    
    func addObserver(observer : CategorieIngredientServiceObserver){
        self.tabObserver.append(observer)
        observer.emit(to: tabCategorieIngredient)
    }
    
    func getAllCategorieIngredient(){
        firestore.collection("categories-ingrédients").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabCategorieIngredient = documents.map{
                (doc) -> String in
                return doc["nomCategorie"] as? String ?? ""
            }
        }

    }
    
    func deleteCategorie(nom : String){
        firestore.collection("categories-ingrédients").whereField("nomCategorie", isEqualTo: nom)
        .getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting document : \(err)")
            }
            else{
                if let data = querySnapshot {
                    for doc in data.documents {
                        self.firestore.collection("categories-ingrédients").document(doc.documentID).delete()
                    }
                }
            }
        }
    }
    
    func addCategorie(nom : String){
        firestore.collection("categories-ingrédients").addDocument(data: [
            "nomCategorie" : nom,
        ])
    }
}

