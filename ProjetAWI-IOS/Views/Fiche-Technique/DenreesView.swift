//
//  DenreesView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 03/03/2022.
//

import Foundation
import SwiftUI

struct DenreesView : View {

    var tabDenree : [Denree] = []
    
    init(vm : FicheTechniqueViewModel){
        self.tabDenree = vm.getListDenree()
    }
    
    var sommeDenrées : Double {
        var somme : Double = 0
        for d in tabDenree {
            somme += d.nombre * d.ingredient.prixUnitaire
        }
        return somme
    }
    
    var body: some View {
        VStack {
            Text("Coût total des denrées : " + String(format: "%.2f",sommeDenrées).replaceComa() + "€").padding(20)
            List  {
                ForEach(Array(tabDenree.enumerated()), id : \.offset) {
                   index, denree in
                   HStack {
                       VStack(alignment: .leading){
                           Text(denree.ingredient.nomIngredient).bold()
                           HStack {
                               Text(String(format: "%.3f",denree.nombre).replaceComa() + " " + denree.ingredient.unite)
                               Text("à " + String(format: "%.3f",denree.ingredient.prixUnitaire).replaceComa())
                               Text("€/" + denree.ingredient.unite)
                               Text(" (" + String(format: "%.3f",denree.ingredient.prixUnitaire * denree.nombre).replaceComa()+"€)")
                           }
                       }
                   }
               }
            }
        }
        
    }
    
}
