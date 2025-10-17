import '../models/job.dart';
import '../models/company.dart';

class JobDataService {
  static final List<Company> _companies = [
    // Tech Companies
    Company(
      id: 'tech_nova',
      name: 'TechNova Solutions',
      logoUrl: 'assets/images/technova_logo.png',
      location: 'Jakarta, Indonesia',
      description: 'Leading technology solutions provider',
    ),
    Company(
      id: 'datamind_ai',
      name: 'DataMind AI',
      logoUrl: 'assets/images/datamind_logo.png',
      location: 'Bandung, Indonesia',
      description: 'AI and machine learning company',
    ),
    Company(
      id: 'google',
      name: 'Google',
      logoUrl: 'assets/images/google_logo.png',
      location: 'Surabaya, Indonesia',
      description: 'Global technology leader',
    ),
    Company(
      id: 'microsoft',
      name: 'Microsoft',
      logoUrl: 'assets/images/microsoft_logo.png',
      location: 'Jakarta, Indonesia',
      description: 'Software and cloud services',
    ),
    Company(
      id: 'startup_tech',
      name: 'StartupTech',
      logoUrl: 'assets/images/startup_logo.png',
      location: 'Yogyakarta, Indonesia',
      description: 'Innovative startup solutions',
    ),
    Company(
      id: 'cloud_systems',
      name: 'CloudSystems',
      logoUrl: 'assets/images/cloud_logo.png',
      location: 'Bali, Indonesia',
      description: 'Cloud infrastructure specialists',
    ),
    Company(
      id: 'design_hub',
      name: 'DesignHub',
      logoUrl: 'assets/images/design_logo.png',
      location: 'Jakarta, Indonesia',
      description: 'Creative design agency',
    ),
    Company(
      id: 'backend_solutions',
      name: 'Backend Solutions',
      logoUrl: 'assets/images/backend_logo.png',
      location: 'Medan, Indonesia',
      description: 'Backend development specialists',
    ),
  ];

