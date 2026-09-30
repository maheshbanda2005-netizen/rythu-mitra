# 🌾 Rythu Mitra (రైతు మిత్ర)
### *Smart AI & Data-Driven Agricultural Companion for Farmers*

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green?style=for-the-badge)](https://flutter.dev/multi-platform)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](https://github.com/maheshbanda2005-netizen/rythu-mitra/pulls)

---

## 📖 Overview

**Rythu Mitra (రైతు మిత్ర / Farmer's Friend)** is an advanced, all-in-one smart agriculture and farm management mobile application built using **Flutter**. Designed specifically to empower Indian farmers, Rythu Mitra combines cutting-edge agricultural science, machine learning insights from a **1 Million record Kaggle crop dataset**, real-time mandi prices, satellite field health diagnostics, and direct access to state & central government welfare schemes.

The application features full multilingual localization in **Telugu (తెలుగు)**, **Hindi (हिन्दी)**, and **English**, paired with native typography (`Anek Telugu`, `Noto Sans Devanagari`, `Geist`) and a responsive, modern agriculture-fintech design system with both **Light** and **Dark** modes.

---

## 🌟 Key Features

### 1. 🌾 Kaggle 1M Dataset Crop Analytics & Yield Predictor
- Powered by an empirical benchmark derived from **1,000,000+ agricultural data points**.
- Predicts expected yield in **Quintals per Acre** and **Tons per Hectare** based on:
  - Soil Type (*Clay, Loam, Sandy, Silt, Peaty, Chalky*)
  - Rainfall (mm) & Temperature (°C)
  - Fertilizer application & Irrigation usage
  - Days to harvest & seasonal weather patterns
- Visual comparison charts powered by `fl_chart` showing expected yield gains from modern management practices.

### 2. 🔬 AI Crop Doctor & Plant Disease Diagnosis
- Instant diagnostic assistant for major crops (*Cotton, Paddy, Chilli, Maize, Groundnut, Soybean, etc.*).
- Identifies critical pests and diseases: Pink Bollworm, Blast, Leaf Curl Virus, Stem Borer, Fall Armyworm, Rust, and more.
- Provides dual-action remedies:
  - **Organic / Natural Treatment**: Neem oil, *Trichoderma*, *Pseudomonas*, Jeevamrutham, Brahmastra.
  - **Scientific Chemical Treatment**: Precise dosage, dilution instructions, and chemical safety guidelines.

### 3. 🏛️ Government Schemes & Subsidy Hub
- Comprehensive catalog of Central and State schemes:
  - **Telangana / AP State**: Rythu Bharosa, Rythu Bandhu, TSMIP Micro-Irrigation (Up to 90-100% subsidy on Drip/Sprinkler), Farm Mechanization.
  - **Central Schemes**: PM-KISAN (₹6,000/yr), PMFBY Crop Insurance, PM-KUSUM Solar Pumps (60-90% subsidy), Soil Health Card Scheme, Kisan Credit Card (KCC @ 4%).
- Detailed eligibility checklists, required document guides, and **one-tap direct launch to official government application portals**.

### 4. 📈 Real-Time Mandi & Market Intelligence (Agmarknet / e-NAM)
- Live wholesale agricultural commodity prices across Agricultural Produce Market Committees (APMCs).
- Displays Minimum, Maximum, and Modal (average) prices per quintal.
- Daily market arrivals and price trend movement indicators (Bullish / Bearish).

### 5. 🚜 Farm Equipment Rental Marketplace
- Peer-to-peer agricultural machinery rental platform connecting equipment owners with local farmers.
- Available rentals include: **Tractors, Combine Harvesters, Drone Sprayers, Rotavators, Power Tillers, and Seed Drills**.
- Transparent pricing (per hour / per acre / per day), owner phone contact, distance calculation, and direct booking.

### 6. 🛰️ Satellite Field Health Monitoring (NDVI)
- Satellite vegetation index and canopy health analysis.
- Multi-spectral zoning displaying crop vigor, water stress index, and localized nitrogen deficiency warnings.
- Actionable recommendations to remedy underperforming zones.

### 7. 💧 Smart Irrigation & Weather Advisory
- Hyper-local real-time weather monitoring with temperature, humidity, wind speed, and precipitation forecasts.
- Intelligent crop-stage irrigation scheduler calculating water requirements (liters/acre) based on soil moisture and ambient weather.

### 8. 🧪 Precision Fertilizer Dosage Calculator
- Custom nutrient management calculator based on acreage, crop type, and physiological growth phase (*Basal, Vegetative, Flowering, Grain-Filling*).
- Calculates exact quantities of Urea, DAP, MOP (Potash), and micronutrients (Zinc, Boron, Sulfur).

### 9. 📺 Curated Video Masterclasses & Research Portals
- Integrated field demonstration videos from **ICAR** and **PJTSAU** with timestamped chapters and key takeaways in regional languages.
- Direct research portal integration with:
  - **ICAR** (Indian Council of Agricultural Research)
  - **PJTSAU** (Professor Jayashankar Telangana State Agricultural University - *Vyavasaya Darshini*)
  - **Vikaspedia Agri Portal**
  - **e-NAM / Agmarknet**
  - **Kisan Suvidha**

### 10. 🗣️ Native Multilingual Voice Assistant
- Hands-free voice query assistant built for farmers working directly in the field.
- Answers queries regarding crop prices, disease identification, fertilizer doses, and weather updates.

### 11. 💰 Farm Expense Bookkeeper & Financial Ledger
- Track all seasonal agricultural income and expenditures:
  - Inputs (Seeds, Fertilizers, Pesticides)
  - Operations (Tractor fuel, Labor, Machinery rentals, Transport)
  - Harvest Sales Revenue
- Calculates net profit/loss with intuitive category breakdowns.

### 12. 🤝 Community Forum & Expert Tele-Consultation
- Farmer community discussion board for sharing field insights, pest alerts, and regional tips.
- Direct connection with certified agronomists and agricultural extension officers.

---

## 📱 Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.12.2)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider) (`AppStateService`)
- **Data Visualization**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Localization**: Native JSON / AppStrings dictionary with reactive language switching
- **Typography**: [google_fonts](https://pub.dev/packages/google_fonts)
  - Telugu: `Anek Telugu`
  - Hindi: `Noto Sans Devanagari`
  - English: `Geist`
- **External Integration**: [url_launcher](https://pub.dev/packages/url_launcher)
- **Design System**: Custom Agriculture-Fintech theme (`AppColors`, `AppTheme`, `AgriInteractiveCard`, `AnimatedPressCard`)

---

## 📂 Project Directory Structure

```plaintext
d:\fram\
├── assets/
│   ├── data/
│   │   ├── crop_yield_sample.csv        # Sample Kaggle crop yield records
│   │   └── crop_yield_summary.json      # Pre-aggregated 1M dataset statistical benchmarks
│   └── images/
│       ├── app_logo.png                 # Official Rythu Mitra branding
│       └── splash_bg.jpg                # Scenic splash screen asset
├── lib/
│   ├── main.dart                        # App entry point & Provider configuration
│   ├── core/
│   │   ├── localization/
│   │   │   ├── app_localizations.dart   # Localization context extensions
│   │   │   └── app_strings.dart         # Multi-language string repository (TE, HI, EN)
│   │   ├── theme/
│   │   │   ├── app_colors.dart          # Deep emerald, amber & harvest color tokens
│   │   │   └── app_theme.dart           # Dynamic font and theme builder (Light/Dark)
│   │   ├── utils/
│   │   │   └── url_helper.dart          # Safe URL & external portal launcher
│   │   └── widgets/                     # Reusable micro-animated UI components
│   ├── models/                          # Data models for crops, schemes, market, etc.
│   │   ├── crop_model.dart
│   │   ├── crop_portal_model.dart
│   │   ├── diagnosis_model.dart
│   │   ├── equipment_model.dart
│   │   ├── expense_model.dart
│   │   ├── market_model.dart
│   │   ├── scheme_model.dart
│   │   ├── video_model.dart
│   │   └── weather_model.dart
│   ├── screens/                         # Comprehensive modular screens
│   │   ├── analytics/                   # 1M dataset yield benchmark charts
│   │   ├── auth/                        # Farmer authentication & onboarding
│   │   ├── calendar/                    # Crop advisory & seasonal schedules
│   │   ├── community/                   # Farmer discussions & Q&A
│   │   ├── crops/                       # Crop guides, agronomy & research portals
│   │   ├── diagnosis/                   # AI crop doctor & pest management
│   │   ├── emergency/                   # SOS agricultural alerts & helplines
│   │   ├── equipment/                   # Machinery sharing & rental marketplace
│   │   ├── expenses/                    # Farm ledger & revenue analytics
│   │   ├── expert/                      # Agronomist tele-consultation
│   │   ├── fertilizer/                  # Stage-wise NPK dosage calculator
│   │   ├── home/                        # Dynamic dashboard & quick actions
│   │   ├── irrigation/                  # Smart water scheduling
│   │   ├── language/                    # Language switch modal
│   │   ├── market/                      # Live Mandi rates & APMC trends
│   │   ├── marketplace/                 # Farmer-to-buyer trade portal
│   │   ├── organic/                     # Organic farming formulations & certification
│   │   ├── satellite/                   # Satellite NDVI field health monitoring
│   │   ├── schemes/                     # Government schemes & portal applications
│   │   ├── videos/                      # Video tutorials with chapters & takeaways
│   │   └── voice/                       # Native voice assistant interface
│   └── services/
│       ├── agri_data_service.dart       # Master agricultural repository & market data
│       ├── ai_diagnosis_service.dart    # Pest & disease diagnosis engine
│       ├── app_state_service.dart       # Reactive state for language, theme, farm profile
│       ├── crop_video_service.dart      # Curated ICAR/PJTSAU video library
│       └── kaggle_crop_yield_service.dart # ML statistical prediction engine
└── pubspec.yaml                         # Dependencies and asset declarations
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your development machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version **3.12.2** or higher)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) / [VS Code](https://code.visualstudio.com/) with Flutter and Dart extensions
- Android device or emulator with USB debugging enabled, or Google Chrome for Web preview

### Installation & Run

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/maheshbanda2005-netizen/rythu-mitra.git
   cd rythu-mitra
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Flutter Setup**:
   ```bash
   flutter doctor
   ```

4. **Run the Application**:
   - On Android / iOS:
     ```bash
     flutter run
     ```
   - On Chrome (Web):
     ```bash
     flutter run -d chrome
     ```
   - On Windows Desktop:
     ```bash
     flutter run -d windows
     ```

5. **Build for Release**:
   - Android APK:
     ```bash
     flutter build apk --release
     ```
   - Web:
     ```bash
     flutter build web --release
     ```

---

## 🌐 Localization

Rythu Mitra treats regional accessibility as a top priority:

| Language | Code | Font Family | Default |
|:---|:---:|:---|:---:|
| **తెలుగు (Telugu)** | `te` | `Anek Telugu` | ✅ Yes |
| **हिन्दी (Hindi)** | `hi` | `Noto Sans Devanagari` | |
| **English** | `en` | `Geist` | |

To switch language dynamically within the app, tap the **Language** icon in the app bar or visit the Profile tab.

---

## 📊 Data Citations & References

- **Crop Yield Analytics**: Pre-trained statistical modeling based on the Kaggle 1M Agricultural Crop Yield Dataset.
- **Mandi Prices**: Data structure mapped according to [Agmarknet (Directorate of Marketing & Inspection, Ministry of Agriculture)](https://agmarknet.gov.in/).
- **Crop Practices**: Recommended packages of practices from [ICAR (Indian Council of Agricultural Research)](https://icar.org.in/) and [PJTSAU (Professor Jayashankar Telangana State Agricultural University)](https://pjtsau.edu.in/).
- **Government Portals**:
  - [Rythu Bharosa Telangana](https://rythubharosa.telangana.gov.in)
  - [PM-KISAN](https://pmkisan.gov.in)
  - [Pradhan Mantri Fasal Bima Yojana (PMFBY)](https://pmfby.gov.in)
  - [PM-KUSUM Solar Scheme](https://pmkusum.mnre.gov.in)
  - [Soil Health Card Portal](https://soilhealth.dac.gov.in)

---

## 🤝 Contributing

Contributions are always welcome! If you would like to contribute:
1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <b>రైతే దేశానికి వెన్నెముక • Jai Jawan, Jai Kisan 🌾</b><br>
  Built with ❤️ for Indian Farmers by <a href="https://github.com/maheshbanda2005-netizen">Mahesh Banda</a>
</p>
