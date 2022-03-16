//
//  Double.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 05/03/2022.
//

extension Double
{
    func formatComa() -> String
    {
        return String(format: "%.2f", self).replaceComa()
    }
}
