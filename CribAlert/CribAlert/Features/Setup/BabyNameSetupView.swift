//
//  BabyNameSetupView.swift
//  CribAlert
//
//  Step 1 of 4: Enter baby's name for personalized alerts.
//

import SwiftUI

struct BabyNameSetupView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var appState: AppState
    
    let onContinue: () -> Void
    let onBack: () -> Void
    
    @State private var babyName: String = ""
    @FocusState private var isNameFieldFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with navigation
            header
            
            // Progress bar
            progressBar
            
            ScrollView {
                VStack(spacing: 32) {
                    // Baby icon
                    babyIcon
                    
                    // Title
                    VStack(spacing: 8) {
                        Text("What do you call your baby?")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Name input field
                    nameInputField
                    
                    // Helper text
                    Text("We'll use this name for personalized safety alerts.")
                        .font(.system(size: 15))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
            }
            
            Spacer()
            
            // Continue button
            continueButton
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.99))
        .navigationBarHidden(true)
        .onAppear {
            babyName = appState.babyName
        }
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text("Step 1 of 4")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.accentBlue)
            
            Spacer()
            
            // Empty space for balance
            Image(systemName: "arrow.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Progress Bar
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.accentBlue)
                    .frame(width: geometry.size.width * 0.25, height: 6)
            }
        }
        .frame(height: 6)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
    
    // MARK: - Baby Icon
    
    private var babyIcon: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 120, height: 120)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            
            Circle()
                .fill(Color.accentBlue.opacity(0.1))
                .frame(width: 100, height: 100)
            
            Image(systemName: "face.smiling.fill")
                .font(.system(size: 40))
                .foregroundColor(.accentBlue)
        }
    }
    
    // MARK: - Name Input Field
    
    private var nameInputField: some View {
        HStack(spacing: 12) {
            Image(systemName: "pencil")
                .font(.system(size: 16))
                .foregroundColor(.accentBlue)
            
            TextField("Baby's name", text: $babyName)
                .font(.system(size: 17))
                .foregroundColor(.textPrimary)
                .focused($isNameFieldFocused)
                .submitLabel(.done)
                .onSubmit {
                    if !babyName.trimmingCharacters(in: .whitespaces).isEmpty {
                        saveName()
                        onContinue()
                    }
                }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(isNameFieldFocused ? Color.accentBlue : Color.accentBlue.opacity(0.3), lineWidth: 2)
        )
    }
    
    // MARK: - Continue Button
    
    private var continueButton: some View {
        Button(action: {
            saveName()
            onContinue()
        }) {
            HStack(spacing: 8) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isNameValid ? Color.accentBlue : Color.accentBlue.opacity(0.5))
            .cornerRadius(12)
        }
        .disabled(!isNameValid)
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
    
    // MARK: - Helpers
    
    private var isNameValid: Bool {
        !babyName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func saveName() {
        appState.babyName = babyName.trimmingCharacters(in: .whitespaces)
    }
}

// MARK: - Preview

#Preview {
    BabyNameSetupView(
        onContinue: { print("Continue") },
        onBack: { print("Back") }
    )
    .environmentObject(AppState())
}
