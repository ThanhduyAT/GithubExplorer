//
//  Item.swift
//  GitHubExplorer
//
//  Created by Duy Thanh on 30/4/25.
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
