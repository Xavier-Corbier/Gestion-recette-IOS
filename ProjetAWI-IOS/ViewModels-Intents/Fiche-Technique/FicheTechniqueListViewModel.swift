//
//  FicheTechniqueListViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation
import Combine
import SwiftUI

enum FicheTechniqueListViewModelError : Error, Equatable, CustomStringConvertible{
    case noError
    case deleteError
    case addError
    case updateError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .deleteError : return "Erreur de supression"
        case .addError : return "Erreur d'addition"
        case .updateError : return "Erreur d'update"
        }
    }
}


class FicheTechniqueListViewModel : ObservableObject, Subscriber, FicheTechniqueListServiceObserver {
    
    var ficheTechniqueService : FicheTechniqueService
    @Published var tabFicheTechnique : [FicheTechnique]
    @Published var result : Result<String, FicheTechniqueListViewModelError> = .failure(.noError)
    
    init(ficheService : FicheTechniqueService = FicheTechniqueService()){
        self.ficheTechniqueService = ficheService
        self.tabFicheTechnique = []
        self.ficheTechniqueService.getAllFicheTechnique()
        self.ficheTechniqueService.setObserver(obs: self)
    }
    
    func emit(to: [FicheTechnique]) {
        self.tabFicheTechnique = to
    }
    
    func emit(to: Result<String, FicheTechniqueListViewModelError>) {
        self.result = to
    }
    
    
    typealias Input = FicheTechniqueListIntentState
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
            subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: FicheTechniqueListIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .deleteFicheTechnique(let id):
            // faire action
            self.ficheTechniqueService.removeFicheTechnique(id : self.tabFicheTechnique[id].header.id, categorie: self.tabFicheTechnique[id].header.categorie)
        }
        return .none
    }
    
}
