//
//  IngredientViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 25/02/2022.
//

import Foundation
import SwiftUI
import Combine

enum IngredientViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case updateError
    case createError
    case inputError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .updateError : return "Erreur de mise à jour"
        case .createError : return "Erreur de création"
        case .inputError : return "Input non valide"
        }
    }
}

class IngredientViewModel : ObservableObject, Subscriber, IngredientServiceObserver, IngredientObserver {
    
    private var ingredientService : IngredientService = IngredientService()
    private var ingredient : Ingredient
    @Published var nomIngredient : String
    @Published var prixUnitaire : Double
    @Published var qteIngredient : Double
    @Published var unite : String
    @Published var categorie : String
    @Published var listAllergene : [String]
    @Published var result : Result<String, IngredientViewModelError> = .failure(.noError)
    
    init(ingrédientListViewModel : IngredientListViewModel? = nil, indice : Int? = nil) {
        if let indice = indice , let ingrédientListViewModel = ingrédientListViewModel{
            self.ingredient = ingrédientListViewModel.tabIngredient[indice]
        } else {
            self.ingredient = Ingredient(nomIngredient: "", prixUnitaire: 0, qteIngredient: 0, unite: "", categorie: "", listAllergene: [])
        }
        self.nomIngredient = self.ingredient.nomIngredient
        self.prixUnitaire = self.ingredient.prixUnitaire
        self.qteIngredient = self.ingredient.qteIngredient
        self.unite = self.ingredient.unite
        self.categorie = self.ingredient.categorie
        self.listAllergene = self.ingredient.listAllergene
        self.ingredientService.addObserver(observer: self)
        self.ingredient.observer = self
    }
    
    func emit(to: Result<String, IngredientViewModelError>) {
        self.result = to
    }
    
    typealias Input = IngredientIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: IngredientIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .changingNom(let string):
            self.ingredient.nomIngredient = string
            if self.ingredient.nomIngredient != string {
                self.nomIngredient = self.ingredient.nomIngredient
            }
        case .updateDatabase:
            if self.ingredient.isValid {
                self.ingredientService.updateIngredient(ingredient: self.ingredient)
            } else {
                self.result = .failure(.inputError)
            }
        case .addIngredient:
            if self.ingredient.isValid {
                self.ingredientService.addIngredient(ingredient: self.ingredient)
            } else {
                self.result = .failure(.inputError)
            }
        case .changingPrix(let double):
            self.ingredient.prixUnitaire = double
            if self.ingredient.prixUnitaire != double {
                self.prixUnitaire = self.ingredient.prixUnitaire
            }
        case .changingQuantité(let double):
            self.ingredient.qteIngredient = double
            if self.ingredient.qteIngredient != double {
                self.qteIngredient = self.ingredient.qteIngredient
            }
        case .changingUnite(let string):
            self.ingredient.unite = string
            if self.ingredient.unite != string {
                self.unite = self.ingredient.unite
            }
        case .changingCategorie(let string):
            self.ingredient.categorie = string
            if self.ingredient.categorie != string {
                self.categorie = self.ingredient.categorie
            }
        case .changingListAllergene(let array):
            self.ingredient.listAllergene = array
            if self.ingredient.listAllergene != array {
                self.listAllergene = self.ingredient.listAllergene
            }
        }
        return .none
    }
    
    func changed(nomIngredient: String) {
        self.nomIngredient = nomIngredient
    }
    
    func changed(prixUnitaire: Double) {
        self.prixUnitaire = prixUnitaire
    }
    
    func changed(qteIngredient: Double) {
        self.qteIngredient = qteIngredient
    }
    
    func changed(unite: String) {
        self.unite = unite
    }
    
    func changed(categorie: String) {
        self.categorie = categorie
    }
    
    func changed(listAllergene: [String]) {
        self.listAllergene = listAllergene
    }
}

