# Database Architecture Diagram

## 1. Entity Relationship Diagram (ERD)

```
┌─────────────────────────────────────────────────────────────────┐
│                        AUTHENTICATION                           │
├─────────────────────────────────────────────────────────────────┤
│  Supabase Auth (auth.users)                                     │
│  ├── id (UUID - Primary Key)                                    │
│  ├── email                                                      │
│  ├── password_hash                                              │
│  ├── email_confirmed_at                                         │
│  └── created_at / updated_at                                    │
└─────────────────────────────────────────────────────────────────┘
                             │ 1:1
                             │ (References)
                             ▼
         ┌───────────────────────────────────────┐
         │          USERS (Profile)              │
         ├───────────────────────────────────────┤
         │ id (UUID, FK to auth.users)          │
         │ email (TEXT, UNIQUE)                 │
         │ full_name (TEXT)                     │
         │ phone_number (TEXT)                  │
         │ address (TEXT)                       │
         │ bio (TEXT)                           │
         │ profile_picture_url (TEXT)           │
         │ birth_date (DATE)                    │
         │ gender (ENUM)                        │
         │ cv_file_url (TEXT)                   │
         │ created_at / updated_at              │
         └───────────────────────────────────────┘
         │ 1:Many
         ├─────────────────┬──────────────────┬─────────────────────┐
         ▼                 ▼                  ▼                     ▼
    ┌─────────────┐  ┌──────────────┐  ┌──────────────┐  ┌─────────────────┐
    │ EDUCATION   │  │  JOB_        │  │ FAVORITE_    │  │ PORTFOLIO_      │
    │             │  │ APPLICATIONS │  │ JOBS         │  │ PROJECTS        │
    ├─────────────┤  ├──────────────┤  ├──────────────┤  ├─────────────────┤
    │ id          │  │ id           │  │ id           │  │ id              │
    │ user_id (FK)│  │ user_id (FK) │  │ user_id (FK) │  │ user_id (FK)    │
    │ level       │  │ job_id (FK)  │  │ job_id (FK)  │  │ project_name    │
    │ institution │  │ status       │  │ created_at   │  │ description     │
    │ major       │  │ applied_date │  │              │  │ project_link    │
    │ start_year  │  │ notes        │  │              │  │ image_url       │
    │ end_year    │  │ created_at   │  │              │  │ created_at      │
    │ is_current  │  │ updated_at   │  │              │  │ updated_at      │
    │ gpa         │  │              │  │              │  │                 │
    │ created_at  │  │              │  │              │  │                 │
    └─────────────┘  └──────────────┘  └──────────────┘  └────────┬────────┘
                             │                              │ 1:Many
                             │ Many:1                      │
                             │                              ▼
                             │                          ┌──────────────┐
                             └─────────────────────────→│ USER_SKILLS  │
                                                        ├──────────────┤
                                                        │ id           │
                                                        │ user_id (FK) │
                                                        │ skill_id (FK)│◄─────┐
                                                        │ proficiency  │      │
                                                        │ portfolio_id │      │
                                                        │ created_at   │      │
                                                        └──────────────┘      │
                                                                              │
                                                                              │
         ┌────────────────────────────────────────────────────────────┐     │
         │                    JOBS MANAGEMENT                         │     │
         ├────────────────────────────────────────────────────────────┤     │
         │                                                            │     │
         │  ┌──────────────┐    ┌───────────────────┐               │     │
         │  │  COMPANIES   │    │  JOBS             │               │     │
         │  ├──────────────┤    ├───────────────────┤    Many:1     │     │
         │  │ id           │◄──┤| company_id (FK)  │◄─────────┘     │     │
         │  │ name         │    │ title             │               │     │
         │  │ logo_url     │    │ category          │               │     │
         │  │ description  │    │ type              │               │     │
         │  │ location     │    │ location          │               │     │
         │  │ website      │    │ description       │               │     │
         │  │ industry     │    │ min_salary        │               │     │
         │  │ company_size │    │ max_salary        │               │     │
         │  │ created_at   │    │ experience_req    │               │     │
         │  └──────────────┘    │ job_level         │               │     │
         │                       │ capacity          │               │     │
         │                       │ posted_date       │               │     │
         │                       │ deadline_date     │               │     │
         │                       │ start_date        │               │     │
         │                       │ is_active         │               │     │
         │                       │ created_at        │               │     │
         │                       └───────┬───────────┘               │     │
         │                               │ 1:Many                   │     │
         │                      ┌────────┴─────────────┐             │     │
         │                      ▼                      ▼             │     │
         │               ┌─────────────┐      ┌──────────────┐     │     │
         │               │ JOB_REQUIRE │      │ JOB_TAGS     │     │     │
         │               │ MENTS       │      ├──────────────┤     │     │
         │               ├─────────────┤      │ id           │     │     │
         │               │ id          │      │ job_id (FK)  │     │     │
         │               │ job_id (FK) │      │ tag          │     │     │
         │               │ requirement │      │ created_at   │     │     │
         │               │ is_required │      └──────────────┘     │     │
         │               │ created_at  │                           │     │
         │               └─────────────┘                           │     │
         │                                                        │     │
         │  ┌──────────────────────────────────────────────────┘     │
         │  │                                                        │
         │  └───→ REFERENCED BY:                                    │
         │        - JOB_APPLICATIONS (job_id)                       │
         │        - FAVORITE_JOBS (job_id)                          │
         │                                                         │
         └────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│              MASTER DATA (Read-only)                     │
├──────────────────────────────────────────────────────────┤
│                   SKILLS                                │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │ id (UUID)                                        │  │
│  │ name (TEXT, UNIQUE)                              │  │
│  │ category (ENUM: frontend, backend, design, ...) │  │
│  │ created_at                                       │  │
│  │                                                  │  │
│  │ ◄──── Referenced by USER_SKILLS (skill_id)     │  │
│  └──────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘
```

