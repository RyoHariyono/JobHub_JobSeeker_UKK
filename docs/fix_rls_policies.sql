-- ========================================
-- FIX RLS POLICIES FOR SIGNUP
-- ========================================
-- Run this in Supabase SQL Editor to fix signup issues

-- 1. Drop existing policies for users table
DROP POLICY IF EXISTS "Users can read own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Users can insert own profile" ON users;

-- 2. Create new policies that allow signup
-- Policy untuk INSERT (saat signup)
CREATE POLICY "Enable insert for authenticated users"
ON users
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- Policy untuk SELECT (read own profile)
CREATE POLICY "Users can read own profile"
ON users
FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- Policy untuk UPDATE (update own profile)
CREATE POLICY "Users can update own profile"
ON users
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- 3. OPTIONAL: Allow public insert untuk signup tanpa auth (NOT RECOMMENDED for production)
-- Uncomment line di bawah HANYA untuk development/testing
-- CREATE POLICY "Allow public insert during signup"
-- ON users
-- FOR INSERT
-- TO public
-- WITH CHECK (true);

-- 4. Verify RLS is enabled
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 5. Check existing policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
WHERE tablename = 'users';
