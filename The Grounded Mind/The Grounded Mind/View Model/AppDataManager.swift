//
//  AppDataManager.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import Foundation
import FirebaseFirestore

@Observable
@MainActor
class AppDataManager {
    var categories: [Category] = []
    var topicsCache: [String: [Topic]] = [:]
    var isPreloading: Bool = true
    var errorMessage: String? = nil
    
    func preloadAllData() async {
        isPreloading = true
        errorMessage = nil
        
        let db = Firestore.firestore()
        do {
            let categorySnapshot = try await db.collection("categories")
                .getDocuments()
            
            self.categories = categorySnapshot.documents.compactMap { doc in
                try? doc.data(as: Category.self)
            }
            
            let topicsSnapshot = try await db.collectionGroup("topics")
                .getDocuments()
            
            var temporaryCache: [String: [Topic]] = [:]
            
            for document in topicsSnapshot.documents {
                if let categoryId = document.reference.parent.parent?.documentID,
                   let topic = try? document.data(as: Topic.self) {
                    
                    temporaryCache[categoryId, default: []].append(topic)
                }
            }
            
            self.topicsCache = temporaryCache
            self.isPreloading = false
            
        } catch {
            self.isPreloading = false
            self.errorMessage = "Initialization error: \(error.localizedDescription)"
        }
    }
}
