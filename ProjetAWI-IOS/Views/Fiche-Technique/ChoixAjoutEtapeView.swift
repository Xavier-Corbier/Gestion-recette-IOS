//
//  ChoixAjoutEtapeView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import SwiftUI

struct ChoixAjoutEtapeView : View {
    @Environment(\.presentationMode) var presentationMode

    private var tabFiche : [FicheTechnique]
    private var intent : FicheTechniqueIntent
    
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var searchText : String = ""
    @State private var selectedIndex : Int = -2
    
    
    init(intent : FicheTechniqueIntent, lvmFiche : FicheTechniqueListViewModel){
        self.intent = intent
        self.tabFiche = lvmFiche.tabFicheTechnique
    }
    
    var tabFicheFiltre : [FicheTechnique] {
        if searchText.isEmpty {
            return tabFiche.filter{ (fiche) -> Bool in
                fiche.progression.filter { (etapeFiche) -> Bool in
                    etapeFiche.estSousFicheTechnique
                }.count == 0 // on est sûr qu'elle ne contient pas de sous fiche technique
            }
        } else {
            return tabFiche.filter{ (fiche) -> Bool in
                fiche.header.nomPlat.uppercased().contains(searchText.uppercased()) &&
                fiche.progression.filter { (etapeFiche) -> Bool in
                    etapeFiche.estSousFicheTechnique
                }.count == 0 // on est sûr qu'elle ne contient pas de sous fiche technique
            }
        }
    }
    
    
    var body: some View {
        VStack {
            Button("Ajout Etape") {
                self.selectedIndex = -1
            }.padding(50)
            
            Spacer()
            
            Text("Ajout une sous-fiche technique : ")
            List  {
                ForEach(Array(tabFicheFiltre.enumerated()), id : \.offset) {
                   index, fiche in
                   HStack {
                       VStack(alignment: .leading){
                           Button(fiche.header.nomPlat){
                               self.selectedIndex = index
                           }
                       }
                   }
               }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationBarTitle(Text("Choix de l'ajout d'étape"), displayMode: .inline)
            .onChange(of: selectedIndex){
                index in
                self.alertMessage = index == -1 ? "Voulez vous ajouter une nouvelle étape ?" : "Voulez vous ajouter cette sous-fiche technique ? "
                self.showingAlert = true
            }
            .alert("\(alertMessage)", isPresented: $showingAlert){
                Button("Ajout") {
                    if selectedIndex == -1 {
                        intent.intentToAddEtape()
                    }
                    else {
                        intent.intentToAddSousFicheTechnique(id: self.tabFicheFiltre[selectedIndex].header.id)
                    }
                    self.presentationMode.wrappedValue.dismiss()

                }
                Button("Annuler", role: .cancel){
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        
    }
    
}
