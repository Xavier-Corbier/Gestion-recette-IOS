//
//  UtilisateurListViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import Combine

enum UtilisateurListError : Error, Equatable, CustomStringConvertible {
    case noError
    case deleteError
    var description: String {
        switch self {
        case .deleteError:
            return "Erreur lors de la suppresion"
        default :
            return "Erreur inconnu"
        }
    }
}


class UtilisateurListViewModel : ObservableObject, Subscriber, UserServiceObserver{
    @Published var utilisateurs : [Utilisateur]
    @Published var result : Result<String, UtilisateurListError> = .success("")
    
    
    private var userService : UtilisateurService = UtilisateurService.instance
    
    func emit(to: [Utilisateur]){
        self.utilisateurs = to
    }
    
    func emit(to: Result<String, UtilisateurListError>) {
        self.result = to
    }
    
    init(){
        self.utilisateurs = []
        self.userService.addObserverList(obs: self)
        self.userService.getListUtilisateurs()

    }
    
    typealias Input = UtilisateurListIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
           subscription.request(.unlimited)
    }
       
    func receive(completion: Subscribers.Completion<Never>) {
       return
    }
   
    func receive(_ input: UtilisateurListIntentState) -> Subscribers.Demand {
       switch input {
       case .ready:
           break
       case .deleteUser(let id):
           self.userService.deleteUtilisateur(id: self.utilisateurs[id].id)
           break
       /*case .updateList:
           self.objectWillChange.send()
           break
*/       }
       return .none
    }
}
