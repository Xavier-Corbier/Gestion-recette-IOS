//
//  CategorieRecetteViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import SwiftUI
import Combine

class CategorieRecetteViewModel : ObservableObject, CategorieRecetteServiceObserver {

    private var categorieRecetteService : CategorieRecetteService = CategorieRecetteService()
    @Published var tabCategorieRecette : [String]

    init() {
        self.tabCategorieRecette = ["Choisir"]
        self.categorieRecetteService.addObserver(observer: self)
        self.categorieRecetteService.getAllCategorieRecette()
    }
    
    func emit(to: [String]) {
        self.tabCategorieRecette.append(contentsOf: to)
    }
   
}
