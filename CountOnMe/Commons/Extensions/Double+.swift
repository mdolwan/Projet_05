//
//  Double+.swift
//  CountOnMe
//
//  Created by Mohammad Olwan on 03/10/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
