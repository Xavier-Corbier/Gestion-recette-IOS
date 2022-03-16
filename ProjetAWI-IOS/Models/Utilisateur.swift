//
//  User.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation

protocol UtilisateurObserver {
    func changed(nom : String)
    func changed(prenom : String)
    func changed(type : TypeUtilisateur)
    func changed(email : String)
    func changed(motDePasse : String)
}

enum TypeUtilisateur : String, CaseIterable, Identifiable{
    case User, Admin
    var id: Self {self}
}

class Utilisateur : ObservableObject{
    var observer : UtilisateurObserver?
    var id : String = UUID().uuidString
    
    var isValidForAdmin : Bool{
        return email.isValidEmail() && nom.count > 1 && prenom.count > 1
    }
    
    /**
                Vérifie si le modèle est valid
     */
    var isValid : Bool{
        return email.isValidEmail() && motDePasse.isValidPassword() && nom.count > 1 && prenom.count > 1
    }

    
    var email : String {
        didSet {
            if email != oldValue {
                if email.isValidEmail(){
                    self.observer?.changed(email : self.email)
                } else{
                    self.email = oldValue
                }
            } 
        }
    }
    
    
    var nom : String {
        didSet {
            if nom != oldValue {
                if nom.count >= 1{
                    self.observer?.changed(nom: self.nom)
                }
                else{
                    self.nom = oldValue
                }
            }
        }
    }
    var prenom : String{
        didSet{
            if prenom != oldValue {
                if prenom.count >= 1{
                    self.observer?.changed(prenom: self.prenom)
                }
                else{
                    self.nom = oldValue
                }
            }
        }
    }
    
    var type : TypeUtilisateur{
        didSet{
            if type != oldValue {
                self.observer?.changed(type : self.type)
            }
        }
    }
    
    var motDePasse : String {
        didSet {
            if motDePasse != oldValue {
                if motDePasse.isValidPassword() {
                    self.observer?.changed(motDePasse: motDePasse)
                }
                else{
                    self.motDePasse = oldValue
                }
            }
        }
    }
    
    func estConnecte() -> Bool{
        return self.email.count > 3 
    }
    
    func estAdmin() -> Bool{
        return self.type == .Admin && self.estConnecte()
    }
    
    init(email : String, nom : String, prenom : String, type : TypeUtilisateur, id : String, mdp : String = ""){
        self.email = email
        self.nom = nom
        self.prenom = prenom
        self.type = type
        self.id = id
        self.motDePasse = mdp
    }
    
}
