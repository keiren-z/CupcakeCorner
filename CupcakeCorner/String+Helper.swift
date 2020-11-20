//
//  String+Helper.swift
//  CupcakeCorner
//
//  Created by Karen Zaracho on 11/19/20.
//

import Foundation

extension String {
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
