//
//  IngredientListViewModel.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

import Foundation
import SwiftUI
import Combine

enum IngredientListViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case deleteError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .deleteError : return "Erreur de supression"
        }
    }
}

class IngredientListViewModel : ObservableObject, Subscriber, IngredientListServiceObserver {

    var ingredientService : IngredientService = IngredientService()
    @Published var tabIngredient : [Ingredient]
    @Published var result : Result<String, IngredientListViewModelError> = .failure(.noError)

    init() {
        self.tabIngredient = []
        self.ingredientService.addObserver(observer: self)
        self.ingredientService.getAllIngredient()
    }
    
    func emit(to: [Ingredient]) {
        self.tabIngredient = to
    }
    
    func emit(to: Result<String, IngredientListViewModelError>) {
        self.result = to
    }
    
    typealias Input = IngredientListIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: IngredientListIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .deleteIngredient(let id):
            self.ingredientService.deleteIngredient(ingredient: self.tabIngredient[id])
        }
        return .none
    }
    
    
}
