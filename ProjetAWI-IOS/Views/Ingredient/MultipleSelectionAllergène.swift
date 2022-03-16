//
//  MultipleSelectionAllergène.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation
import SwiftUI

struct MultipleSelectionAllergène: View {
    var items: [Allergène] 
    @Binding var selections: [String]
    @State private var searchText : String = ""
    var allergènesFiltre: [Allergène] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter{ $0.nom.uppercased().contains(searchText.uppercased()) }
        }
    }
    var body: some View {
        VStack {
            List {
                ForEach(Array(allergènesFiltre.enumerated()), id: \.offset) { index,allergène in
                    MultipleSelectionRow(title: allergène.nom, isSelected: self.selections.contains(allergène.nom)) {
                        if self.selections.contains(allergène.nom) {
                            self.selections.removeAll(where: { $0 == allergène.nom })
                        }
                        else {
                            self.selections.append(allergène.nom)
                        }
                    }
                }
            }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}