---

## 2. Database Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLIENT APPLICATION                          │
│  (Flutter JobSeeker App)                                        │
└──────────────────┬──────────────────────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
        ▼                     ▼
    ┌─────────────┐    ┌─────────────────────┐
    │   Auth      │    │   Database/API      │
    │   Service   │    │   Service           │
    └──────┬──────┘    └────────┬────────────┘
           │                    │
           ▼                    ▼
    ┌─────────────┐    ┌─────────────────────┐
    │ Supabase    │    │  Supabase SQL       │
    │ Auth        │    │  Edge/REST API      │
    └──────┬──────┘    └────────┬────────────┘
           │                    │
           └────────┬───────────┘
                    ▼
         ┌──────────────────────┐
         │ Supabase Backend     │
         │ (PostgreSQL)         │
         └──────────────────────┘
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
    ┌─────────┐ ┌──────────┐ ┌──────────┐
    │ Tables  │ │ RLS      │ │ Realtime │
    │         │ │ Policies │ │ Subscr.  │
    └─────────┘ └──────────┘ └──────────┘
```

---

## 3. User Journey Flow

```
┌──────────────┐
│ New User     │
└──────┬───────┘
       │
       ▼
┌──────────────────────┐
│ SIGNUP FLOW          │
├──────────────────────┤
│ 1. Email & Password  │
│ 2. Create auth.users │
│ 3. Create users rec. │
│ 4. Verify email      │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│ LOGIN                │
├──────────────────────┤
│ Email & Password     │
│ Get session token    │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ USER PROFILE PAGE                │
├──────────────────────────────────┤
│ Update:                          │
│ ├─ Personal Info (users)         │
│ ├─ Education (education)         │
│ ├─ Skills (user_skills)          │
│ ├─ Portfolio (portfolio_projects)│
│ └─ CV Upload (storage)           │
└──────┬───────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ BROWSE JOBS PAGE                 │
├──────────────────────────────────┤
│ Display:                         │
│ ├─ Jobs (jobs table)             │
│ ├─ Company Info (companies)      │
│ ├─ Requirements (job_requirements)│
│ ├─ Tags (job_tags)               │
│ └─ Status (job_applications)     │
└──────┬───────────────────────────┘
       │
       ├─────────────────────────┐
       │                         │
       ▼                         ▼
   FAVORITE              APPLY FOR JOB
   (favorite_jobs)       (job_applications)
       │                         │
       └────────┬────────────────┘
                │
                ▼
    ┌──────────────────────────────┐
    │ APPLICATION HISTORY          │
    ├──────────────────────────────┤
    │ View:                        │
    │ ├─ Applied Jobs              │
    │ ├─ Application Status        │
    │ ├─ Applied Date              │
    │ └─ Recruiter Notes           │
    └──────────────────────────────┘
