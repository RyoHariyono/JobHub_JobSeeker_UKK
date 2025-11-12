# JobHub Supabase - Visual Diagrams

## 1. Database Schema Relationship

```
                        ┌─────────────────────┐
                        │   SUPABASE AUTH     │
                        │  (auth.users)       │
                        │  - id (UUID)        │
                        │  - email            │
                        │  - password_hash    │
                        └──────────┬──────────┘
                                   │ 1:1 References
                                   ▼
                        ┌─────────────────────────┐
                        │      USERS              │
                        │  (Job Seeker Profile)   │
                        ├─────────────────────────┤
                        │ id (UUID)              │
                        │ email                  │
                        │ full_name              │
                        │ phone_number           │
                        │ address                │
                        │ profile_picture_url    │
                        │ cv_file_url            │
                        │ birth_date             │
                        │ gender                 │
                        │ bio                    │
                        │ created_at             │
                        │ updated_at             │
                        └──────────┬─────────────┘
                                   │ 1:Many
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
            ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐
            │ EDUCATION   │  │ USER_SKILLS  │  │ PORTFOLIO_       │
            │             │  │              │  │ PROJECTS         │
            ├─────────────┤  ├──────────────┤  ├──────────────────┤
            │ id          │  │ id           │  │ id               │
            │ user_id (FK)│  │ user_id (FK) │  │ user_id (FK)     │
            │ level       │  │ skill_id (FK)│  │ project_name     │
            │ institution │  │ proficiency  │  │ description      │
            │ major       │  │ portfolio_id │  │ project_link     │
            │ start_year  │  │              │  │ image_url        │
            │ end_year    │  │              │  │ created_at       │
            │ gpa         │  │              │  │ updated_at       │
            │ is_current  │  │              │  └──────────────────┘
            │ created_at  │  └──────────────┘
            └─────────────┘         │
                                   │ Many:1
                                   │
                                   ▼
                        ┌──────────────────┐
                        │   SKILLS         │ ◄─────────────┐
                        │ (Master Data)    │               │
                        ├──────────────────┤               │
                        │ id               │               │
                        │ name (UNIQUE)    │               │
                        │ category         │               │
                        │ created_at       │               │
                        └──────────────────┘               │
                                                           │
                    ┌──────────────────────────────────────┘
                    │
                    └──→ Referenced by USER_SKILLS


            ┌────────────────────────────────────────┐
            │   JOB MANAGEMENT & APPLICATIONS        │
            ├────────────────────────────────────────┤
            │                                        │
            │  ┌──────────────┐   ┌──────────────┐  │
            │  │ COMPANIES    │   │ JOBS         │  │
            │  │ (Master)     │   │              │  │
            │  ├──────────────┤   ├──────────────┤  │
            │  │ id           │◄─┤ company_id   │  │
            │  │ name         │   │ title        │  │
            │  │ logo_url     │   │ category     │  │
            │  │ location     │   │ type         │  │
            │  │ website      │   │ location     │  │
            │  │ industry     │   │ description  │  │
            │  │ company_size │   │ salary_min   │  │
            │  │ created_at   │   │ salary_max   │  │
            │  └──────────────┘   │ experience   │  │
            │                      │ job_level    │  │
            │                      │ capacity     │  │
            │                      │ posted_date  │  │
            │                      │ deadline     │  │
            │                      │ is_active    │  │
            │                      └────┬─────────┘  │
            │                           │ 1:Many     │
            │                  ┌────────┴────────┐   │
            │                  ▼                 ▼   │
            │           ┌───────────────┐ ┌──────────────┐
            │           │ JOB_          │ │ JOB_TAGS     │
            │           │ REQUIREMENTS  │ │              │
            │           ├───────────────┤ ├──────────────┤
            │           │ id            │ │ id           │
            │           │ job_id (FK)   │ │ job_id (FK)  │
            │           │ requirement   │ │ tag          │
            │           │ is_required   │ │ created_at   │
            │           └───────────────┘ └──────────────┘
            │                                        │
            │   Many:1 from USERS                   │
            │                │                      │
            │                ├─────────────┬────────┘
            │                ▼             ▼
            │        ┌──────────────┐ ┌──────────────────┐
            │        │ JOB_         │ │ FAVORITE_JOBS    │
            │        │ APPLICATIONS │ │                  │
            │        ├──────────────┤ ├──────────────────┤
            │        │ id           │ │ id               │
            │        │ user_id (FK) │ │ user_id (FK)     │
            │        │ job_id (FK)  │ │ job_id (FK)      │
            │        │ status       │ │ created_at       │
            │        │ applied_date │ │                  │
            │        │ notes        │ │ UNIQUE(user,job) │
            │        └──────────────┘ └──────────────────┘
            │        UNIQUE(user,job)
            │
            └────────────────────────────────────────┘

```

