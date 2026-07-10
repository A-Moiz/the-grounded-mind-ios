//
//  ContentView.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import SwiftUI

struct IntroView: View {
    @State private var navigateToAllCategories: Bool = false
    @State private var showPrerequisite: Bool = false
    @State private var showDocumentsView: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // MARK: - Header
                    VStack(spacing: 12) {
                        Text("Explore beliefs through reason, evidence, and thoughtful discussion.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }

                    // MARK: - Prerequisite Card
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("A Question Worth Asking", systemImage: "globe.americas.fill")
                                .font(.headline)

                            Text("There are 2.3 billion Christians, 2 billion Muslims, 1.1 billion Hindus, 500 million Buddhists, and 15 million Jews in the world - and a total of 4,300 religions.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 10) {
                            Label("Cartesian Skepticism", systemImage: "lightbulb.fill")
                                .font(.headline)

                            Text("We will answer this with a technique developed by the philosopher Descartes.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)

                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "basket.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                                    .padding(.top, 2)

                                Text("Imagine a basket full of apples. Instead of checking each apple one by one and throwing away the rotten ones, you empty the whole basket - then only put back the good ones.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(4)
                            }
                            .padding()
                            .background(Color.accentColor.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            Text("Let's apply this to religion. We can't examine all 4,300 religions one by one - so instead, let's look at the clues the universe itself gives us through reason and logic, and determine the conditions that must exist in a true religion.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal)

                    // MARK: - CTA Button
                    Button("Get Started") {
                        navigateToAllCategories = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Button("View Documents") {
                        showDocumentsView = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
            }
            .navigationTitle("The Grounded Mind")
            .navigationDestination(isPresented: $navigateToAllCategories) {
                AllCategoriesView()
            }
            .sheet(isPresented: $showDocumentsView) {
                DocumentsView()
            }
        }
    }
}

#Preview {
    IntroView()
}

