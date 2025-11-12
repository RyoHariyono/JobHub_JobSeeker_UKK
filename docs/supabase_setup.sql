-- ============================================================
-- JobHub JobSeeker - Supabase SQL Setup Script
-- Copy-paste seluruh script ini ke Supabase SQL Editor
-- ============================================================

-- ==================== CREATE EXTENSION ====================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==================== USERS TABLE ====================
CREATE TABLE IF NOT EXISTS users (
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

-- ==================== EDUCATION TABLE ====================
CREATE TABLE IF NOT EXISTS education (
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

-- ==================== COMPANIES TABLE ====================
CREATE TABLE IF NOT EXISTS companies (
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

-- ==================== JOBS TABLE ====================
CREATE TABLE IF NOT EXISTS jobs (
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

-- ==================== JOB REQUIREMENTS TABLE ====================
CREATE TABLE IF NOT EXISTS job_requirements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  requirement TEXT NOT NULL,
  is_required BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== JOB TAGS TABLE ====================
CREATE TABLE IF NOT EXISTS job_tags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  tag TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== JOB APPLICATIONS TABLE ====================
CREATE TABLE IF NOT EXISTS job_applications (
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

-- ==================== FAVORITE JOBS TABLE ====================
CREATE TABLE IF NOT EXISTS favorite_jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, job_id)
);

-- ==================== SKILLS TABLE ====================
CREATE TABLE IF NOT EXISTS skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  category TEXT CHECK (category IN ('frontend', 'backend', 'design', 'mobile', 'other')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== PORTFOLIO PROJECTS TABLE ====================
CREATE TABLE IF NOT EXISTS portfolio_projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  project_name TEXT NOT NULL,
  description TEXT,
  project_link TEXT,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==================== USER SKILLS TABLE ====================
CREATE TABLE IF NOT EXISTS user_skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  skill_id UUID NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  proficiency_level TEXT CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
  portfolio_project_id UUID REFERENCES portfolio_projects(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, skill_id)
);

-- ==================== CREATE INDEXES ====================
CREATE INDEX IF NOT EXISTS idx_education_user_id ON education(user_id);
CREATE INDEX IF NOT EXISTS idx_education_created_at ON education(created_at);

CREATE INDEX IF NOT EXISTS idx_jobs_company_id ON jobs(company_id);
CREATE INDEX IF NOT EXISTS idx_jobs_category ON jobs(category);
CREATE INDEX IF NOT EXISTS idx_jobs_location ON jobs(location);
CREATE INDEX IF NOT EXISTS idx_jobs_is_active ON jobs(is_active);
CREATE INDEX IF NOT EXISTS idx_jobs_posted_date ON jobs(posted_date);

CREATE INDEX IF NOT EXISTS idx_job_requirements_job_id ON job_requirements(job_id);
CREATE INDEX IF NOT EXISTS idx_job_tags_job_id ON job_tags(job_id);

CREATE INDEX IF NOT EXISTS idx_job_applications_user_id ON job_applications(user_id);
CREATE INDEX IF NOT EXISTS idx_job_applications_job_id ON job_applications(job_id);
CREATE INDEX IF NOT EXISTS idx_job_applications_status ON job_applications(status);
CREATE INDEX IF NOT EXISTS idx_job_applications_applied_date ON job_applications(applied_date);

CREATE INDEX IF NOT EXISTS idx_favorite_jobs_user_id ON favorite_jobs(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_jobs_job_id ON favorite_jobs(job_id);

CREATE INDEX IF NOT EXISTS idx_skills_name ON skills(name);
CREATE INDEX IF NOT EXISTS idx_skills_category ON skills(category);

CREATE INDEX IF NOT EXISTS idx_portfolio_projects_user_id ON portfolio_projects(user_id);

CREATE INDEX IF NOT EXISTS idx_user_skills_user_id ON user_skills(user_id);
CREATE INDEX IF NOT EXISTS idx_user_skills_skill_id ON user_skills(skill_id);
CREATE INDEX IF NOT EXISTS idx_user_skills_portfolio_project_id ON user_skills(portfolio_project_id);

-- ==================== ENABLE ROW LEVEL SECURITY ====================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE education ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorite_jobs ENABLE ROW LEVEL SECURITY;

-- ==================== RLS POLICIES - USERS ====================
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

-- ==================== RLS POLICIES - EDUCATION ====================
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

-- ==================== RLS POLICIES - PORTFOLIO PROJECTS ====================
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

-- ==================== RLS POLICIES - USER SKILLS ====================
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

-- ==================== RLS POLICIES - JOB APPLICATIONS ====================
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

-- ==================== RLS POLICIES - FAVORITE JOBS ====================
CREATE POLICY "Users can read own favorite jobs"
  ON favorite_jobs FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own favorite jobs"
  ON favorite_jobs FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own favorite jobs"
  ON favorite_jobs FOR DELETE
  USING (user_id = auth.uid());

-- ==================== RLS POLICIES - PUBLIC READ ====================
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

-- ==================== INSERT SAMPLE DATA ====================

-- Insert sample companies
INSERT INTO companies (name, logo_url, description, location, website, industry, company_size)
VALUES 
  ('Apple', 'assets/images/apple_logo.png', 'Technology innovation leader', 'Jakarta, Indonesia', 'https://apple.com', 'Technology', 'large'),
  ('Google', 'assets/images/google_logo.png', 'Global technology leader', 'Surabaya, Indonesia', 'https://google.com', 'Technology', 'large'),
  ('Microsoft', 'assets/images/microsoft_logo.png', 'Software and cloud services', 'Jakarta, Indonesia', 'https://microsoft.com', 'Software', 'large'),
  ('Meta', 'assets/images/meta_logo.png', 'Social technology company', 'Bandung, Indonesia', 'https://meta.com', 'Technology', 'large'),
  ('Amazon', 'assets/images/amazon_logo.png', 'E-commerce and cloud computing', 'Jakarta, Indonesia', 'https://amazon.com', 'E-commerce', 'enterprise'),
  ('Netflix', 'assets/images/netflix_logo.png', 'Entertainment streaming service', 'Bali, Indonesia', 'https://netflix.com', 'Entertainment', 'large'),
  ('Tesla', 'assets/images/tesla_logo.png', 'Electric vehicles and clean energy', 'Surabaya, Indonesia', 'https://tesla.com', 'Automotive', 'large'),
  ('Spotify', 'assets/images/spotify_logo.png', 'Audio streaming platform', 'Yogyakarta, Indonesia', 'https://spotify.com', 'Entertainment', 'large')
ON CONFLICT (name) DO NOTHING;

-- Insert sample skills
INSERT INTO skills (name, category)
VALUES 
  ('Flutter Dev', 'mobile'),
  ('UI/UX Design', 'design'),
  ('Web Dev', 'frontend'),
  ('React', 'frontend'),
  ('Vue.js', 'frontend'),
  ('Angular', 'frontend'),
  ('Node.js', 'backend'),
  ('Python', 'backend'),
  ('Java', 'backend'),
  ('C++', 'backend'),
  ('JavaScript', 'frontend'),
  ('TypeScript', 'frontend'),
  ('CSS', 'frontend'),
  ('HTML', 'frontend'),
  ('SQL', 'backend'),
  ('MongoDB', 'backend'),
  ('Firebase', 'backend'),
  ('AWS', 'backend'),
  ('Docker', 'backend'),
  ('Git', 'backend'),
  ('Figma', 'design'),
  ('Adobe XD', 'design'),
  ('Photoshop', 'design'),
  ('Illustrator', 'design'),
  ('Mobile Development', 'mobile'),
  ('Backend Development', 'backend'),
  ('Frontend Development', 'frontend'),
  ('Full Stack Development', 'frontend'),
  ('DevOps', 'backend'),
  ('Machine Learning', 'backend')
ON CONFLICT (name) DO NOTHING;

-- ==================== END OF SCRIPT ====================
-- Script selesai. Database siap digunakan!
-- Langkah berikutnya:
-- 1. Setup Storage buckets (user-profiles, cv-files, portfolio-images)
-- 2. Configure Authentication providers
-- 3. Integrate ke Flutter app
