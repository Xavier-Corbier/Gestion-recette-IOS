//
//  CategorieRecetteService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation


import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CategorieRecetteServiceObserver {
    func emit(to: [String])
}

class CategorieRecetteService {
    private let firestore = Firestore.firestore()
    private var tabObserver : [CategorieRecetteServiceObserver] = []
    private var tabCategorieRecette : [String] {
        didSet {
            for observer in tabObserver {
                observer.emit(to: tabCategorieRecette)
            }
        }
    }
    
    init(){
        self.tabCategorieRecette = []
    }
    
    func addObserver(observer : CategorieRecetteServiceObserver){
        self.tabObserver.append(observer)
        observer.emit(to: tabCategorieRecette)
    }
    
    func deleteCategorie(id : String){
        firestore.collection("categories-recettes").document("\(id)").delete() {
            (error) in if let _ = error {
                print("Error getting document : \(String(describing: error))")
            }
        }
    }
    
    func deleteCategorie(nom : String){
        firestore.collection("categories-recettes").whereField("nomCategorie", isEqualTo: nom)
            .getDocuments{
            (querySnapshot, err) in
            if let err = err {
                print("Error getting document : \(err)")
            }
            else if querySnapshot != nil && querySnapshot!.documents.count == 1 {
                // on la trouvé on le suprime 
                self.deleteCategorie(id: querySnapshot!.documents[0].documentID)
            }
        }
    }
    
    func addCategorie(nom:String){
        checkIfCreateCategorie(nom:nom){
            result in
            if result {
                self.firestore.collection("categories-recettes").addDocument(data: ["nomCategorie" : nom]){
                    (error) in
                    if let _ = error {
                        print("Error getting document : \(String(describing: error))")
                    }
                }
            }
        }
    }
    
    func checkIfCreateCategorie(nom : String, action : ((Bool) -> Void)?){
        firestore.collection("categories-recettes").whereField("nomCategorie", isEqualTo: nom)
            .getDocuments{
            (querySnapshot, err) in
            if let err = err {
                print("Error getting document : \(err)")
                action?(false)
            }
            else if querySnapshot != nil && querySnapshot!.documents.count < 1 {
                // Il n'y a pas de catégorie avec ce nom
                action?(true)
            }
            else{
                action?(false)
            }
        }
    }
    
    func getAllCategorieRecette(){
        firestore.collection("categories-recettes").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabCategorieRecette = documents.map{
                (doc) -> String in
                return doc["nomCategorie"] as? String ?? ""
            }
        }
    }
}
