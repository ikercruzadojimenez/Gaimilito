# gaimilito

Cross-platform personal productivity, assistant, and automated job-search application for **Android** and **Windows**, built with a 100% free-tier architecture.

## Key Features

- **Adaptive Multiplatform UI (60-30-10 Design):** Minimalist interface with `BottomNavigationBar` on Android and navigation sidebar on Windows, centralized in `lib/app_colors.dart`.
- **Goal Tracking (`lib/objetivos_view.dart`):** Daily Goal (auto-resets at midnight), Weekly Goal (auto-resets on Sunday), and dynamic Global Goals management.
- **Job Search & Anti-Duplicate Control (`lib/buscador_view.dart`):** Filter opportunities by role, location, and source (Google/LinkedIn) with duplicate-contact protection.
- **Drafts & CRM (`lib/correos_view.dart`):** Expandable editable email drafts (*Approve & Send* / *Discard*) and responsive grid for positive company replies with interview detection and Google Calendar scheduling.

## Tech Stack (Zero-Cost Architecture)

- **Frontend:** Flutter (Dart) — Android & Windows
- **Database & Push Notifications:** Firebase Firestore & Firebase Cloud Messaging (FCM)
- **Backend & Automation:** Google Apps Script, Gemini API (free tier), Gmail API, Google Drive & Google Calendar

## Roadmap

- [x] **Phase 1:** Adaptive Flutter layout (Android/Windows) & centralized 60-30-10 color palette
- [x] **Phase 2:** Daily/Weekly/Global Goals view & Job Search with anti-duplicate lock
- [x] **Phase 3:** Editable Email Drafts & Selected Companies CRM view
- [ ] **Phase 3.6:** Firebase Firestore real-time sync & FCM push notifications
- [ ] **Phase 4:** Google Apps Script + Gemini API backend (AI draft writer, fail-safe inbox filter & Calendar integration)
- [ ] **Phase 5:** Personal Assistant mode (Daily Briefing, natural-language quick capture & integrated daily agenda)

## Screenshots

*(Screenshots of Android & Windows views coming soon)*

## Security Note

All API keys and Firebase configuration files are excluded from version control via `.gitignore`.

## © Copyright & License

Copyright © 2026 Iker Cruzado Jiménez. All rights reserved.

This repository is publicly available strictly for **portfolio and code-review purposes**. No license is granted to copy, modify, distribute, or use this code for commercial or non-commercial purposes without explicit written permission from the author.