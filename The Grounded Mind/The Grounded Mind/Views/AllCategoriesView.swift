//
//  AllCategoriesView.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import SwiftUI

struct AllCategoriesView: View {
    @Environment(AppDataManager.self) private var dataManager
    
    var body: some View {
        if dataManager.isPreloading {
            // A professional, clean loading screen while downloading paragraphs
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
            CategorySelectionView()
        }
    }
}

struct CategorySelectionView: View {
    @Environment(AppDataManager.self) private var dataManager
    
    var body: some View {
        NavigationStack {
            List(dataManager.categories) { category in
                if let categoryId = category.id {
                    NavigationLink(category.name) {
                        TopicListView(
                            categoryName: category.name,
                            topics: dataManager.topicsCache[categoryId] ?? []
                        )
                    }
                }
            }
        }
    }
}

struct TopicListView: View {
    let categoryName: String
    let topics: [Topic]
    
    var body: some View {
        List(topics) { topic in
            NavigationLink(topic.heading) {
                Text(topic.content)
                    .padding()
                    .navigationTitle(topic.heading)
            }
        }
        .navigationTitle(categoryName)
    }
}

#Preview {
    AllCategoriesView()
}
