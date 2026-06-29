//
//  Topic.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import Foundation
import FirebaseFirestore

struct Topic: Identifiable, Codable {
    @DocumentID var id: String?
    let heading: String
    let content: String
    let sources: [TopicSource]
    let imageURLs: [String]?
}
