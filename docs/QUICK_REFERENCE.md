# Quick Reference - Database Structure

## 📊 Database Tables Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        DATABASE TABLES                           │
└─────────────────────────────────────────────────────────────────┘

USER MANAGEMENT (3 tables):
├─ users
│  ├─ id (UUID, PK)
│  ├─ email (UNIQUE)
│  ├─ full_name, phone_number, address
│  ├─ profile_picture_url, cv_file_url
│  ├─ birth_date, gender, bio
│  └─ created_at, updated_at
│
├─ education (1:Many with users)
│  ├─ id (UUID, PK)
│  ├─ user_id (FK)
│  ├─ education_level (ENUM: smp, sma, d3, s1, s2, s3)
│  ├─ institution, major
│  ├─ start_year, end_year
│  ├─ is_currently_studying (BOOLEAN)
│  ├─ gpa (DECIMAL: 0-4)
│  └─ created_at, updated_at
│
└─ portfolio_projects (1:Many with users)
   ├─ id (UUID, PK)
   ├─ user_id (FK)
   ├─ project_name, description
   ├─ project_link, image_url
   └─ created_at, updated_at


SKILLS (2 tables):
├─ skills (Master Data)
│  ├─ id (UUID, PK)
│  ├─ name (TEXT, UNIQUE)
│  ├─ category (ENUM)
│  └─ created_at
│
└─ user_skills (Many:Many)
   ├─ id (UUID, PK)
   ├─ user_id (FK)
   ├─ skill_id (FK)
   ├─ proficiency_level (ENUM: beginner-expert)
   ├─ portfolio_project_id (FK, nullable)
   └─ created_at


JOB MANAGEMENT (4 tables):
├─ companies (Master Data)
│  ├─ id (UUID, PK)
│  ├─ name (UNIQUE)
│  ├─ logo_url, description
│  ├─ location, website
│  ├─ industry, company_size
│  └─ created_at, updated_at
│
├─ jobs (1:Many with companies)
│  ├─ id (UUID, PK)
│  ├─ company_id (FK)
│  ├─ title, description
│  ├─ category, type
│  ├─ location
│  ├─ min_salary, max_salary
│  ├─ experience_required, job_level
│  ├─ capacity
│  ├─ posted_date, deadline_date, start_date
│  ├─ is_active (BOOLEAN)
│  └─ created_at, updated_at
│
├─ job_requirements (1:Many with jobs)
│  ├─ id (UUID, PK)
│  ├─ job_id (FK)
│  ├─ requirement (TEXT)
│  ├─ is_required (BOOLEAN)
│  └─ created_at
│
└─ job_tags (1:Many with jobs)
   ├─ id (UUID, PK)
   ├─ job_id (FK)
   ├─ tag (TEXT)
   └─ created_at


APPLICATION TRACKING (2 tables):
├─ job_applications (Many:Many)
│  ├─ id (UUID, PK)
│  ├─ user_id (FK)
│  ├─ job_id (FK)
│  ├─ status (ENUM: applied-rejected-withdrawn)
│  ├─ applied_date, status_updated_at
│  ├─ notes (TEXT, nullable)
│  ├─ created_at, updated_at
│  └─ UNIQUE(user_id, job_id)
│
└─ favorite_jobs (Many:Many)
   ├─ id (UUID, PK)
   ├─ user_id (FK)
   ├─ job_id (FK)
   ├─ created_at
   └─ UNIQUE(user_id, job_id)
```

---

## 🔐 Authentication

```
FLOW:
1. User signup dengan email & password
   → Supabase Auth.signUp() creates auth.users record
   → App creates users table record
   → Email verification dikirim

2. User login dengan email & password
   → Supabase Auth.signInWithPassword()
   → Returns JWT session token
   → Token included dalam semua API requests

3. RLS Policies enforce access control
   → Users only dapat access data dengan user_id = auth.uid()
   → Public data (jobs, companies) readable by anonymous

4. User logout
   → Supabase Auth.signOut()
   → Session invalidated
   → Redirect to login
```

---

## 📁 Storage Buckets

```
BUCKETS (Public):
├─ user-profiles
│  └─ Limit: 10 MB/file
│  └─ Types: JPG, PNG
│  └─ URL: https://...cdn.supabase.io/...
│
├─ cv-files
│  └─ Limit: 50 MB/file
│  └─ Types: PDF
│  └─ URL: https://...cdn.supabase.io/...
│
└─ portfolio-images
   └─ Limit: 20 MB/file
   └─ Types: JPG, PNG
   └─ URL: https://...cdn.supabase.io/...
