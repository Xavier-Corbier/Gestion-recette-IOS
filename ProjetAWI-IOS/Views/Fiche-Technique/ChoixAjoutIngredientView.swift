//
//  ChoixAjoutIngredientView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 05/03/2022.
//

import Foundation
import SwiftUI

struct ChoixAjoutIngredientView : View {
    @Environment(\.presentationMode) var presentationMode

    private var tabIngredient : [Ingredient] = []
    private var intent : EtapeIntent
    
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var searchText : String = ""
    @State private var selectedIndex : Int = -1
    
    
    init(intent : EtapeIntent, lvmIngredient : IngredientListViewModel){
        self.intent = intent
        self.tabIngredient = lvmIngredient.tabIngredient
    }
    
    var tabIngredientFiltre : [Ingredient] {
        if searchText.isEmpty {
            return tabIngredient
        } else {
            return tabIngredient.filter{ (ingredient) -> Bool in
                ingredient.nomIngredient.uppercased().contains(searchText.uppercased())
            }
        }
    }
    
    
    var body: some View {
        VStack {
            Text("Ajout un ingrédient : ").padding(10)
            List  {
                ForEach(Array(tabIngredientFiltre.enumerated()), id : \.offset) {
                   index, ingredient in
                   HStack {
                       VStack(alignment: .leading){
                           Button(ingredient.nomIngredient){
                               self.selectedIndex = index
                           }
                       }
                   }
               }
            }
        }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationBarTitle(Text("Choix de l'ajout d'ingrédient"), displayMode: .inline)
            .onChange(of: selectedIndex){
                index in
                self.alertMessage = "Voulez vous ajouter cette ingrédient ? "
                self.showingAlert = true
            }
            .alert("\(alertMessage)", isPresented: $showingAlert){
                Button("Ajout") {
                    intent.intentToAddDenree(id: self.tabIngredientFiltre[selectedIndex].id == nil ? "" : self.tabIngredientFiltre[selectedIndex].id!)
                    self.presentationMode.wrappedValue.dismiss()

                }
                Button("Annuler", role: .cancel){
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        
    }
    
}
