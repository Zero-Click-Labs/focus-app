<h1 align="center">MindPower</h1>

<p align="center">
  <strong>Focus, the physical way</strong>
</p>

<p align="center">
  MindPower helps you put your most distracting apps behind a quick tap — using NFC tags or QR codes — so you can stay in the zone and build better digital habits.
</p>

<p align="center">
  <em>MindPower is a commercial product built on the open-source <a href="https://github.com/awaseem/foqos">Foqos</a> project. A portion of its proceeds is contributed back to Foqos. See <a href="#-attribution--license">Attribution & License</a>.</em>
</p>

---

## ✨ Features

- **🏷️ NFC & QR Blocking**: Start or stop sessions with a quick tag tap or QR scan
- **🧩 Mix & Match Strategies**: Manual, NFC, QR, NFC + Manual, QR + Manual, NFC + Timer, QR + Timer
- **⏱️ Timer-Based Blocking**: Block for a set duration, then unblock with NFC or QR
- **🔐 Physical Unblock**: Optionally require a specific tag or code to stop
- **📱 Profiles for Life**: Create profiles for work, study, sleep — whatever you need
- **📊 Habit Tracking**: See your focus streaks and session history at a glance
- **⏸️ Smart Breaks**: Take a breather without stopping your session
- **🌐 Website Blocking**: Block distracting websites in addition to apps
- **🔄 Live Activities**: Real-time status on your Lock Screen

## 📋 Requirements

- iOS 17.6+
- iPhone with NFC capability (for NFC features)
- Screen Time permissions (for app blocking)

## 🚀 Getting Started

1. Download MindPower from the App Store
2. Grant Screen Time permissions when prompted
3. Create your first blocking profile
4. Optionally set up NFC tags or a QR code and start focusing

### Setting Up NFC Tags

1. Grab a few NFC tags (NTAG213 or similar works great)
2. Create a profile in MindPower
3. Write the tag from within the app
4. Stick tags where they make sense (desk, study spot, bedside)
5. Tap to start or stop a session

## 🛠️ Development

### Prerequisites

- Xcode 15.0+
- iOS 17.0+ SDK
- Swift 5.9+
- Apple Developer Account (for Screen Time and NFC entitlements)

### Building the Project

```bash
git clone https://github.com/Zero-Click-Labs/focus-app.git
cd focus-app
open foqos.xcodeproj
```

A `Makefile` provides common tasks:

```bash
make build      # Build the project
make lint       # Check code formatting
make lint-fix   # Fix formatting issues
make check      # Run both lint and build
make clean      # Clean build artifacts
make help       # Show all available commands
```

### Project Structure

```
focus-app/
├── Foqos/                     # Main app target
│   ├── Views/                 # SwiftUI views
│   ├── Models/                # Data models (and Strategies/)
│   ├── Components/            # Reusable UI components
│   ├── Utils/                 # Utility functions (StoreKit, NFC, theming…)
│   └── Intents/               # App Intents & Shortcuts
├── FoqosWidget/               # Widget extension
├── FoqosDeviceMonitor/        # Device monitoring extension
├── FoqosShieldConfig/         # Shield configuration extension
└── web/                       # Universal Links AASA hosting (.well-known/)
```

### Key Technologies

- **SwiftUI** — declarative UI
- **SwiftData** — local persistence
- **Family Controls** — app blocking
- **Core NFC** — tag reading/writing
- **CodeScanner** — QR scanning ([MIT](https://github.com/twostraws/CodeScanner))
- **StoreKit 2** — in-app purchases / subscriptions
- **BackgroundTasks**, **Live Activities**, **WidgetKit**, **App Intents**

### Deep Links & Universal Links

Profiles expose a deep link via `BlockedProfiles.getProfileDeepLink(profile)`:

- `https://mindpower.zeroclicklabs.org/profile/<PROFILE_UUID>`

NFC tags, QR codes, and widgets use this URL to toggle a profile. For iOS to route
these into the app, the AASA file in [`web/.well-known/`](web/README.md) must be hosted
at `mindpower.zeroclicklabs.org`. See [`web/README.md`](web/README.md) for hosting steps.

## 📄 Attribution & License

MindPower is a derivative of **[Foqos](https://github.com/awaseem/foqos)** by **Ali Waseem**,
used under the MIT License. The original copyright notice is retained in [`LICENSE`](LICENSE),
and open-source attributions are surfaced in-app under **Settings → Legal → Acknowledgements**.

A portion of MindPower's proceeds is contributed back to the original Foqos project as a
voluntary thank-you to its author and community.

Third-party components:

- **Foqos** — © 2024 Ali Waseem — MIT License
- **CodeScanner** — © 2019 Paul Hudson — MIT License

This project is distributed under the MIT License — see [`LICENSE`](LICENSE) for details.

---

<p align="center">
  MindPower is a product of <strong>Zero Click Labs</strong>, built on the open-source work of <a href="https://github.com/awaseem">Ali Waseem</a>.
</p>
