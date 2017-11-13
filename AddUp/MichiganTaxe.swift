//
//  MichiganTaxe.swift
//  AddUp

//=================================
import Foundation
//=================================
class MichiganTaxe {
    //# MARK: - Properties
    var theTaxe: Float!
    
    //# MARK: - getTaxes
    func getTaxes(initialAmount: Float) -> String {
        self.theTaxe = initialAmount * 0.06
        return String(format: "%.2f", self.theTaxe)
    }
    
    //# MARK: - getAmountWithTaxes
    func getAmountWithTaxes(initialAmount: Float) -> String {
        let taxes: Float = Float(self.getTaxes(initialAmount:
            initialAmount))!
        return String(format: "%.2f", (taxes + initialAmount))
    }
}
//=================================

