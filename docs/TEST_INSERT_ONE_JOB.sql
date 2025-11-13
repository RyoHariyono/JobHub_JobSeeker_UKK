-- ============================================
-- TEST INSERT 1 JOB DULU (CEK UUID)
-- ============================================

-- Test Job: Senior UI/UX Designer at Apple
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
    'We are looking for a highly skilled Senior UI/UX Designer to join Apple.',
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
    (job_id, 'Bachelor''s degree in Design, Computer Science, or related field.', true);

  INSERT INTO job_tags (job_id, tag) VALUES
    (job_id, 'Design'),
    (job_id, 'Figma');

  RAISE NOTICE 'SUCCESS! Job inserted with ID: %', job_id;
END $$;

-- Verifikasi
SELECT j.title, c.name as company_name 
FROM jobs j 
JOIN companies c ON j.company_id = c.id 
ORDER BY j.created_at DESC LIMIT 1;
