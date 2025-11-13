-- ============================================
-- INSERT JOBS DATA TO SUPABASE
-- ============================================
-- This SQL script inserts 12 job listings into the 'jobs' table
-- Make sure the company IDs match your actual Supabase company records
-- ============================================

-- IMPORTANT: Replace these UUIDs with your actual company IDs from Supabase
-- You can get them by running: SELECT id, name FROM companies;
-- 
-- Based on the screenshot, here are the company IDs:
-- ofb56b74-cfef-41a7-aaed-8a5676a82ca69 = Google
-- 226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05 = Apple
-- 847ba4d5-80ea-490f-a20a-5f7f99b0e860f = Netflix
-- 8970f715-6edc-46c0-ba15-85881abe1ccc2 = Amazon
-- d23de120-5668-403f-ae3e-78b2cb6e67b8 = Microsoft
-- d26f01e4-1ffc-4586-b784-d466dd342b8a = Tesla
-- dee289ad-6c26-4434-a097-e8ba7338ead = Spotify
-- e67914fe-bb8a-4e61-a3b3-f4f73bd56cfb = Meta

-- ============================================
-- UI/UX DESIGN JOBS (3 jobs)
-- ============================================

-- Job 1: Senior UI/UX Designer at Apple
INSERT INTO jobs (
  company_id,
  title,
  category,
  type,
  location,
  min_salary,
  max_salary,
  description,
  experience_required,
  job_level,
  capacity,
  posted_date,
  deadline_date,
  start_date,
  is_active
) VALUES
(
  '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05', -- Apple
  'Senior UI/UX Designer',
  'ui_ux',
  'full_time',
  'Jakarta, Indonesia',
  1000,
  3000,
  'We are looking for a highly skilled Senior UI/UX Designer to join Apple in Jakarta, Indonesia. The role involves creating intuitive, user-friendly, and visually appealing designs that enhance user experiences across digital platforms. You will work closely with cross-functional teams to ensure design consistency and innovation.',
  '7+ years',
  'senior',
  2,
  CURRENT_DATE - INTERVAL '20 days',
  '2025-09-17',
  '2025-08-28',
  true
)
RETURNING id;

-- Job 1 Requirements
INSERT INTO job_requirements (job_id, requirement, is_required) VALUES
((SELECT id FROM jobs WHERE title = 'Senior UI/UX Designer' AND company_id = '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05' ORDER BY created_at DESC LIMIT 1), 
  'Bachelor''s degree in Design, Computer Science, or related field.', true),
((SELECT id FROM jobs WHERE title = 'Senior UI/UX Designer' AND company_id = '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05' ORDER BY created_at DESC LIMIT 1), 
  'Proven experience as a UI/UX Designer with a strong portfolio.', true),
((SELECT id FROM jobs WHERE title = 'Senior UI/UX Designer' AND company_id = '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05' ORDER BY created_at DESC LIMIT 1), 
  'Proficiency in design tools such as Figma, Sketch, Adobe XD, and Photoshop.', true),
((SELECT id FROM jobs WHERE title = 'Senior UI/UX Designer' AND company_id = '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05' ORDER BY created_at DESC LIMIT 1), 
  'Strong understanding of user-centered design principles and usability testing.', true),
((SELECT id FROM jobs WHERE title = 'Senior UI/UX Designer' AND company_id = '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05' ORDER BY created_at DESC LIMIT 1), 
  'Excellent communication and collaboration skills to work effectively with cross-functional teams.', true);

-- Job 1 Tags
INSERT INTO job_tags (job_id, tag) VALUES
((SELECT id FROM jobs WHERE title = 'Senior UI/UX Designer' AND company_id = '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05' ORDER BY created_at DESC LIMIT 1), 'Design'),
((SELECT id FROM jobs WHERE title = 'Senior UI/UX Designer' AND company_id = '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05' ORDER BY created_at DESC LIMIT 1), 'Figma'),
((SELECT id FROM jobs WHERE title = 'Senior UI/UX Designer' AND company_id = '226d5dc1-19e5-4ef4-bb0e-d9a596a2e4e05' ORDER BY created_at DESC LIMIT 1), 'UI/UX');

