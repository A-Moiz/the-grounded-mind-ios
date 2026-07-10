//
//  DocumentFile.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 10/07/2026.
//

import Foundation
import SwiftUI

struct DocumentFile: Identifiable {
    let id = UUID()
    let title: String
    let filename: String
    let fileExtension: String
    
    var url: URL? {
        Bundle.main.url(forResource: filename, withExtension: fileExtension)
    }
}

