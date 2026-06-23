//
//  TopicViewModel.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import Foundation
import Firebase
import FirebaseFirestore

@Observable
@MainActor
class TopicViewModel {
    var topics: [Topic] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    func fetchTopics(for categoryId: String) async {
        isLoading = true
        errorMessage = nil
        
        let db = Firestore.firestore()
        let topicsCollectionRef = db.collection("categories").document(categoryId).collection("topics")
        
        do {
            let snapshot = try await topicsCollectionRef
                .getDocuments()
            
            self.topics = snapshot.documents.compactMap { document in
                try? document.data(as: Topic.self)
            }
            
            isLoading = false
        } catch {
            isLoading = false
            self.errorMessage = "Failed to load topics: \(error.localizedDescription)"
            print("Firestore Subcollection Error: \(error)")
        }
    }
}
