import 'package:supabase_flutter/supabase_flutter.dart';

enum JobCategory {
  technology,
  design,
  marketing,
  business,
  finance,
  education,
  healthcare,
  other,
}

enum JobType { fulltime, parttime, contract, internship, freelance }

class JobService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _currentUserId {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.id;
  }

  // Get all jobs with optional filters
  Future<List<Map<String, dynamic>>> getJobs({
    JobCategory? category,
    String? searchQuery,
    JobType? jobType,
    String? location,
    bool activeOnly = true,
  }) async {
    try {
      var query = _supabase.from('jobs').select('''
            *,
            companies (
              id,
              name,
              logo_url,
              location,
              industry,
              company_size
            )
          ''');

      if (activeOnly) {
        query = query.eq('is_active', true);
      }

      if (category != null) {
        query = query.eq('category', _categoryToString(category));
      }

      if (jobType != null) {
        query = query.eq('job_type', _typeToString(jobType));
      }

      if (location != null && location.isNotEmpty) {
        query = query.ilike('location', '%$location%');
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or(
          'title.ilike.%$searchQuery%,description.ilike.%$searchQuery%',
        );
      }

      final response = await query.order('created_at', ascending: false);

      return _parseJobs(response);
    } catch (e) {
      throw Exception('Failed to load jobs: $e');
    }
  }

  // Get job by ID with full details
  Future<Map<String, dynamic>?> getJobById(String jobId) async {
    try {
      final response =
          await _supabase
              .from('jobs')
              .select('''
            *,
            companies (
              id,
              name,
              logo_url,
              location,
              industry,
              company_size,
              description,
              website,
              email
            )
          ''')
              .eq('id', jobId)
              .single();

      // Get requirements
      final requirements = await _supabase
          .from('job_requirements')
          .select('*')
          .eq('job_id', jobId)
          .order('requirement_order', ascending: true);

      // Get tags
      final tags = await _supabase
          .from('job_tags')
          .select('*')
          .eq('job_id', jobId)
          .order('tag_order', ascending: true);

      return {...response, 'requirements': requirements, 'tags': tags};
    } catch (e) {
      throw Exception('Failed to load job details: $e');
    }
  }

  // Apply for a job
  Future<void> applyForJob(String jobId, {String? coverLetter}) async {
    try {
      await _supabase.from('job_applications').insert({
        'job_id': jobId,
        'user_id': _currentUserId,
        'cover_letter': coverLetter,
        'status': 'pending',
        'applied_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to apply for job: $e');
    }
  }

  // Check if user has applied for a job
  Future<bool> hasApplied(String jobId) async {
    try {
      final response =
          await _supabase
              .from('job_applications')
              .select('id')
              .eq('job_id', jobId)
              .eq('user_id', _currentUserId)
              .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Get user's job applications
  Future<List<Map<String, dynamic>>> getUserApplications() async {
    try {
      final response = await _supabase
          .from('job_applications')
          .select('''
            *,
            jobs (
              id,
              title,
              location,
              job_type,
              salary_min,
              salary_max,
              companies (
                id,
                name,
                logo_url
              )
            )
          ''')
          .eq('user_id', _currentUserId)
          .order('applied_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load applications: $e');
    }
  }

  // Get application by ID
  Future<Map<String, dynamic>?> getApplicationById(String applicationId) async {
    try {
      final response =
          await _supabase
              .from('job_applications')
              .select('''
            *,
            jobs (
              id,
              title,
              description,
              location,
              job_type,
              salary_min,
              salary_max,
              companies (
                id,
                name,
                logo_url,
                location,
                email
              )
            )
          ''')
              .eq('id', applicationId)
              .single();

      return response;
    } catch (e) {
      throw Exception('Failed to load application: $e');
    }
  }

  // Withdraw application
  Future<void> withdrawApplication(String applicationId) async {
    try {
      await _supabase
          .from('job_applications')
          .update({'status': 'withdrawn'})
          .eq('id', applicationId);
    } catch (e) {
      throw Exception('Failed to withdraw application: $e');
    }
  }

  // Add job to favorites
  Future<void> addToFavorites(String jobId) async {
    try {
      await _supabase.from('favorite_jobs').insert({
        'user_id': _currentUserId,
        'job_id': jobId,
      });
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  // Remove job from favorites
  Future<void> removeFromFavorites(String jobId) async {
    try {
      await _supabase
          .from('favorite_jobs')
          .delete()
          .eq('user_id', _currentUserId)
          .eq('job_id', jobId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  // Check if job is favorited
  Future<bool> isFavorited(String jobId) async {
    try {
      final response =
          await _supabase
              .from('favorite_jobs')
              .select('id')
              .eq('user_id', _currentUserId)
              .eq('job_id', jobId)
              .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Get user's favorite jobs
  Future<List<Map<String, dynamic>>> getFavoriteJobs() async {
    try {
      final response = await _supabase
          .from('favorite_jobs')
          .select('''
            *,
            jobs (
              id,
              title,
              location,
              job_type,
              salary_min,
              salary_max,
              is_active,
              companies (
                id,
                name,
                logo_url
              )
            )
          ''')
          .eq('user_id', _currentUserId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load favorite jobs: $e');
    }
  }

  // Helper methods
  List<Map<String, dynamic>> _parseJobs(dynamic response) {
    final jobs = List<Map<String, dynamic>>.from(response);
    return jobs.map((job) {
      return {
        ...job,
        'category_enum': _stringToCategory(job['category']),
        'job_type_enum': _stringToType(job['job_type']),
      };
    }).toList();
  }

  String _categoryToString(JobCategory category) {
    return category.toString().split('.').last;
  }

  JobCategory _stringToCategory(String? category) {
    if (category == null) return JobCategory.other;
    try {
      return JobCategory.values.firstWhere(
        (e) => e.toString().split('.').last == category.toLowerCase(),
        orElse: () => JobCategory.other,
      );
    } catch (e) {
      return JobCategory.other;
    }
  }

  String _typeToString(JobType type) {
    return type.toString().split('.').last;
  }

  JobType _stringToType(String? type) {
    if (type == null) return JobType.fulltime;
    try {
      return JobType.values.firstWhere(
        (e) => e.toString().split('.').last == type.toLowerCase(),
        orElse: () => JobType.fulltime,
      );
    } catch (e) {
      return JobType.fulltime;
    }
  }
}
