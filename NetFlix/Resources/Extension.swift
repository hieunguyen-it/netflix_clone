//
//  Extension.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 4/19/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
