import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';

class PortfolioService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _currentUserId {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.id;
  }

  // Get all portfolio projects for current user
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

  // Get single portfolio project by ID
  Future<Map<String, dynamic>?> getPortfolioById(String portfolioId) async {
    try {
      final response =
          await _supabase
              .from('portfolio_projects')
              .select('*')
              .eq('id', portfolioId)
              .single();

      return response;
    } catch (e) {
      throw Exception('Failed to load portfolio details: $e');
    }
  }

  // Add new portfolio project
  Future<void> addPortfolio({
    required String title,
    required String description,
    String? projectUrl,
    String? imageUrl,
    required DateTime startDate,
    DateTime? endDate,
    bool isOngoing = false,
    List<String>? technologies,
  }) async {
    try {
      await _supabase.from('portfolio_projects').insert({
        'user_id': _currentUserId,
        'title': title,
        'description': description,
        'project_url': projectUrl,
        'image_url': imageUrl,
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate?.toIso8601String().split('T')[0],
        'is_ongoing': isOngoing,
        'technologies': technologies,
      });
    } catch (e) {
      throw Exception('Failed to add portfolio: $e');
    }
  }

  // Update portfolio project
  Future<void> updatePortfolio({
    required String portfolioId,
    String? title,
    String? description,
    String? projectUrl,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    bool? isOngoing,
    List<String>? technologies,
  }) async {
    try {
      // Get current portfolio first
      final current = await getPortfolioById(portfolioId);
      if (current == null) {
        throw Exception('Portfolio project not found');
      }

      // Build update map with only changed fields
      final Map<String, dynamic> updates = {};

      if (title != null && title != current['title']) {
        updates['title'] = title;
      }
      if (description != null && description != current['description']) {
        updates['description'] = description;
      }
      if (projectUrl != null && projectUrl != current['project_url']) {
        updates['project_url'] = projectUrl;
      }
      if (imageUrl != null && imageUrl != current['image_url']) {
        updates['image_url'] = imageUrl;
      }
      if (startDate != null &&
          startDate.toIso8601String().split('T')[0] != current['start_date']) {
        updates['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null &&
          endDate.toIso8601String().split('T')[0] != current['end_date']) {
        updates['end_date'] = endDate.toIso8601String().split('T')[0];
      }
      if (isOngoing != null && isOngoing != current['is_ongoing']) {
        updates['is_ongoing'] = isOngoing;
      }
      if (technologies != null) {
        updates['technologies'] = technologies;
      }

      // Only update if there are changes
      if (updates.isEmpty) {
        return;
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabase
          .from('portfolio_projects')
          .update(updates)
          .eq('id', portfolioId)
          .eq('user_id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to update portfolio: $e');
    }
  }

  // Delete portfolio project
  Future<void> deletePortfolio(String portfolioId) async {
    try {
      // Get portfolio to check for image
      final portfolio = await getPortfolioById(portfolioId);
      if (portfolio != null && portfolio['image_url'] != null) {
        // Delete image from storage
        final imageUrl = portfolio['image_url'] as String;
        final fileName = imageUrl.split('/').last;
        await _supabase.storage.from('portfolio-images').remove([
          'portfolio-images/$fileName',
        ]);
      }

      // Delete portfolio record
      await _supabase
          .from('portfolio_projects')
          .delete()
          .eq('id', portfolioId)
          .eq('user_id', _currentUserId);
    } catch (e) {
      throw Exception('Failed to delete portfolio: $e');
    }
  }

  // Upload portfolio image
  Future<String> uploadPortfolioImage(File file) async {
    try {
      final fileName =
          '${_currentUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'portfolio-images/$fileName';

      // Upload to Supabase Storage
      await _supabase.storage
          .from('portfolio-images')
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      // Get public URL
      final publicUrl = _supabase.storage
          .from('portfolio-images')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload portfolio image: $e');
    }
  }

  // Pick and upload portfolio image
  Future<String?> pickAndUploadImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        return await uploadPortfolioImage(file);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to pick and upload image: $e');
    }
  }

  // Delete portfolio image from storage
  Future<void> deletePortfolioImage(String imageUrl) async {
    try {
      final fileName = imageUrl.split('/').last;
      await _supabase.storage.from('portfolio-images').remove([
        'portfolio-images/$fileName',
      ]);
    } catch (e) {
      throw Exception('Failed to delete portfolio image: $e');
    }
  }
}
