//
//  VenteViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import Combine

enum VenteViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case createError
    case inputError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .createError : return "Erreur d'enregistrement"
        case .inputError : return "Input non valide"
        }
    }
}

class VenteViewModel : ObservableObject, VenteObserver, Subscriber, VenteServiceObserver {
    
    private var vente : Vente
    private var venteService : VenteService
    @Published var dateAchat: String
    @Published var idficheReference: String
    @Published var nbrPlatVendu: Int
    @Published var result : Result<String, VenteViewModelError> = .failure(.noError)
    
    init(idficheReference: String){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        self.vente = Vente(dateAchat: dateFormatter.string(from: date), idficheReference: idficheReference, nbrPlatVendu: 1)
        self.dateAchat = vente.dateAchat
        self.idficheReference = vente.idficheReference
        self.nbrPlatVendu = vente.nbrPlatVendu
        self.venteService = VenteService()
        self.vente.observer = self
        self.venteService.addObserver(observer: self)
    }
    
    func emit(to: Result<String, VenteViewModelError>) {
        self.result = to
    }
    
    func changed(dateAchat: String) {
        self.dateAchat = dateAchat
    }
    
    func changed(idficheReference: String) {
        self.idficheReference = idficheReference
    }
    
    func changed(nbrPlatVendu: Int) {
        self.nbrPlatVendu = nbrPlatVendu
    }
    
    typealias Input = VenteIntentState
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: VenteIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .changingDateAchat(let value):
            self.vente.dateAchat = value
            if self.vente.dateAchat != value {
                self.dateAchat = self.vente.dateAchat
            }
        case .changingIdficheReference(let value):
            self.vente.idficheReference = value
            if self.vente.idficheReference != value {
                self.idficheReference = self.vente.idficheReference
            }
        case .changingNbrPlatVendu(let value):
            self.vente.nbrPlatVendu = value
            if self.vente.nbrPlatVendu != value {
                self.nbrPlatVendu = self.vente.nbrPlatVendu
            }
        case .addVente:
            if self.vente.isValid {
                self.venteService.addVente(vente: self.vente)
            } else {
                self.result = .failure(.inputError)
            }
        }
        return .none
    }
}
