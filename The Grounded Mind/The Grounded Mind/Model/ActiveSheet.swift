//
//  ActiveSheet.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 14/07/2026.
//

import Foundation

enum ActiveSheet: Identifiable {
    case aiSummary
    case images
    case sources
    
    var id: Int {
        switch self {
        case .aiSummary: return 0
        case .images: return 1
        case .sources: return 2
        }
    }
}