---

## 2. Authentication & Authorization Flow

```
┌─────────────────────────────────────────────────────────┐
│              AUTHENTICATION FLOW                         │
└─────────────────────────────────────────────────────────┘

NEW USER → SIGNUP
├─ 1. Enter Email & Password
│
├─ 2. Supabase Auth.signUp()
│  └─ Creates auth.users record
│  └─ Sends confirmation email
│
├─ 3. App creates users table record
│  └─ Links with auth.uid()
│  └─ Stores profile data
│
├─ 4. User confirms email
│  └─ Email verified in auth.users
│
└─ 5. Auto-login or redirect to login
   └─ Session created with JWT token


EXISTING USER → LOGIN
├─ 1. Enter Email & Password
│
├─ 2. Supabase Auth.signInWithPassword()
│  └─ Validates against auth.users
│  └─ Returns JWT session token
│
├─ 3. Session stored in Flutter app
│  └─ Included in all API requests
│
└─ 4. Navigate to home/dashboard
   └─ Can access protected data via RLS


DATA ACCESS WITH RLS
├─ Public Data (No Auth Required)
│  └─ Jobs (where is_active = true)
│  └─ Companies
│  └─ Skills
│  └─ Job Requirements
│  └─ Job Tags
│
├─ Protected Data (Auth Required)
│  └─ User's own profile (users)
│  └─ User's education records
│  └─ User's skills
│  └─ User's portfolio
│  └─ User's applications
│  └─ User's favorites
│
└─ RLS Policies Enforce
   └─ WHERE user_id = auth.uid()
   └─ Only user can access their data
   └─ Automatic in all queries

LOGOUT
├─ 1. User taps Logout
│
├─ 2. Supabase Auth.signOut()
│  └─ Invalidates session
│  └─ Clears auth token
│
└─ 3. Navigate back to login
   └─ Session no longer valid
   └─ Can't access protected data
```

---

## 3. Data Flow Diagram

```
┌──────────────────────┐
│  FLUTTER APP         │
│ (JobSeeker Client)   │
└──────────┬───────────┘
           │
           ├─────────────────────────────────┐
           │                                 │
           ▼                                 ▼
    ┌────────────────┐            ┌──────────────────┐
    │ Auth Service   │            │ Database Service │
    ├────────────────┤            ├──────────────────┤
    │ signup()       │            │ getProfile()     │
    │ signin()       │            │ updateProfile()  │
    │ signout()      │            │ getJobs()        │
    │ getCurrentUser │            │ applyJob()       │
    └────────┬───────┘            │ getFavorites()   │
             │                     └────────┬─────────┘
             │                             │
             └────────────┬────────────────┘
                          │
                          ▼
                  ┌─────────────────────┐
                  │ Supabase REST API   │
                  │ (JSON over HTTPS)   │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌──────────────────────────┐
                  │ Supabase PostgreSQL DB   │
                  │                          │
                  ├─ Read active jobs        │
                  ├─ Read user profile       │
                  ├─ Write applications      │
                  ├─ Check RLS policies      │
                  └─ Return data             │
                             │
                             ▼
                  ┌──────────────────────────┐
                  │ JSON Response to App     │
                  └──────────┬───────────────┘
                             │
                             ▼
                  ┌──────────────────────────┐
                  │ Update UI with Data      │
                  │ Show jobs list           │
                  │ Show user profile        │
                  │ Update application status│
                  └──────────────────────────┘


STORAGE FILES FLOW:
┌──────────────────────┐
│ Upload File (Image)  │
│ from Flutter         │
└──────────┬───────────┘
           │
           ▼
    ┌────────────────────┐
    │ File Compression   │
    │ Validation         │
    └────────┬───────────┘
             │
             ▼
    ┌────────────────────────────┐
    │ Supabase Storage Upload    │
    │ PUT /user-profiles/...     │
    └────────┬───────────────────┘
             │
             ▼
    ┌────────────────────────────┐
    │ Get Public URL             │
    │ https://...cdn.supabase... │
    └────────┬───────────────────┘
             │
             ▼
    ┌────────────────────────────┐
    │ Update users table         │
    │ profile_picture_url = URL  │
    └────────┬───────────────────┘
             │
             ▼
    ┌────────────────────────────┐
    │ Show image in UI           │
    │ Cached for fast loading    │
    └────────────────────────────┘
```

---

## 4. User Profile Completeness

