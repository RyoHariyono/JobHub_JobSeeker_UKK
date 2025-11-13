# JobHub Data Fetching Integration Guide

Panduan lengkap untuk mengintegrasikan semua fitur UI dengan Supabase backend menggunakan services yang sudah dibuat.

## Table of Contents
1. [Services Overview](#services-overview)
2. [Profile & CV Management](#profile--cv-management)
3. [Job Listings & Applications](#job-listings--applications)
4. [Education & Portfolio](#education--portfolio)
5. [Company Data](#company-data)
6. [Implementation Examples](#implementation-examples)

---

## Services Overview

### Available Services

1. **AuthService** - Authentication (signup, login, logout)
2. **ProfileService** - User profile, CV upload, skills
3. **JobService** - Job listings, applications, favorites
4. **CompanyService** - Company data
5. **EducationService** - Education CRUD operations
6. **PortfolioService** - Portfolio CRUD operations

---

## Profile & CV Management

### ProfileService Methods

#### 1. Get Profile
```dart
final profileService = ProfileService();

Future<void> loadProfile() async {
  try {
    final profile = await profileService.getProfile();
    setState(() {
      fullName = profile?['full_name'] ?? '';
      email = profile?['email'] ?? '';
      phone = profile?['phone'] ?? '';
      address = profile?['address'] ?? '';
      cvUrl = profile?['cv_file_url'];
    });
  } catch (e) {
    print('Error: $e');
  }
}
```

#### 2. Update Profile (Conditional Update)
```dart
// Hanya update field yang berubah
await profileService.updateProfile(
  fullName: nameController.text.isNotEmpty ? nameController.text : null,
  phone: phoneController.text.isNotEmpty ? phoneController.text : null,
  address: addressController.text.isNotEmpty ? addressController.text : null,
  birthDate: selectedBirthDate,
  gender: selectedGender,
);
```

#### 3. Upload CV
```dart
// Method 1: Pick and upload automatically
Future<void> handleCVUpload() async {
  try {
    setState(() => isUploading = true);
    
    final cvUrl = await profileService.pickAndUploadCV();
    
    if (cvUrl != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CV uploaded successfully!')),
      );
      // Reload profile
      await loadProfile();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Upload failed: $e')),
    );
  } finally {
    setState(() => isUploading = false);
  }
}

// Method 2: Upload existing file
Future<void> uploadExistingCV(File file) async {
  try {
    final cvUrl = await profileService.uploadCV(file);
    print('CV uploaded: $cvUrl');
  } catch (e) {
    print('Error: $e');
  }
}
```

#### 4. Delete CV
```dart
Future<void> handleDeleteCV() async {
  try {
    await profileService.deleteCV();
    setState(() => cvUrl = null);
  } catch (e) {
    print('Error: $e');
  }
}
```

#### 5. Check if CV Exists
```dart
Widget buildCVSection() {
  if (cvUrl != null && cvUrl!.isNotEmpty) {
    return Column(
      children: [
        Text('Current CV: ${cvUrl!.split('/').last}'),
        ElevatedButton(
          onPressed: handleDeleteCV,
          child: Text('Delete CV'),
        ),
      ],
    );
  }
  
  return ElevatedButton(
    onPressed: handleCVUpload,
    child: Text('Upload CV'),
  );
}
```

### Upload CV Page Integration

```dart
import 'package:file_picker/file_picker.dart';
import 'package:jobhub_jobseeker_ukk/data/services/profile_service.dart';

class UploadCvPage extends StatefulWidget {
  @override
  State<UploadCvPage> createState() => _UploadCvPageState();
}

class _UploadCvPageState extends State<UploadCvPage> {
  final ProfileService _profileService = ProfileService();
  
  String? _currentCvUrl;
  String? _newFileName;
  bool _isLoading = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentCV();
  }

  Future<void> _loadCurrentCV() async {
    try {
      final profile = await _profileService.getProfile();
      setState(() {
        _currentCvUrl = profile?['cv_file_url'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadCV() async {
    try {
      setState(() => _isUploading = true);
      
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final cvUrl = await _profileService.uploadCV(file);
        
        setState(() {
          _currentCvUrl = cvUrl;
          _newFileName = result.files.single.name;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CV uploaded successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Upload CV')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Upload area
            GestureDetector(
              onTap: _isUploading ? null : _pickAndUploadCV,
              child: Container(
                padding: EdgeInsets.all(60),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (_newFileName != null)
                      Text(
                        _newFileName!,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    else
                      Text(
                        'Press here to change CV',
                        style: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 40),
            
            // Current CV section
            if (_currentCvUrl != null) ...[
              Text('Your CV right now', style: TextStyle(fontSize: 14)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: AppColors.primaryBlue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _currentCvUrl!.split('/').last,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        label: 'Edit CV',
        onPressed: () => context.go('/profile'),
        isDisabled: _isUploading,
      ),
    );
  }
}
```

---

## Job Listings & Applications

### JobService Methods

#### 1. Get All Jobs with Filters
```dart
final jobService = JobService();

// Get all jobs
final jobs = await jobService.getJobs();

// Filter by category
final techJobs = await jobService.getJobs(
  category: JobCategory.technology,
);

// Search jobs
final searchResults = await jobService.getJobs(
  searchQuery: 'Flutter Developer',
);

// Multiple filters
final filteredJobs = await jobService.getJobs(
  category: JobCategory.design,
  jobType: JobType.fulltime,
  location: 'Jakarta',
);
```

#### 2. Get Job Detail
```dart
Future<void> loadJobDetail(String jobId) async {
  try {
    final job = await jobService.getJobById(jobId);
    
    setState(() {
      jobTitle = job?['title'];
      jobDescription = job?['description'];
      company = job?['companies'];
      requirements = job?['requirements']; // List
      tags = job?['tags']; // List
    });
  } catch (e) {
    print('Error: $e');
  }
}
```

#### 3. Apply for Job
```dart
Future<void> handleApply(String jobId) async {
  try {
    // Check if already applied
    final hasApplied = await jobService.hasApplied(jobId);
    
    if (hasApplied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have already applied for this job')),
      );
      return;
    }

    // Apply
    await jobService.applyForJob(
      jobId,
      coverLetter: coverLetterController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Application submitted successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Application failed: $e')),
    );
  }
}
```

#### 4. Favorites Management
```dart
// Add to favorites
Future<void> addToFavorites(String jobId) async {
  try {
    await jobService.addToFavorites(jobId);
    setState(() => isFavorited = true);
  } catch (e) {
    print('Error: $e');
  }
}

// Remove from favorites
Future<void> removeFromFavorites(String jobId) async {
  try {
    await jobService.removeFromFavorites(jobId);
    setState(() => isFavorited = false);
  } catch (e) {
    print('Error: $e');
  }
}

// Check if favorited
Future<void> checkFavoriteStatus(String jobId) async {
  final isFav = await jobService.isFavorited(jobId);
  setState(() => isFavorited = isFav);
}

// Get all favorite jobs
Future<void> loadFavorites() async {
  try {
    final favorites = await jobService.getFavoriteJobs();
    setState(() => favoriteJobs = favorites);
  } catch (e) {
    print('Error: $e');
  }
}
```

#### 5. Application History
```dart
Future<void> loadApplicationHistory() async {
  try {
    final applications = await jobService.getUserApplications();
    
    setState(() {
      allApplications = applications;
      
      // Group by status
      pendingApplications = applications
          .where((app) => app['status'] == 'pending')
          .toList();
      acceptedApplications = applications
          .where((app) => app['status'] == 'accepted')
          .toList();
      rejectedApplications = applications
          .where((app) => app['status'] == 'rejected')
          .toList();
    });
  } catch (e) {
    print('Error: $e');
  }
}
```

### Job Detail Page Example
```dart
class JobDetailPage extends StatefulWidget {
  final String jobId;
  
  const JobDetailPage({required this.jobId});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final JobService _jobService = JobService();
  
  Map<String, dynamic>? _job;
  bool _isLoading = true;
  bool _hasApplied = false;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadJobData();
  }

  Future<void> _loadJobData() async {
    try {
      final job = await _jobService.getJobById(widget.jobId);
      final hasApplied = await _jobService.hasApplied(widget.jobId);
      final isFavorited = await _jobService.isFavorited(widget.jobId);
      
      setState(() {
        _job = job;
        _hasApplied = hasApplied;
        _isFavorited = isFavorited;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load job: $e')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (_isFavorited) {
        await _jobService.removeFromFavorites(widget.jobId);
      } else {
        await _jobService.addToFavorites(widget.jobId);
      }
      setState(() => _isFavorited = !_isFavorited);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action failed: $e')),
      );
    }
  }

  Future<void> _applyForJob() async {
    if (_hasApplied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have already applied')),
      );
      return;
    }

    try {
      await _jobService.applyForJob(widget.jobId);
      setState(() => _hasApplied = true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application submitted!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final company = _job?['companies'];
    final requirements = _job?['requirements'] as List? ?? [];
    final tags = _job?['tags'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_job?['title'] ?? ''),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorited ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company info
            Row(
              children: [
                if (company?['logo_url'] != null)
                  Image.network(
                    company['logo_url'],
                    width: 60,
                    height: 60,
                  ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company?['name'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(company?['location'] ?? ''),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Job details
            Text(_job?['title'] ?? '', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text(_job?['description'] ?? ''),
            
            SizedBox(height: 20),
            
            // Requirements
            Text('Requirements', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            ...requirements.map((req) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• '),
                  Expanded(child: Text(req['requirement_text'])),
                ],
              ),
            )),
            
            SizedBox(height: 20),
            
            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) => Chip(
                label: Text(tag['tag_name']),
              )).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _hasApplied ? null : _applyForJob,
          child: Text(_hasApplied ? 'Already Applied' : 'Apply Now'),
        ),
      ),
    );
  }
}
```

---

## Education & Portfolio

### EducationService Methods

#### 1. Get All Education
```dart
final educationService = EducationService();

Future<void> loadEducation() async {
  try {
    final education = await educationService.getEducation();
    setState(() => educationList = education);
  } catch (e) {
    print('Error: $e');
  }
}
```

#### 2. Add Education
```dart
Future<void> addNewEducation() async {
  try {
    await educationService.addEducation(
      institution: institutionController.text,
      degree: degreeController.text,
      fieldOfStudy: fieldController.text,
      startDate: startDate,
      endDate: isCurrentlyStudying ? null : endDate,
      isCurrentlyStudying: isCurrentlyStudying,
      description: descriptionController.text,
      gpa: double.tryParse(gpaController.text),
    );
    
    // Reload list
    await loadEducation();
    
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add education: $e')),
    );
  }
}
```

#### 3. Update Education
```dart
Future<void> updateEducation(String educationId) async {
  try {
    await educationService.updateEducation(
      educationId: educationId,
      institution: institutionController.text,
      degree: degreeController.text,
      fieldOfStudy: fieldController.text,
      startDate: startDate,
      endDate: endDate,
      gpa: double.tryParse(gpaController.text),
    );
    
    await loadEducation();
  } catch (e) {
    print('Error: $e');
  }
}
```

#### 4. Delete Education
```dart
Future<void> deleteEducation(String educationId) async {
  try {
    await educationService.deleteEducation(educationId);
    await loadEducation();
  } catch (e) {
    print('Error: $e');
  }
}
```

### PortfolioService Methods

#### 1. Get All Portfolio
```dart
final portfolioService = PortfolioService();

Future<void> loadPortfolio() async {
  try {
    final portfolio = await portfolioService.getPortfolio();
    setState(() => portfolioList = portfolio);
  } catch (e) {
    print('Error: $e');
  }
}
```

#### 2. Add Portfolio with Image
```dart
Future<void> addNewPortfolio() async {
  try {
    // Upload image first (optional)
    String? imageUrl;
    if (selectedImage != null) {
      imageUrl = await portfolioService.uploadPortfolioImage(selectedImage!);
    }
    
    // Add portfolio
    await portfolioService.addPortfolio(
      title: titleController.text,
      description: descriptionController.text,
      projectUrl: urlController.text,
      imageUrl: imageUrl,
      startDate: startDate,
      endDate: isOngoing ? null : endDate,
      isOngoing: isOngoing,
      technologies: selectedTechnologies,
    );
    
    await loadPortfolio();
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add portfolio: $e')),
    );
  }
}
```

#### 3. Pick and Upload Image
```dart
Future<void> pickImage() async {
  try {
    final imageUrl = await portfolioService.pickAndUploadImage();
    if (imageUrl != null) {
      setState(() => uploadedImageUrl = imageUrl);
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## Company Data

### CompanyService Methods

```dart
final companyService = CompanyService();

// Get all companies
final companies = await companyService.getCompanies();

// Get company by ID
final company = await companyService.getCompanyById(companyId);

// Get company with jobs count
final companyDetail = await companyService.getCompanyWithJobsCount(companyId);
print('Active jobs: ${companyDetail?['jobs_count']}');

// Search companies
final results = await companyService.searchCompanies('Tech');
```

---

## Implementation Checklist

### ✅ Completed
- [x] AuthService (login, signup, logout)
- [x] ProfileService with conditional update
- [x] JobService with filters and applications
- [x] EducationService with CRUD
- [x] PortfolioService with image upload
- [x] CompanyService
- [x] Profile Edit Page integration
- [x] Conditional update (only changed fields)

### 🔄 Next Steps

1. **Job Listings Page**
   - Integrate JobService.getJobs()
   - Add search and filter UI
   - Implement pagination

2. **Job Detail Page**
   - Load full job data with requirements & tags
   - Implement Apply button
   - Implement Favorite toggle

3. **Application History Page**
   - Load user applications
   - Group by status
   - Add filter tabs

4. **CV Upload Page**
   - Integrate ProfileService.pickAndUploadCV()
   - Show current CV
   - Allow deletion

5. **Education Page**
   - List all education
   - Add/Edit/Delete functionality
   - Form validation

6. **Portfolio Page**
   - List all projects
   - Add/Edit/Delete with image upload
   - Technology tags

---

## Error Handling Pattern

```dart
Future<void> fetchData() async {
  setState(() => isLoading = true);
  
  try {
    final data = await service.getData();
    setState(() {
      this.data = data;
      isLoading = false;
    });
  } catch (e) {
    setState(() => isLoading = false);
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

---

## Notes

- All services use `_currentUserId` automatically from Supabase auth
- Conditional updates only send changed fields to reduce bandwidth
- CV upload supports PDF only
- Portfolio image upload supports common image formats
- All methods include proper error handling
- Use `setState(() => isLoading = true/false)` for loading states
- Check `mounted` before calling `setState` after async operations

---

**Last Updated**: November 13, 2025
