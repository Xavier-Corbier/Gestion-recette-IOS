//
//  CategorieIngredientViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 27/02/2022.
//

import Foundation
import SwiftUI
import Combine

class CategorieIngredientViewModel : ObservableObject, CategorieIngredientServiceObserver {

    private var categorieIngredientService : CategorieIngredientService = CategorieIngredientService()
    @Published var tabCategorieIngredient : [String]
    @Published var result : Result<String, AllergèneListViewModelError> = .failure(.noError)

    init() {
        self.tabCategorieIngredient = ["Choisir"]
        self.categorieIngredientService.addObserver(observer: self)
        self.categorieIngredientService.getAllCategorieIngredient()
    }
    
    func emit(to: [String]) {
        self.tabCategorieIngredient = ["Choisir"]
        self.tabCategorieIngredient.append(contentsOf: to)
    }
}
