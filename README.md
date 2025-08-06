# 🚨 Danger Aanallo

**Danger Aanallo** is a powerful Flutter app that allows users to check if a website is **safe, suspicious, or dangerous**. The app uses real-time threat intelligence from:

- 🌐 Google Safe Browsing API  
- 🧠 VirusTotal URL Scanner  
- 🛡️ IPQualityScore (IPQS)  

It also checks for cookie tracking and helps raise awareness about online threats.

---

## 📸 Screenshots

<img width="1080" height="2424" alt="flutter_04" src="https://github.com/user-attachments/assets/3bc77c11-0440-40c5-87a5-8221f8c6e185" />
<img width="1080" height="2424" alt="flutter_02" src="https://github.com/user-attachments/assets/ecf69c63-01e1-485f-a934-6f78dae65863" />
<img width="1080" height="2424" alt="flutter_03" src="https://github.com/user-attachments/assets/60f26ac8-8439-4365-92db-a81ca4ac8c29" />


<img width="1080" height="2424" alt="flutter_01" src="https://github.com/user-attachments/assets/931e405b-0340-4e70-997a-92c7906bc03b" />


---

## ⚙️ Features

- 🔍 Analyze any website for:
  - Malware
  - Phishing
  - Tracking cookies
  - Suspicious behavior
- ✅ Real-time API-based checks
- 🚦 Visual danger meter (Safe, Suspicious, Dangerous)
- 🎯 Clean UI with smooth animations
- 💡 Tips for safer browsing

---

## 📦 Tech Stack

| Layer            | Technology        |
|------------------|-------------------|
| Frontend         | Flutter           |
| State Management | StatefulWidget    |
| APIs Used        | Google Safe Browsing, VirusTotal, IPQS |
| Animation        | Splash + Scale Animations |
| Package Manager  | pubspec.yaml      |

---

## 🛠️ Installation

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/danger-aanallo.git
cd danger-aanallo
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Add `.env` file

Create a file named `.env` at the root of the project and paste:

```env
GOOGLE_SAFE_BROWSING_API=your_google_safe_browsing_api_key
VIRUS_TOTAL_API=your_virustotal_api_key
IP_QUALITY_API=your_ipqualityscore_api_key
```

> **Never expose these keys publicly.**

### 4. Run the app

```bash
flutter run
```

---

## 📱 Build APK

```bash
flutter build apk --release
```

Find your APK at:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧩 Dependencies

```yaml
dependencies:
  flutter:
  flutter_dotenv: ^5.1.0
  http: ^1.4.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_launcher_icons: ^0.14.4
```

---

## 📁 Project Structure

```
danger-aanallo/
├── assets/
│   ├── images/            # Logos, visuals
│   └── animations/        # (Optional) Lottie/other animations
├── lib/
│   ├── main.dart          # Entry point
│   └── homepage.dart      # UI & logic
├── .env                   # API Keys (ignored in Git)
├── pubspec.yaml
└── README.md
```

---

## 🚀 Coming Soon

- Cookie tracking details
- History of scanned URLs
- Dark mode
- Shareable scan reports

---

## 👨‍💻 Author

**Arjun Santhosh**  
📫 [Contact on LinkedIn](https://www.linkedin.com/in/arjun-santhosh-a9a731252/)

---

## 🛡️ Disclaimer

This app is for **educational and awareness purposes only**. It does not store or misuse any user data. Results depend on third-party APIs and are not 100% definitive.

---

## ⭐️ Support

If you like the project, star 🌟 it on GitHub!  
Have suggestions? [Raise an issue](https://github.com/Arjunsanthosh09)
