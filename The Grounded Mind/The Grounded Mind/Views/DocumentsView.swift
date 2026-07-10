//
//  DocumentsView.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 10/07/2026.
//

import SwiftUI

struct DocumentsView: View {
    @State private var shareItem: URL? = nil
    @State private var showShareSheet: Bool = false
    let documents: [DocumentFile] = [
        DocumentFile(title: "Why Islam?", filename: "why_islam", fileExtension: "pdf")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Header
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Recommended Reading", systemImage: "books.vertical.fill")
                            .font(.headline)
                        
                        Text("A curated of resources that complement the topics covered in this app. Each document can be saved directly to your device.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: - Documents
                Section {
                    ForEach(documents) { document in
                        if let url = document.url {
                            ShareLink(item: url) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.red.opacity(0.12))
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "doc.fill")
                                            .foregroundColor(.red)
                                            .font(.title3)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(document.title)
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.accentColor)
                                        .font(.subheadline)
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Documents")
        }
    }
}

#Preview {
    DocumentsView()
}
