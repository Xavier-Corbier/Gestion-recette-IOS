//
//  EtapeFicheView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 03/03/2022.
//

import Foundation

import SwiftUI

struct EtapeFicheView : View {
    @Environment(\.editMode) var editMode

    @ObservedObject var ficheVM : FicheTechniqueViewModel
    @ObservedObject var ingredientVM : IngredientListViewModel
    
    @State var isUpdate : Bool = false
    @State var isEditMode : Bool = false
    
    var intent : FicheTechniqueIntent
    private var indice : Int

    
    init(vm : FicheTechniqueViewModel,vmIngredient : IngredientListViewModel, intent : FicheTechniqueIntent, indice : Int){
        self.ficheVM = vm
        self.intent = intent
        self.indice = indice
        self.ingredientVM = vmIngredient
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header : Text("Nom de la sous-fiche technique")){
                    HStack{
                        Text("\(ficheVM.progression[self.indice].nomSousFicheTechnique!)")
                    }
                }
                
                Section(header:Text("Liste des étapes")){
                    List {
                        ForEach(Array(ficheVM.progression[self.indice].etapes.enumerated()), id: \.offset) { index, etape in
                            HStack {
                                NavigationLink(destination : EtapeDetailView(vm: ficheVM, indice: self.indice, vmIngredient: ingredientVM, indiceSousFicheTechnique: index)){
                                    VStack(alignment: .leading){
                                        HStack{
                                            Image(systemName:"\(index+1).circle")
                                            Image(systemName:"e.circle")
                                        }
                                        Text("\(etape.description.nom)")
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    
}
