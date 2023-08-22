//
//  Memory.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 12.08.2023.
//

import Foundation

struct Memory {
    var name: String
    var desription: String?
    var isChecked = false
}

extension Memory {
    func getMemoryList() -> [Memory] {
        [
            Memory(name: "sin, cos properties"),
            Memory(name: "Euler's formula"),
            Memory(name: "Applications of trigonometry"),
        ]
    }
}
