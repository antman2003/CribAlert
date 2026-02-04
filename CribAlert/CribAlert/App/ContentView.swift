//
//  ContentView.swift
//  CribAlert
//
//  Root view that handles navigation between onboarding and main app.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Environment
    
    @EnvironmentObject var appState: AppState
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if appState.shouldShowOnboarding {
                // Show onboarding flow
                OnboardingFlow()
            } else {
                // Show main app with tab bar
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.shouldShowOnboarding)
    }
}

// MARK: - Onboarding Flow

/// Manages the onboarding screens (Welcome, Setup steps)
struct OnboardingFlow: View {
    
    @EnvironmentObject var appState: AppState
    
    /// Current step in the onboarding flow
    @State private var currentStep: OnboardingStep = .welcome
    
    var body: some View {
        NavigationStack {
            Group {
                switch currentStep {
                case .welcome:
                    // Welcome screen with safety disclaimer
                    WelcomeView(onContinue: {
                        appState.acceptDisclaimer()
                        currentStep = .babyName
                    })
                    
                case .babyName:
                    // Placeholder - will be implemented in Step 3.1
                    SetupPlaceholderView(
                        step: 1,
                        title: "What do you call your baby?",
                        onContinue: { currentStep = .cameraPlacement },
                        onBack: { currentStep = .welcome }
                    )
                    
                case .cameraPlacement:
                    // Placeholder - will be implemented in Step 3.2
                    SetupPlaceholderView(
                        step: 2,
                        title: "Mount your device",
                        onContinue: { currentStep = .defineSleepArea },
                        onBack: { currentStep = .babyName }
                    )
                    
                case .defineSleepArea:
                    // Placeholder - will be implemented in Step 3.3
                    SetupPlaceholderView(
                        step: 3,
                        title: "Define the sleep area",
                        onContinue: { currentStep = .finalCheck },
                        onBack: { currentStep = .cameraPlacement }
                    )
                    
                case .finalCheck:
                    // Placeholder - will be implemented in Step 3.4
                    SetupPlaceholderView(
                        step: 4,
                        title: "Final setup check",
                        onContinue: {
                            appState.completeSetup()
                        },
                        onBack: { currentStep = .defineSleepArea }
                    )
                }
            }
        }
    }
}

/// Steps in the onboarding flow
enum OnboardingStep {
    case welcome
    case babyName
    case cameraPlacement
    case defineSleepArea
    case finalCheck
}

// MARK: - Main Tab View

/// Main app interface with bottom tab bar
struct MainTabView: View {
    
    /// Currently selected tab
    @State private var selectedTab: MainTab = .monitor
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Monitor Tab
            MonitorPlaceholderView()
                .tabItem {
                    Label("Monitor", systemImage: "video.fill")
                }
                .tag(MainTab.monitor)
            
            // History Tab
            HistoryPlaceholderView()
                .tabItem {
                    Label("History", systemImage: "chart.bar.fill")
                }
                .tag(MainTab.history)
            
            // Settings Tab
            SettingsPlaceholderView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(MainTab.settings)
        }
        .tint(Color.primaryGreen)
    }
}

/// Main tabs in the app
enum MainTab {
    case monitor
    case history
    case settings
}

// MARK: - Placeholder Views

/// Placeholder for Welcome screen
struct WelcomePlaceholderView: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "video.fill")
                .font(.system(size: 60))
                .foregroundColor(.primaryGreen)
            
            Text("Welcome to CribAlert")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Let's help everyone get a better night's rest with smart monitoring.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            
            // Safety disclaimer placeholder
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "shield.fill")
                        .foregroundColor(.accentBlue)
                    Text("Safety First")
                        .font(.headline)
                        .foregroundColor(.accentBlue)
                }
                
                Text("Important: This is not a medical device. It does not monitor vital signs or prevent SIDS. Always follow safe sleep guidelines.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.backgroundCard)
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Start Setup")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryGreen)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(Color.backgroundPrimary)
    }
}

/// Placeholder for Setup steps
struct SetupPlaceholderView: View {
    let step: Int
    let title: String
    let onContinue: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Progress indicator
            ProgressView(value: Double(step), total: 4)
                .tint(.primaryGreen)
                .padding(.horizontal)
            
            Spacer()
            
            Text("Step \(step) of 4")
                .font(.subheadline)
                .foregroundColor(.accentBlue)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("(Placeholder - to be implemented)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: onContinue) {
                HStack {
                    Text(step == 4 ? "Start Monitoring" : "Continue")
                    Image(systemName: "arrow.right")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryGreen)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(Color.backgroundPrimary)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: onBack) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Step \(step) of 4")
                    .font(.subheadline)
                    .foregroundColor(.accentBlue)
            }
            
            if step > 1 && step < 4 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        onContinue()
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
    }
}

/// Placeholder for Monitor tab
struct MonitorPlaceholderView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Status card
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                    Text("\(appState.displayBabyName)'s sleep looks normal")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.primaryGreen)
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Camera preview placeholder
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(4/3, contentMode: .fit)
                    .overlay(
                        VStack {
                            Image(systemName: "video.fill")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("Live Preview")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
                    .padding(.horizontal)
                
                // Status indicators
                HStack(spacing: 16) {
                    StatusIndicatorView(
                        icon: "waveform.path",
                        title: "Movement",
                        value: "Still",
                        subtitle: "Looks normal"
                    )
                    
                    StatusIndicatorView(
                        icon: "bed.double.fill",
                        title: "Position",
                        value: "On Back",
                        subtitle: "Recommended"
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .background(Color.backgroundPrimary)
            .navigationTitle("\(appState.displayBabyName)'s Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text("LIVE")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

/// Status indicator card component
struct StatusIndicatorView: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.primaryGreen)
                    .font(.caption)
            }
            
            Text(value)
                .font(.headline)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.primaryGreen)
        }
        .padding()
        .background(Color.backgroundCard)
        .cornerRadius(12)
    }
}

/// Placeholder for History tab
struct HistoryPlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("History")
                    .font(.headline)
                Text("(To be implemented in Phase 7)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
            .navigationTitle("History Log")
        }
    }
}

/// Placeholder for Settings tab
struct SettingsPlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                    .font(.headline)
                Text("(To be implemented in Phase 8)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(AppState())
}