```
USER PROFILE STATUS TRACKING:

┌─────────────────────────────────────────┐
│ STEP 1: AUTHENTICATION                  │
├─────────────────────────────────────────┤
│ ✓ Email registered                      │
│ ✓ Password set                          │
│ ✓ Email verified                        │
│ → auth.users record created             │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ STEP 2: BASIC PROFILE                   │
├─────────────────────────────────────────┤
│ ○ Full name                             │
│ ○ Phone number                          │
│ ○ Address                               │
│ ○ Birth date                            │
│ ○ Gender                                │
│ → users table record populated          │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ STEP 3: PROFESSIONAL INFO               │
├─────────────────────────────────────────┤
│ ○ Upload profile picture                │
│ ○ Upload CV                             │
│ ○ Add bio/description                   │
│ → Storage + users table updated         │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ STEP 4: EDUCATION                       │
├─────────────────────────────────────────┤
│ ○ Add education records (1+)            │
│ ○ SMP, SMA, D3, S1, S2, S3              │
│ ○ GPA information                       │
│ → education table populated             │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ STEP 5: SKILLS & PORTFOLIO              │
├─────────────────────────────────────────┤
│ ○ Add portfolio projects (1+)           │
│ ○ Add skills (3+)                       │
│ ○ Link skills to projects               │
│ → portfolio_projects + user_skills      │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ PROFILE COMPLETE! 100%                  │
├─────────────────────────────────────────┤
│ ✓ Ready to browse jobs                  │
│ ✓ Ready to apply                        │
│ ✓ Better matching recommendations       │
│ ✓ Higher visibility to employers        │
└─────────────────────────────────────────┘
```

---

## 5. Application Status Flow

```
APPLICATION LIFECYCLE:

User Applies for Job
        │
        ▼
┌──────────────────┐
│ Status: APPLIED  │ ← Automatic (current time)
├──────────────────┤
│ User just clicked│
│ "Apply" button  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Status: REVIEWING│ ← HR reviewing application
├──────────────────┤
│ HR/Recruiter     │
│ checking profile │
└────────┬─────────┘
         │
    ┌────┴────┐
    │          │
    ▼          ▼
NOT MATCH    MATCH
    │          │
    │          ▼
    │    ┌──────────────────┐
    │    │ Status: INTERVIEW│
    │    ├──────────────────┤
    │    │ Schedule call/   │
    │    │ video interview  │
    │    └────────┬─────────┘
    │             │
    │             ├────────────┬─────────────┐
    │             │            │             │
    │             ▼            ▼             ▼
    │       GOOD    MEDIUM    POOR
    │             │            │
    │             ▼            ▼
    │        ┌──────────┐  ┌─────────────┐
    │        │ OFFERED  │  │ REJECTED    │
    │        └──────────┘  └─────────────┘
    │
    └────────────→ ┌──────────────────┐
                   │ Status: REJECTED │
                   ├──────────────────┤
                   │ Not selected     │
                   └──────────────────┘

OR User can:
┌──────────────────────────┐
│ Status: WITHDRAWN        │
├──────────────────────────┤
│ User manually cancel     │
│ application              │
└──────────────────────────┘

Each status change:
✓ Logged with timestamp
✓ Can include recruiter notes
✓ User gets notification (optional)
✓ Can track in application history
```

---

## 6. Search & Filter Flow

```
JOB DISCOVERY:

┌──────────────────────────┐
│ BROWSE ALL JOBS          │
│ (is_active = true)       │
└────────┬─────────────────┘
         │ Sort: posted_date DESC
         ▼
    [Job List with Pagination]
         │
         ├─────────────────────────┐
         │                         │
         ▼                         ▼
    APPLY BUTTON            FAVORITE BUTTON
    (insert to                (add to
     job_applications)        favorite_jobs)


ADVANCED SEARCH:

┌──────────────────────────┐
│ Search Jobs by:          │
├──────────────────────────┤
│ □ Title/Keywords         │ (ILIKE)
│ □ Category               │ (Exact Match)
│ □ Location               │ (ILIKE)
│ □ Job Type               │ (Exact Match)
│ □ Salary Range           │ (Between)
│ □ Experience Level       │ (Exact Match)
└────────┬─────────────────┘
         │
         ▼
    [SQL WHERE clauses combined]
    Combined with AND/OR logic
         │
         ▼
    [Filtered Results]
         │
         ├─────────────────────────┐
         │                         │
         ▼                         ▼
    APPLY                   FAVORITE
```

---

## 7. Database Capacity

