//
//  VenteView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import SwiftUI

struct VenteView : View {
    @ObservedObject var vente : VenteViewModel
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    var intent : VenteIntent
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.fixed(50))]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
        
    init(fiche : FicheTechniqueViewModel){
        self.vente = VenteViewModel(idficheReference: fiche.id)
        self.intent = VenteIntent()
        self.intent.addObserver(vente)
    }
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    LazyVGrid(columns: columns, alignment: .leading){
                        Text("Nombre de vente : ")
                        TextField("Nombre", value : $vente.nbrPlatVendu, formatter: formatter)
                            .onSubmit {
                                intent.intentToChange(nbrPlatVendu: vente.nbrPlatVendu)
                            }
                    }
                }
            }.onChange(of: vente.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = "\(msg)"
                    self.vente.nbrPlatVendu = 1
                    self.intent.intentToChange(nbrPlatVendu: self.vente.nbrPlatVendu)
                    self.showingAlert = true
                case let .failure(error):
                    switch error {
                    case .createError, .inputError :
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    case .noError :
                        return
                    }
                }
            }.alert(Text(alertMessage), isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    vente.result = .failure(.noError)
                    self.showingAlert = false
                }
            }
            Spacer()
            Button("Vendre"){
                makeVente()
            }.padding(20)
        }.padding()
            .navigationBarTitle(Text("Vente"), displayMode: .inline)
    }
    
    func makeVente(){
        intent.intentToChangeAddVente()
    }
    
}