-- ============================================

-- Job 2: Product Designer at Google
(
  gen_random_uuid(),
  'ofb56b74-cfef-41a7-aaed-8a5676a82ca69', -- Google
  'Product Designer',
  'UI/UX Design',
  'Full-Time',
  'Surabaya, Indonesia',
  2800,
  4500,
  'Google is seeking an experienced Product Designer to lead design initiatives for innovative products. You will be responsible for creating user-centric designs, conducting user research, and collaborating with product teams to deliver exceptional digital experiences.',
  ARRAY[
    'Bachelor''s degree in Design or related field.',
    '5+ years of experience in product design.',
    'Strong portfolio showcasing design thinking and problem-solving.',
    'Expertise in Figma, Sketch, and prototyping tools.',
    'Experience with user research and usability testing.'
  ],
  CURRENT_DATE - INTERVAL '15 days',
  '2025-11-20',
  '2025-11-01',
  ARRAY['Product Design', 'User Research', 'Figma'],
  3,
  '5+ years',
  'Senior Level'
),

-- Job 3: UI Designer at Meta
(
  gen_random_uuid(),
  'e67914fe-bb8a-4e61-a3b3-f4f73bd56cfb', -- Meta
  'UI Designer',
  'UI/UX Design',
  'Full-Time',
  'Bandung, Indonesia',
  1500,
  2500,
  'Meta is looking for a talented UI Designer to create beautiful and functional user interfaces for our social media platforms. You will work with product managers and developers to bring designs to life.',
  ARRAY[
    'Bachelor''s degree in Graphic Design or related field.',
    '3+ years of UI design experience.',
    'Proficiency in Figma, Adobe XD, and Illustrator.',
    'Strong understanding of color theory, typography, and layout.',
    'Ability to work in a fast-paced environment.'
  ],
  CURRENT_DATE - INTERVAL '10 days',
  '2025-12-01',
  '2025-11-15',
  ARRAY['UI Design', 'Visual Design', 'Figma'],
  1,
  '3+ years',
  'Mid Level'
),

-- ============================================
-- SOFTWARE DEVELOPMENT JOBS (3 jobs)
-- ============================================

-- Job 4: Full-Stack Developer at Microsoft
(
  gen_random_uuid(),
  'd23de120-5668-403f-ae3e-78b2cb6e67b8', -- Microsoft
  'Full-Stack Developer',
  'Software Development',
  'Full-Time',
  'Jakarta, Indonesia',
  2500,
  4000,
  'Microsoft is seeking a skilled Full-Stack Developer to build and maintain web applications. You will work with both frontend and backend technologies to deliver high-quality software solutions.',
  ARRAY[
    'Bachelor''s degree in Computer Science or related field.',
    '4+ years of full-stack development experience.',
    'Proficiency in React, Node.js, and databases.',
    'Experience with cloud platforms (Azure preferred).',
    'Strong problem-solving and debugging skills.'
  ],
  CURRENT_DATE - INTERVAL '25 days',
  '2025-11-10',
  '2025-10-25',
  ARRAY['React', 'Node.js', 'Full-Stack'],
  2,
  '4+ years',
  'Senior Level'
),

-- Job 5: Mobile Developer (Flutter) at Google
(
  gen_random_uuid(),
  'ofb56b74-cfef-41a7-aaed-8a5676a82ca69', -- Google
  'Mobile Developer (Flutter)',
  'Software Development',
  'Full-Time',
  'Surabaya, Indonesia',
  2800,
  4200,
  'Build amazing mobile applications with Flutter for Android and iOS platforms. Join Google''s mobile team to create innovative solutions that reach millions of users worldwide.',
  ARRAY[
    'Bachelor''s degree in Computer Science.',
    '3+ years of Flutter development experience.',
    'Strong knowledge of Dart programming language.',
    'Experience with Firebase and REST APIs.',
    'Published apps on App Store or Google Play.'
  ],
  CURRENT_DATE - INTERVAL '18 days',
  '2025-12-05',
  '2025-11-20',
  ARRAY['Flutter', 'Mobile', 'Dart'],
  3,
  '3+ years',
  'Mid to Senior Level'
),

