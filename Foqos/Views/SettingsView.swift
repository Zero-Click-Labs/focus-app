import FamilyControls
import SwiftData
import SwiftUI

let AMZN_STORE_LINK = "https://amzn.to/4fbMuTM"
let TEMU_STORE_LINK =
  "https://www.temu.com/ca/nfc-sticker-with--blank-chip-operating-at-13-56mhz-is-a-rewritable-label-with-504--of-memory-compatible-with-nfc-enabled-smartphones-g-601102251435878.html"
let ALIEXPRESS_STORE_LINK = "https://www.aliexpress.com/item/1005010075431327.html"

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
  @EnvironmentObject var themeManager: ThemeManager
  @EnvironmentObject var requestAuthorizer: RequestAuthorizer
  @EnvironmentObject var strategyManager: StrategyManager

  @State private var showResetBlockingStateAlert = false
  @State private var showDebugView = false

  private var appVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
      ?? "1.0"
  }

  var body: some View {
    NavigationStack {
      Form {
        Section("Theme") {
          HStack {
            Image(systemName: "paintpalette.fill")
              .foregroundStyle(themeManager.themeColor)
              .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
              Text("Appearance")
                .font(.headline)
              Text("Customize the look of your app")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          }
          .padding(.vertical, 8)

          Picker("Theme Color", selection: $themeManager.selectedColorName) {
            ForEach(ThemeManager.availableColors, id: \.name) { colorOption in
              HStack {
                Circle()
                  .fill(colorOption.color)
                  .frame(width: 20, height: 20)
                Text(colorOption.name)
              }
              .tag(colorOption.name)
            }
          }
          .onChange(of: themeManager.selectedColorName) { _, _ in
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
          }
        }

        Section("About") {
          HStack {
            Text("Version")
              .foregroundStyle(.primary)
            Spacer()
            Text("v\(appVersion)")
              .foregroundStyle(.secondary)
          }

          HStack {
            Text("Screen Time Access")
              .foregroundStyle(.primary)
            Spacer()
            HStack(spacing: 8) {
              Circle()
                .fill(requestAuthorizer.getAuthorizationStatus() == .approved ? .green : .red)
                .frame(width: 8, height: 8)
              Text(
                requestAuthorizer.getAuthorizationStatus() == .approved
                  ? "Authorized" : "Not Authorized"
              )
              .foregroundStyle(.secondary)
              .font(.subheadline)
            }
          }

          HStack {
            Text("Made in")
              .foregroundStyle(.primary)
            Spacer()
            Text("Calgary AB 🇨🇦")
              .foregroundStyle(.secondary)
          }
        }

        Section("Buy NFC Tags") {
          Link(destination: URL(string: AMZN_STORE_LINK)!) {
            HStack {
              Text("Amazon")
                .foregroundColor(.primary)
              Spacer()
              Image(systemName: "arrow.up.right.square")
                .foregroundColor(.secondary)
            }
          }
          Link(destination: URL(string: TEMU_STORE_LINK)!) {
            HStack {
              Text("Temu")
                .foregroundColor(.primary)
              Spacer()
              Image(systemName: "arrow.up.right.square")
                .foregroundColor(.secondary)
            }
          }

          Link(destination: URL(string: ALIEXPRESS_STORE_LINK)!) {
            HStack {
              Text("AliExpress")
                .foregroundColor(.primary)
              Spacer()
              Image(systemName: "arrow.up.right.square")
                .foregroundColor(.secondary)
            }
          }
        }

        Section("Help") {
          HStack {
            Text("Debug Mode")
              .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
              .foregroundColor(.secondary)
              .font(.caption)
          }
          .onTapGesture {
            showDebugView = true
          }

          Link(destination: URL(string: "https://mindpower.zeroclicklabs.org/blocking-native-apps.html")!) {
            HStack {
              Text("Blocking Native Apps")
                .foregroundColor(.primary)
              Spacer()
              Image(systemName: "arrow.up.right.square")
                .foregroundColor(.secondary)
            }
          }

          if !strategyManager.isBlocking {
            Button {
              showResetBlockingStateAlert = true
            } label: {
              Text("Reset Blocking State")
                .foregroundColor(themeManager.themeColor)
            }
          }
        }

        Section("Legal") {
          NavigationLink {
            AcknowledgementsView()
          } label: {
            Text("Acknowledgements")
              .foregroundColor(.primary)
          }
        }
      }
      .navigationTitle("Settings")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(action: { dismiss() }) {
            Image(systemName: "xmark")
          }
          .accessibilityLabel("Close")
        }
      }
      .alert("Reset Blocking State", isPresented: $showResetBlockingStateAlert) {
        Button("Cancel", role: .cancel) {}
        Button("Reset", role: .destructive) {
          strategyManager.resetBlockingState(context: context)
        }
      } message: {
        Text(
          "This will clear all app restrictions and remove any ghost schedules. Only use this if you're locked out and no profile is active."
        )
      }
      .sheet(isPresented: $showDebugView) {
        DebugView()
      }
    }
  }
}

private struct OpenSourceLicense: Identifiable {
  let id = UUID()
  let name: String
  let copyright: String
  let url: String
}

private let mitLicenseText = """
Permission is hereby granted, free of charge, to any person obtaining a copy \
of this software and associated documentation files (the "Software"), to deal \
in the Software without restriction, including without limitation the rights \
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell \
copies of the Software, and to permit persons to whom the Software is \
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all \
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR \
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, \
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE \
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER \
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, \
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE \
SOFTWARE.
"""

private let openSourceLicenses: [OpenSourceLicense] = [
  OpenSourceLicense(
    name: "Foqos",
    copyright: "Copyright (c) 2024 Ali Waseem",
    url: "https://github.com/awaseem/foqos"
  ),
  OpenSourceLicense(
    name: "CodeScanner",
    copyright: "Copyright (c) 2019 Paul Hudson",
    url: "https://github.com/twostraws/CodeScanner"
  ),
]

struct AcknowledgementsView: View {
  var body: some View {
    List {
      Section {
        Text(
          "MindPower is built on the open-source Foqos project and other open-source software. We're grateful to their authors. A portion of MindPower's proceeds is contributed back to the original Foqos project."
        )
        .font(.callout)
        .foregroundStyle(.secondary)
      }

      ForEach(openSourceLicenses) { license in
        Section(license.name) {
          Text(license.copyright)
            .font(.subheadline.weight(.semibold))
          Link(destination: URL(string: license.url)!) {
            HStack {
              Text("Source")
                .foregroundColor(.primary)
              Spacer()
              Image(systemName: "arrow.up.right.square")
                .foregroundColor(.secondary)
            }
          }
          Text("MIT License")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
          Text(mitLicenseText)
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
      }
    }
    .navigationTitle("Acknowledgements")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  SettingsView()
    .environmentObject(ThemeManager.shared)
    .environmentObject(RequestAuthorizer())
    .environmentObject(StrategyManager.shared)
    .modelContainer(for: BlockedProfiles.self, inMemory: true)
}

#Preview("Acknowledgements") {
  NavigationStack {
    AcknowledgementsView()
  }
}
