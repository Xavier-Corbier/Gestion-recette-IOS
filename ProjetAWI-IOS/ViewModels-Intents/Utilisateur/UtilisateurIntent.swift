//
//  UtilisateurIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import Combine

enum UtilisateurIntentState : CustomStringConvertible, Equatable {
    case ready
    case changingName(String)
    case changingFirstName(String)
    case changingType(TypeUtilisateur)
    case changingEmail(String)
    case changingPassword(String)
    case updateDatabase
    case deleteUser
    case createUser
    var description: String {
        switch self {
        case .ready : return "ready"
        case .changingFirstName(let prenom) : return "Va changer son prénom : \(prenom)"
        case .changingType(let typeUtilisateur) : return "Va changer son statue : \(typeUtilisateur)"
        case .changingName(let nom) : return "Va changer son nom : \(nom)"
        case .changingEmail(let email) : return "Va email \(email)"
        case .changingPassword(let password) : return "Va \(password)"
        case .updateDatabase : return "Modification effectuée"
        case .createUser : return "Utilisateur bien créé !"
        case .deleteUser : return "Utilisateur a bien été supprimé"
        }
    }
}

enum UtilisateurListIntentState : Equatable{
    case ready
    //case updateList
    case deleteUser(Int)
}

struct UtilisateurIntent  {
    private var stateElement = PassthroughSubject<UtilisateurIntentState,Never>()
    private var stateList = PassthroughSubject<UtilisateurListIntentState,Never>()
    //private var isFromList : Bool = true
    
    func intentToChange(name : String){
        self.stateElement.send(UtilisateurIntentState.changingName(name))
        //self.updateList()
    }
    
    func intentToChange(firstName : String) {
        self.stateElement.send(UtilisateurIntentState.changingFirstName(firstName))
        //self.updateList()
    }
    
    func intentToChange(type : TypeUtilisateur){
        self.stateElement.send(UtilisateurIntentState.changingType(type))
        //self.updateList()
    }
    
    func intentToChange(email : String) {
        self.stateElement.send(UtilisateurIntentState.changingEmail(email))
    }
    
    func intentToChange(password : String){
        self.stateElement.send(UtilisateurIntentState.changingPassword(password))
    }
    
    func intentToUpdateDatabase(){
        self.stateElement.send(UtilisateurIntentState.updateDatabase)
    }
    
    func intentToCreateUser(){
        self.stateElement.send(UtilisateurIntentState.createUser)
    }
    
    func intentToDeleteUser(){
        self.stateElement.send(UtilisateurIntentState.deleteUser)
    }
    
    func intentToDeleteUserFromList(id : Int){
        self.stateList.send(UtilisateurListIntentState.deleteUser(id))
    }
    
    mutating func addObserver(_ utilisateurViewModel : UtilisateurViewModel){
        self.stateElement.subscribe(utilisateurViewModel)
       // self.isFromList = false
    }
    
    mutating func addObserver(_ utilisateurListViewModel : UtilisateurListViewModel){
        //self.stateElement.subscribe(utilisateurViewModel)
        self.stateList.subscribe(utilisateurListViewModel)
       /* self.isFromList = true*/
    }
    
    /*func updateList(){
        if self.isFromList {
            self.stateList.send(.updateList)
        }
    }*/
}
