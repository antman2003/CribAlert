//
//  BabyProfileView.swift
//  CribAlert
//
//  Settings for baby's name and optional photo.
//

import SwiftUI

struct BabyProfileView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var babyName: String = ""
    @State private var sleepLocation: String = ""
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 32) {
                    // Photo placeholder
                    photoSection
                    
                    // Baby's name field
                    nameSection
                    
                    // Sleep location field
                    locationSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
            }
            
            Spacer()
            
            // Footer and save button
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("You can change this anytime.")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                    
                    Text("Profile details don't affect monitoring or alerts.")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
                .multilineTextAlignment(.center)
                
                Button(action: saveProfile) {
                    Text("Save")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primaryGreen)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.white)
        .navigationTitle("Baby Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            babyName = appState.babyName
        }
    }
    
    // MARK: - Photo Section
    
    private var photoSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                    .foregroundColor(.primaryGreen.opacity(0.4))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "camera.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.primaryGreen)
                
                // Edit badge
                Circle()
                    .fill(Color.primaryGreen)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    )
                    .offset(x: 40, y: 40)
            }
            
            Button("Add photo") {
                // Photo picker
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.primaryGreen)
            
            Text("Optional — used only for personalization.")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
        }
    }
    
    // MARK: - Name Section
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Baby's name")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            TextField("Enter baby's name", text: $babyName)
                .font(.system(size: 16))
                .padding(16)
                .background(Color.backgroundSecondary)
                .cornerRadius(12)
            
            Text("This is how we'll refer to your baby in the app.")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
        }
    }
    
    // MARK: - Location Section
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Sleep location")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("Optional")
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(4)
            }
            
            TextField("e.g. Nursery or Bedroom", text: $sleepLocation)
                .font(.system(size: 16))
                .padding(16)
                .background(Color.backgroundSecondary)
                .cornerRadius(12)
        }
    }
    
    // MARK: - Actions
    
    private func saveProfile() {
        appState.babyName = babyName.trimmingCharacters(in: .whitespaces)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BabyProfileView()
            .environmentObject(AppState())
    }
}
