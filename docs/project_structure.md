# JobHub Project Structure Guide

This document outlines the folder and file architecture for the JobHub application, developed using Lean Agile methodology. The structure is optimized for a three-person development with a target project duration until October.

---

## Project Overview

**Technology Stack:**

* **Frontend:** Flutter
* **Backend:** Firebase (Authentication, Firestore, Cloud Functions)

---

## Folder Structure

---
JobHub-app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── config/
│   │   │   ├── constants.dart
│   │   │   └── env.dart
│   │   ├── routing/
│   │   │   ├── app_router.dart
│   │   │   └── route_names.dart
│   │   └── theme/
│   │       └── app_theme.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── user.dart
│   │   │   ├── room.dart
│   │   │   └── booking.dart
│   │   ├── services/
│   │   │   └── auth_service.dart
│   │   └── repositories/
│   ├── features/
│   │   ├── auth/
│   │   ├── booking/
│   │   ├── checkout/
│   │   └── dashboard/
│   │       ├── view/
│   │       ├── controller/
│   │       └── widgets/
│   └── shared/
│       ├── widgets/
│       │   └── custom_widgets.dart
│       ├── utils/
│       │   └── helpers.dart
│       └── extensions/
│           └── extensions.dart
├── test/
│   ├── unit/
│   └── widget/
├── firebase/
│   ├── functions/
│   │   ├── index.ts
│   │   └── services/
│   └── firestore.rules
├── pubspec.yaml
├── README.md
└── PROJECT-STRUCTURE.md