# gmAIl

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20Windows-0288D1?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-In%20Progress%20(Frontend%20Complete)-success?style=for-the-badge)

Cross-platform personal productivity, assistant, and automated job-search application for **Android** and **Windows**, built with a 100% free-tier architecture.

## Key Features

- **Adaptive Multiplatform UI (60-30-10 Design):** Minimalist interface with `BottomNavigationBar` on Android and navigation sidebar on Windows, centralized in `lib/app_colors.dart`.
- **Goal Tracking (`lib/objetivos_view.dart`):** Daily Goal (auto-resets at midnight), Weekly Goal (auto-resets on Sunday), and dynamic Global Goals management.
- **Job Search & Anti-Duplicate Control (`lib/buscador_view.dart`):** Filter opportunities by role, location, and source (Google/LinkedIn) with duplicate-contact protection.
- **Drafts & CRM (`lib/correos_view.dart`):** Expandable editable email drafts (*Approve & Send* / *Discard*) and responsive grid for positive company replies with interview detection and Google Calendar scheduling.

## Screenshots

| Desktop (Windows) — Goals & Sidebar | Desktop (Windows) — Job Search |
| :---: | :---: |
| ![Goals Windows](screenshots/objetivos_windows.png) | ![Search Windows](screenshots/buscador_windows.png) |

| Desktop (Windows) — Drafts & CRM | Mobile (Android) — Adaptive UI |
| :---: | :---: |
| ![CRM Windows](screenshots/correos_windows.png) | <img src="screenshots/objetivos_android.png" width="250" alt="Android UI" /> |

## Project Structure

```text
lib/
├── main.dart            # Adaptive layout (BottomNavigationBar on Android / Sidebar on Windows)
├── app_colors.dart      # Centralized 60-30-10 color palette & status tokens
├── objetivos_view.dart  # Daily, Weekly & dynamic Global Goals management
├── buscador_view.dart   # Job search filters & anti-duplicate contact control
└── correos_view.dart    # Editable email drafts & selected companies CRM grid
```

## Getting Started (Local Frontend Preview)

```bash
git clone https://github.com/ikercruzadojimenez/gmAIl.git
cd gmAIl
flutter pub get
flutter run