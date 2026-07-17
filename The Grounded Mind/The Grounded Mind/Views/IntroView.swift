//
//  ContentView.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import SwiftUI

struct IntroView: View {
    @State private var navigateToAllCategories: Bool = false
    @State private var showDocumentsView: Bool = false
    @State private var currentStep: Int = 0
    @State private var animateContent: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                TabView(selection: $currentStep) {
                    questionStepCard
                        .tag(0)
                    
                    disclaimerStepCard
                        .tag(1)
                    
                    skepticismStepCard
                        .tag(2)
                    
                    logicStepCard
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .ignoresSafeArea()
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.88)
                .offset(y: animateContent ? 0 : 350)
            }
            .background(Color(uiColor: .secondarySystemBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToAllCategories) {
                AllCategoriesView()
            }
            .sheet(isPresented: $showDocumentsView) {
                DocumentsView()
            }
            .onAppear {
                triggerLaunchAnimations()
            }
        }
    }
    
    // MARK: - Animation Controller
    private func triggerLaunchAnimations() {
        withAnimation(.spring(response: 0.85, dampingFraction: 0.72, blendDuration: 0).delay(0.1)) {
            animateContent = true
        }
    }
    
    // MARK: - View Builders
    @ViewBuilder
    private var questionStepCard: some View {
        OnboardingFullScreenView(
            imageName: "globe.americas.fill",
            title: "A Question Worth Asking",
            accentColor: .blue
        ) {
            VStack(spacing: 20) {
                Text("There are **2.3 billion** Christians, **2 billion** Muslims, **1.1 billion** Hindus, **500 million** Buddhists, and **15 million** Jews in the world - out of a total of **4,300** religions.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                
                Text("Is any religion the absolute truth? If so, which one?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    @ViewBuilder
    private var disclaimerStepCard: some View {
        OnboardingFullScreenView(
            imageName: "exclamationmark.triangle.fill",
            title: "Disclaimer",
            accentColor: .teal
        ) {
            VStack(spacing: 20) {
                Text("This app is built on a foundation of **deep respect** for all spiritual and philosophical paths.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(.teal)
                            .font(.title3)
                        Text("**Educational & Philosophical:** The content is purely educational, focusing on academic philosophy, historical evidence, and logic.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(.teal)
                            .font(.title3)
                        Text("**Zero Hostility:** This is not an attack on anyone's personal faith or heritage. It is an open invitation to seek truth thoughtfully.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(20)
                .background(Color.teal.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
    @ViewBuilder
    private var skepticismStepCard: some View {
        OnboardingFullScreenView(
            imageName: "basket.fill",
            title: "Cartesian Skepticism",
            accentColor: .orange
        ) {
            VStack(spacing: 20) {
                Text("We approach this using a logical technique developed by the philosopher René Descartes:")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Imagine a basket full of apples. Instead of inspecting each apple one by one to find the rotten ones, you empty the entire basket then you only place the perfectly good ones back inside.")
                        .font(.subheadline)
                        .foregroundColor(.primary.opacity(0.85))
                        .lineSpacing(5)
                }
                .padding(20)
                .background(Color.orange.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
    @ViewBuilder
    private var logicStepCard: some View {
        OnboardingFullScreenView(
            imageName: "lightbulb.fill",
            title: "The Logic Method",
            accentColor: .yellow
        ) {
            VStack(spacing: 24) {
                Text("Since we cannot examine all **4,300** religions one by one, we empty the basket.\n\nInstead, we will look at the logical clues the universe itself leaves behind to determine the necessary conditions of a true religion.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                
                actionButtons
                    .padding(.top, 10)
            }
        }
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                navigateToAllCategories = true
            }) {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Button(action: {
                showDocumentsView = true
            }) {
                Text("View Documents")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }
}

// MARK: - Full Screen Onboarding Container with Cascade Animation
struct OnboardingFullScreenView<Content: View>: View {
    let imageName: String
    let title: String
    let accentColor: Color
    let content: () -> Content
    @State private var revealItems: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    // 1. App name
                    Text("THE GROUNDED MIND")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary.opacity(0.6))
                        .tracking(2)
                        .padding(.top, 40)
                        .opacity(revealItems ? 1.0 : 0.0)
                        .offset(y: revealItems ? 0 : -30)
                    
                    Spacer(minLength: 40)
                    
                    // 2. Main Icon
                    Image(systemName: imageName)
                        .font(.system(size: 76))
                        .foregroundColor(accentColor)
                        .padding(.bottom, 24)
                        .scaleEffect(revealItems ? 1.0 : 0.2)
                        .rotationEffect(.degrees(revealItems ? 0 : -45))
                        .opacity(revealItems ? 1.0 : 0.0)
                    
                    // 3. Title
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 24)
                        .padding(.horizontal, 20)
                        .opacity(revealItems ? 1.0 : 0.0)
                        .offset(y: revealItems ? 0 : 30)
                    
                    // 4. Step Content
                    content()
                        .padding(.horizontal, 24)
                        .opacity(revealItems ? 1.0 : 0.0)
                        .offset(y: revealItems ? 0 : 40)
                    
                    Spacer(minLength: 80)
                }
                .frame(minHeight: max(0, proxy.size.height - 100))
            }
            .background(Color(uiColor: .secondarySystemBackground).ignoresSafeArea())
            .onAppear {
                withAnimation(.interpolatingSpring(stiffness: 70, damping: 11).delay(0.35)) {
                    revealItems = true
                }
            }
        }
    }
}

#Preview {
    IntroView()
}

