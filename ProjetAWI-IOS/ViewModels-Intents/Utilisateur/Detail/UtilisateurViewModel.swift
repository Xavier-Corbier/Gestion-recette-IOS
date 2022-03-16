//
//  UtilisateurViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import Combine
import SwiftUI

enum UserError : Error, Equatable, CustomStringConvertible {
    case errorName(String)
    case errorFirstName(String)
    case emailError(String)
    case mdpError
    case connexioError
    case noError
    case updateError
    case createError
    case deleteError
    var description: String {
        switch self {
        case .updateError:
            return "Erreur de modification (mot de passe incorrect)"
            
        case .deleteError:
            return "Erreur lors de la suppresion"
            
        case .connexioError:
            return "Erreur : Email ou mot de passe erroné"
            
        case .createError:
            return "Erreur durant la création du compte"

        case .errorName(_), .errorFirstName(_):
            return "Erreur : Le champs ne doit pas être vide"
            
        case .emailError(let email):
            return "Erreur, l'email n'a pas le bon format : \(email)"
            
        case .mdpError:
            return "Erreur : Le mot de passe doit faire au moins 6 caractères"
            
        
        default :
            return "Erreur inconnu"
        }
    }
}

class UtilisateurViewModel : ObservableObject, UtilisateurObserver,UserServiceResultObserver, Subscriber{
    private var model : Utilisateur
    private var userService : UtilisateurService = UtilisateurService.instance
    
    var isValid : Bool {
        return model.isValid
    }
    
    var isValidForAdmin : Bool {
        return model.isValidForAdmin
    }
    
    @ObservedObject var user : UtilisateurService = UtilisateurService.instance
    
    @Published var nom : String
    @Published var prenom : String
    @Published var email : String
    @Published var type : TypeUtilisateur
    @Published var motDePasse : String = ""

    @Published var result : Result<String, UserError> = .success("")
    
    
    
    init(from model : Utilisateur){
        self.model = model
        self.email = model.email
        self.nom = model.nom
        self.prenom = model.prenom
        self.type = model.type
        self.model.observer = self
    }
    
    func addObserverResult(){
        userService.addObserverResult(obs: self)
    }
    
    func removeObserverResult(){
        userService.removeObserverResult()
    }
    
    func emit(to: Result<String, UserError>) {
        result = to
    }
    
    func changed(nom: String) {
        self.nom = nom
    }
    
    func changed(prenom: String) {
        self.prenom = prenom
    }
    
    func changed(type : TypeUtilisateur) {
        self.type = type
    }
    
    func changed(email: String) {
        self.email = email
    }
    
    func changed(motDePasse: String) {
        self.motDePasse = motDePasse
    }
    
    typealias Input = UtilisateurIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    
    func receive(_ input: UtilisateurIntentState) -> Subscribers.Demand {
        switch input {
        case .ready: break
        case .changingName(let nom):
            self.model.nom = nom
            if nom != self.model.nom {
                self.result = .failure(.errorName(nom))
                self.nom = nom
            }
        case .changingPassword(let motDePasse):
            self.model.motDePasse = motDePasse
            if motDePasse != self.model.motDePasse {
                self.result = .failure(.mdpError)
                self.motDePasse = motDePasse
            }
            
        case .changingEmail(let email):
            self.model.email = email
            if email != self.model.email {
                self.result = .failure(.emailError(email))
                self.email = self.model.email // ancienne valeur 
            }
               
        case .changingFirstName(let prenom):
            self.model.prenom = prenom
            if prenom != self.model.prenom {
                self.result = .failure(.errorFirstName(prenom))
                self.prenom = prenom
            }
                
        case .changingType(let type):
            self.model.type = type
            
        case .updateDatabase:
            if (user.currentUtilisateur.estAdmin() && self.model.isValidForAdmin) || self.model.isValid {
                self.userService.updateUtilisateur(util: self.model)
            }
            else{
                self.result = .failure(.updateError)
            }
            
        case .deleteUser:
            self.userService.deleteUtilisateur(id: self.model.id)
            
        case .createUser:
            if self.model.isValid {
                self.userService.createUtilisateur(util: self.model)
            }
            else{
                self.result = .failure(.createError)
            }
        }
        return .none
    }
}
