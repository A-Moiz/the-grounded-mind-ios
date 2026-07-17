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
        Group {
            if dataManager.isPreloading {
                preloadingSection
            } else if let error = dataManager.errorMessage {
                ContentUnavailableView(
                    "Connection Error",
                    systemImage: "wifi.exclamationmark",
                    description: Text(error)
                )
            } else {
                categoriesGridView
            }
        }
        .animation(.easeInOut(duration: 0.5), value: dataManager.isPreloading)
    }
    
    // MARK: - View Builders
    @ViewBuilder
    private var preloadingSection: some View {
        VStack(spacing: 24) {
            Text("The Grounded Mind")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ProgressView("Loading content...")
                .controlSize(.regular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
    
    @ViewBuilder
    private var categoriesGridView: some View {
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
            .padding(16)
        }
        .background(Color(uiColor: .systemBackground))
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Category View
struct CategoryView: View {
    var category: Category
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(category.name.uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .tracking(1)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Divider()
                .background(Color.primary.opacity(0.1))
            
            Text(category.description)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(4)
                .lineSpacing(3)
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Topic View
struct TopicView: View {
    let categoryName: String
    let topics: [Topic]
    @State private var searchText: String = ""
    
    var filteredTopics: [Topic] {
        if searchText.isEmpty {
            return topics
        }
        return topics.filter { $0.heading.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        Group {
            if topics.isEmpty {
                ContentUnavailableView("Coming Soon",
                                       systemImage: "book.closed",
                                       description: Text("Content for this category is currently under compilation."))
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredTopics) { topic in
                            NavigationLink {
                                TopicDetailReadingView(topic: topic)
                            } label: {
                                TopicDetailView(topic: topic)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        if filteredTopics.isEmpty {
                            ContentUnavailableView.search(text: searchText)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search topics")
    }
}

// MARK: - Topic detail View
struct TopicDetailView: View {
    var topic: Topic
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "doc.plaintext.fill")
                .font(.title2)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading) {
                Text(topic.heading)
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                
                if let topicDescription = topic.topicDescription, !topicDescription.isEmpty {
                    Text(topicDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Topic reading view
struct TopicDetailReadingView: View {
    let topic: Topic
    @State private var summaryManager = TopicSummaryManager()
    @State private var selectedURL: URL? = nil
    @Environment(\.colorScheme) var colorScheme
    @State private var activeSheet: ActiveSheet? = nil
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 20) {
                    Text(topic.content)
                        .font(.body)
                        .lineSpacing(8)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                )
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(topic.heading)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $selectedURL) { url in
            SafariView(url: url)
                .ignoresSafeArea()
        }
        .sheet(item: $activeSheet) { sheetType in
            NavigationStack {
                Group {
                    switch sheetType {
                    case .aiSummary:
                        ScrollView {
                            aiSummary.padding()
                        }
                        .navigationTitle("AI Summary")
                        
                    case .images:
                        ScrollView {
                            imagesSection.padding()
                        }
                        .navigationTitle("Images")
                        
                    case .sources:
                        ScrollView {
                            sourcesSection.padding()
                        }
                        .navigationTitle("References")
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(uiColor: .systemGroupedBackground))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            activeSheet = nil
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    // AI Summary Button
                    Button {
                        activeSheet = .aiSummary
                    } label: {
                        Label("AI Summary", systemImage: "sparkles")
                    }
                    
                    // Image Section Button
                    Button {
                        activeSheet = .images
                    } label: {
                        Label("Images", systemImage: "photo")
                    }
                    
                    // Sources Section Button
                    Button {
                        activeSheet = .sources
                    } label: {
                        Label("References", systemImage: "text.page.badge.magnifyingglass")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
    
    // MARK: - AI Summary View
    @ViewBuilder
    private var aiSummary: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Requires iPhone 15 Pro or later")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
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
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .disabled(summaryManager.isGenerating)
                }
            }
            
            if summaryManager.isGenerating {
                HStack(spacing: 12) {
                    ProgressView().tint(.purple)
                    Text("Analysing...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .center)
            } else if !summaryManager.summary.isEmpty {
                Text(summaryManager.summary)
                    .font(.subheadline)
                    .lineSpacing(6)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ContentUnavailableView(
                    "No Summary Yet",
                    systemImage: "sparkles",
                    description: Text("Tap 'Summarise' above to synthesize this topic utilising on-device LLMs.")
                )
                .padding(.top, 20)
            }
        }
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - Images Section View
    @ViewBuilder
    private var imagesSection: some View {
        if let imageUrls = topic.imageURLs, !imageUrls.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(imageUrls, id: \.self) { imageURL in
                        NavigationLink {
                            ImageDetailView(imageURLs: imageUrls, selectedImageURL: imageURL)
                        } label: {
                            KFImage(URL(string: imageURL))
                                .placeholder {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.secondary.opacity(0.1))
                                        .frame(height: 120)
                                        .overlay(ProgressView())
                                }
                                .resizable()
                                .fade(duration: 0.25)
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        } else {
            ContentUnavailableView(
                "No Media Available",
                systemImage: "photo.on.rectangle",
                description: Text("There are no associated images for this topic.")
            )
        }
    }
    
    // MARK: - Sources Section View
    @ViewBuilder
    private var sourcesSection: some View {
        if let sources = topic.sources, !sources.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(sources) { source in
                    if let url = URL(string: source.url) {
                        Button {
                            activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                selectedURL = url
                            }
                        } label: {
                            HStack(alignment: .center, spacing: 14) {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Text("\(source.id)")
                                            .font(.caption.bold())
                                            .foregroundColor(.blue)
                                    )
                                
                                Text(source.label)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right.square")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 12)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        if source.id != sources.last?.id {
                            Divider()
                                .padding(.leading, 46)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
        } else {
            ContentUnavailableView(
                "No References",
                systemImage: "text.badge.xmark",
                description: Text("There are no external sources listed for this topic.")
            )
        }
    }
}

// MARK: - Image detail View
struct ImageDetailView: View {
    let imageURLs: [String]
    @State var selectedImageURL: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            TabView(selection: $selectedImageURL) {
                ForEach(imageURLs, id: \.self) { urlString in
                    VStack {
                        KFImage(URL(string: urlString))
                            .placeholder {
                                ProgressView()
                                    .scaleEffect(1.2)
                            }
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 8)
                    }
                    .tag(urlString)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .background(Color(.systemBackground))
        .toolbarTitleDisplayMode(.inline)
    }
}

// MARK: - URL Extension
extension URL: @retroactive Identifiable {
    public var id: URL { self }
}

#Preview {
    AllCategoriesView()
}
