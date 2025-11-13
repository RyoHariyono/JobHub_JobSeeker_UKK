-- ============================================
-- INSERT JOBS DATA TO SUPABASE (CORRECTED)
-- ============================================
-- This SQL inserts 12 jobs with their requirements and tags
-- Struktur: jobs → job_requirements → job_tags (3 tables)
-- ============================================

-- IMPORTANT: Replace company IDs with YOUR actual Supabase company IDs
-- Run: SELECT id, name FROM companies; to get the correct IDs

-- ============================================
-- Job 1: Senior UI/UX Designer at Apple
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05',
    'Senior UI/UX Designer',
    'ui_ux',
    'full_time',
    'Jakarta, Indonesia',
    1000, 3000,
    'We are looking for a highly skilled Senior UI/UX Designer to join Apple in Jakarta, Indonesia. The role involves creating intuitive, user-friendly, and visually appealing designs that enhance user experiences across digital platforms. You will work closely with cross-functional teams to ensure design consistency and innovation.',
    '7+ years',
    'senior',
    2,
    CURRENT_DATE - INTERVAL '20 days',
    '2025-09-17',
    '2025-08-28',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Design, Computer Science, or related field.'),
    ('Proven experience as a UI/UX Designer with a strong portfolio.'),
    ('Proficiency in design tools such as Figma, Sketch, Adobe XD, and Photoshop.'),
    ('Strong understanding of user-centered design principles and usability testing.'),
    ('Excellent communication and collaboration skills to work effectively with cross-functional teams.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('Design'), ('Figma'), ('UI/UX')) AS tags(tag_name);

-- ============================================
-- Job 2: Product Designer at Google
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    'ofb56b74-cfef-41a7-aaed-8a5676a82ca69',
    'Product Designer',
    'ui_ux',
    'full_time',
    'Surabaya, Indonesia',
    2800, 4500,
    'Google is seeking an experienced Product Designer to lead design initiatives for innovative products. You will be responsible for creating user-centric designs, conducting user research, and collaborating with product teams to deliver exceptional digital experiences.',
    '5+ years',
    'senior',
    3,
    CURRENT_DATE - INTERVAL '15 days',
    '2025-11-20',
    '2025-11-01',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Design or related field.'),
    ('5+ years of experience in product design.'),
    ('Strong portfolio showcasing design thinking and problem-solving.'),
    ('Expertise in Figma, Sketch, and prototyping tools.'),
    ('Experience with user research and usability testing.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('Product Design'), ('User Research'), ('Figma')) AS tags(tag_name);

-- ============================================
-- Job 3: UI Designer at Meta
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    'e67914fe-bb8a-4e61-a3b3-f4f73bd56cfb',
    'UI Designer',
    'ui_ux',
    'full_time',
    'Bandung, Indonesia',
    1500, 2500,
    'Meta is looking for a talented UI Designer to create beautiful and functional user interfaces for our social media platforms. You will work with product managers and developers to bring designs to life.',
    '3+ years',
    'mid',
    1,
    CURRENT_DATE - INTERVAL '10 days',
    '2025-12-01',
    '2025-11-15',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Graphic Design or related field.'),
    ('3+ years of UI design experience.'),
    ('Proficiency in Figma, Adobe XD, and Illustrator.'),
    ('Strong understanding of color theory, typography, and layout.'),
    ('Ability to work in a fast-paced environment.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('UI Design'), ('Visual Design'), ('Figma')) AS tags(tag_name);

-- ============================================
-- Job 4: Full-Stack Developer at Microsoft
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    'd23de120-5668-403f-ae3e-78b2cb6e67b8',
    'Full-Stack Developer',
    'fullstack',
    'full_time',
    'Jakarta, Indonesia',
    2500, 4000,
    'Microsoft is seeking a skilled Full-Stack Developer to build and maintain web applications. You will work with both frontend and backend technologies to deliver high-quality software solutions.',
    '4+ years',
    'senior',
    2,
    CURRENT_DATE - INTERVAL '25 days',
    '2025-11-10',
    '2025-10-25',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Computer Science or related field.'),
    ('4+ years of full-stack development experience.'),
    ('Proficiency in React, Node.js, and databases.'),
    ('Experience with cloud platforms (Azure preferred).'),
    ('Strong problem-solving and debugging skills.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('React'), ('Node.js'), ('Full-Stack')) AS tags(tag_name);

-- ============================================
-- Job 5: Mobile Developer (Flutter) at Google
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    'ofb56b74-cfef-41a7-aaed-8a5676a82ca69',
    'Mobile Developer (Flutter)',
    'mobile',
    'full_time',
    'Surabaya, Indonesia',
    2800, 4200,
    'Build amazing mobile applications with Flutter for Android and iOS platforms. Join Google''s mobile team to create innovative solutions that reach millions of users worldwide.',
    '3+ years',
    'mid',
    3,
    CURRENT_DATE - INTERVAL '18 days',
    '2025-12-05',
    '2025-11-20',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Computer Science.'),
    ('3+ years of Flutter development experience.'),
    ('Strong knowledge of Dart programming language.'),
    ('Experience with Firebase and REST APIs.'),
    ('Published apps on App Store or Google Play.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('Flutter'), ('Mobile'), ('Dart')) AS tags(tag_name);

-- ============================================
-- Job 6: Software Engineer (Python) at Amazon
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    '8970f715-6edc-46c0-ba15-85881abe1ccc2',
    'Software Engineer (Python)',
    'backend',
    'full_time',
    'Jakarta, Indonesia',
    3500, 5000,
    'Amazon is hiring a Software Engineer specializing in Python to work on backend services and data processing systems. You will contribute to building scalable solutions for e-commerce and cloud services.',
    '5+ years',
    'senior',
    4,
    CURRENT_DATE - INTERVAL '30 days',
    '2025-11-30',
    '2025-12-15',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s or Master''s degree in Computer Science.'),
    ('5+ years of Python development experience.'),
    ('Experience with Django or Flask frameworks.'),
    ('Knowledge of AWS services and microservices architecture.'),
    ('Strong algorithmic and data structure skills.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('Python'), ('AWS'), ('Backend')) AS tags(tag_name);

-- ============================================
-- Job 7: React Frontend Developer at Netflix
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    '847ba4d5-80ea-490f-a20a-5f7f99b0e860f',
    'React Frontend Developer',
    'frontend',
    'full_time',
    'Bali, Indonesia',
    2200, 3800,
    'Netflix is looking for a React Frontend Developer to create stunning user interfaces for our streaming platform. You will work on performance optimization and delivering seamless user experiences.',
    '3+ years',
    'mid',
    2,
    CURRENT_DATE - INTERVAL '12 days',
    '2025-11-25',
    '2025-11-10',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Computer Science or related field.'),
    ('3+ years of React development experience.'),
    ('Strong knowledge of JavaScript, TypeScript, and CSS.'),
    ('Experience with state management (Redux, Context API).'),
    ('Understanding of responsive design and web accessibility.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('React'), ('Frontend'), ('TypeScript')) AS tags(tag_name);

-- ============================================
-- Job 8: Vue.js Developer at Spotify
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    'dee289ad-6c26-4434-a097-e8ba7338ead',
    'Vue.js Developer',
    'frontend',
    'contract',
    'Yogyakarta, Indonesia',
    2000, 3500,
    'Spotify is seeking a Vue.js Developer for a 6-month contract to build modern web applications for our music streaming platform. You will collaborate with designers and backend engineers.',
    '2+ years',
    'mid',
    1,
    CURRENT_DATE - INTERVAL '8 days',
    '2025-12-10',
    '2025-12-01',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Computer Science.'),
    ('2+ years of Vue.js development experience.'),
    ('Proficiency in JavaScript and Nuxt.js.'),
    ('Experience with RESTful APIs and GraphQL.'),
    ('Familiarity with modern frontend build tools.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('Vue.js'), ('Frontend'), ('JavaScript')) AS tags(tag_name);

-- ============================================
-- Job 9: Node.js Backend Developer at Microsoft
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    'd23de120-5668-403f-ae3e-78b2cb6e67b8',
    'Node.js Backend Developer',
    'backend',
    'full_time',
    'Jakarta, Indonesia',
    2600, 4000,
    'Build scalable backend services with Node.js for Microsoft''s cloud platform. You will design APIs, work with databases, and ensure high performance and security.',
    '4+ years',
    'senior',
    3,
    CURRENT_DATE - INTERVAL '20 days',
    '2025-11-15',
    '2025-11-01',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Computer Science.'),
    ('4+ years of Node.js backend development.'),
    ('Experience with Express.js and REST APIs.'),
    ('Strong knowledge of MongoDB or PostgreSQL.'),
    ('Familiarity with Docker and Kubernetes.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('Node.js'), ('Backend'), ('API')) AS tags(tag_name);

-- ============================================
-- Job 10: Java Spring Developer at Amazon
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    '8970f715-6edc-46c0-ba15-85881abe1ccc2',
    'Java Spring Developer',
    'backend',
    'full_time',
    'Jakarta, Indonesia',
    3000, 4500,
    'Amazon is hiring a Java Spring Developer to work on enterprise backend systems for our e-commerce platform. You will build microservices and work with large-scale distributed systems.',
    '5+ years',
    'senior',
    2,
    CURRENT_DATE - INTERVAL '28 days',
    '2025-11-05',
    '2025-10-20',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Computer Science.'),
    ('5+ years of Java development experience.'),
    ('Expertise in Spring Boot and Spring Cloud.'),
    ('Experience with microservices architecture.'),
    ('Knowledge of MySQL, Redis, and message queues.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('Java'), ('Spring'), ('Microservices')) AS tags(tag_name);

-- ============================================
-- Job 11: DevOps Engineer at Google
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    'ofb56b74-cfef-41a7-aaed-8a5676a82ca69',
    'DevOps Engineer',
    'devops',
    'full_time',
    'Surabaya, Indonesia',
    3200, 5000,
    'Google is looking for a DevOps Engineer to manage cloud infrastructure, automate deployments, and ensure system reliability. You will work with cutting-edge technologies and tools.',
    '4+ years',
    'senior',
    2,
    CURRENT_DATE - INTERVAL '14 days',
    '2025-11-20',
    '2025-11-05',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s degree in Computer Science or related field.'),
    ('4+ years of DevOps experience.'),
    ('Strong knowledge of AWS, GCP, or Azure.'),
    ('Experience with Docker, Kubernetes, and Terraform.'),
    ('Proficiency in CI/CD pipelines and automation.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('DevOps'), ('GCP'), ('Kubernetes')) AS tags(tag_name);

-- ============================================
-- Job 12: Cloud Architect at Amazon
-- ============================================
WITH new_job AS (
  INSERT INTO jobs (
    company_id, title, category, type, location,
    min_salary, max_salary, description,
    experience_required, job_level, capacity,
    posted_date, deadline_date, start_date, is_active
  ) VALUES (
    '8970f715-6edc-46c0-ba15-85881abe1ccc2',
    'Cloud Architect',
    'devops',
    'full_time',
    'Jakarta, Indonesia',
    4000, 6000,
    'Amazon is seeking an experienced Cloud Architect to design and implement scalable cloud solutions for our global infrastructure. You will lead architectural decisions and mentor engineering teams.',
    '7+ years',
    'lead',
    1,
    CURRENT_DATE - INTERVAL '22 days',
    '2025-10-28',
    '2025-10-15',
    true
  ) RETURNING id
),
requirements AS (
  INSERT INTO job_requirements (job_id, requirement, is_required)
  SELECT new_job.id, req, true
  FROM new_job, (VALUES
    ('Bachelor''s or Master''s degree in Computer Science.'),
    ('7+ years of cloud architecture experience.'),
    ('Expert knowledge of AWS services and best practices.'),
    ('Experience with multi-region deployments and disaster recovery.'),
    ('Strong leadership and communication skills.')
  ) AS requirements(req)
)
INSERT INTO job_tags (job_id, tag)
SELECT new_job.id, tag_name
FROM new_job, (VALUES ('AWS'), ('Cloud Architecture'), ('Leadership')) AS tags(tag_name);

-- ============================================
-- VERIFICATION QUERY
-- ============================================
-- Run this to verify all jobs were inserted successfully:
SELECT 
  j.title, 
  c.name as company_name, 
  j.category, 
  j.type, 
  j.location,
  j.min_salary || '-' || j.max_salary as salary_range,
  COUNT(DISTINCT jr.id) as requirements_count,
  COUNT(DISTINCT jt.id) as tags_count
FROM jobs j
JOIN companies c ON j.company_id = c.id
LEFT JOIN job_requirements jr ON j.id = jr.job_id
LEFT JOIN job_tags jt ON j.id = jt.job_id
GROUP BY j.id, j.title, c.name, j.category, j.type, j.location, j.min_salary, j.max_salary
ORDER BY j.posted_date DESC;
