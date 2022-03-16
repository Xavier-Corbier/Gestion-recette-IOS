//
//  MutipleSelectionIngredient.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 05/03/2022.
//

import Foundation
import SwiftUI

struct MultipleSelectionIngredient: View {
    var items: [Ingredient]
    @Binding var selections: [String]
    @State private var searchText : String = ""
    var ingredientFiltre: [Ingredient] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter{ $0.nomIngredient.uppercased().contains(searchText.uppercased()) }
        }
    }
    var body: some View {
        VStack {
            List {
                ForEach(Array(ingredientFiltre.enumerated()), id: \.offset) { index,ingredient in
                    MultipleSelectionRow(title: ingredient.nomIngredient, isSelected: self.selections.contains(ingredient.nomIngredient)) {
                        if self.selections.contains(ingredient.nomIngredient) {
                            self.selections.removeAll(where: { $0 == ingredient.nomIngredient })
                        }
                        else {
                            self.selections.append(ingredient.nomIngredient)
                        }
                    }
                }
            }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}