-- Job 6: Software Engineer (Python) at Amazon
(
  gen_random_uuid(),
  '8970f715-6edc-46c0-ba15-85881abe1ccc2', -- Amazon
  'Software Engineer (Python)',
  'Software Development',
  'Full-Time',
  'Jakarta, Indonesia',
  3500,
  5000,
  'Amazon is hiring a Software Engineer specializing in Python to work on backend services and data processing systems. You will contribute to building scalable solutions for e-commerce and cloud services.',
  ARRAY[
    'Bachelor''s or Master''s degree in Computer Science.',
    '5+ years of Python development experience.',
    'Experience with Django or Flask frameworks.',
    'Knowledge of AWS services and microservices architecture.',
    'Strong algorithmic and data structure skills.'
  ],
  CURRENT_DATE - INTERVAL '30 days',
  '2025-11-30',
  '2025-12-15',
  ARRAY['Python', 'AWS', 'Backend'],
  4,
  '5+ years',
  'Senior Engineer'
),

-- ============================================
-- FRONTEND DEVELOPMENT JOBS (2 jobs)
-- ============================================

-- Job 7: React Frontend Developer at Netflix
(
  gen_random_uuid(),
  '847ba4d5-80ea-490f-a20a-5f7f99b0e860f', -- Netflix
  'React Frontend Developer',
  'Frontend Development',
  'Full-Time',
  'Bali, Indonesia',
  2200,
  3800,
  'Netflix is looking for a React Frontend Developer to create stunning user interfaces for our streaming platform. You will work on performance optimization and delivering seamless user experiences.',
  ARRAY[
    'Bachelor''s degree in Computer Science or related field.',
    '3+ years of React development experience.',
    'Strong knowledge of JavaScript, TypeScript, and CSS.',
    'Experience with state management (Redux, Context API).',
    'Understanding of responsive design and web accessibility.'
  ],
  CURRENT_DATE - INTERVAL '12 days',
  '2025-11-25',
  '2025-11-10',
  ARRAY['React', 'Frontend', 'TypeScript'],
  2,
  '3+ years',
  'Mid Level'
),

-- Job 8: Vue.js Developer at Spotify
(
  gen_random_uuid(),
  'dee289ad-6c26-4434-a097-e8ba7338ead', -- Spotify
  'Vue.js Developer',
  'Frontend Development',
  'Contract',
  'Yogyakarta, Indonesia',
  2000,
  3500,
  'Spotify is seeking a Vue.js Developer for a 6-month contract to build modern web applications for our music streaming platform. You will collaborate with designers and backend engineers.',
  ARRAY[
    'Bachelor''s degree in Computer Science.',
    '2+ years of Vue.js development experience.',
    'Proficiency in JavaScript and Nuxt.js.',
    'Experience with RESTful APIs and GraphQL.',
    'Familiarity with modern frontend build tools.'
  ],
  CURRENT_DATE - INTERVAL '8 days',
  '2025-12-10',
  '2025-12-01',
  ARRAY['Vue.js', 'Frontend', 'JavaScript'],
  1,
  '2+ years',
  'Mid Level'
),

-- ============================================
-- BACKEND DEVELOPMENT JOBS (2 jobs)
-- ============================================

-- Job 9: Node.js Backend Developer at Microsoft
(
  gen_random_uuid(),
  'd23de120-5668-403f-ae3e-78b2cb6e67b8', -- Microsoft
  'Node.js Backend Developer',
  'Backend Development',
  'Full-Time',
  'Jakarta, Indonesia',
  2600,
  4000,
  'Build scalable backend services with Node.js for Microsoft''s cloud platform. You will design APIs, work with databases, and ensure high performance and security.',
  ARRAY[
    'Bachelor''s degree in Computer Science.',
    '4+ years of Node.js backend development.',
    'Experience with Express.js and REST APIs.',
    'Strong knowledge of MongoDB or PostgreSQL.',
    'Familiarity with Docker and Kubernetes.'
  ],
  CURRENT_DATE - INTERVAL '20 days',
  '2025-11-15',
  '2025-11-01',
  ARRAY['Node.js', 'Backend', 'API'],
  3,
  '4+ years',
  'Senior Level'
),

