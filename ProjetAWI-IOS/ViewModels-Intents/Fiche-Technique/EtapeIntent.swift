//
//  EtapeIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 05/03/2022.
//

import Foundation
import Combine

enum EtapeIntentState : Equatable{
    case ready
    
    case changingNom(String)
    case changingDuree(Double)
    case changingDescription(String)
    
    case addDenree(String)
    case deleteDenree(Int)
    case changingDenreeNumber(Int, Double)
}

struct EtapeIntent {
    private var stateEtape = PassthroughSubject<EtapeIntentState, Never>()
    
    
    /* ---- Etape ----*/
    
    func intentToChange(nomEtape : String){
        self.stateEtape.send(EtapeIntentState.changingNom(nomEtape))
    }
    
    func intentToChange(dureeEtape : Double){
        self.stateEtape.send(EtapeIntentState.changingDuree(dureeEtape))
    }
    
    func intentToChange(descriptionEtape : String){
        self.stateEtape.send(EtapeIntentState.changingDescription(descriptionEtape))
    }
    
    func intentToChange(id : Int, denreeNumber : Double){
        self.stateEtape.send(EtapeIntentState.changingDenreeNumber(id, denreeNumber))
    }
    
    func intentToAddDenree(id : String){
        self.stateEtape.send(EtapeIntentState.addDenree(id))
    }
    
    func intentToRemoveDenree(id : Int){
        self.stateEtape.send(EtapeIntentState.deleteDenree(id))
    }
    
    func addObserver (_ etape : EtapeViewModel){
        self.stateEtape.subscribe(etape)
    }
    
}
