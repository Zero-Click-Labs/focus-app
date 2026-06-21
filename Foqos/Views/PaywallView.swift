import StoreKit
import SwiftUI

/// Minimal MindPower Pro paywall scaffold. Present it wherever you gate a
/// premium feature, e.g. `.sheet(isPresented: $showPaywall) { PaywallView() }`.
struct PaywallView: View {
  @EnvironmentObject var purchaseManager: PurchaseManager
  @EnvironmentObject var themeManager: ThemeManager
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading, spacing: 24) {
        VStack(alignment: .leading, spacing: 8) {
          Text("MindPower Pro")
            .font(.largeTitle.bold())
          Text("Unlock everything and support ongoing development.")
            .font(.callout)
            .foregroundStyle(.secondary)
        }
        .padding(.top, 12)

        if purchaseManager.isPro {
          Label("You're Pro — thank you!", systemImage: "checkmark.seal.fill")
            .font(.headline)
            .foregroundStyle(themeManager.themeColor)
        } else if purchaseManager.products.isEmpty {
          ProgressView()
            .frame(maxWidth: .infinity)
        } else {
          ForEach(purchaseManager.products, id: \.id) { product in
            Button {
              Task { await purchaseManager.purchase(product) }
            } label: {
              HStack {
                VStack(alignment: .leading) {
                  Text(product.displayName.isEmpty ? product.id : product.displayName)
                    .font(.headline)
                  if !product.description.isEmpty {
                    Text(product.description)
                      .font(.subheadline)
                      .foregroundStyle(.secondary)
                  }
                }
                Spacer()
                Text(product.displayPrice)
                  .font(.headline)
              }
              .padding()
              .frame(maxWidth: .infinity)
              .background(themeManager.themeColor.opacity(0.12))
              .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
          }
        }

        if let error = purchaseManager.purchaseError {
          Text(error)
            .font(.footnote)
            .foregroundStyle(.red)
        }

        Spacer()

        Button("Restore Purchases") {
          Task { await purchaseManager.restore() }
        }
        .frame(maxWidth: .infinity)
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(themeManager.themeColor)
      }
      .padding(.horizontal, 20)
      .navigationTitle("Upgrade")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: { dismiss() }) {
            Image(systemName: "xmark")
          }
          .accessibilityLabel("Close")
        }
      }
      .overlay {
        if purchaseManager.isLoading {
          ProgressView()
        }
      }
    }
  }
}

#Preview {
  PaywallView()
    .environmentObject(PurchaseManager.shared)
    .environmentObject(ThemeManager.shared)
}
