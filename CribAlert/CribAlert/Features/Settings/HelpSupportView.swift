//
//  HelpSupportView.swift
//  CribAlert
//
//  Help & support page with FAQ and contact options.
//

import SwiftUI

struct HelpSupportView: View {
    
    // MARK: - Properties
    
    @State private var expandedFAQ: Int? = nil
    
    let faqs: [FAQItem] = [
        FAQItem(
            question: "How does CribAlert monitor my baby?",
            answer: "CribAlert uses your phone's camera and microphone to observe visible conditions in the sleep area. All analysis happens on your device - no video or audio is uploaded."
        ),
        FAQItem(
            question: "Is CribAlert a medical device?",
            answer: "No. CribAlert is a safety companion, not a medical device. It does not monitor vital signs or prevent SIDS. Always follow safe sleep guidelines."
        ),
        FAQItem(
            question: "What alerts will I receive?",
            answer: "You may receive alerts for: baby rolling onto stomach, face may be covered, unusual stillness, and crying detected. All alerts use calm, observational language."
        ),
        FAQItem(
            question: "Does CribAlert record video?",
            answer: "No video or audio is recorded by default. Live monitoring works in real-time without saving footage. Your privacy is our priority."
        ),
        FAQItem(
            question: "Do I need an account?",
            answer: "No. Core monitoring and alerts work without an account. Accounts are only needed for optional premium features."
        )
    ]
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // FAQ Section
                faqSection
                
                // Contact Section
                contactSection
                
                // App version
                appVersionSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - FAQ Section
    
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("FREQUENTLY ASKED QUESTIONS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .tracking(0.5)
            
            VStack(spacing: 8) {
                ForEach(Array(faqs.enumerated()), id: \.element.id) { index, faq in
                    FAQRow(
                        faq: faq,
                        isExpanded: expandedFAQ == index,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if expandedFAQ == index {
                                    expandedFAQ = nil
                                } else {
                                    expandedFAQ = index
                                }
                            }
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Contact Section
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CONTACT US")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .tracking(0.5)
            
            VStack(spacing: 0) {
                ContactRow(
                    icon: "envelope.fill",
                    title: "Email Support",
                    subtitle: "support@cribalert.com"
                )
                
                Divider()
                    .padding(.leading, 56)
                
                ContactRow(
                    icon: "bubble.left.and.bubble.right.fill",
                    title: "Community",
                    subtitle: "Join our parent community"
                )
                
                Divider()
                    .padding(.leading, 56)
                
                ContactRow(
                    icon: "star.fill",
                    title: "Rate CribAlert",
                    subtitle: "Share your experience"
                )
            }
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    // MARK: - App Version Section
    
    private var appVersionSection: some View {
        VStack(spacing: 8) {
            Text("CribAlert v1.0.0")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
            
            Text("© 2024 CribAlert. All rights reserved.")
                .font(.system(size: 12))
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }
}

// MARK: - FAQ Row

struct FAQRow: View {
    let faq: FAQItem
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    Text(faq.question)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
                .padding(16)
            }
            
            if isExpanded {
                Text(faq.answer)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Contact Row

struct ContactRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.accentBlue)
                .frame(width: 32, height: 32)
                .background(Color.accentBlue.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.textTertiary)
        }
        .padding(16)
    }
}

// MARK: - Supporting Types

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HelpSupportView()
    }
}