```

---

## 🔄 Common Operations

### Profile
```sql
-- Get user profile
SELECT * FROM users WHERE id = user_id;

-- Update profile
UPDATE users SET full_name = ?, phone_number = ? WHERE id = user_id;

-- Upload profile picture
POST /storage/user-profiles/user_id/profile.jpg
UPDATE users SET profile_picture_url = ? WHERE id = user_id;
```

### Education
```sql
-- Add education
INSERT INTO education (user_id, education_level, institution, ...)
VALUES (?, ?, ?, ...);

-- Get education
SELECT * FROM education WHERE user_id = ? ORDER BY start_year DESC;

-- Update education
UPDATE education SET institution = ?, major = ? WHERE id = ?;

-- Delete education
DELETE FROM education WHERE id = ? AND user_id = ?;
```

### Jobs
```sql
-- Browse active jobs
SELECT j.*, c.name, c.logo_url, json_agg(t.tag) as tags
FROM jobs j
JOIN companies c ON j.company_id = c.id
LEFT JOIN job_tags t ON j.id = t.job_id
WHERE j.is_active = true
GROUP BY j.id, c.id
ORDER BY j.posted_date DESC
LIMIT 20;

-- Search jobs
SELECT j.* FROM jobs j
WHERE j.is_active = true
AND (j.title ILIKE ? OR j.description ILIKE ?)
AND j.category = ?
AND j.location ILIKE ?;

-- Get job details
SELECT j.*, c.*, json_agg(jr.*) as requirements
FROM jobs j
JOIN companies c ON j.company_id = c.id
LEFT JOIN job_requirements jr ON j.id = jr.job_id
WHERE j.id = ?
GROUP BY j.id, c.id;
```

### Applications
```sql
-- Apply for job
INSERT INTO job_applications (user_id, job_id, status)
VALUES (?, ?, 'applied');

-- Get application history
SELECT ja.*, j.title, j.company_id, c.name, c.logo_url
FROM job_applications ja
JOIN jobs j ON ja.job_id = j.id
JOIN companies c ON j.company_id = c.id
WHERE ja.user_id = ?
ORDER BY ja.applied_date DESC;

-- Check if already applied
SELECT EXISTS(
  SELECT 1 FROM job_applications 
  WHERE user_id = ? AND job_id = ?
);
```

### Favorites
```sql
-- Add favorite
INSERT INTO favorite_jobs (user_id, job_id) VALUES (?, ?);

-- Get favorites
SELECT j.*, c.name, c.logo_url
FROM favorite_jobs fj
JOIN jobs j ON fj.job_id = j.id
JOIN companies c ON j.company_id = c.id
WHERE fj.user_id = ?
ORDER BY fj.created_at DESC;

-- Remove favorite
DELETE FROM favorite_jobs WHERE user_id = ? AND job_id = ?;

-- Check if favorited
SELECT EXISTS(
  SELECT 1 FROM favorite_jobs 
  WHERE user_id = ? AND job_id = ?
);
```

### Skills
```sql
-- Add skill to user
INSERT INTO user_skills (user_id, skill_id, proficiency_level)
SELECT ?, id, ? FROM skills WHERE name = ?;

-- Get user skills
SELECT us.*, s.name, s.category
FROM user_skills us
JOIN skills s ON us.skill_id = s.id
WHERE us.user_id = ?
ORDER BY s.name;

-- Get all skills (for dropdown)
SELECT id, name, category FROM skills ORDER BY name;

-- Remove skill
DELETE FROM user_skills WHERE user_id = ? AND skill_id = ?;
```

---

## 📋 Indexes Created

```
PERFORMANCE INDEXES:

education:
├─ idx_education_user_id          (Fast lookup by user)
└─ idx_education_created_at       (Sort by date)

jobs:
├─ idx_jobs_company_id            (Filter by company)
├─ idx_jobs_category              (Filter by category)
├─ idx_jobs_location              (Filter by location)
├─ idx_jobs_is_active             (Get active jobs)
└─ idx_jobs_posted_date           (Sort by date)

job_requirements:
└─ idx_job_requirements_job_id    (Get requirements)

job_tags:
└─ idx_job_tags_job_id            (Get tags)

