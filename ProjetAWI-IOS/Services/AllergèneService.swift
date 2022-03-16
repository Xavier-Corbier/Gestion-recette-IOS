//
//  AllergèneService.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AllergèneListServiceObserver {
    func emit(to: [Allergène])
    func emit(to: Result<String,AllergèneListViewModelError>)
}

protocol AllergèneServiceObserver {
    func emit(to: Result<String,AllergèneViewModelError>)
}

class AllergèneService {
    
    private let firestore = Firestore.firestore()
    private var tabListObserver : [AllergèneListServiceObserver] = []
    private var tabObserver : [AllergèneServiceObserver] = []
    private var tabAllergène : [Allergène] {
        didSet {
            for observer in tabListObserver {
                observer.emit(to: tabAllergène)
            }
        }
    }
    private var ingredientService : IngredientService = IngredientService()
    
    init(){
        self.tabAllergène = []
    }
    
    func addObserver(observer : AllergèneListServiceObserver){
        self.tabListObserver.append(observer)
        observer.emit(to: tabAllergène)
    }
    
    func addObserver(observer : AllergèneServiceObserver){
        self.tabObserver.append(observer)
    }
    
    func getAllAllergène(){
        firestore.collection("allergenes").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabAllergène = documents.map{
                (doc) -> Allergène in
                
                return AllergèneDTO.transformDTO(
                    AllergèneDTO(id: doc.documentID,
                                 nom: doc["nom"] as? String ?? "" ))
            }
        }
    }
    
    func addAllergène(allergène : Allergène){
        firestore.collection("allergenes").addDocument(data: AllergèneDTO.transformToDTO(allergène)){
            (error) in if let _ = error {
                self.sendResultElement(result: .failure(.createError))
            } else {
                self.sendResultElement(result: .success("Création effectué"))
            }
        }
    }
    
    func deleteAllergène(allergène : Allergène){
        firestore.collection("allergenes").document(allergène.id!).delete() {
            (error) in if let _ = error {
                self.sendResultList(result: .failure(.deleteError))
            } else{
                self.deleteAllergèneIntoIngredient(allergèneName: allergène.nom)
                self.sendResultList(result: .success("Suppresion effectué !"))
            }
        }
    }
    
    func updateAllergène(allergène : Allergène){
        self.updateAllergèneIntoIngrédient(allergène: allergène){
            let ref = self.firestore.collection("allergenes").document(allergène.id!)
            ref.updateData(AllergèneDTO.transformToDTO(allergène)) {
                (error) in
                if let _ = error {
                    self.sendResultElement(result: .failure(.updateError))
                } else {
                    self.sendResultElement(result: .success("Mise a jour effectué"))
                }
            }
        }
    }
    
    // Link allergène with ingredient
    
    private func deleteAllergèneIntoIngredient(allergèneName : String){
        self.ingredientService.getIngredientsByAllergène(allergène: allergèneName){
            ingredients in
            for ingredient in ingredients {
                if let index = ingredient.listAllergene.firstIndex(of: allergèneName) {
                    ingredient.listAllergene.remove(at: index)
                }
                self.ingredientService.updateIngredient(ingredient: ingredient)
            }
        }
    }
    
    private func updateAllergèneIntoIngrédient(allergène : Allergène, action : (() -> Void)?){
        self.getAllergèneById(id: allergène.id!){ allergèneOld in
            if !(allergène.nom == allergèneOld.nom) {
                self.ingredientService.getIngredientsByAllergène(allergène: allergèneOld.nom){ ingredients in
                    for ingredient in ingredients {
                        if let index = ingredient.listAllergene.firstIndex(of: allergèneOld.nom) {
                            ingredient.listAllergene.remove(at: index)
                        }
                        ingredient.listAllergene.append(allergène.nom)
                        self.ingredientService.updateIngredient(ingredient: ingredient)
                    }
                }
            }
            action?()
        }
    }
    
    private func getAllergèneById(id : String, action : ((Allergène) -> Void)?){
        firestore.collection("allergenes").document(id).getDocument(){data,err in
            if let err = err {
                print("Error getting document : \(err)")
            }
            else{
                guard let doc = data else {
                    return
                }
                action?(AllergèneDTO.transformDTO(
                    AllergèneDTO(id: doc.documentID,
                                  nom: doc["nom"] as? String ?? ""))
                )
                
            }
        }
    }
    
    // Result to observer

    private func sendResultElement(result : Result<String,AllergèneViewModelError>){
        for observer in self.tabObserver {
            observer.emit(to: result)
        }
    }
    
    private func sendResultList(result : Result<String,AllergèneListViewModelError>){
        for observer in self.tabListObserver {
            observer.emit(to: result)
        }
    }
}
