//
//  VenteService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol VenteServiceObserver{
    func emit(to: Result<String,VenteViewModelError>)
}

class VenteService {
    private let firestore = Firestore.firestore()
    private var tabObserver : [VenteServiceObserver] = []
    private var ficheTechniqueService : FicheTechniqueService = FicheTechniqueService()
    private var ingredientService : IngredientService = IngredientService()

    func addVente(vente : Vente){
        firestore.collection("ventes").addDocument(data: VenteDTO.transformToDTO(vente)){
            (error) in if let _ = error {
                self.sendResult(result: .failure(.createError))
            } else {
                self.impactStock(idFiche: vente.idficheReference, nombre: vente.nbrPlatVendu){
                    self.sendResult(result: .success("Vente effectué"))
                }
            }
        }
    }
    
    private func impactStock(idFiche : String, nombre: Int, action : (() -> Void)?){
        self.ficheTechniqueService.getFicheTechniqueBD(id: idFiche){fiche in
            let listDenree = fiche.getListDenree
            for denree in listDenree {
                self.ingredientService.getIngredientsByName(nomIngrédient: denree.ingredient.nomIngredient){ingredient in
                    if let ingredient = ingredient {
                        ingredient.qteIngredient = ingredient.qteIngredient - ( denree.nombre / Double(fiche.header.nbrCouvert)) * Double(nombre)
                        self.ingredientService.updateIngredient(ingredient: ingredient)
                    }
                }
            }
            action?()
        }
    }
    
    func addObserver(observer : VenteServiceObserver){
        self.tabObserver.append(observer)
    }
    
    private func sendResult(result : Result<String,VenteViewModelError>){
        for observer in self.tabObserver {
            observer.emit(to: result)
        }
    }
}
