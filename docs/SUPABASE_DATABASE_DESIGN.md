# JobHub JobSeeker - Supabase Database Design

## 📋 Daftar Isi
1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Tabel Utama](#tabel-utama)
4. [SQL Schema](#sql-schema)
5. [Row Level Security (RLS)](#row-level-security)
6. [Indexes](#indexes)
7. [Setup Instructions](#setup-instructions)

---

## Overview

Database Supabase untuk JobHub JobSeeker dirancang untuk mendukung:
- **User Management**: Authentication & Profile
- **Job Listings**: Jobs, Companies, Requirements
- **User Applications**: Job applications dan tracking
- **Education**: Pendidikan user
- **Portfolio & Skills**: Portfolio projects dan skill management
- **Favorites**: Job favorites/bookmarks

---

## Authentication

Menggunakan Supabase Authentication dengan metode:
- Email & Password
- Optional: Google OAuth, GitHub OAuth

**User dibuat otomatis di `auth.users` table** saat sign up, data profile disimpan di tabel `users` terpisah.

---

## Tabel Utama

### 1. **users** (Profile User)
Menyimpan data profil job seeker.

```
Columns:
- id (UUID, PK, FK ke auth.users.id)
- email (TEXT, UNIQUE)
- full_name (TEXT)
- phone_number (TEXT, nullable)
- address (TEXT, nullable)
- bio (TEXT, nullable)
- profile_picture_url (TEXT, nullable)
- birth_date (DATE, nullable)
- gender (TEXT enum: 'male', 'female', 'other', nullable)
- cv_file_url (TEXT, nullable)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

---

### 2. **education** (Riwayat Pendidikan)
Menyimpan data pendidikan user.

```
Columns:
- id (UUID, PK)
- user_id (UUID, FK ke users.id)
- education_level (TEXT enum: 'smp', 'sma', 'd3', 's1', 's2', 's3')
- institution (TEXT)
- major (TEXT, nullable)
- start_year (INT)
- end_year (INT, nullable)
- is_currently_studying (BOOLEAN, default: false)
- gpa (DECIMAL(3,2), nullable) // Range: 0-4
- description (TEXT, nullable)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

---

### 3. **portfolio_projects** (Portfolio Projects)
Menyimpan data project portfolio user.

```
Columns:
- id (UUID, PK)
- user_id (UUID, FK ke users.id)
- project_name (TEXT)
- description (TEXT, nullable)
- project_link (TEXT, nullable) // URL ke project
- image_url (TEXT, nullable)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

---

### 4. **skills** (Master Skills)
Master data untuk semua skills yang tersedia.

```
Columns:
- id (UUID, PK)
- name (TEXT, UNIQUE)
- category (TEXT enum: 'frontend', 'backend', 'design', 'mobile', 'other')
- created_at (TIMESTAMP)
```

---

### 5. **user_skills** (User Skills)
Many-to-many relationship antara users dan skills.

```
Columns:
- id (UUID, PK)
- user_id (UUID, FK ke users.id)
- skill_id (UUID, FK ke skills.id)
- proficiency_level (TEXT enum: 'beginner', 'intermediate', 'advanced', 'expert', nullable)
- portfolio_project_id (UUID, FK ke portfolio_projects.id, nullable)
- created_at (TIMESTAMP)
```

---

### 6. **companies** (Data Perusahaan)
Master data untuk perusahaan yang posting job.

```
Columns:
- id (UUID, PK)
- name (TEXT, UNIQUE)
- logo_url (TEXT, nullable)
- description (TEXT, nullable)
- location (TEXT)
- website (TEXT, nullable)
- industry (TEXT, nullable)
- company_size (TEXT enum: 'startup', 'small', 'medium', 'large', 'enterprise', nullable)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

---

### 7. **jobs** (Daftar Job)
Menyimpan semua lowongan kerja.

```
Columns:
- id (UUID, PK)
- company_id (UUID, FK ke companies.id)
- title (TEXT)
- category (TEXT enum: 'frontend', 'backend', 'fullstack', 'mobile', 'ui_ux', 'devops', 'other')
- type (TEXT enum: 'full_time', 'part_time', 'contract', 'freelance')
- location (TEXT)
- description (TEXT)
- min_salary (INT, nullable)
- max_salary (INT, nullable)
- experience_required (TEXT) // e.g., "3+ years"
- job_level (TEXT enum: 'entry', 'mid', 'senior', 'lead')
- capacity (INT) // Jumlah posisi yang tersedia
- posted_date (TIMESTAMP)
- deadline_date (TIMESTAMP)
- start_date (TIMESTAMP, nullable)
- is_active (BOOLEAN, default: true)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

---

### 8. **job_requirements** (Requirements per Job)
Menyimpan requirement untuk setiap job.

```
Columns:
- id (UUID, PK)
- job_id (UUID, FK ke jobs.id)
- requirement (TEXT)
- is_required (BOOLEAN, default: true) // true = required, false = nice to have
- created_at (TIMESTAMP)
```

---

### 9. **job_tags** (Tags per Job)
Tags/kategorisasi untuk job (e.g., React, Flutter, Python).

```
Columns:
- id (UUID, PK)
- job_id (UUID, FK ke jobs.id)
- tag (TEXT) // e.g., 'React', 'Flutter'
- created_at (TIMESTAMP)
```

---

### 10. **job_applications** (Aplikasi User untuk Job)
Tracking aplikasi user ke job.

```
Columns:
- id (UUID, PK)
- user_id (UUID, FK ke users.id)
- job_id (UUID, FK ke jobs.id)
- status (TEXT enum: 'applied', 'reviewing', 'interview', 'offered', 'rejected', 'withdrawn')
- applied_date (TIMESTAMP)
- status_updated_at (TIMESTAMP)
- notes (TEXT, nullable) // Catatan dari recruiter/perusahaan
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)

Unique Constraint: (user_id, job_id) // User hanya bisa apply 1x per job
```

---

### 11. **favorite_jobs** (Favorite/Bookmark Jobs)
Menyimpan job yang difavorit user.

```
Columns:
- id (UUID, PK)
- user_id (UUID, FK ke users.id)
- job_id (UUID, FK ke jobs.id)
- created_at (TIMESTAMP)

Unique Constraint: (user_id, job_id) // User hanya bisa favorite 1x per job
```

---

## SQL Schema

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==================== USERS ====================
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  phone_number TEXT,
  address TEXT,
  bio TEXT,
  profile_picture_url TEXT,
  birth_date DATE,
  gender TEXT CHECK (gender IN ('male', 'female', 'other')),
  cv_file_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== EDUCATION ====================
CREATE TABLE education (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  education_level TEXT NOT NULL CHECK (education_level IN ('smp', 'sma', 'd3', 's1', 's2', 's3')),
  institution TEXT NOT NULL,
  major TEXT,
  start_year INT NOT NULL,
  end_year INT,
  is_currently_studying BOOLEAN DEFAULT FALSE,
  gpa DECIMAL(3, 2) CHECK (gpa >= 0 AND gpa <= 4),
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== COMPANIES ====================
CREATE TABLE companies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  logo_url TEXT,
  description TEXT,
  location TEXT NOT NULL,
  website TEXT,
  industry TEXT,
  company_size TEXT CHECK (company_size IN ('startup', 'small', 'medium', 'large', 'enterprise')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== JOBS ====================
CREATE TABLE jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('frontend', 'backend', 'fullstack', 'mobile', 'ui_ux', 'devops', 'other')),
  type TEXT NOT NULL CHECK (type IN ('full_time', 'part_time', 'contract', 'freelance')),
  location TEXT NOT NULL,
  description TEXT,
  min_salary INT,
  max_salary INT,
  experience_required TEXT,
  job_level TEXT CHECK (job_level IN ('entry', 'mid', 'senior', 'lead')),
  capacity INT NOT NULL DEFAULT 1,
  posted_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  deadline_date TIMESTAMP WITH TIME ZONE,
  start_date TIMESTAMP WITH TIME ZONE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== JOB REQUIREMENTS ====================
CREATE TABLE job_requirements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  requirement TEXT NOT NULL,
  is_required BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== JOB TAGS ====================
CREATE TABLE job_tags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  tag TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== JOB APPLICATIONS ====================
CREATE TABLE job_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'applied' CHECK (status IN ('applied', 'reviewing', 'interview', 'offered', 'rejected', 'withdrawn')),
  applied_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  status_updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, job_id)
);

-- ==================== FAVORITE JOBS ====================
CREATE TABLE favorite_jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, job_id)
);

-- ==================== SKILLS ====================
CREATE TABLE skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  category TEXT CHECK (category IN ('frontend', 'backend', 'design', 'mobile', 'other')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== PORTFOLIO PROJECTS ====================
CREATE TABLE portfolio_projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  project_name TEXT NOT NULL,
  description TEXT,
  project_link TEXT,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== USER SKILLS ====================
CREATE TABLE user_skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  skill_id UUID NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  proficiency_level TEXT CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
  portfolio_project_id UUID REFERENCES portfolio_projects(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, skill_id)
);

-- ==================== INDEXES ====================
CREATE INDEX idx_education_user_id ON education(user_id);
CREATE INDEX idx_education_created_at ON education(created_at);

CREATE INDEX idx_jobs_company_id ON jobs(company_id);
CREATE INDEX idx_jobs_category ON jobs(category);
CREATE INDEX idx_jobs_location ON jobs(location);
CREATE INDEX idx_jobs_is_active ON jobs(is_active);
CREATE INDEX idx_jobs_posted_date ON jobs(posted_date);

CREATE INDEX idx_job_requirements_job_id ON job_requirements(job_id);
CREATE INDEX idx_job_tags_job_id ON job_tags(job_id);

CREATE INDEX idx_job_applications_user_id ON job_applications(user_id);
CREATE INDEX idx_job_applications_job_id ON job_applications(job_id);
CREATE INDEX idx_job_applications_status ON job_applications(status);
CREATE INDEX idx_job_applications_applied_date ON job_applications(applied_date);

CREATE INDEX idx_favorite_jobs_user_id ON favorite_jobs(user_id);
CREATE INDEX idx_favorite_jobs_job_id ON favorite_jobs(job_id);

CREATE INDEX idx_skills_name ON skills(name);
CREATE INDEX idx_skills_category ON skills(category);

CREATE INDEX idx_portfolio_projects_user_id ON portfolio_projects(user_id);

CREATE INDEX idx_user_skills_user_id ON user_skills(user_id);
CREATE INDEX idx_user_skills_skill_id ON user_skills(skill_id);
CREATE INDEX idx_user_skills_portfolio_project_id ON user_skills(portfolio_project_id);
```

---

## Row Level Security (RLS)

Enable RLS pada tabel-tabel penting:

```sql
-- ==================== ENABLE RLS ====================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE education ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorite_jobs ENABLE ROW LEVEL SECURITY;

-- ==================== POLICIES ====================

-- Users: User hanya bisa read/write profil sendiri
CREATE POLICY "Users can read own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Education: User hanya bisa read/write education record sendiri
CREATE POLICY "Users can read own education"
  ON education FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own education"
  ON education FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own education"
  ON education FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own education"
  ON education FOR DELETE
  USING (user_id = auth.uid());

-- Portfolio Projects: User hanya bisa read/write project sendiri
CREATE POLICY "Users can read own portfolio projects"
  ON portfolio_projects FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own portfolio projects"
  ON portfolio_projects FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own portfolio projects"
  ON portfolio_projects FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own portfolio projects"
  ON portfolio_projects FOR DELETE
  USING (user_id = auth.uid());

-- User Skills: User hanya bisa manage skill sendiri
CREATE POLICY "Users can read own skills"
  ON user_skills FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own skills"
  ON user_skills FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own skills"
  ON user_skills FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own skills"
  ON user_skills FOR DELETE
  USING (user_id = auth.uid());

-- Job Applications: User hanya bisa read aplikasi sendiri
CREATE POLICY "Users can read own applications"
  ON job_applications FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own applications"
  ON job_applications FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own applications"
  ON job_applications FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Favorite Jobs: User hanya bisa manage favorite sendiri
CREATE POLICY "Users can read own favorite jobs"
  ON favorite_jobs FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own favorite jobs"
  ON favorite_jobs FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own favorite jobs"
  ON favorite_jobs FOR DELETE
  USING (user_id = auth.uid());

-- Jobs & Companies: Public readable
CREATE POLICY "Anyone can read active jobs"
  ON jobs FOR SELECT
  USING (is_active = true);

CREATE POLICY "Anyone can read companies"
  ON companies FOR SELECT
  USING (true);

CREATE POLICY "Anyone can read job requirements"
  ON job_requirements FOR SELECT
  USING (true);

CREATE POLICY "Anyone can read job tags"
  ON job_tags FOR SELECT
  USING (true);

CREATE POLICY "Anyone can read skills"
  ON skills FOR SELECT
  USING (true);
```

---

## Indexes

Sudah include dalam SQL schema di atas. Indexes membantu performance untuk:
- Filter by `user_id` (Education, Applications, Favorites)
- Filter by `job_id` (Requirements, Tags)
- Filter by `category`, `location` (Jobs)
- Sort by `created_at`, `posted_date`, `applied_date`

---

## Setup Instructions

### Step 1: Buat Project Supabase
1. Go to https://supabase.com
2. Sign up/Login
3. Click "New Project"
4. Isikan project name: `jobhub-jobseeker`
5. Set password yang aman
6. Choose region (pilih yang terdekat dengan user base)
7. Click "Create new project" dan tunggu hingga selesai

### Step 2: Setup Database
1. Pergi ke **SQL Editor**
2. Click "New Query"
3. Copy-paste seluruh SQL schema dari section [SQL Schema](#sql-schema)
4. Click "Run" untuk execute semua queries

### Step 3: Setup Authentication
1. Pergi ke **Authentication** > **Providers**
2. Enable **Email** (sudah default)
3. (Optional) Enable **Google** atau **GitHub** untuk OAuth
4. Configurasi **Email Templates** di **Auth** > **Email Templates** jika perlu custom

### Step 4: Setup Storage (untuk CV & Profile Pictures)
1. Pergi ke **Storage**
2. Create new bucket: `user-profiles`
   - Make it **Public**
3. Create new bucket: `cv-files`
   - Make it **Public**
4. Create new bucket: `portfolio-images`
   - Make it **Public**

### Step 5: Setup Realtime (Optional)
1. Pergi ke **Database** > **Tables**
2. Untuk tabel yang perlu realtime updates, enable:
   - `job_applications` (untuk tracking aplikasi status)
   - `favorite_jobs` (untuk sync favorites)
   - `jobs` (untuk job updates real-time)
3. Click tabel > **Realtime** > Enable

### Step 6: Get Connection Keys
1. Pergi ke **Project Settings** > **API**
2. Copy:
   - `Project URL`
   - `anon` (public key)
   - `service_role` (secret key, jangan share!)

---

## Integration dengan Flutter

### Install Package
```bash
flutter pub add supabase
```

### Setup di Flutter
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;
```

### Auth Examples
```dart
// Sign up
final result = await supabase.auth.signUp(
  email: 'user@example.com',
  password: 'password',
);

// Sign in
await supabase.auth.signInWithPassword(
  email: 'user@example.com',
  password: 'password',
);

// Sign out
await supabase.auth.signOut();

// Get current user
final user = supabase.auth.currentUser;
```

### Database Examples
```dart
// Insert education
await supabase.from('education').insert({
  'user_id': supabase.auth.currentUser!.id,
  'education_level': 's1',
  'institution': 'Universitas Indonesia',
  'major': 'Teknik Informatika',
  'start_year': 2017,
  'end_year': 2021,
  'gpa': 3.75,
});

// Get jobs
final jobs = await supabase
  .from('jobs')
  .select('*, company:companies(name, logo_url)')
  .eq('is_active', true)
  .order('posted_date', ascending: false);

// Apply untuk job
await supabase.from('job_applications').insert({
  'user_id': supabase.auth.currentUser!.id,
  'job_id': jobId,
  'status': 'applied',
});
```

---

## Data Relationships

```
users (1) ──→ (Many) education
users (1) ──→ (Many) portfolio_projects
users (1) ──→ (Many) user_skills ←─ (Many) skills
users (1) ──→ (Many) job_applications → jobs
users (1) ──→ (Many) favorite_jobs → jobs
companies (1) ──→ (Many) jobs
jobs (1) ──→ (Many) job_requirements
jobs (1) ──→ (Many) job_tags
portfolio_projects (1) ──→ (Many) user_skills
```

---

## Tabel Cheat Sheet

| Tabel | Purpose | Key |
|-------|---------|-----|
| `users` | User profile | `id` (UUID from auth) |
| `education` | Riwayat pendidikan | `id`, `user_id` |
| `portfolio_projects` | Portfolio projects | `id`, `user_id` |
| `user_skills` | Skills user + proficiency | `id`, `user_id`, `skill_id` |
| `companies` | Master companies | `id` |
| `jobs` | Job listings | `id`, `company_id` |
| `job_requirements` | Requirements per job | `id`, `job_id` |
| `job_tags` | Tags per job | `id`, `job_id` |
| `job_applications` | User applications | `id`, `user_id`, `job_id` |
| `favorite_jobs` | User favorites | `id`, `user_id`, `job_id` |
| `skills` | Master skills | `id` |

---

## Best Practices

1. **Timestamps**: Selalu include `created_at` dan `updated_at` untuk audit trail
2. **UUIDs**: Gunakan UUID untuk primary keys (lebih aman dari sequential IDs)
3. **Constraints**: Gunakan CHECK constraints dan UNIQUE constraints
4. **Indexes**: Index pada columns yang sering di-filter atau sort
5. **RLS**: Enable RLS untuk data yang sensitive (user data)
6. **Foreign Keys**: Gunakan ON DELETE CASCADE untuk maintain data integrity
7. **Enums**: Gunakan CHECK constraints untuk enums (atau buat actual ENUM type jika banyak values)

---

## Common Queries

```sql
-- Get user profile dengan education
SELECT u.*, json_agg(e.*) as education
FROM users u
LEFT JOIN education e ON u.id = e.user_id
WHERE u.id = 'user-uuid'
GROUP BY u.id;

-- Get job dengan company, requirements, dan tags
SELECT j.*, 
       c.name as company_name,
       json_agg(jr.*) as requirements,
       json_agg(jt.tag) as tags
FROM jobs j
LEFT JOIN companies c ON j.company_id = c.id
LEFT JOIN job_requirements jr ON j.id = jr.job_id
LEFT JOIN job_tags jt ON j.id = jt.job_id
WHERE j.id = 'job-uuid'
GROUP BY j.id, c.id;

-- Get application history untuk user
SELECT ja.*, j.title, c.name as company_name
FROM job_applications ja
JOIN jobs j ON ja.job_id = j.id
JOIN companies c ON j.company_id = c.id
WHERE ja.user_id = 'user-uuid'
ORDER BY ja.applied_date DESC;

-- Get user's favorite jobs
SELECT j.*, c.name as company_name
FROM favorite_jobs fj
JOIN jobs j ON fj.job_id = j.id
JOIN companies c ON j.company_id = c.id
WHERE fj.user_id = 'user-uuid'
ORDER BY fj.created_at DESC;
```

---

## Security Considerations

1. **RLS Policies**: Selalu enforce user authentication untuk data yang sensitive
2. **API Keys**: 
   - `anon` key digunakan di client (limited permissions)
   - `service_role` key hanya di server (full permissions)
3. **File Upload**: Setup proper validation dan virus scanning untuk uploads
4. **Password**: Gunakan hashing yang aman (Supabase sudah handle ini)
5. **Rate Limiting**: Setup rate limits di edge untuk prevent abuse

---

## Next Steps

1. ✅ Setup Supabase project
2. ✅ Create database schema
3. ✅ Configure RLS policies
4. ✅ Setup storage buckets
5. ⏳ Integrate Supabase di Flutter app
6. ⏳ Create service classes untuk database operations
7. ⏳ Setup error handling dan logging
8. ⏳ Test authentication flow
9. ⏳ Test data persistence
10. ⏳ Deploy ke production

---

## Troubleshooting

### Error: "No rows affected"
- Check apakah RLS policy memungkinkan operation
- Verify data types match dengan schema

### Error: "UNIQUE constraint failed"
- User sudah apply ke job tersebut
- User sudah favorite job tersebut
- Email sudah registered

### Error: "Foreign key constraint"
- Referenced record tidak ada (e.g., user_id tidak valid)
- Cek data sebelum insert/update

### Slow queries
- Check indexes sudah created
- Optimize query dengan mengurangi data yang di-fetch
- Use `limit()` untuk pagination

