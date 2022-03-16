//
//  VenteIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import Combine

enum VenteIntentState : Equatable {
    case ready
    case changingDateAchat(String)
    case changingIdficheReference(String)
    case changingNbrPlatVendu(Int)
    case addVente
}

struct VenteIntent {
    private var state = PassthroughSubject<VenteIntentState,Never>()
    
    func intentToChange(dateAchat : String){
        self.state.send(VenteIntentState.changingDateAchat(dateAchat))
    }
    
    func intentToChange(idficheReference : String){
        self.state.send(VenteIntentState.changingIdficheReference(idficheReference))
    }
    
    func intentToChange(nbrPlatVendu : Int){
        self.state.send(VenteIntentState.changingNbrPlatVendu(nbrPlatVendu))
    }
    
    func intentToChangeAddVente(){
        self.state.send(VenteIntentState.addVente)
    }
    
    func addObserver(_ venteViewModel : VenteViewModel){
        self.state.subscribe(venteViewModel)
    }
}
