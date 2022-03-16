//
//  EtiquetteViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import Combine

enum EtiquetteViewModelError : Error, Equatable, CustomStringConvertible {
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

class EtiquetteViewModel : ObservableObject, EtiquetteObserver, Subscriber, EtiquetteServiceObserver {
    
    private var etiquette : Etiquette
    private var etiquetteService : EtiquetteService
    @Published var dateCreation : String
    @Published var idficheReference : String
    @Published var nombreEtiquete : Int
    @Published var nomPlat : String
    @Published var listDenree : [DenreeEtiquette]
    @Published var result : Result<String, EtiquetteViewModelError> = .failure(.noError)
    @Published var idEtiquette : String = ""
    
    init(idficheReference : String, nomPlat : String,  listDenree : [DenreeEtiquette]){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        self.etiquette = Etiquette(dateCreation: dateFormatter.string(from: date), idficheReference: idficheReference, nombreEtiquete: 1, nomPlat: nomPlat, listDenree: listDenree)
        self.dateCreation = etiquette.dateCreation
        self.idficheReference = etiquette.idficheReference
        self.nombreEtiquete = etiquette.nombreEtiquete
        self.nomPlat = etiquette.nomPlat
        self.listDenree = etiquette.listDenree
        self.etiquetteService = EtiquetteService()
        self.etiquette.observer = self
        self.etiquetteService.addObserver(observer: self)
    }
    
    func emit(to: Result<String, EtiquetteViewModelError>) {
        self.result = to
    }
    
    func changed(dateCreation: String) {
        self.dateCreation = dateCreation
    }
    
    func changed(idficheReference: String) {
        self.idficheReference = idficheReference
    }
    
    func changed(nombreEtiquete: Int) {
        self.nombreEtiquete = nombreEtiquete
    }
    
    func changed(nomPlat: String) {
        self.nomPlat = nomPlat
    }
    
    func changed(listDenree: [DenreeEtiquette]) {
        self.listDenree = listDenree
    }
    
    typealias Input = EtiquetteIntentState
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: EtiquetteIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .changingDateCreation(let value):
            self.etiquette.dateCreation = value
            if self.etiquette.dateCreation != value {
                self.dateCreation = self.etiquette.dateCreation
            }
        case .changingIdficheReference(let value):
            self.etiquette.idficheReference = value
            if self.etiquette.idficheReference != value {
                self.idficheReference = self.etiquette.idficheReference
            }
        case .changingNombreEtiquete(let value):
            self.etiquette.nombreEtiquete = value
            if self.etiquette.nombreEtiquete != value {
                self.nombreEtiquete = self.etiquette.nombreEtiquete
            }
        case .changingNomPlat(let value):
            self.etiquette.nomPlat = value
            if self.etiquette.nomPlat != value {
                self.nomPlat = self.etiquette.nomPlat
            }
        case .changingListDenree(let value):
            self.etiquette.listDenree = value
            if self.etiquette.listDenree != value {
                self.listDenree = self.etiquette.listDenree
            }
        case .addEtiquette:
            if self.etiquette.isValid {
                self.idEtiquette = self.etiquetteService.addEtiquette(etiquette: self.etiquette)
            } else {
                self.result = .failure(.inputError)
            }
        }
        return .none
    }
}
