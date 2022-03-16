//
//  String.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 23/02/2022.
//

import Foundation

extension String
{
    func replaceComa() -> String
    {
        return self.replacingOccurrences(of: ".", with: ",", options: String.CompareOptions.literal, range: nil)
    }
    
    /**
            Function from https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
     */
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let regex = "^[0-9a-zA-Z]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@",regex).evaluate(with: self)
    }
}
