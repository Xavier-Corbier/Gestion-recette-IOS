//
//  GestionCoutView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 03/03/2022.
//

import Foundation
import SwiftUI

struct GestionCoutView : View {

    @ObservedObject var ficheVM : FicheTechniqueViewModel
    
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.fixed(50))]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    var intent: FicheTechniqueIntent
    
    init(vm : FicheTechniqueViewModel, intent : FicheTechniqueIntent){
        self.ficheVM = vm
        self.intent = intent
    }
    
    var body: some View {
        VStack {
            Form{
                Section(header : Text("Calculs des charges")){
                    HStack {
                        Text("Coût Matiere : " + String(format: "%.2f",ficheVM.coutMatiereTotal).replaceComa() + "€ (ASS 5% : " + String(format: "%.2f",ficheVM.ASS).replaceComa() + "€)")
                    }
                    HStack {
                        Text("Coût Personnel : " + String(format: "%.2f",ficheVM.coutPersonnel).replaceComa() + "€ (Durée : " + String(format: "%.2f",ficheVM.dureeTotal).replaceComa() + " min)")
                    }
                    HStack {
                        Text("Coût Fluide : " + String(format: "%.2f",ficheVM.coutForfaitaire).replaceComa() + "€")
                    }
                }
                
                Section(header : Text("Résultat total")){
                    HStack {
                        Text("Coût Production : " + String(format: "%.2f",ficheVM.coutProductionTotal).replaceComa() + "€" )
                    }
                    HStack {
                        Text("Prix de vente (HT) : " + String(format: "%.2f",ficheVM.prixDeVente).replaceComa() + "€")
                    }
                    HStack {
                        Text("Bénéfice : " + String(format: "%.2f",ficheVM.beneficeTotal).replaceComa() + "€")
                    }
                    HStack {
                        Text("Seuil de rentabilité : \(ficheVM.seuilRentabilité)/\(ficheVM.couvert) portions" )
                    }
                }
                
                Section(header : Text("Résultat par portion")){
                    HStack {
                        Text("Coût Production : " + String(format: "%.2f",ficheVM.coutProductionPortion).replaceComa() + "€")
                    }
                    HStack {
                        Text("Prix de vente (HT)  : " + String(format: "%.2f",ficheVM.prixDeVentePortion).replaceComa() + "€")
                    }
                    HStack {
                        Text("Bénéfice : " + String(format: "%.2f",ficheVM.beneficePortion).replaceComa() + "€")
                    }
                }
                
                Section(header: VStack{
                    Text("Gestions des coûts")
                    Toggle("Avec charges", isOn: $ficheVM.isCalculCharge).onChange(of : ficheVM.isCalculCharge){
                        value in intent.intentToChange(isCalculCharge: ficheVM.isCalculCharge)
                    }
                }){
                    if !ficheVM.isCalculCharge {
                        HStack {
                            LazyVGrid(columns: columns){
                                Text("Coefficient Prix de Vente :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("",value: $ficheVM.coefPrixDeVente, formatter: formatter)
                                    .onSubmit {
                                        intent.intentToChange(coefVente: ficheVM.coefPrixDeVente)
                                    }.textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    else {
                        HStack {
                            LazyVGrid(columns: columns){
                                Text("Coefficient Coût de Production :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("",value: $ficheVM.coefCoutProduction, formatter: formatter)
                                    .onSubmit {
                                        intent.intentToChange(coefProd: ficheVM.coefCoutProduction)
                                        // corrige bug input error view précédente
                                    }.textFieldStyle(.roundedBorder)
                            }
                        }
                       
                        HStack {
                            LazyVGrid(columns: columns){
                                Text("Coefficient Coût Forfaitaire :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("",value: $ficheVM.coutForfaitaire, formatter: formatter)
                                    .onSubmit {
                                        intent.intentToChange(coutForfaitaire: ficheVM.coutForfaitaire)
                                    }.textFieldStyle(.roundedBorder)
                            }
                        }
                        HStack {
                            LazyVGrid(columns: columns){
                                Text("Coefficient Coût Moyen :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("",value: $ficheVM.coutMoyenHoraire, formatter: formatter)
                                    .onSubmit {
                                        intent.intentToChange(coutMoyenHoraire: ficheVM.coutMoyenHoraire)
                                    }.textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                }
                
            }
        
            
        }
        
    }
    
}
