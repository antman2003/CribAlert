//
//  HistoryView.swift
//  CribAlert
//
//  History log showing past monitoring sessions and activity timeline.
//

import SwiftUI

struct HistoryView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var appState: AppState
    @State private var selectedTimeRange: TimeRange = .tonight
    
    // Sample data
    let sessionDuration = "5h 20m"
    let sessionStatus = "Monitoring stayed normal"
    
    let timelineItems: [TimelineItem] = [
        TimelineItem(time: "02:15 AM", title: "Safe monitoring check", description: "All clear.", type: .success),
        TimelineItem(time: "01:45 AM", title: "Movement noticed", description: "Liam moved naturally.", type: .movement),
        TimelineItem(time: "01:43 AM", title: "Checked: Blanket position", description: "Area clear; monitoring continued.", type: .warning),
        TimelineItem(time: "11:00 PM", title: "Safe monitoring check", description: "All clear.", type: .success),
        TimelineItem(time: "09:30 PM", title: "Monitoring started", description: "System active.", type: .info)
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Time range selector
                    timeRangeSelector
                    
                    // Session summary card
                    sessionSummaryCard
                    
                    // Activity timeline
                    activityTimeline
                    
                    // Footer message
                    footerMessage
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("History Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text("LIVE")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - Time Range Selector
    
    private var timeRangeSelector: some View {
        HStack(spacing: 8) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTimeRange = range
                    }
                }) {
                    Text(range.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedTimeRange == range ? .white : .textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(selectedTimeRange == range ? Color.primaryGreen : Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.borderLight, lineWidth: selectedTimeRange == range ? 0 : 1)
                        )
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Session Summary Card
    
    private var sessionSummaryCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Session Summary")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                
                Text(sessionDuration)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.primaryGreen)
                        .frame(width: 8, height: 8)
                    
                    Text(sessionStatus)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primaryGreen)
                }
            }
            
            Spacer()
            
            // Progress ring
            ZStack {
                Circle()
                    .stroke(Color.primaryGreen.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: 0.85)
                    .stroke(Color.primaryGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.primaryGreen)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
    }
    
    // MARK: - Activity Timeline
    
    private var activityTimeline: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("ACTIVITY TIMELINE")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .tracking(0.5)
                .padding(.bottom, 16)
            
            ForEach(Array(timelineItems.enumerated()), id: \.element.id) { index, item in
                TimelineRowView(
                    item: item,
                    isLast: index == timelineItems.count - 1
                )
            }
        }
    }
    
    // MARK: - Footer Message
    
    private var footerMessage: some View {
        Text("Monitoring continued normally after these events.")
            .font(.system(size: 14))
            .foregroundColor(.textSecondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderLight, lineWidth: 1)
            )
    }
}

// MARK: - Timeline Row

struct TimelineRowView: View {
    let item: TimelineItem
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon and line
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(item.type.backgroundColor)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: item.type.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(item.type.iconColor)
                }
                
                if !isLast {
                    Rectangle()
                        .fill(Color.primaryGreen.opacity(0.3))
                        .frame(width: 2)
                        .frame(minHeight: 40)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Text(item.time)
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                }
                
                Text(item.description)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }
            .padding(.bottom, isLast ? 0 : 16)
        }
    }
}

// MARK: - Supporting Types

enum TimeRange: String, CaseIterable {
    case tonight = "Tonight"
    case lastNight = "Last Night"
    case calendar = "Calendar"
}

struct TimelineItem: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let description: String
    let type: TimelineItemType
}

enum TimelineItemType {
    case success
    case movement
    case warning
    case info
    
    var icon: String {
        switch self {
        case .success: return "checkmark"
        case .movement: return "waveform.path"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .success: return .primaryGreen
        case .movement: return .warningOrange
        case .warning: return .warningOrange
        case .info: return .textSecondary
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .success: return .primaryGreen.opacity(0.15)
        case .movement: return .warningOrange.opacity(0.15)
        case .warning: return .warningOrange.opacity(0.15)
        case .info: return .gray.opacity(0.15)
        }
    }
}

// MARK: - Preview

#Preview {
    HistoryView()
        .environmentObject(AppState())
}
