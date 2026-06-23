//
//  Category.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import Foundation
import FirebaseFirestore

struct Category: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let description: String
}