  static final List<Job> _allJobs = [
    // Software Development Jobs
    Job(
      id: 'job_1',
      title: 'Full-Stack Developer',
      company: _companies[0], // TechNova Solutions
      category: JobCategory.softwareDevelopment,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 2500,
      maxSalary: 4000,
      description:
          'We are looking for a skilled Full-Stack Developer to join our team...',
      requirements: ['React', 'Node.js', 'MongoDB', 'TypeScript'],
      postedDate: DateTime.now().subtract(Duration(days: 20)),
      deadlineDate: DateTime.now().add(Duration(days: 10)),
      tags: ['React', 'Node.js', 'Full-Stack'],
    ),
    Job(
      id: 'job_2',
      title: 'Software Engineer (Python)',
      company: _companies[1], // DataMind AI
      category: JobCategory.softwareDevelopment,
      type: JobType.fullTime,
      location: 'Bandung, Indonesia',
      minSalary: 3500,
      maxSalary: 4500,
      description: 'Join our AI team as a Python Software Engineer...',
      requirements: ['Python', 'Django', 'PostgreSQL', 'Machine Learning'],
      postedDate: DateTime.now().subtract(Duration(days: 20)),
      deadlineDate: DateTime.now().add(Duration(days: 15)),
      tags: ['Python', 'AI', 'Machine Learning'],
    ),
    Job(
      id: 'job_3',
      title: 'Mobile Developer (Flutter)',
      company: _companies[2], // Google
      category: JobCategory.softwareDevelopment,
      type: JobType.fullTime,
      location: 'Surabaya, Indonesia',
      minSalary: 2800,
      maxSalary: 4200,
      description: 'Build amazing mobile applications with Flutter...',
      requirements: ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
      postedDate: DateTime.now().subtract(Duration(days: 20)),
      deadlineDate: DateTime.now().add(Duration(days: 20)),
      tags: ['Flutter', 'Mobile', 'Dart'],
    ),

    // Frontend Development Jobs
    Job(
      id: 'job_4',
      title: 'React Frontend Developer',
      company: _companies[3], // Microsoft
      category: JobCategory.frontendDevelopment,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 2200,
      maxSalary: 3800,
      description: 'Create stunning user interfaces with React...',
      requirements: ['React', 'TypeScript', 'CSS3', 'Redux'],
      postedDate: DateTime.now().subtract(Duration(days: 15)),
      deadlineDate: DateTime.now().add(Duration(days: 25)),
      tags: ['React', 'Frontend', 'TypeScript'],
    ),
    Job(
      id: 'job_5',
      title: 'Vue.js Developer',
      company: _companies[4], // StartupTech
      category: JobCategory.frontendDevelopment,
      type: JobType.contract,
      location: 'Yogyakarta, Indonesia',
      minSalary: 2000,
      maxSalary: 3500,
      description: 'Build modern web applications with Vue.js...',
      requirements: ['Vue.js', 'Nuxt.js', 'JavaScript', 'CSS'],
      postedDate: DateTime.now().subtract(Duration(days: 10)),
      deadlineDate: DateTime.now().add(Duration(days: 30)),
      tags: ['Vue.js', 'Frontend', 'JavaScript'],
    ),
    Job(
      id: 'job_6',
      title: 'Angular Developer',
      company: _companies[0], // TechNova Solutions
      category: JobCategory.frontendDevelopment,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 2400,
      maxSalary: 3600,
      description: 'Develop enterprise applications with Angular...',
      requirements: ['Angular', 'TypeScript', 'RxJS', 'SCSS'],
      postedDate: DateTime.now().subtract(Duration(days: 12)),
      deadlineDate: DateTime.now().add(Duration(days: 18)),
      tags: ['Angular', 'Frontend', 'TypeScript'],
    ),

    // Backend Development Jobs
    Job(
      id: 'job_7',
      title: 'Node.js Backend Developer',
      company: _companies[7], // Backend Solutions
      category: JobCategory.backendDevelopment,
      type: JobType.fullTime,
      location: 'Medan, Indonesia',
      minSalary: 2600,
      maxSalary: 4000,
      description: 'Build scalable backend services with Node.js...',
      requirements: ['Node.js', 'Express.js', 'MongoDB', 'Docker'],
      postedDate: DateTime.now().subtract(Duration(days: 18)),
      deadlineDate: DateTime.now().add(Duration(days: 22)),
      tags: ['Node.js', 'Backend', 'API'],
    ),
    Job(
      id: 'job_8',
      title: 'Java Spring Developer',
      company: _companies[3], // Microsoft
      category: JobCategory.backendDevelopment,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 3000,
      maxSalary: 4500,
      description: 'Develop enterprise backend systems with Java Spring...',
      requirements: ['Java', 'Spring Boot', 'MySQL', 'Microservices'],
      postedDate: DateTime.now().subtract(Duration(days: 25)),
      deadlineDate: DateTime.now().add(Duration(days: 5)),
      tags: ['Java', 'Spring', 'Backend'],
    ),
    Job(
      id: 'job_9',
      title: 'PHP Laravel Developer',
      company: _companies[4], // StartupTech
      category: JobCategory.backendDevelopment,
      type: JobType.partTime,
      location: 'Yogyakarta, Indonesia',
      minSalary: 1800,
      maxSalary: 2800,
      description: 'Build web applications with PHP Laravel...',
      requirements: ['PHP', 'Laravel', 'MySQL', 'Redis'],
      postedDate: DateTime.now().subtract(Duration(days: 8)),
      deadlineDate: DateTime.now().add(Duration(days: 27)),
      tags: ['PHP', 'Laravel', 'Backend'],
    ),

    // DevOps & Cloud Engineering Jobs
    Job(
      id: 'job_10',
      title: 'DevOps Engineer',
      company: _companies[5], // CloudSystems
      category: JobCategory.devopsCloud,
      type: JobType.fullTime,
      location: 'Bali, Indonesia',
      minSalary: 3200,
      maxSalary: 5000,
      description: 'Manage cloud infrastructure and CI/CD pipelines...',
      requirements: ['AWS', 'Docker', 'Kubernetes', 'Terraform'],
      postedDate: DateTime.now().subtract(Duration(days: 14)),
      deadlineDate: DateTime.now().add(Duration(days: 16)),
      tags: ['DevOps', 'AWS', 'Docker'],
    ),
    Job(
      id: 'job_11',
      title: 'Cloud Architect',
      company: _companies[2], // Google
      category: JobCategory.devopsCloud,
      type: JobType.fullTime,
      location: 'Surabaya, Indonesia',
      minSalary: 4000,
      maxSalary: 6000,
      description: 'Design and implement cloud solutions...',
      requirements: ['GCP', 'Azure', 'Cloud Architecture', 'Microservices'],
      postedDate: DateTime.now().subtract(Duration(days: 30)),
      deadlineDate: DateTime.now().add(Duration(days: 2)),
      tags: ['Cloud', 'Architecture', 'GCP'],
    ),
    Job(
      id: 'job_12',
      title: 'Site Reliability Engineer',
      company: _companies[5], // CloudSystems
      category: JobCategory.devopsCloud,
      type: JobType.fullTime,
      location: 'Bali, Indonesia',
      minSalary: 3500,
      maxSalary: 4800,
      description: 'Ensure system reliability and performance...',
      requirements: ['Linux', 'Monitoring', 'Python', 'Automation'],
      postedDate: DateTime.now().subtract(Duration(days: 7)),
      deadlineDate: DateTime.now().add(Duration(days: 23)),
      tags: ['SRE', 'Monitoring', 'Linux'],
    ),

    // UI/UX & Product Design Jobs
    Job(
      id: 'job_13',
      title: 'UI/UX Designer',
      company: _companies[6], // DesignHub
      category: JobCategory.uiuxDesign,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 2000,
      maxSalary: 3500,
      description: 'Create beautiful and functional user experiences...',
      requirements: ['Figma', 'Adobe XD', 'User Research', 'Prototyping'],
      postedDate: DateTime.now().subtract(Duration(days: 5)),
      deadlineDate: DateTime.now().add(Duration(days: 25)),
      tags: ['UI/UX', 'Design', 'Figma'],
    ),
    Job(
      id: 'job_14',
      title: 'Product Designer',
      company: _companies[2], // Google
      category: JobCategory.uiuxDesign,
      type: JobType.fullTime,
      location: 'Surabaya, Indonesia',
      minSalary: 2800,
      maxSalary: 4200,
      description: 'Lead product design initiatives...',
      requirements: [
        'Design Thinking',
        'Figma',
        'User Testing',
        'Product Strategy',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 22)),
      deadlineDate: DateTime.now().add(Duration(days: 8)),
      tags: ['Product Design', 'Strategy', 'UX'],
    ),
    Job(
      id: 'job_15',
      title: 'Visual Designer',
      company: _companies[6], // DesignHub
      category: JobCategory.uiuxDesign,
      type: JobType.freelance,
      location: 'Jakarta, Indonesia',
      minSalary: 1500,
      maxSalary: 2500,
      description: 'Create compelling visual designs...',
      requirements: [
        'Adobe Creative Suite',
        'Branding',
        'Typography',
        'Color Theory',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 3)),
      deadlineDate: DateTime.now().add(Duration(days: 35)),
      tags: ['Visual Design', 'Branding', 'Adobe'],
    ),
  ];

  // Get all jobs
  static List<Job> getAllJobs() {
    return List.from(_allJobs);
  }

  // Get jobs by category
  static List<Job> getJobsByCategory(JobCategory category) {
    return _allJobs.where((job) => job.category == category).toList();
  }

  // Get random jobs for recommendations
  static List<Job> getRandomJobs(int count) {
    final shuffled = List<Job>.from(_allJobs)..shuffle();
    return shuffled.take(count).toList();
  }

  // Get popular jobs (most recent)
  static List<Job> getPopularJobs({int limit = 5}) {
    final sorted = List<Job>.from(_allJobs)
      ..sort((a, b) => b.postedDate.compareTo(a.postedDate));
    return sorted.take(limit).toList();
  }

  // Get job categories
  static List<JobCategory> getJobCategories() {
    return JobCategory.values;
  }

  // Get category name
  static String getCategoryName(JobCategory category) {
    switch (category) {
      case JobCategory.softwareDevelopment:
        return 'Software Development';
      case JobCategory.frontendDevelopment:
        return 'Frontend Development';
      case JobCategory.backendDevelopment:
        return 'Backend Development';
      case JobCategory.devopsCloud:
        return 'DevOps & Cloud Engineering';
      case JobCategory.uiuxDesign:
        return 'UI/UX & Product Design';
    }
  }

  // Search jobs
  static List<Job> searchJobs(String query) {
    if (query.isEmpty) return getAllJobs();

    final lowercaseQuery = query.toLowerCase();
    return _allJobs.where((job) {
      return job.title.toLowerCase().contains(lowercaseQuery) ||
          job.company.name.toLowerCase().contains(lowercaseQuery) ||
          job.location.toLowerCase().contains(lowercaseQuery) ||
          job.categoryName.toLowerCase().contains(lowercaseQuery) ||
          job.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Toggle bookmark
  static Job toggleBookmark(Job job) {
    final index = _allJobs.indexWhere((j) => j.id == job.id);
    if (index != -1) {
      _allJobs[index] = job.copyWith(isBookmarked: !job.isBookmarked);
      return _allJobs[index];
    }
    return job;
  }
}