```

---

## 4. Data Storage Breakdown

```
TABLE STORAGE ALLOCATION:
│
├─ AUTH DATA (Supabase Auth)
│  └─ auth.users: ~100KB per 1000 users
│
├─ USER PROFILES
│  ├─ users: ~50KB per 1000 users
│  ├─ education: ~200KB per 1000 users (avg 2 records per user)
│  ├─ portfolio_projects: ~150KB per 1000 users
│  └─ user_skills: ~100KB per 1000 users
│
├─ JOB LISTINGS
│  ├─ companies: ~50KB (static data)
│  ├─ jobs: ~500KB per 1000 jobs
│  ├─ job_requirements: ~300KB per 1000 jobs (avg 3 per job)
│  └─ job_tags: ~100KB per 1000 jobs (avg 2 per job)
│
├─ APPLICATION TRACKING
│  ├─ job_applications: ~200KB per 1000 applications
│  └─ favorite_jobs: ~100KB per 1000 favorites
│
├─ MASTER DATA
│  ├─ skills: ~5KB (static)
│  └─ [Other lookups]
│
└─ FILE STORAGE (Buckets)
   ├─ user-profiles: Variable (avg 500KB per image)
   ├─ cv-files: Variable (avg 1-5MB per PDF)
   └─ portfolio-images: Variable (avg 1-2MB per image)

EXAMPLE: 10,000 Users, 5,000 Jobs
├─ Database: ~50MB total
├─ Profile Pictures: ~5GB (500KB × 10K)
├─ CVs: ~30GB (3MB avg × 10K)
└─ Portfolio Images: ~15GB (1.5MB avg × 10K)

Total: ~50GB for full deployment
```

---

## 5. Index Strategy

```
INDEXES CREATED:

┌─ education
│  ├─ idx_education_user_id          → Fast lookup by user
│  └─ idx_education_created_at       → Sort by date
│
├─ jobs
│  ├─ idx_jobs_company_id            → Lookup by company
│  ├─ idx_jobs_category              → Filter by category
│  ├─ idx_jobs_location              → Filter by location
│  ├─ idx_jobs_is_active             → Get active jobs only
│  └─ idx_jobs_posted_date           → Sort by date
│
├─ job_requirements
│  └─ idx_job_requirements_job_id    → Get reqs for job
│
├─ job_tags
│  └─ idx_job_tags_job_id            → Get tags for job
│
├─ job_applications
│  ├─ idx_job_applications_user_id   → User's applications
│  ├─ idx_job_applications_job_id    → Job's applicants
│  ├─ idx_job_applications_status    → Filter by status
│  └─ idx_job_applications_date      → Sort by date
│
├─ favorite_jobs
│  ├─ idx_favorite_jobs_user_id      → User's favorites
│  └─ idx_favorite_jobs_job_id       → Job's favoriters
│
├─ skills
│  ├─ idx_skills_name                → Lookup by name
│  └─ idx_skills_category            → Filter by category
│
├─ portfolio_projects
│  └─ idx_portfolio_projects_user_id → User's projects
│
└─ user_skills
   ├─ idx_user_skills_user_id        → User's skills
   ├─ idx_user_skills_skill_id       → Skill's users
   └─ idx_user_skills_project_id     → Project's skills
