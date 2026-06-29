//
//  TopicSummaryManager.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 27/06/2026.
//

import Foundation
import FoundationModels

@Observable
class TopicSummaryManager {
    var summary: String = ""
    var isGenerating: Bool = false
    
    func generateSummary(for content: String) async {
        isGenerating = true
        
        do {
            let session = LanguageModelSession()
            
            let prompt = "Summarize the following text concisely:\n\n\(content)"
            
            let response = try await session.respond(to: prompt)
            
            await MainActor.run {
                self.summary = response.content
                self.isGenerating = false
            }
        } catch {
            await MainActor.run {
                self.summary = "Failed to generate summary locally."
                self.isGenerating = false
            }
        }
    }
}

