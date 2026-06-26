//
//  AllCategoriesView.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import SwiftUI

struct AllCategoriesView: View {
    @Environment(AppDataManager.self) private var dataManager
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        if dataManager.isPreloading {
            VStack(spacing: 20) {
                Text("The Grounded Mind")
                    .font(.largeTitle)
                    .bold()
                
                ProgressView("Syncing reference library...")
            }
        } else if let error = dataManager.errorMessage {
            ContentUnavailableView("Connection Error",
                                   systemImage: "wifi.exclamationmark",
                                   description: Text(error))
        } else {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(dataManager.categories) { category in
                            if let categoryId = category.id {
                                NavigationLink {
                                    TopicView(
                                        categoryName: category.name,
                                        topics: dataManager.topicsCache[categoryId] ?? []
                                    )
                                } label: {
                                    CategoryView(category: category)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct CategoryView: View {
    var category: Category
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category.name.uppercased())
                .font(.headline)
                .bold()
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Divider()
            
            Text(category.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(5)
            
            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }
}

struct TopicView: View {
    let categoryName: String
    let topics: [Topic]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        Group {
            if topics.isEmpty {
                ContentUnavailableView("Coming Soon",
                                       systemImage: "book.closed",
                                       description: Text("Content for this category is currently under compilation."))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(topics) { topic in
                            NavigationLink {
                                TopicDetailReadingView(topic: topic)
                            } label: {
                                TopicDetailView(topic: topic)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TopicDetailView: View {
    var topic: Topic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "doc.plaintext.fill")
                .font(.title2)
                .foregroundColor(.accentColor)
            
            Text(topic.heading)
                .font(.subheadline)
                .bold()
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
            
            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }
}

struct TopicDetailReadingView: View {
    let topic: Topic
    @State private var selectedURL: URL? = nil
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(topic.content)
                    .font(.body)
                    .lineSpacing(6)
                
                Divider()
                
                if let imageKeys = topic.imageKey, !imageKeys.isEmpty {
                    Text("Images")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(imageKeys, id: \.self) { imageName in
                            NavigationLink {
                                ImageDetailView(imageName: imageName)
                            } label: {
                                Image(imageName)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
                
                Divider()
                
                if !topic.sources.isEmpty {
                    Text("Sources")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    ForEach(topic.sources) { source in
                        if let url = URL(string: source.url) {
                            Button {
                                selectedURL = url
                            } label: {
                                HStack(alignment: .top, spacing: 8) {
                                    Text("[\(source.id)] \(source.label)")
                                        .font(.footnote)
                                        .foregroundColor(.blue)
                                        .multilineTextAlignment(.leading)
                                        .underline()
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(topic.heading)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $selectedURL) { url in
            SafariView(url: url)
                .ignoresSafeArea()
        }
    }
}

struct ImageDetailView: View {
    var imageName: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
}

extension URL: @retroactive Identifiable {
    public var id: URL { self }
}

#Preview {
    AllCategoriesView()
}
