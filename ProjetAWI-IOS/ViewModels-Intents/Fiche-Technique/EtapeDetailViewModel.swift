//
//  EtapeDetailViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import Combine
import SwiftUI

enum EtapeViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case inputError
    case addDenreeError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .inputError : return "Input non valide"
        case .addDenreeError : return "L'ajout de l'ingrédient a été refusé (duplication)"
        }
    }
}

class EtapeViewModel : ObservableObject, Subscriber, DescriptionObserver {

    @ObservedObject var ficheVM : FicheTechniqueViewModel
    
    private var etape : Etape
    private var indice : Int
    private var indiceSousFicheTechnique : Int? = nil
    private var ingredientService : IngredientService
    
    var estEtapeSousFicheTechnique : Bool = false
    
    @Published var nomEtape : String
    @Published var dureeEtape : Double
    @Published var descriptionEtape : String
    
    @Published var contenu : [Denree]
    
    @Published var result : Result<String, EtapeViewModelError> = .failure(.noError)
    
    init(ficheTechViewModel : FicheTechniqueViewModel,ingredientVM : IngredientListViewModel,  indice : Int, indiceSousFiche : Int?  = nil){
        
        self.ficheVM = ficheTechViewModel
        
        self.ingredientService = ingredientVM.ingredientService
        
        if let indiceSousFiche = indiceSousFiche {
            self.etape = ficheTechViewModel.progression[indice].etapes[indiceSousFiche]
            self.estEtapeSousFicheTechnique = true
        }
        else{
            self.etape = ficheTechViewModel.progression[indice].etapes[0]
        }
        
        self.indice = indice
        
        self.nomEtape = self.etape.description.nom
        self.dureeEtape = self.etape.description.tempsPreparation
        self.descriptionEtape = self.etape.description.description
        
        self.contenu = self.etape.contenu
        
    }
    
    
    typealias Input = EtapeIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: EtapeIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
            
        case .changingNom(let nom):
            self.etape.description.nom = nom
            if self.etape.description.nom != nom {
                self.nomEtape = self.etape.description.nom
                self.result = .failure(.inputError)
            }
            break
            
        case .changingDuree(let duree):
            self.etape.description.tempsPreparation = duree
            if self.etape.description.tempsPreparation != duree {
                self.dureeEtape = self.etape.description.tempsPreparation
                self.result = .failure(.inputError)
            }
            break
            
        case .changingDescription(let desc):
            self.etape.description.description = desc
            if self.etape.description.description != desc {
                self.descriptionEtape = self.etape.description.description
                self.result = .failure(.inputError)
            }
            break
            
        case .addDenree(let idIngredient):
            if let ingredient : Ingredient = self.ingredientService.getIngredient(id: idIngredient){
               let count = self.etape.contenu.count
               self.etape.contenu.append(Denree(ingredient: ingredient, nombre: 1))
               if count < self.etape.contenu.count { // modification effectué
                   self.contenu.append(self.etape.contenu[count]) // on l'ajoute au model du ViewModel
                   self.ficheVM.calculDenreeEtCoutMatiere()
               }
               else{
                   self.result = .failure(.addDenreeError)
               }
           }
           else{
               self.result = .failure(.addDenreeError)
           }
            
        case .deleteDenree(let idTab):
            let count = self.etape.contenu.count
            self.etape.contenu.remove(at: idTab)
            if count > self.etape.contenu.count {
                self.contenu.remove(at: idTab)
                self.ficheVM.calculDenreeEtCoutMatiere()
            }
            else{
                self.result = .failure(.inputError)
            }
            
        case .changingDenreeNumber(let idTab, let nombre):
            self.etape.contenu[idTab].nombre = nombre
            if self.etape.contenu[idTab].nombre != nombre {
                self.contenu[idTab].nombre = self.etape.contenu[idTab].nombre
                self.result = .failure(.inputError)
            }
            else{
                self.ficheVM.calculDenreeEtCoutMatiere()
            }
            break
        }
        
        return .none
    }
    
    func changed(nom: String) {
        self.nomEtape = nom
    }
    
    func changed(description: String) {
        self.descriptionEtape = description
    }
    
    func changed(tempsPreparation: Double) {
        self.dureeEtape = tempsPreparation
    }
    
    
}
