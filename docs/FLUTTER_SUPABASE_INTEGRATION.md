# Supabase Integration Guide untuk JobHub Flutter App

## 📋 Daftar Isi
1. [Installation](#installation)
2. [Setup](#setup)
3. [Authentication](#authentication)
4. [Database Operations](#database-operations)
5. [File Upload](#file-upload)
6. [Service Classes](#service-classes)
7. [Error Handling](#error-handling)

---

## Installation

### Step 1: Tambah Dependency
```bash
flutter pub add supabase
flutter pub add supabase_flutter
```

### Step 2: Update pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.5.0
```

---

## Setup

### Update main.dart

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Ganti dengan URL Supabase project
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Ganti dengan anon key
  );
  
  runApp(const MyApp());
}

// Global Supabase client
final supabase = Supabase.instance.client;
```

### Dapatkan Credentials
1. Masuk ke https://supabase.com
2. Pilih project JobHub
3. Pergi ke **Settings** → **API**
4. Copy `Project URL` dan `anon public key`
5. Simpan di file config atau environment variable

---

## Authentication

### 1. Signup

```dart
class AuthService {
  final supabase = Supabase.instance.client;

  Future<void> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Sign up dengan auth
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Create user profile
        await supabase.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
        });

        print('Signup successful!');
      }
    } on AuthException catch (e) {
      print('Auth error: ${e.message}');
      rethrow;
    }
  }
}
```

### 2. Login

```dart
Future<void> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session != null) {
      print('Login successful!');
      // Navigate to home
    }
  } on AuthException catch (e) {
    print('Login error: ${e.message}');
    rethrow;
  }
}
```

### 3. Logout

```dart
Future<void> logout() async {
  try {
    await supabase.auth.signOut();
    print('Logout successful!');
    // Navigate to login
  } on AuthException catch (e) {
    print('Logout error: ${e.message}');
    rethrow;
  }
}
```

### 4. Check Authentication Status

```dart
Future<void> checkAuthStatus() async {
  final session = supabase.auth.currentSession;
  
  if (session != null) {
    print('User logged in: ${session.user.email}');
    // Navigate to home
  } else {
    print('User not logged in');
    // Navigate to login
  }
}
```

### 5. Listen untuk Auth Changes

```dart
void setupAuthListener() {
  supabase.auth.onAuthStateChange.listen((data) {
    final event = data.event;
    final session = data.session;

    switch (event) {
      case AuthChangeEvent.signedIn:
        print('User signed in');
        // Navigate to home
        break;
      case AuthChangeEvent.signedOut:
        print('User signed out');
        // Navigate to login
        break;
      case AuthChangeEvent.userUpdated:
        print('User updated');
        break;
      default:
        break;
    }
  });
}
```

---

## Database Operations

### 1. Profile Operations

#### Get User Profile

```dart
class ProfileService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      
      final response = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      return response;
    } catch (e) {
      print('Error getting profile: $e');
      rethrow;
    }
  }
}
```

#### Update User Profile

```dart
Future<void> updateProfile({
  required String fullName,
  required String phoneNumber,
  required String address,
  String? birthDate,
  String? gender,
}) async {
  try {
    final userId = supabase.auth.currentUser!.id;
    
    await supabase
        .from('users')
        .update({
          'full_name': fullName,
          'phone_number': phoneNumber,
          'address': address,
          'birth_date': birthDate,
          'gender': gender,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
    
    print('Profile updated');
  } catch (e) {
    print('Error updating profile: $e');
    rethrow;
  }
}
```

### 2. Education Operations

#### Add Education

```dart
class EducationService {
  final supabase = Supabase.instance.client;

  Future<void> addEducation({
    required String educationLevel,
    required String institution,
    required String? major,
    required int startYear,
    required int? endYear,
    required bool isCurrentlyStudying,
    required double? gpa,
  }) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      
      await supabase.from('education').insert({
        'user_id': userId,
        'education_level': educationLevel,
        'institution': institution,
        'major': major,
        'start_year': startYear,
        'end_year': endYear,
        'is_currently_studying': isCurrentlyStudying,
        'gpa': gpa,
      });
      
      print('Education added');
    } catch (e) {
      print('Error adding education: $e');
      rethrow;
    }
  }
}
```

#### Get User Education

```dart
Future<List<Map<String, dynamic>>> getUserEducation() async {
  try {
    final userId = supabase.auth.currentUser!.id;
    
    final response = await supabase
        .from('education')
        .select()
        .eq('user_id', userId)
        .order('start_year', ascending: false);
    
    return response;
  } catch (e) {
    print('Error getting education: $e');
    rethrow;
  }
}
```

#### Update Education

```dart
Future<void> updateEducation({
  required String educationId,
  required String? institution,
  required String? major,
  required int? startYear,
  required int? endYear,
  required bool? isCurrentlyStudying,
  required double? gpa,
}) async {
  try {
    await supabase
        .from('education')
        .update({
          if (institution != null) 'institution': institution,
          if (major != null) 'major': major,
          if (startYear != null) 'start_year': startYear,
          if (endYear != null) 'end_year': endYear,
          if (isCurrentlyStudying != null) 'is_currently_studying': isCurrentlyStudying,
          if (gpa != null) 'gpa': gpa,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', educationId);
    
    print('Education updated');
  } catch (e) {
    print('Error updating education: $e');
    rethrow;
  }
}
```

#### Delete Education

```dart
Future<void> deleteEducation(String educationId) async {
  try {
    await supabase
        .from('education')
        .delete()
        .eq('id', educationId);
    
    print('Education deleted');
  } catch (e) {
    print('Error deleting education: $e');
    rethrow;
  }
}
```

### 3. Skills Operations

#### Add Skill ke User

```dart
class SkillService {
  final supabase = Supabase.instance.client;

  Future<void> addSkill({
    required String skillName,
    String? proficiencyLevel,
    String? portfolioProjectId,
  }) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      
      // Get skill by name
      final skill = await supabase
          .from('skills')
          .select()
          .eq('name', skillName)
          .single();
      
      // Add user skill
      await supabase.from('user_skills').insert({
        'user_id': userId,
        'skill_id': skill['id'],
        'proficiency_level': proficiencyLevel,
        'portfolio_project_id': portfolioProjectId,
      });
      
      print('Skill added');
    } catch (e) {
      print('Error adding skill: $e');
      rethrow;
    }
  }
}
```

#### Get User Skills

```dart
Future<List<Map<String, dynamic>>> getUserSkills() async {
  try {
    final userId = supabase.auth.currentUser!.id;
    
    final response = await supabase
        .from('user_skills')
        .select('*, skill:skills(name, category)')
        .eq('user_id', userId);
    
    return response;
  } catch (e) {
    print('Error getting skills: $e');
    rethrow;
  }
}
```

### 4. Portfolio Operations

#### Add Portfolio Project

```dart
class PortfolioService {
  final supabase = Supabase.instance.client;

  Future<String> addPortfolioProject({
    required String projectName,
    required String? description,
    required String? projectLink,
    required List<String> skills,
  }) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      
      // Insert portfolio project
      final response = await supabase
          .from('portfolio_projects')
          .insert({
            'user_id': userId,
            'project_name': projectName,
            'description': description,
            'project_link': projectLink,
          })
          .select();
      
      final projectId = response[0]['id'];
      
      // Add skills untuk project ini
      for (String skillName in skills) {
        final skill = await supabase
            .from('skills')
            .select()
            .eq('name', skillName)
            .single();
        
        await supabase.from('user_skills').insert({
          'user_id': userId,
          'skill_id': skill['id'],
          'portfolio_project_id': projectId,
        });
      }
      
      print('Portfolio added');
      return projectId;
    } catch (e) {
      print('Error adding portfolio: $e');
      rethrow;
    }
  }
}
```

### 5. Job Operations

#### Get All Active Jobs

```dart
class JobService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getActiveJobs({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await supabase
          .from('jobs')
          .select('''
            *,
            company:companies(name, logo_url, location),
            job_requirements(*),
            job_tags(tag)
          ''')
          .eq('is_active', true)
          .order('posted_date', ascending: false)
          .range(offset, offset + limit - 1);
      
      return response;
    } catch (e) {
      print('Error getting jobs: $e');
      rethrow;
    }
  }
}
```

#### Search Jobs

```dart
Future<List<Map<String, dynamic>>> searchJobs({
  required String query,
  String? category,
  String? location,
}) async {
  try {
    var queryBuilder = supabase
        .from('jobs')
        .select('''
          *,
          company:companies(name, logo_url, location),
          job_requirements(*),
          job_tags(tag)
        ''')
        .eq('is_active', true);
    
    // Filter by category
    if (category != null) {
      queryBuilder = queryBuilder.eq('category', category);
    }
    
    // Filter by location
    if (location != null) {
      queryBuilder = queryBuilder.ilike('location', '%$location%');
    }
    
    // Search in title dan description
    final response = await queryBuilder
        .or('title.ilike.%$query%, description.ilike.%$query%')
        .order('posted_date', ascending: false);
    
    return response;
  } catch (e) {
    print('Error searching jobs: $e');
    rethrow;
  }
}
```

### 6. Application Operations

#### Apply untuk Job

```dart
class ApplicationService {
  final supabase = Supabase.instance.client;

  Future<void> applyJob(String jobId) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      
      await supabase.from('job_applications').insert({
        'user_id': userId,
        'job_id': jobId,
        'status': 'applied',
      });
      
      print('Job application submitted');
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Unique constraint error - user sudah apply
        throw Exception('Anda sudah melamar pekerjaan ini');
      }
      rethrow;
    }
  }
}
```

#### Get Application History

```dart
Future<List<Map<String, dynamic>>> getApplicationHistory() async {
  try {
    final userId = supabase.auth.currentUser!.id;
    
    final response = await supabase
        .from('job_applications')
        .select('''
          *,
          job:jobs(
            title,
            company:companies(name, logo_url),
            location
          )
        ''')
        .eq('user_id', userId)
        .order('applied_date', ascending: false);
    
    return response;
  } catch (e) {
    print('Error getting application history: $e');
    rethrow;
  }
}
```

### 7. Favorite Operations

#### Add Favorite Job

```dart
class FavoriteService {
  final supabase = Supabase.instance.client;

  Future<void> addFavorite(String jobId) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      
      await supabase.from('favorite_jobs').insert({
        'user_id': userId,
        'job_id': jobId,
      });
      
      print('Job added to favorites');
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }
}
```

#### Get Favorite Jobs

```dart
Future<List<Map<String, dynamic>>> getFavoriteJobs() async {
  try {
    final userId = supabase.auth.currentUser!.id;
    
    final response = await supabase
        .from('favorite_jobs')
        .select('''
          *,
          job:jobs(
            *,
            company:companies(name, logo_url),
            job_tags(tag)
          )
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return response;
  } catch (e) {
    print('Error getting favorites: $e');
    rethrow;
  }
}
```

#### Remove Favorite

```dart
Future<void> removeFavorite(String jobId) async {
  try {
    final userId = supabase.auth.currentUser!.id;
    
    await supabase
        .from('favorite_jobs')
        .delete()
        .eq('user_id', userId)
        .eq('job_id', jobId);
    
    print('Job removed from favorites');
  } catch (e) {
    print('Error removing favorite: $e');
    rethrow;
  }
}
```

---

## File Upload

### Upload Profile Picture

```dart
class StorageService {
  final supabase = Supabase.instance.client;

  Future<String> uploadProfilePicture({
    required File file,
    required String userId,
  }) async {
    try {
      final fileName = '$userId/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Upload file ke storage
      await supabase.storage
          .from('user-profiles')
          .upload(fileName, file);
      
      // Get public URL
      final publicUrl = supabase.storage
          .from('user-profiles')
          .getPublicUrl(fileName);
      
      // Update user profile dengan URL
      await supabase
          .from('users')
          .update({'profile_picture_url': publicUrl})
          .eq('id', userId);
      
      return publicUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      rethrow;
    }
  }
}
```

### Upload CV

```dart
Future<String> uploadCV({
  required File file,
  required String userId,
}) async {
  try {
    final fileName = '$userId/cv_${DateTime.now().millisecondsSinceEpoch}.pdf';
    
    await supabase.storage
        .from('cv-files')
        .upload(fileName, file);
    
    final publicUrl = supabase.storage
        .from('cv-files')
        .getPublicUrl(fileName);
    
    // Update user CV URL
    await supabase
        .from('users')
        .update({'cv_file_url': publicUrl})
        .eq('id', userId);
    
    return publicUrl;
  } catch (e) {
    print('Error uploading CV: $e');
    rethrow;
  }
}
```

### Upload Portfolio Image

```dart
Future<String> uploadPortfolioImage({
  required File file,
  required String userId,
  required String portfolioId,
}) async {
  try {
    final fileName = '$userId/$portfolioId/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    await supabase.storage
        .from('portfolio-images')
        .upload(fileName, file);
    
    final publicUrl = supabase.storage
        .from('portfolio-images')
        .getPublicUrl(fileName);
    
    // Update portfolio image URL
    await supabase
        .from('portfolio_projects')
        .update({'image_url': publicUrl})
        .eq('id', portfolioId);
    
    return publicUrl;
  } catch (e) {
    print('Error uploading portfolio image: $e');
    rethrow;
  }
}
```

---

## Service Classes

### Complete Auth Service

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final supabase = Supabase.instance.client;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Check if user is logged in
  bool get isLoggedIn => supabase.auth.currentSession != null;

  // Get current user
  User? get currentUser => supabase.auth.currentUser;

  // Get current user ID
  String? get currentUserId => supabase.auth.currentUser?.id;

  // Sign up
  Future<void> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
        });
      }
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Sign in
  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Sign out
  Future<void> signout() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Listen to auth changes
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
```

---

## Error Handling

### General Error Handling

```dart
class SupabaseException implements Exception {
  final String message;
  final String? code;

  SupabaseException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

// Helper function untuk handle errors
void handleSupabaseError(dynamic error) {
  if (error is PostgrestException) {
    // Database error
    print('Database error: ${error.message}');
    if (error.code == '23505') {
      // Unique constraint
      throw SupabaseException(
        message: 'Data sudah ada dalam sistem',
        code: error.code,
      );
    }
  } else if (error is AuthException) {
    // Auth error
    print('Auth error: ${error.message}');
    throw SupabaseException(
      message: error.message,
      code: error.code,
    );
  } else {
    // Unknown error
    throw SupabaseException(message: error.toString());
  }
}
```

### Try-Catch Example

```dart
Future<void> safeOperation() async {
  try {
    // Do something
  } catch (e) {
    if (e is PostgrestException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database error: ${e.message}')),
      );
    } else if (e is AuthException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auth error: ${e.message}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unknown error: $e')),
      );
    }
  }
}
```

---

## Tips & Best Practices

1. **Use Singleton Pattern**: AuthService dan service lainnya gunakan singleton
2. **Error Handling**: Selalu handle PostgrestException dan AuthException
3. **Caching**: Cache data yang jarang berubah untuk improve performance
4. **Rate Limiting**: Implement rate limiting untuk prevent abuse
5. **Validation**: Validate data sebelum send ke database
6. **RLS**: Ensure RLS policies sudah correctly configured
7. **Transactions**: Gunakan transactions untuk multi-step operations
8. **Pagination**: Implement pagination untuk list yang besar
9. **Real-time**: Use realtime subscriptions untuk data yang frequently updated
10. **Security**: Jangan expose `service_role` key di client app

---

## Next Steps

1. ✅ Install Supabase package
2. ✅ Setup Supabase project
3. ✅ Create service classes
4. ⏳ Integrate auth flow
5. ⏳ Create data models/entities
6. ⏳ Implement state management (Provider/Riverpod/Bloc)
7. ⏳ Connect UI pages dengan service
8. ⏳ Test all operations
9. ⏳ Setup error handling
10. ⏳ Deploy to production