```
STORAGE ESTIMATION (Per 10,000 Users):

┌──────────────────────────────┐
│ Database Size                │
├──────────────────────────────┤
│ users              500 KB     │
│ education        2,000 KB     │
│ portfolio_proj.  1,500 KB     │
│ user_skills      1,000 KB     │
│ job_applicat.    2,000 KB     │
│ favorite_jobs    1,000 KB     │
├──────────────────────────────┤
│ TOTAL DATABASE    ~50 MB      │
└──────────────────────────────┘

┌──────────────────────────────┐
│ Storage Buckets              │
├──────────────────────────────┤
│ user-profiles    ~5 GB        │
│ (500KB × 10K users)          │
│                              │
│ cv-files        ~30 GB        │
│ (3MB × 10K users)            │
│                              │
│ portfolio-images~15 GB        │
│ (1.5MB × 10K users)          │
├──────────────────────────────┤
│ TOTAL STORAGE   ~50 GB        │
└──────────────────────────────┘

SCALING:
├─ 1,000 users      → 10 MB DB + 6 GB storage
├─ 10,000 users     → 50 MB DB + 50 GB storage
├─ 100,000 users    → 500 MB DB + 500 GB storage
└─ 1M users         → 5 GB DB + 5 TB storage

All easily manageable on Supabase!
```

---

## 8. API Rate Limits & Quotas

```
SUPABASE FREE TIER:
├─ Database size        500 MB
├─ Monthly bandwidth    2 GB
├─ Concurrent connections: 10
├─ Auto backups         Daily (7 days)
├─ Response time        < 200ms
└─ Rate limiting        Fair use

SUPABASE PRO TIER:
├─ Database size        Unlimited
├─ Monthly bandwidth    50 GB
├─ Concurrent connections: 100
├─ Auto backups         Daily (35 days)
├─ Response time        < 100ms
└─ Rate limiting        Fair use

For JobHub (recommended):
├─ Start with FREE for dev/testing
├─ Upgrade to PRO for production
├─ Expected for 10K users: PRO tier
└─ Cost: $25/month base + overages
```

---

## 9. Security Model

```
┌───────────────────────────────────────┐
│ SECURITY LAYERS                       │
└───────────────────────────────────────┘

LAYER 1: AUTHENTICATION
├─ Email & Password (Hashed)
├─ JWT Session Tokens
├─ Email Verification
├─ Password Reset Flow
└─ Session Expiry

LAYER 2: AUTHORIZATION (RLS)
├─ Row Level Security Policies
├─ User ID Verification
├─ Role-based Access
├─ Public/Protected Data Separation
└─ Automatic Enforcement

LAYER 3: DATA VALIDATION
├─ Type Checking (ENUM, INT, DECIMAL)
├─ Constraints (NOT NULL, UNIQUE)
├─ Foreign Key Integrity
├─ Check Constraints
└─ Data Format Validation

LAYER 4: STORAGE SECURITY
├─ File Type Validation
├─ File Size Limits
├─ Access Control Lists
├─ Public/Private Buckets
└─ Signed URLs (optional)

LAYER 5: NETWORK SECURITY
├─ HTTPS/TLS Encryption
├─ DDoS Protection
├─ Rate Limiting
├─ WAF (Web Application Firewall)
└─ Monitoring & Alerts
```

---

## 10. Deployment Architecture

```
                    ┌─────────────────┐
                    │  USERS          │
                    │  (Mobile/Web)   │
                    └────────┬────────┘
                             │
                ┌────────────┼────────────┐
                ▼            ▼            ▼
            [Android]   [iOS]        [Web]
            [Flutter]   [Flutter]    [Flutter Web]
                │            │            │
                └────────────┼────────────┘
                             │ HTTPS
                             ▼
                    ┌──────────────────┐
                    │ Supabase Cloud   │
                    │ (Google Cloud)   │
                    ├──────────────────┤
                    │ REST API Layer   │
                    │ (Edge functions) │
                    └────────┬─────────┘
                             │
                ┌────────────┼────────────┐
                ▼            ▼            ▼
            ┌─────────┐ ┌──────────┐ ┌─────────┐
            │PostgreSQL│ │ Storage  │ │ Auth    │
            │Database  │ │ (Buckets)│ │ Service │
            └─────────┘ └──────────┘ └─────────┘
                │            │            │
                └────────────┼────────────┘
                             │
                    ┌────────┴─────────┐
                    ▼                  ▼
                ┌────────┐      ┌──────────┐
                │Backups │      │Monitoring│
                │(Daily) │      │& Logs    │
                └────────┘      └──────────┘
```

---

Created: November 2024
Status: Complete & Ready for Implementation
Version: 1.0
