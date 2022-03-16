//
//  MenuViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 22/02/2022.
//

import Foundation
import Combine

class MenuViewModel : ObservableObject, CurrentUserServiceObserver{
    
    @Published var currentUtilisateur : Utilisateur
    
    private var userService : UtilisateurService = UtilisateurService.instance
    
    func emit(to: Utilisateur){
        self.currentUtilisateur = to
    }
    
    init(){
        self.currentUtilisateur = userService.currentUtilisateur
        self.userService.setObserverCurrent(obs: self)

    }
}

