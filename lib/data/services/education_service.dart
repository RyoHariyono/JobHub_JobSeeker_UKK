import 'package:supabase_flutter/supabase_flutter.dart';

class EducationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _currentUserId {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.id;
  }

  // Get all education records for current user
  Future<List<Map<String, dynamic>>> getEducation() async {
    try {
      final response = await _supabase
          .from('education')
          .select('*')
          .eq('user_id', _currentUserId)
          .order('end_date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load education: $e');
    }
  }

  // Get single education record by ID
  Future<Map<String, dynamic>?> getEducationById(String educationId) async {
    try {
      final response =
          await _supabase
              .from('education')
              .select('*')
              .eq('id', educationId)
              .single();

      return response;
    } catch (e) {
      throw Exception('Failed to load education details: $e');
    }
  }

  // Add new education record
  Future<void> addEducation({
    required String institution,
    required String degree,
    required String fieldOfStudy,
    required DateTime startDate,
    DateTime? endDate,
    bool isCurrentlyStudying = false,
    String? description,
    double? gpa,
  }) async {
    try {
      await _supabase.from('education').insert({
        'user_id': _currentUserId,
        'institution': institution,
        'degree': degree,
        'field_of_study': fieldOfStudy,
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate?.toIso8601String().split('T')[0],
        'is_currently_studying': isCurrentlyStudying,
        'description': description,
        'gpa': gpa,
      });
    } catch (e) {
      throw Exception('Failed to add education: $e');
    }
  }

  // Update education record
  Future<void> updateEducation({
    required String educationId,
    String? institution,
    String? degree,
    String? fieldOfStudy,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentlyStudying,
    String? description,
    double? gpa,
  }) async {
    try {
      // Get current education first
      final current = await getEducationById(educationId);
      if (current == null) {
        throw Exception('Education record not found');
      }

      // Build update map with only changed fields
      final Map<String, dynamic> updates = {};

      if (institution != null && institution != current['institution']) {
        updates['institution'] = institution;
      }
      if (degree != null && degree != current['degree']) {
        updates['degree'] = degree;
      }
      if (fieldOfStudy != null && fieldOfStudy != current['field_of_study']) {
        updates['field_of_study'] = fieldOfStudy;
      }
      if (startDate != null &&
          startDate.toIso8601String().split('T')[0] != current['start_date']) {
        updates['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null &&
          endDate.toIso8601String().split('T')[0] != current['end_date']) {
        updates['end_date'] = endDate.toIso8601String().split('T')[0];
      }
      if (isCurrentlyStudying != null &&
          isCurrentlyStudying != current['is_currently_studying']) {
        updates['is_currently_studying'] = isCurrentlyStudying;
      }
      if (description != null && description != current['description']) {
        updates['description'] = description;
      }
      if (gpa != null && gpa != current['gpa']) {
        updates['gpa'] = gpa;
      }

      // Only update if there are changes
      if (updates.isEmpty) {
        return;
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabase
          .from('education')
          .update(updates)
          .eq('id', educationId)
          .eq('user_id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to update education: $e');
    }
  }

  // Delete education record
  Future<void> deleteEducation(String educationId) async {
    try {
      await _supabase
          .from('education')
          .delete()
          .eq('id', educationId)
          .eq('user_id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to delete education: $e');
    }
  }
}