-- Job 10: Java Spring Developer at Amazon
(
  gen_random_uuid(),
  '8970f715-6edc-46c0-ba15-85881abe1ccc2', -- Amazon
  'Java Spring Developer',
  'Backend Development',
  'Full-Time',
  'Jakarta, Indonesia',
  3000,
  4500,
  'Amazon is hiring a Java Spring Developer to work on enterprise backend systems for our e-commerce platform. You will build microservices and work with large-scale distributed systems.',
  ARRAY[
    'Bachelor''s degree in Computer Science.',
    '5+ years of Java development experience.',
    'Expertise in Spring Boot and Spring Cloud.',
    'Experience with microservices architecture.',
    'Knowledge of MySQL, Redis, and message queues.'
  ],
  CURRENT_DATE - INTERVAL '28 days',
  '2025-11-05',
  '2025-10-20',
  ARRAY['Java', 'Spring', 'Microservices'],
  2,
  '5+ years',
  'Senior Engineer'
),

-- ============================================
-- DEVOPS & CLOUD ENGINEERING JOBS (2 jobs)
-- ============================================

-- Job 11: DevOps Engineer at Google
(
  gen_random_uuid(),
  'ofb56b74-cfef-41a7-aaed-8a5676a82ca69', -- Google
  'DevOps Engineer',
  'DevOps & Cloud',
  'Full-Time',
  'Surabaya, Indonesia',
  3200,
  5000,
  'Google is looking for a DevOps Engineer to manage cloud infrastructure, automate deployments, and ensure system reliability. You will work with cutting-edge technologies and tools.',
  ARRAY[
    'Bachelor''s degree in Computer Science or related field.',
    '4+ years of DevOps experience.',
    'Strong knowledge of AWS, GCP, or Azure.',
    'Experience with Docker, Kubernetes, and Terraform.',
    'Proficiency in CI/CD pipelines and automation.'
  ],
  CURRENT_DATE - INTERVAL '14 days',
  '2025-11-20',
  '2025-11-05',
  ARRAY['DevOps', 'GCP', 'Kubernetes'],
  2,
  '4+ years',
  'Senior Level'
),

-- Job 12: Cloud Architect at Amazon
(
  gen_random_uuid(),
  '8970f715-6edc-46c0-ba15-85881abe1ccc2', -- Amazon
  'Cloud Architect',
  'DevOps & Cloud',
  'Full-Time',
  'Jakarta, Indonesia',
  4000,
  6000,
  'Amazon is seeking an experienced Cloud Architect to design and implement scalable cloud solutions for our global infrastructure. You will lead architectural decisions and mentor engineering teams.',
  ARRAY[
    'Bachelor''s or Master''s degree in Computer Science.',
    '7+ years of cloud architecture experience.',
    'Expert knowledge of AWS services and best practices.',
    'Experience with multi-region deployments and disaster recovery.',
    'Strong leadership and communication skills.'
  ],
  CURRENT_DATE - INTERVAL '22 days',
  '2025-10-28',
  '2025-10-15',
  ARRAY['AWS', 'Cloud Architecture', 'Leadership'],
  1,
  '7+ years',
  'Principal/Staff Level'
);

-- ============================================
-- VERIFICATION QUERY
-- ============================================
-- Run this query after inserting to verify all jobs were added:
-- SELECT 
--   j.title, 
--   c.name as company_name, 
--   j.category, 
--   j.type, 
--   j.location,
--   j.min_salary || '-' || j.max_salary as salary_range
-- FROM jobs j
-- JOIN companies c ON j.company_id = c.id
-- ORDER BY j.posted_date DESC;