```

---

## 6. RLS Security Model

```
PUBLIC READABLE:
├─ jobs (is_active = true)
├─ companies (all)
├─ job_requirements (all)
├─ job_tags (all)
└─ skills (all)

USER OWNED (RLS Protected):
├─ users
│  └─ Can read/write own profile
│
├─ education
│  └─ Can CRUD own education records
│
├─ portfolio_projects
│  └─ Can CRUD own portfolio projects
│
├─ user_skills
│  └─ Can CRUD own skills
│
├─ job_applications
│  └─ Can read/insert own applications
│
└─ favorite_jobs
   └─ Can read/insert/delete own favorites

CHECK: ALL OPERATIONS REQUIRE auth.uid() = user_id
```

---

## 7. Query Performance Patterns

```
COMMON QUERIES:

1. GET USER PROFILE (Hot Query)
   SELECT * FROM users WHERE id = ? ✓ INDEXED
   └─ Speed: < 1ms

2. GET USER EDUCATION
   SELECT * FROM education WHERE user_id = ? ✓ INDEXED
   └─ Speed: < 2ms

3. BROWSE JOBS (Hot Query)
   SELECT * FROM jobs WHERE is_active = true LIMIT 20 ✓ INDEXED
   └─ Speed: < 5ms

4. SEARCH JOBS (Medium Query)
   SELECT * FROM jobs WHERE
     is_active = true
     AND category = ?
     AND location ILIKE ?
   ✓ INDEXED (category, location, is_active)
   └─ Speed: < 10ms

5. GET JOB DETAILS WITH RELATIONS
   SELECT jobs.*, companies.*, 
          json_agg(job_requirements.*),
          json_agg(job_tags.tag)
   FROM jobs
   LEFT JOIN companies
   LEFT JOIN job_requirements
   LEFT JOIN job_tags
   WHERE jobs.id = ?
   └─ Speed: < 15ms (optimized)

6. GET USER APPLICATIONS
   SELECT job_applications.*,
          jobs.title, companies.name
   FROM job_applications
   JOIN jobs
   JOIN companies
   WHERE job_applications.user_id = ?
   ✓ INDEXED
   └─ Speed: < 5ms

7. CHECK IF APPLIED (Exist Query)
   SELECT EXISTS(
     SELECT 1 FROM job_applications
     WHERE user_id = ? AND job_id = ?
   ) ✓ INDEXED (user_id, job_id)
   └─ Speed: < 1ms
```

---

## 8. Backup Strategy

```
SUPABASE AUTOMATIC BACKUP:
└─ Daily backups (7 days retention)

RECOMMENDED MANUAL BACKUP:
├─ Daily database dump
├─ Weekly storage backup
└─ Monthly full backup

BACKUP COMMANDS:
pg_dump postgresql://...  > backup.sql
pg_restore -d database < backup.sql

DISASTER RECOVERY:
├─ Database: Restore from backup
├─ Storage: Restore from backup
└─ Recovery Time Objective: < 1 hour
```

---

## 9. Scaling Considerations

```
CURRENT CAPACITY: ✓
├─ 10,000 users: OK
├─ 5,000 jobs: OK
├─ 100,000 applications: OK
└─ Database size: ~50MB

SCALING TIMELINE:
├─ < 100K users: Current setup OK
├─ 100K - 1M users: 
│  ├─ Enable pgBouncer
│  ├─ Increase indexes
│  └─ Implement caching layer
└─ > 1M users:
   ├─ Database partitioning
   ├─ Read replicas
   ├─ Cache layer (Redis)
   └─ CDN for storage

MONITORING:
├─ Connection pool
├─ Query performance
├─ Storage usage
├─ Realtime subscribers
└─ Auth rate limits
```