job_applications:
├─ idx_job_applications_user_id   (User's applications)
├─ idx_job_applications_job_id    (Job's applicants)
├─ idx_job_applications_status    (Filter by status)
└─ idx_job_applications_date      (Sort by date)

favorite_jobs:
├─ idx_favorite_jobs_user_id      (User's favorites)
└─ idx_favorite_jobs_job_id       (Job's favorites)

skills:
├─ idx_skills_name                (Lookup by name)
└─ idx_skills_category            (Filter by category)

portfolio_projects:
└─ idx_portfolio_projects_user_id (User's projects)

user_skills:
├─ idx_user_skills_user_id        (User's skills)
├─ idx_user_skills_skill_id       (Skill's users)
└─ idx_user_skills_project_id     (Project's skills)
```

---

## 🛡️ RLS Policies

```
PROTECTED (User-owned):
├─ users               → WHERE id = auth.uid()
├─ education          → WHERE user_id = auth.uid()
├─ portfolio_projects → WHERE user_id = auth.uid()
├─ user_skills        → WHERE user_id = auth.uid()
├─ job_applications   → WHERE user_id = auth.uid()
└─ favorite_jobs      → WHERE user_id = auth.uid()

PUBLIC (Anyone can read):
├─ jobs               → WHERE is_active = true
├─ companies          → All records
├─ job_requirements   → All records
├─ job_tags           → All records
└─ skills             → All records

INSERTS PROTECTED:
├─ job_applications   → Only authenticated users
├─ favorite_jobs      → Only authenticated users
└─ Others            → Only own data
```

---

## 💻 Service Classes (Flutter)

```dart
AuthService:
├─ signup(email, password, fullName)
├─ signin(email, password)
├─ signout()
├─ getCurrentUser()
└─ authStateChanges stream

ProfileService:
├─ getUserProfile()
└─ updateProfile(data)

EducationService:
├─ addEducation(data)
├─ getEducation()
├─ updateEducation(id, data)
└─ deleteEducation(id)

SkillService:
├─ addSkill(skillName, proficiency)
├─ getSkills()
└─ removeSkill(skillId)

PortfolioService:
├─ addPortfolio(data)
├─ getPortfolio()
├─ updatePortfolio(id, data)
└─ deletePortfolio(id)

JobService:
├─ getActiveJobs(limit, offset)
├─ searchJobs(query, filters)
├─ getJobDetails(jobId)
├─ applyJob(jobId)
└─ getApplications()

FavoriteService:
├─ addFavorite(jobId)
├─ removeFavorite(jobId)
├─ getFavorites()
└─ isFavorited(jobId)

StorageService:
├─ uploadProfilePicture(file, userId)
├─ uploadCV(file, userId)
└─ uploadPortfolioImage(file, userId)
```

---

## 📊 Data Relationships

```
users (1) ──→ (Many) education
users (1) ──→ (Many) portfolio_projects
users (1) ──→ (Many) user_skills ← (Many) skills
users (1) ──→ (Many) job_applications → jobs
users (1) ──→ (Many) favorite_jobs → jobs
companies (1) ──→ (Many) jobs
jobs (1) ──→ (Many) job_requirements
jobs (1) ──→ (Many) job_tags
portfolio_projects (1) ──→ (Many) user_skills
```

---

## ⚡ Performance Tips

```
DO:
✅ Use indexes untuk filter/sort operations
✅ Paginate large result sets
✅ Cache frequently accessed data
✅ Use SELECT only needed columns
✅ Batch operations when possible
✅ Enable realtime only when needed

DON'T:
❌ SELECT * (unless needed)
❌ N+1 queries (use joins)
❌ Disable RLS for convenience
❌ Store large files in database
❌ Execute queries in loops
❌ Cache sensitive data
```

---

## 🆘 Common Errors & Solutions

```
ERROR: RLS policy prevents operation
→ Check RLS policies in Supabase dashboard
→ Ensure user_id = auth.uid()

ERROR: Foreign key constraint failed
→ Verify referenced record exists
→ Check data types match

ERROR: UNIQUE constraint failed
→ User already applied to this job
→ User already favorited this job
→ Email already registered

ERROR: Row not found
→ Record doesn't exist
→ User doesn't own this record (RLS)

ERROR: Permission denied
→ Check Storage policies
→ Verify bucket name
```

---

Created: November 2024
Version: 1.0
Status: Quick Reference Ready

Gunakan sebagai handy reference saat development! 📌
