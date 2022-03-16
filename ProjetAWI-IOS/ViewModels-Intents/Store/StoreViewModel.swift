//
//  StoreViewModel.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//

import Foundation
import SwiftUI
import Combine

enum StoreViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case updateError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .updateError : return "Erreur de mise à jour"
        }
    }
}

class StoreViewModel : ObservableObject, StoreObserver, Subscriber, StoreServiceObserver{

    private var store : Store
    private var storeService : StoreService = StoreService.instance
    @Published var coefCoûtProduction : Double
    @Published var coefPrixDeVente : Double
    @Published var coûtForfaitaire : Double
    @Published var coûtMoyen : Double
    @Published var result : Result<String, StoreViewModelError> = .success("")
    
    init(){
        self.store = Store(coefCoûtProduction: 0, coefPrixDeVente: 0, coûtForfaitaire: 0, coûtMoyen: 0)
        self.coefCoûtProduction = store.coefCoûtProduction
        self.coefPrixDeVente = store.coefPrixDeVente
        self.coûtForfaitaire = store.coûtForfaitaire
        self.coûtMoyen = store.coûtMoyen
        self.store.observer = self
        self.storeService.addObserver(observer: self)
        self.storeService.getStore()
    }
    
    func emit(to: Store) {
        self.store = to
        self.refreshModel()
    }
    
    func emit(to: Result<String, StoreViewModelError>) {
        self.result = to
    }
    
    private func refreshModel(){
        self.coefCoûtProduction = store.coefCoûtProduction
        self.coefPrixDeVente = store.coefPrixDeVente
        self.coûtForfaitaire = store.coûtForfaitaire
        self.coûtMoyen = store.coûtMoyen
        self.store.observer = self
    }
    
    func changed(coefCoûtProduction: Double) {
        self.coefCoûtProduction = coefCoûtProduction
    }
    
    func changed(coefPrixDeVente: Double) {
        self.coefPrixDeVente = coefPrixDeVente
    }
    
    func changed(coûtForfaitaire: Double) {
        self.coûtForfaitaire = coûtForfaitaire
    }
    
    func changed(coûtMoyen: Double) {
        self.coûtMoyen = coûtMoyen
    }
    
    typealias Input = StoreIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: StoreIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .changingCoefCoûtProduction(let double):
            self.store.coefCoûtProduction = double
            if self.store.coefCoûtProduction != double {
                self.coefCoûtProduction = self.store.coefCoûtProduction
            }
        case .changingCoefPrixDeVente(let double):
            self.store.coefPrixDeVente = double
            if self.store.coefPrixDeVente != double {
                self.coefPrixDeVente = self.store.coefPrixDeVente
            }
        case .changingCoûtForfaitaire(let double):
            self.store.coûtForfaitaire = double
            if self.store.coûtForfaitaire != double {
                self.coûtForfaitaire = self.store.coûtForfaitaire
            }
        case .changingCoûtMoyen(let double):
            self.store.coûtMoyen = double
            if self.store.coûtMoyen != double {
                self.coûtMoyen = self.store.coûtMoyen
            }
        case .updateDatabase:
            self.storeService.updateStore(store: self.store)
        }
        return .none
    }
}
