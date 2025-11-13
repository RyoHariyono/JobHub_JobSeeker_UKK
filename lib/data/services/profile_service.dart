import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _currentUserId {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.id;
  }

  // Get current user profile
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response =
          await _supabase
              .from('users')
              .select('*')
              .eq('id', _currentUserId)
              .single();

      return response;
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  // Update profile - only update changed fields
  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? address,
    DateTime? birthDate,
    String? gender,
    String? bio,
  }) async {
    try {
      // Get current profile first
      final currentProfile = await getProfile();
      if (currentProfile == null) {
        throw Exception('Profile not found');
      }

      // Build update map with only changed fields
      final Map<String, dynamic> updates = {};

      if (fullName != null && fullName != currentProfile['full_name']) {
        updates['full_name'] = fullName;
      }
      if (phone != null && phone != currentProfile['phone']) {
        updates['phone'] = phone;
      }
      if (address != null && address != currentProfile['address']) {
        updates['address'] = address;
      }
      if (birthDate != null &&
          birthDate.toIso8601String().split('T')[0] !=
              currentProfile['birth_date']) {
        updates['birth_date'] = birthDate.toIso8601String().split('T')[0];
      }
      if (gender != null && gender != currentProfile['gender']) {
        updates['gender'] = gender;
      }
      if (bio != null && bio != currentProfile['bio']) {
        updates['bio'] = bio;
      }

      // Only update if there are changes
      if (updates.isEmpty) {
        return; // No changes to update
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabase.from('users').update(updates).eq('id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Upload or update CV
  Future<String> uploadCV(File file) async {
    try {
      final fileName =
          '${_currentUserId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = 'cv-files/$fileName';

      // Upload to Supabase Storage
      await _supabase.storage
          .from('cv-files')
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      // Get public URL
      final publicUrl = _supabase.storage
          .from('cv-files')
          .getPublicUrl(filePath);

      // Update user profile with CV URL
      await _supabase
          .from('users')
          .update({
            'cv_file_url': publicUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _currentUserId);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload CV: $e');
    }
  }

  // Pick and upload CV file
  Future<String?> pickAndUploadCV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        return await uploadCV(file);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to pick and upload CV: $e');
    }
  }

  // Delete CV
  Future<void> deleteCV() async {
    try {
      final profile = await getProfile();
      if (profile == null || profile['cv_file_url'] == null) {
        return;
      }

      final cvUrl = profile['cv_file_url'] as String;
      final fileName = cvUrl.split('/').last;

      // Delete from storage
      await _supabase.storage.from('cv-files').remove(['cv-files/$fileName']);

      // Update profile
      await _supabase
          .from('users')
          .update({
            'cv_file_url': null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to delete CV: $e');
    }
  }

  // Upload profile photo
  Future<String> uploadProfilePhoto(File file) async {
    try {
      final fileName =
          '${_currentUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'user-profiles/$fileName';

      // Upload to Supabase Storage
      await _supabase.storage
          .from('user-profiles')
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      // Get public URL
      final publicUrl = _supabase.storage
          .from('user-profiles')
          .getPublicUrl(filePath);

      // Update user profile with photo URL
      await _supabase
          .from('users')
          .update({
            'profile_photo_url': publicUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _currentUserId);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  // Get user's education
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

  // Get user's portfolio projects
  Future<List<Map<String, dynamic>>> getPortfolio() async {
    try {
      final response = await _supabase
          .from('portfolio_projects')
          .select('*')
          .eq('user_id', _currentUserId)
          .order('end_date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load portfolio: $e');
    }
  }

  // Get user's skills
  Future<List<Map<String, dynamic>>> getUserSkills() async {
    try {
      final response = await _supabase
          .from('user_skills')
          .select('''
            *,
            skills (
              id,
              name,
              category
            )
          ''')
          .eq('user_id', _currentUserId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load skills: $e');
    }
  }

  // Add skill to user
  Future<void> addSkill(String skillId, String proficiencyLevel) async {
    try {
      await _supabase.from('user_skills').insert({
        'user_id': _currentUserId,
        'skill_id': skillId,
        'proficiency_level': proficiencyLevel,
      });
    } catch (e) {
      throw Exception('Failed to add skill: $e');
    }
  }

  // Remove skill from user
  Future<void> removeSkill(String skillId) async {
    try {
      await _supabase
          .from('user_skills')
          .delete()
          .eq('user_id', _currentUserId)
          .eq('skill_id', skillId);
    } catch (e) {
      throw Exception('Failed to remove skill: $e');
    }
  }

  // Update skill proficiency
  Future<void> updateSkillProficiency(
    String skillId,
    String proficiencyLevel,
  ) async {
    try {
      await _supabase
          .from('user_skills')
          .update({'proficiency_level': proficiencyLevel})
          .eq('user_id', _currentUserId)
          .eq('skill_id', skillId);
    } catch (e) {
      throw Exception('Failed to update skill: $e');
    }
  }
}
