//
//  PrintFicheView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import SwiftUI

struct PrintFicheView : View {

    @State var isChecked:Bool = false
    var fiche : FicheTechniqueViewModel
    var vmIngredient : IngredientListViewModel
    func toggle(){isChecked = !isChecked}
    
    init(fiche : FicheTechniqueViewModel, vmIngredient : IngredientListViewModel){
        self.fiche = fiche
        self.vmIngredient = vmIngredient
    }
    
    var body: some View {
        VStack {
            Form {
                Button(action: toggle){
                    HStack{
                        Image(systemName: isChecked ? "checkmark.square": "square")
                        Spacer()
                        Text("Imprimer avec les coûts ?")
                    }
                }
            }

            Spacer()
            Button("Imprimer"){
                createFichePDF()
            }.padding(20)
        }.padding()
            .navigationBarTitle(Text("Impression Fiche"), displayMode: .inline)
    }
    
    fileprivate func headerFiche(_ html: inout String) {
        if let fileURL = Bundle.main.url(forResource: "head-fiche", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-YYYY"
                let dateHTML = fileContents.replacingOccurrences(of: "{{date}}", with: dateFormatter.string(from: date))
                let nomPlatHTML = dateHTML.replacingOccurrences(of: "{{nomPlat}}", with: self.fiche.nomPlat)
                let nomAuteurHTML = nomPlatHTML.replacingOccurrences(of: "{{nomAuteur}}", with: self.fiche.nomAuteur)
                html = nomAuteurHTML.replacingOccurrences(of: "{{nbrCouvert}}", with: "\(self.fiche.couvert)")
            }
        }
    }
    
    fileprivate func etapeFiche(_ etapeHTML: inout String) {
        if let fileURL = Bundle.main.url(forResource: "etape", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                etapeHTML = fileContents
            }
        }
    }
    
    fileprivate func etapeSousFiche(_ etapeHTML: String, _ i: Int, _ html: inout String) {
        let nomHTML = etapeHTML.replacingOccurrences(of: "{{nom}}", with: "<b>"+fiche.progression[i].nomSousFicheTechnique!+"</b>")
        let phaseHTML = nomHTML.replacingOccurrences(of: "{{phase}}", with: "\(i+1)")
        let tempsHTML = phaseHTML.replacingOccurrences(of: "{{temps}}", with: fiche.progression[i].getDureeTotal.formatComa())
        var denreeInputHTML = ""
        var unitéInputHTML = ""
        var quantitéInputHTML = ""
        var descriptionInputHTML = ""
        for j in 0..<fiche.progression[i].etapes.count {
            let etape = EtapeViewModel(ficheTechViewModel: fiche, ingredientVM: vmIngredient, indice: i, indiceSousFiche: j)
            descriptionInputHTML += "<b>"+etape.nomEtape+"</b><br>"
            descriptionInputHTML += etape.descriptionEtape + "<br>"
            for denree in etape.contenu {
                denreeInputHTML += denree.ingredient.nomIngredient + "<br>"
                unitéInputHTML += denree.ingredient.unite + "<br>"
                quantitéInputHTML += denree.nombre.formatComa() + "<br>"
            }
            
        }
        let denreeHTML = tempsHTML.replacingOccurrences(of: "{{denree}}", with: denreeInputHTML)
        let descriptionHTML = denreeHTML.replacingOccurrences(of: "{{description}}", with: descriptionInputHTML)
        let unitéHTML = descriptionHTML.replacingOccurrences(of: "{{unité}}", with: unitéInputHTML)
        let quantitéHTML = unitéHTML.replacingOccurrences(of: "{{quantité}}", with: quantitéInputHTML)
        html += quantitéHTML
    }
    
    fileprivate func etapeFicheContent(_ etapeHTML: String, _ html: inout String) {
        for i in 0..<fiche.progression.count {
            if fiche.progression[i].estSousFicheTechnique {
                etapeSousFiche(etapeHTML, i, &html)
            } else {
                let etape = EtapeViewModel(ficheTechViewModel: fiche, ingredientVM: vmIngredient, indice: i)
                let nomHTML = etapeHTML.replacingOccurrences(of: "{{nom}}", with: "<b>"+etape.nomEtape+"</b>")
                let descriptionHTML = nomHTML.replacingOccurrences(of: "{{description}}", with: etape.descriptionEtape)
                let phaseHTML = descriptionHTML.replacingOccurrences(of: "{{phase}}", with: "\(i+1)")
                let tempsHTML = phaseHTML.replacingOccurrences(of: "{{temps}}", with: etape.dureeEtape.formatComa())
                var denreeInputHTML = ""
                var unitéInputHTML = ""
                var quantitéInputHTML = ""
                for denree in etape.contenu {
                    denreeInputHTML += denree.ingredient.nomIngredient + "<br>"
                    unitéInputHTML += denree.ingredient.unite + "<br>"
                    quantitéInputHTML += denree.nombre.formatComa() + "<br>"
                }
                let denreeHTML = tempsHTML.replacingOccurrences(of: "{{denree}}", with: denreeInputHTML)
                let unitéHTML = denreeHTML.replacingOccurrences(of: "{{unité}}", with: unitéInputHTML)
                let quantitéHTML = unitéHTML.replacingOccurrences(of: "{{quantité}}", with: quantitéInputHTML)
                html += quantitéHTML
            }
            
        }
    }
    
    fileprivate func materielFiche(_ materielHTML: inout String) {
        if let fileURL = Bundle.main.url(forResource: "materiel", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                let dressageHTML = fileContents.replacingOccurrences(of: "{{dressage}}", with: self.fiche.materielDressage.count == 0 ? "Aucun" :  self.fiche.materielDressage)
                materielHTML = dressageHTML.replacingOccurrences(of: "{{spécifiques}}", with: self.fiche.materielSpecifique.count == 0 ? "Aucun" : self.fiche.materielSpecifique)
            }
        }
    }
    
    fileprivate func coutsFiche(_ html: inout String) {
        if let fileURL = Bundle.main.url(forResource: "couts", withExtension: "html") {
            if let fileContents = try? String(contentsOf: fileURL) {
                let beneficeParPortionHTML = fileContents.replacingOccurrences(of: "{{beneficeParPortion}}", with: self.fiche.beneficePortion.formatComa())
                let beneficeTotalHTML = beneficeParPortionHTML.replacingOccurrences(of: "{{beneficeTotal}}", with: "fdd")
                let coefCoutProductionHTML = beneficeTotalHTML.replacingOccurrences(of: "{{coefCoutProduction}}", with: self.fiche.coefCoutProduction.formatComa())
                let coefPrixDeVenteHTML = coefCoutProductionHTML.replacingOccurrences(of: "{{coefPrixDeVente}}", with: self.fiche.coefPrixDeVente.formatComa())
                let coutFluideHTML = coefPrixDeVenteHTML.replacingOccurrences(of: "{{coutFluide}}", with: self.fiche.coutFluide.formatComa())
                let coutMatiereHTML = coutFluideHTML.replacingOccurrences(of: "{{coutMatiere}}", with: self.fiche.coutMatiere.formatComa())
                let coutMatiereTotalHTML = coutMatiereHTML.replacingOccurrences(of: "{{coutMatiereTotal}}", with: self.fiche.coutMatiereTotal.formatComa())
                let coutMoyenHorraireHTML = coutMatiereTotalHTML.replacingOccurrences(of: "{{coutMoyenHorraire}}", with: self.fiche.coutMoyenHoraire.formatComa())
                let coutPersonnelHTML = coutMoyenHorraireHTML.replacingOccurrences(of: "{{coutPersonnel}}", with: self.fiche.coutPersonnel.formatComa())
                let coutProductionHTML = coutPersonnelHTML.replacingOccurrences(of: "{{coutProduction}}", with: self.fiche.coutProductionTotal.formatComa())
                let coutProductionPortionHTML = coutProductionHTML.replacingOccurrences(of: "{{coutProductionPortion}}", with: self.fiche.coutProductionPortion.formatComa())
                let prixDeVentePortionHTHTML = coutProductionPortionHTML.replacingOccurrences(of: "{{prixDeVentePortionHT}}", with: self.fiche.prixDeVentePortion.formatComa())
                let prixDeVenteTotalHTHTML = prixDeVentePortionHTHTML.replacingOccurrences(of: "{{prixDeVenteTotalHT}}", with: self.fiche.prixDeVente.formatComa())
                let prixDeVentePortionTTCHTML = prixDeVenteTotalHTHTML.replacingOccurrences(of: "{{prixDeVentePortionTTC}}", with: (self.fiche.prixDeVentePortion * 0.2).formatComa())
                let prixDeVenteTotalTTCHTML = prixDeVentePortionTTCHTML.replacingOccurrences(of: "{{prixDeVenteTotalTTC}}", with: (self.fiche.prixDeVente * 0.2).formatComa())
                let seuilRentabiliteHTML = prixDeVenteTotalTTCHTML.replacingOccurrences(of: "{{seuilRentabilite}}", with: "\(self.fiche.seuilRentabilité)")
                let dureeTotalHTML = seuilRentabiliteHTML.replacingOccurrences(of: "{{dureeTotal}}", with: self.fiche.dureeTotal.formatComa())
                html += dureeTotalHTML
                
            }
        }
    }
    
    func createFichePDF(){
        var html = ""
        headerFiche(&html)
        var etapeHTML = ""
        etapeFiche(&etapeHTML)
        etapeFicheContent(etapeHTML, &html)
        var materielHTML = ""
        materielFiche(&materielHTML)
        html += materielHTML
        if isChecked {
            coutsFiche(&html)
        }
        PDF.createPDF(nom: "Fiche_technique", html: html){ link in
            let url = URL(string: link)
                    let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
        }
    }
    
}
