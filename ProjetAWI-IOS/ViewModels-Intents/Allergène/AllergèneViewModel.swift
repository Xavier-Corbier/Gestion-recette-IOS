//
//  AllergèneViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 24/02/2022.
//

import Foundation
import SwiftUI
import Combine

enum AllergèneViewModelError : Error, Equatable, CustomStringConvertible {
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

class AllergèneViewModel : ObservableObject, Subscriber, AllergèneServiceObserver, AllergèneObserver {

    private var allergèneService : AllergèneService = AllergèneService()
    private var allergène : Allergène
    @Published var nom : String
    @Published var result : Result<String, AllergèneViewModelError> = .failure(.noError)
    
    init(allergèneListViewModel : AllergèneListViewModel? = nil, indice : Int? = nil) {
        if let indice = indice , let allergèneListViewModel = allergèneListViewModel{
            self.allergène = allergèneListViewModel.tabAllergène[indice]
            self.nom = allergèneListViewModel.tabAllergène[indice].nom
        } else {
            self.allergène = Allergène(nom: "")
            self.nom = ""
        }
        self.allergèneService.addObserver(observer: self)
        self.allergène.observer = self
    }
    
    func emit(to: Result<String, AllergèneViewModelError>) {
        self.result = to
    }
    
    typealias Input = AllergèneIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: AllergèneIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .changingNom(let string):
            self.allergène.nom = string
            if self.allergène.nom != string {
                self.nom = self.allergène.nom
            }
        case .updateDatabase:
            if self.allergène.isValid {
                self.allergèneService.updateAllergène(allergène: self.allergène)
            } else {
                self.result = .failure(.inputError)
            }
        case .addAllergène:
            if self.allergène.isValid {
                self.allergèneService.addAllergène(allergène: self.allergène)
            } else {
                self.result = .failure(.inputError)
            }
        }
        return .none
    }
    
    func changed(nom: String) {
        self.nom = nom
    }
}
