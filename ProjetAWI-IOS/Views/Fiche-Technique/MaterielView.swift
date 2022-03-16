//
//  FicheTechniqueMaterielView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 03/03/2022.
//

import Foundation
import SwiftUI

struct MaterielView : View {
    
    @ObservedObject var ficheTechniqueVM : FicheTechniqueViewModel
    @State var isUpdate : Bool = false

    var intent : FicheTechniqueIntent
    
    init(vm : FicheTechniqueViewModel, intent : FicheTechniqueIntent){
        self.ficheTechniqueVM = vm
        self.intent = intent
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Materiel Spécifique")){
                    TextEditor(text: $ficheTechniqueVM.materielSpecifique)
                        .disabled(!isUpdate)
                        .frame(minHeight:200)
                }
                
                Section(header : Text("Materiel Dressage")){
                    TextEditor(text: $ficheTechniqueVM.materielDressage)
                        .disabled(!isUpdate)
                        .frame(minHeight:200)
                }
            }
            
            Spacer()
            
            HStack{
                Button("\(isUpdate ? "Terminer" : "Modifier")"){
                    self.isUpdate = !self.isUpdate
                    if isUpdate {
                        intent.intentToChange(materielSpecifique: ficheTechniqueVM.materielSpecifique)
                        intent.intentToChange(materielDressage: ficheTechniqueVM.materielDressage)
                    }
                }.padding(20)
            }.padding(20)
        }
        
    }
    
}
