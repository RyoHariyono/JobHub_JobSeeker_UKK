-- ============================================
-- JOBHUB: INSERT JOBS DATA (CORRECT UUIDs)
-- ============================================
-- Updated with correct company UUIDs from database
-- ============================================

-- STEP 1: CLEAR EXISTING JOBS DATA
DELETE FROM favorite_jobs;
DELETE FROM job_applications;
DELETE FROM job_tags;
DELETE FROM job_requirements;
DELETE FROM jobs;

-- ============================================
-- STEP 2: INSERT 12 JOBS
-- ============================================

-- Job 1: Senior UI/UX Designer at Apple
DO $$
DECLARE
  job_id UUID;
BEGIN
  
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    '22825dc1-19e6-4efd-b82e-d2a3a2264685'::uuid,  -- Apple
    'Senior UI/UX Designer',
    'ui_ux',
    'full_time',
    'Jakarta, Indonesia',
    1000, 3000,
    'We are looking for a highly skilled Senior UI/UX Designer to join Apple in Jakarta, Indonesia. The role involves creating intuitive, user-friendly, and visually appealing designs that enhance user experiences across digital platforms.',
    '7+ years',
    'senior',
    2,
    CURRENT_DATE - INTERVAL '20 days',
    '2025-09-17',
    '2025-08-28',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Design, Computer Science, or related field.', true),
    (job_id, 'Proven experience as a UI/UX Designer with a strong portfolio.', true),
    (job_id, 'Proficiency in design tools such as Figma, Sketch, Adobe XD, and Photoshop.', true),
    (job_id, 'Strong understanding of user-centered design principles and usability testing.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'Design'),
    (job_id, 'Figma'),
    (job_id, 'UI/UX');
END $$;

-- Job 2: Product Designer at Google
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    '0fb55b74-cf6f-41a7-aead-5b5676a3cab9'::uuid,  -- Google (CORRECTED)
    'Product Designer',
    'ui_ux',
    'full_time',
    'Surabaya, Indonesia',
    2800, 4500,
    'Google is seeking an experienced Product Designer to lead design initiatives for innovative products. You will be responsible for creating user-centric designs and conducting user research.',
    '5+ years',
    'senior',
    3,
    CURRENT_DATE - INTERVAL '15 days',
    '2025-11-20',
    '2025-11-01',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Design or related field.', true),
    (job_id, '5+ years of experience in product design.', true),
    (job_id, 'Strong portfolio showcasing design thinking and problem-solving.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'Product Design'),
    (job_id, 'User Research'),
    (job_id, 'Figma');
END $$;

-- Job 3: UI Designer at Meta
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    'e6791d4e-bb8a-4e61-a3b3-f4735bd56cfb'::uuid,  -- Meta
    'UI Designer',
    'ui_ux',
    'full_time',
    'Bandung, Indonesia',
    1500, 2500,
    'Meta is looking for a talented UI Designer to create beautiful and functional user interfaces for our social media platforms.',
    '3+ years',
    'mid',
    1,
    CURRENT_DATE - INTERVAL '10 days',
    '2025-12-01',
    '2025-11-15',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Graphic Design or related field.', true),
    (job_id, '3+ years of UI design experience.', true),
    (job_id, 'Proficiency in Figma, Adobe XD, and Illustrator.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'UI Design'),
    (job_id, 'Visual Design'),
    (job_id, 'Figma');
END $$;

-- Job 4: Full-Stack Developer at Microsoft
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    'd23d6120-5668-403f-ae3e-78b2cb687b55'::uuid,  -- Microsoft (CORRECTED)
    'Full-Stack Developer',
    'fullstack',
    'full_time',
    'Jakarta, Indonesia',
    2500, 4000,
    'Microsoft is seeking a skilled Full-Stack Developer to build and maintain web applications. You will work with both frontend and backend technologies.',
    '4+ years',
    'senior',
    2,
    CURRENT_DATE - INTERVAL '25 days',
    '2025-11-10',
    '2025-10-25',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Computer Science or related field.', true),
    (job_id, '4+ years of full-stack development experience.', true),
    (job_id, 'Proficiency in React, Node.js, and databases.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'React'),
    (job_id, 'Node.js'),
    (job_id, 'Full-Stack');
END $$;

-- Job 5: Mobile Developer (Flutter) at Google
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    '0fb55b74-cf6f-41a7-aead-5b5676a3cab9'::uuid,  -- Google (CORRECTED)
    'Mobile Developer (Flutter)',
    'mobile',
    'full_time',
    'Surabaya, Indonesia',
    2800, 4200,
    'Build amazing mobile applications with Flutter for Android and iOS platforms. Join Google''s mobile team to create innovative solutions.',
    '3+ years',
    'mid',
    3,
    CURRENT_DATE - INTERVAL '18 days',
    '2025-12-05',
    '2025-11-20',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Computer Science.', true),
    (job_id, '3+ years of Flutter development experience.', true),
    (job_id, 'Strong knowledge of Dart programming language.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'Flutter'),
    (job_id, 'Mobile'),
    (job_id, 'Dart');
END $$;

-- Job 6: Software Engineer (Python) at Amazon
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    '89707f15-6adc-46c0-bd21-29888ed5149b'::uuid,  -- Amazon (CORRECTED)
    'Software Engineer (Python)',
    'backend',
    'full_time',
    'Jakarta, Indonesia',
    3500, 5000,
    'Amazon is hiring a Software Engineer specializing in Python to work on backend services and data processing systems.',
    '5+ years',
    'senior',
    4,
    CURRENT_DATE - INTERVAL '30 days',
    '2025-11-30',
    '2025-12-15',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s or Master''s degree in Computer Science.', true),
    (job_id, '5+ years of Python development experience.', true),
    (job_id, 'Experience with Django or Flask frameworks.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'Python'),
    (job_id, 'AWS'),
    (job_id, 'Backend');
END $$;

-- Job 7: React Frontend Developer at Netflix
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    '547bc8d4-8eea-490f-a39a-5f7895ca8502'::uuid,  -- Netflix (CORRECTED)
    'React Frontend Developer',
    'frontend',
    'full_time',
    'Bali, Indonesia',
    2200, 3800,
    'Netflix is looking for a React Frontend Developer to create stunning user interfaces for our streaming platform.',
    '3+ years',
    'mid',
    2,
    CURRENT_DATE - INTERVAL '12 days',
    '2025-11-25',
    '2025-11-10',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Computer Science or related field.', true),
    (job_id, '3+ years of React development experience.', true),
    (job_id, 'Strong knowledge of JavaScript, TypeScript, and CSS.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'React'),
    (job_id, 'Frontend'),
    (job_id, 'TypeScript');
END $$;

-- Job 8: Vue.js Developer at Spotify
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    'dea289ad-6c26-4434-a097-a8ba7338ced1'::uuid,  -- Spotify (CORRECTED)
    'Vue.js Developer',
    'frontend',
    'contract',
    'Yogyakarta, Indonesia',
    2000, 3500,
    'Spotify is seeking a Vue.js Developer for a 6-month contract to build modern web applications for our music streaming platform.',
    '2+ years',
    'mid',
    1,
    CURRENT_DATE - INTERVAL '8 days',
    '2025-12-10',
    '2025-12-01',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Computer Science.', true),
    (job_id, '2+ years of Vue.js development experience.', true),
    (job_id, 'Proficiency in JavaScript and Nuxt.js.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'Vue.js'),
    (job_id, 'Frontend'),
    (job_id, 'JavaScript');
END $$;

-- Job 9: Node.js Backend Developer at Microsoft
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    'd23d6120-5668-403f-ae3e-78b2cb687b55'::uuid,  -- Microsoft (CORRECTED)
    'Node.js Backend Developer',
    'backend',
    'full_time',
    'Jakarta, Indonesia',
    2600, 4000,
    'Build scalable backend services with Node.js for Microsoft''s cloud platform. You will design APIs and work with databases.',
    '4+ years',
    'senior',
    3,
    CURRENT_DATE - INTERVAL '20 days',
    '2025-11-15',
    '2025-11-01',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Computer Science.', true),
    (job_id, '4+ years of Node.js backend development.', true),
    (job_id, 'Experience with Express.js and REST APIs.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'Node.js'),
    (job_id, 'Backend'),
    (job_id, 'API');
END $$;

-- Job 10: Java Spring Developer at Amazon
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    '89707f15-6adc-46c0-bd21-29888ed5149b'::uuid,  -- Amazon (CORRECTED)
    'Java Spring Developer',
    'backend',
    'full_time',
    'Jakarta, Indonesia',
    3000, 4500,
    'Amazon is hiring a Java Spring Developer to work on enterprise backend systems for our e-commerce platform.',
    '5+ years',
    'senior',
    2,
    CURRENT_DATE - INTERVAL '28 days',
    '2025-11-05',
    '2025-10-20',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Computer Science.', true),
    (job_id, '5+ years of Java development experience.', true),
    (job_id, 'Expertise in Spring Boot and Spring Cloud.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'Java'),
    (job_id, 'Spring'),
    (job_id, 'Microservices');
END $$;

-- Job 11: DevOps Engineer at Google
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    '0fb55b74-cf6f-41a7-aead-5b5676a3cab9'::uuid,  -- Google (CORRECTED)
    'DevOps Engineer',
    'devops',
    'full_time',
    'Surabaya, Indonesia',
    3200, 5000,
    'Google is looking for a DevOps Engineer to manage cloud infrastructure, automate deployments, and ensure system reliability.',
    '4+ years',
    'senior',
    2,
    CURRENT_DATE - INTERVAL '14 days',
    '2025-11-20',
    '2025-11-05',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s degree in Computer Science or related field.', true),
    (job_id, '4+ years of DevOps experience.', true),
    (job_id, 'Strong knowledge of AWS, GCP, or Azure.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'DevOps'),
    (job_id, 'GCP'),
    (job_id, 'Kubernetes');
END $$;

-- Job 12: Cloud Architect at Amazon
DO $$
DECLARE
  job_id UUID;
BEGIN
  INSERT INTO jobs (company_id, title, category, type, location, min_salary, max_salary, description, experience_required, job_level, capacity, posted_date, deadline_date, start_date, is_active)
  VALUES (
    '89707f15-6adc-46c0-bd21-29888ed5149b'::uuid,  -- Amazon (CORRECTED)
    'Cloud Architect',
    'devops',
    'full_time',
    'Jakarta, Indonesia',
    4000, 6000,
    'Amazon is seeking an experienced Cloud Architect to design and implement scalable cloud solutions for our global infrastructure.',
    '7+ years',
    'lead',
    1,
    CURRENT_DATE - INTERVAL '22 days',
    '2025-10-28',
    '2025-10-15',
    true
  )
  RETURNING id INTO job_id;

  INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
    (job_id, 'Bachelor''s or Master''s degree in Computer Science.', true),
    (job_id, '7+ years of cloud architecture experience.', true),
    (job_id, 'Expert knowledge of AWS services and best practices.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'AWS'),
    (job_id, 'Cloud Architecture'),
    (job_id, 'Leadership');
END $$;

-- ============================================
-- STEP 3: VERIFY DATA
-- ============================================
SELECT 
  j.title, 
  c.name as company_name, 
  j.category, 
  j.type, 
  j.location,
  j.min_salary || '-' || j.max_salary || ' USD' as salary_range,
  COUNT(DISTINCT jr.id) as requirements_count,
  COUNT(DISTINCT jt.id) as tags_count
FROM jobs j
JOIN companies c ON j.company_id = c.id
LEFT JOIN job_requirements jr ON j.id = jr.job_id
LEFT JOIN job_tags jt ON j.id = jt.job_id
GROUP BY j.id, j.title, c.name, j.category, j.type, j.location, j.min_salary, j.max_salary
ORDER BY j.posted_date DESC;
