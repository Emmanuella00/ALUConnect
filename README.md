# ALUConnect
### *Do Hard Things.. the easy way.*

A mobile-first Flutter application built for the African Leadership University community. ALUConnect is a student engagement and collaboration platform that connects students with opportunities, communities, and each other — all in one place.

---

## What is ALU Connect?

ALUConnect solves a real problem ALU students face every day: opportunities, events, and communities are scattered across WhatsApp groups, emails, and notice boards. By the time a student hears about a hackathon or leadership workshop, registration is already closed.

ALUConnect brings everything into one place — a platform where any student can open the app and immediately know what's happening, what they can join, who's building what, and where they can contribute.

---

## Features

### Core
- **Onboarding & Authentication** — Student email-only registration (`@alustudent.com` / `@alueducation.com`) ensures the platform stays exclusive to the ALU community
- **Dynamic Feed** — Browse and filter opportunities by category (Events, Workshops, Hackathons, Internships) with real-time search
- **Event Detail & RSVP** — View full event details, see who's going, and RSVP or mark interest with instant state feedback
- **Explore & Communities** — Discover and join student clubs and communities with join/leave state management
- **Lightweight Chat** — Peer-to-peer and group messaging for community coordination
- **Profile** — Personal identity with interests, bio, campus, stats (events attended, communities, connections), and RSVP history

### Unique to ALU Connect
- **My RSVPs** — A dedicated screen tracking all Going, Interested, and Past events with ticket view
- **Event Reviews** — Students can leave feedback on past events to help organizers improve
- **Peer Connection** — View other students' profiles, interests, and bios to find collaborators
- **Weekly Newsletter** — Stay updated on ALU-wide announcements and academic news
- **shimmer loading** — Skeleton loaders on the feed for a polished, professional feel
- **Empty states** — Every screen handles no-data gracefully with contextual messages

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| App Name | ALUConnect *(tagline: Do Hard Things.. the easy way.)* |
| Framework | Flutter (Dart) |
| State Management | Provider |
| Local Persistence | SharedPreferences |
| Fonts | Google Fonts (Poppins) |
| Loading Animations | Shimmer |
| Data | Mock data (local) |

---

## Project Structure

```
lib/
├── main.dart                  # App entry point, routes, transitions
├── constants/
│   └── colors.dart            # Global color palette
├── models/
│   └── event.dart             # Event data model + mock data
├── providers/
│   └── rsvp_provider.dart     # RSVP & save state management
├── services/
│   └── prefs_service.dart     # SharedPreferences persistence
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── main_screen.dart       # Bottom nav wrapper
│   ├── home_screen.dart
│   ├── event_detail_screen.dart
│   ├── rsvp_confirmed_screen.dart
│   ├── explore_screen.dart
│   ├── chat_list_screen.dart
│   ├── profile_screen.dart
│   └── my_rsvps_screen.dart
└── widgets/                   # Reusable components
```

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio or VS Code with Flutter extension
- An Android/iOS emulator or physical device

### Installation

```bash
# Clone the repository
git clone https://github.com/Emmanuella00/ALUConnect.git
cd ALUConnect

# Install dependencies
flutter pub get

# Run the app
flutter run
```

> **Note:** The app must be run on a physical device or emulator — not a browser.

---

## Navigation Flow

```
Splash → Onboarding → Login / Register → Main App
                                            ├── Home Feed → Event Detail → RSVP Confirmed
                                            ├── Explore → Community Detail
                                            ├── Chat List → Conversation
                                            └── Profile → My RSVPs / Saved / Reviews
```

All main screens are accessible via a persistent bottom navigation bar (Home · Explore · Chat · Profile). Screen transitions use custom fade and slide animations for a polished feel.

---

## Design Decisions

**Color Palette** — Deep midnight blue (`#031E34`) paired with dark burgundy (`#8A1A30`) and warm beige (`#E8EAD8`). This combination was chosen to feel premium and serious while remaining warm and community-oriented — matching ALU's identity of ambitious, grounded leadership.

**Typography** — Poppins across all screens for its clean, modern, and friendly character that reads well on mobile.

**ALU-specific design** — The app avoids generic social feed patterns. Category filtering, RSVP management, and community spaces are all designed around how ALU students actually organize — through clubs, hackathons, and peer networks rather than passive scrolling.

---

## Team & Contributions

| Name | Role | Branch |
|------|------|--------|
| Emmanuella Ikirezi | UI/UX Lead |
| Leny Pascal Ihirwe| Core Features Dev |
| Audric Mihigo| Extra Features + Technical Initiative | 
| Alain Mugenga | Report + Demo Lead |
| Rashid Ali Ntangungira | Navigation + Bonus features Lead | 
---

## AI Usage Disclosure

In compliance with the ALU Academic Integrity Policy:

- **Claude (Anthropic)** was used as a productivity tool for brainstorming layouts and debugging errors.
- All code was reviewed, understood, and adapted by the team before being committed.
- Every team member can explain and justify any part of the codebase — this was verified through internal code review sessions before the demo.
- The UI/UX design decisions, color palette, feature choices, and ALU-specific product thinking were done independently by the team.

---

## License

This project was built as an academic submission for the African Leadership University Mobile App Development course, May Term 2026.
