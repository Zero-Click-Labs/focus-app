import StoreKit

/// Manages the "MindPower Pro" entitlement using StoreKit 2.
///
/// Scaffold notes:
/// - Product IDs below must match the ones you create in App Store Connect
///   (and in `MindPower.storekit` for local testing).
/// - `isPro` is the single source of truth for gating premium features.
/// - Supports both a one-time lifetime unlock and an auto-renewing subscription;
///   delete whichever you don't ship.
@MainActor
class PurchaseManager: ObservableObject {
  static let shared = PurchaseManager()

  // MARK: - Product identifiers
  static let lifetimeProductID = "org.zeroclicklabs.mindpower.pro.lifetime"
  static let monthlyProductID = "org.zeroclicklabs.mindpower.pro.monthly"

  private var proProductIDs: [String] {
    [Self.lifetimeProductID, Self.monthlyProductID]
  }

  // MARK: - Published state
  @Published private(set) var products: [Product] = []
  @Published private(set) var purchasedProductIDs = Set<String>()
  @Published var purchaseError: String?
  @Published var isLoading = false

  /// Single gate for premium features.
  var isPro: Bool {
    !purchasedProductIDs.isDisjoint(with: proProductIDs)
  }

  private var transactionListener: Task<Void, Error>?

  init() {
    transactionListener = listenForTransactions()
    Task {
      await loadProducts()
      await refreshEntitlements()
    }
  }

  deinit {
    transactionListener?.cancel()
  }

  // MARK: - Loading

  func loadProducts() async {
    isLoading = true
    defer { isLoading = false }
    do {
      products = try await Product.products(for: proProductIDs)
        .sorted { $0.price < $1.price }
    } catch {
      purchaseError = "Failed to load products: \(error.localizedDescription)"
    }
  }

  /// Re-reads the customer's current entitlements (call on launch / after restore).
  func refreshEntitlements() async {
    var owned = Set<String>()
    for await result in Transaction.currentEntitlements {
      if case .verified(let transaction) = result {
        // For subscriptions, currentEntitlements only yields active ones.
        owned.insert(transaction.productID)
      }
    }
    purchasedProductIDs = owned
  }

  // MARK: - Purchase / Restore

  func purchase(_ product: Product) async {
    isLoading = true
    purchaseError = nil
    defer { isLoading = false }
    do {
      let result = try await product.purchase()
      switch result {
      case .success(let verification):
        if case .verified(let transaction) = verification {
          purchasedProductIDs.insert(transaction.productID)
          await transaction.finish()
        } else {
          purchaseError = "Purchase could not be verified."
        }
      case .userCancelled:
        break
      case .pending:
        purchaseError = "Purchase is pending approval."
      @unknown default:
        purchaseError = "Unknown purchase result."
      }
    } catch {
      purchaseError = "Purchase failed: \(error.localizedDescription)"
    }
  }

  func restore() async {
    isLoading = true
    defer { isLoading = false }
    do {
      try await AppStore.sync()
      await refreshEntitlements()
    } catch {
      purchaseError = "Restore failed: \(error.localizedDescription)"
    }
  }

  // MARK: - Background transaction updates

  private func listenForTransactions() -> Task<Void, Error> {
    Task(priority: .background) { [weak self] in
      for await result in Transaction.updates {
        guard case .verified(let transaction) = result else { continue }
        await self?.refreshEntitlements()
        await transaction.finish()
      }
    }
  }
}
