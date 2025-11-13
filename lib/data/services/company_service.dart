import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all companies
  Future<List<Map<String, dynamic>>> getCompanies() async {
    try {
      final response = await _supabase
          .from('companies')
          .select('*')
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load companies: $e');
    }
  }

  // Get company by ID
  Future<Map<String, dynamic>?> getCompanyById(String companyId) async {
    try {
      final response =
          await _supabase
              .from('companies')
              .select('*')
              .eq('id', companyId)
              .single();

      return response;
    } catch (e) {
      throw Exception('Failed to load company: $e');
    }
  }

  // Get company with jobs count
  Future<Map<String, dynamic>?> getCompanyWithJobsCount(
    String companyId,
  ) async {
    try {
      final company = await getCompanyById(companyId);
      if (company == null) return null;

      final jobsCount =
          await _supabase
              .from('jobs')
              .select('id')
              .eq('company_id', companyId)
              .eq('is_active', true)
              .count();

      return {...company, 'jobs_count': jobsCount.count};
    } catch (e) {
      throw Exception('Failed to load company details: $e');
    }
  }

  // Search companies
  Future<List<Map<String, dynamic>>> searchCompanies(String query) async {
    try {
      final response = await _supabase
          .from('companies')
          .select('*')
          .ilike('name', '%$query%')
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to search companies: $e');
    }
  }
}
