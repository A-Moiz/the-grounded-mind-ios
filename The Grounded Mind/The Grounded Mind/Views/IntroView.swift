//
//  ContentView.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import SwiftUI

struct IntroView: View {
    @State private var navigateToAllCategories: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("The Grounded Mind")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Explore beliefs through reason, evidence, and thoughtful discussion.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Get Started") {
                    navigateToAllCategories = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToAllCategories) {
                AllCategoriesView()
            }
        }
    }
}

#Preview {
    IntroView()
}

