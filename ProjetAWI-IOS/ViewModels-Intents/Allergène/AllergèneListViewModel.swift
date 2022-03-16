//
//  AllergèneListViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 24/02/2022.
//


import Foundation
import SwiftUI
import Combine

enum AllergèneListViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case deleteError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .deleteError : return "Erreur de supression"
        }
    }
}

class AllergèneListViewModel : ObservableObject, Subscriber, AllergèneListServiceObserver {

    private var allergèneService : AllergèneService = AllergèneService()
    @Published var tabAllergène : [Allergène]
    @Published var result : Result<String, AllergèneListViewModelError> = .failure(.noError)

    init() {
        self.tabAllergène = []
        self.allergèneService.addObserver(observer: self)
        self.allergèneService.getAllAllergène()
    }
    
    func emit(to: [Allergène]) {
        self.tabAllergène = to
    }
    
    func emit(to: Result<String, AllergèneListViewModelError>) {
        self.result = to
    }
    
    typealias Input = AllergèneListIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: AllergèneListIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .deleteAllergène(let id):
            self.allergèneService.deleteAllergène(allergène: self.tabAllergène[id])
        }
        return .none
    }
    
    
}
