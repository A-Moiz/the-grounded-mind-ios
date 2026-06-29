//
//  AllCategoriesView.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import SwiftUI
import FoundationModels
import Kingfisher

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
    @State private var summaryManager = TopicSummaryManager()
    @State private var selectedURL: URL? = nil
    @Environment(\.colorScheme) var colorScheme
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            GlassEffectContainer(spacing: 24) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - AI Summary Section
                    aiSummary
                    
                    // MARK: - Topic Content Panel
                    VStack(alignment: .leading, spacing: 20) {
                        Text(topic.content)
                            .font(.body)
                            .lineSpacing(8)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    
                    // MARK: - Media Grid Section
                    imagesSection
                    
                    // MARK: - Sources Reference Section
                    sourcesSection
                }
                .padding()
            }
        }
        .navigationTitle(topic.heading)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $selectedURL) { url in
            SafariView(url: url)
                .ignoresSafeArea()
        }
    }
    
    // MARK: - AI Summary section
    @ViewBuilder
    var aiSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text("Requires iPhone 15 Pro Max or later")
                    .font(.footnote.bold())
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.headline)
                            .foregroundStyle(Color("LightGreen"))
                        Text("Apple Intelligence")
                            .font(.subheadline.bold())
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            guard SystemLanguageModel.default.isAvailable else { return }
                            await summaryManager.generateSummary(for: topic.content)
                        }
                    } label: {
                        Text("Summarise")
                            .font(.footnote.bold())
                    }
                    .buttonStyle(.glass)
                    .disabled(summaryManager.isGenerating)
                }
            }
            
            if summaryManager.isGenerating {
                HStack(spacing: 12) {
                    ProgressView().tint(.purple)
                    Text("Analysing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .center)
            } else if !summaryManager.summary.isEmpty {
                Text(summaryManager.summary)
                    .font(.footnote)
                    .lineSpacing(5)
                    .padding(14)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .glassEffect(.regular.tint(colorScheme == .dark ? .purple.opacity(0.5) : Color("LightPurple")).interactive(), in: .rect(cornerRadius: 20))
    }
    
    // MARK: - Images section
    @ViewBuilder
    var imagesSection: some View {
        if let imageUrls = topic.imageURLs, !imageUrls.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Images")
                    .font(.headline)
                    .foregroundColor(.secondary)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(imageUrls, id: \.self) { imageURL in
                        NavigationLink {
                            ImageDetailView(imageURL: imageURL)
                        } label: {
                            KFImage(URL(string: imageURL))
                                .placeholder {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.secondary.opacity(0.1))
                                        .frame(width: 120, height: 120)
                                        .overlay(ProgressView())
                                }
                                .resizable()
                                .fade(duration: 0.25)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
        }
    }
    
    // MARK: - Sources section
    @ViewBuilder
    var sourcesSection: some View {
        if !topic.sources.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                Text("Sources")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                ForEach(topic.sources) { source in
                    if let url = URL(string: source.url) {
                        Button {
                            selectedURL = url
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Text("\(source.id)")
                                            .font(.caption2.bold())
                                            .foregroundColor(.blue)
                                    )
                                
                                Text(source.label)
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right.square")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                        }
                        .glassEffect(.clear, in: .rect(cornerRadius: 10))
                    }
                }
            }
            .padding(20)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
        }
    }
}

struct ImageDetailView: View {
    var imageURL: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .padding()
                case .failure:
                    ContentUnavailableView("Image unavailable", systemImage: "photo.slash")
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}

extension URL: @retroactive Identifiable {
    public var id: URL { self }
}

#Preview {
    AllCategoriesView()
}
