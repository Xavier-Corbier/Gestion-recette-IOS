//
//  EtiquetteIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import Combine

enum EtiquetteIntentState : Equatable {
    case ready
    case changingDateCreation(String)
    case changingIdficheReference(String)
    case changingNombreEtiquete(Int)
    case changingNomPlat(String)
    case changingListDenree([DenreeEtiquette])
    case addEtiquette
}

struct EtiquetteIntent {
    private var state = PassthroughSubject<EtiquetteIntentState,Never>()
    
    func intentToChange(dateCreation : String){
        self.state.send(EtiquetteIntentState.changingDateCreation(dateCreation))
    }
    
    func intentToChange(idficheReference : String){
        self.state.send(EtiquetteIntentState.changingIdficheReference(idficheReference))
    }
    
    func intentToChange(nombreEtiquete : Int){
        self.state.send(EtiquetteIntentState.changingNombreEtiquete(nombreEtiquete))
    }
    func intentToChange(nomPlat : String){
        self.state.send(EtiquetteIntentState.changingNomPlat(nomPlat))
    }
    
    func intentToChange(listDenree : [DenreeEtiquette]){
        self.state.send(EtiquetteIntentState.changingListDenree(listDenree))
    }
    
    func intentToAddEtiquette(){
        self.state.send(EtiquetteIntentState.addEtiquette)
    }
    
    func addObserver(_ venteViewModel : EtiquetteViewModel){
        self.state.subscribe(venteViewModel)
    }
}
