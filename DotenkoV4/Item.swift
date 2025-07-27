//
//  Item.swift
//  DotenkoV4
//
//  Created by Takuma Shinoda on 2025/07/27.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
