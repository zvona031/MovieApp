//
//  Collection+Extension.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 17.05.2022..
//

extension Collection where Indices.Iterator.Element == Index {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
