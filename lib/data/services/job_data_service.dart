import 'package:flutter/foundation.dart';
import '../models/job.dart';
import '../models/company.dart';

class JobDataService {
  static ValueNotifier<List<Job>> get jobsNotifier => _allJobsNotifier;
  static final List<Company> _companies = [
    Company(
      id: 'apple',
      name: 'Apple',
      logoUrl: 'assets/images/apple_logo.png',
      location: 'Jakarta, Indonesia',
      description: 'Technology innovation leader',
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
      id: 'meta',
      name: 'Meta',
      logoUrl: 'assets/images/meta_logo.png',
      location: 'Bandung, Indonesia',
      description: 'Social technology company',
    ),
    Company(
      id: 'amazon',
      name: 'Amazon',
      logoUrl: 'assets/images/amazon_logo.png',
      location: 'Jakarta, Indonesia',
      description: 'E-commerce and cloud computing',
    ),
    Company(
      id: 'netflix',
      name: 'Netflix',
      logoUrl: 'assets/images/netflix_logo.png',
      location: 'Bali, Indonesia',
      description: 'Entertainment streaming service',
    ),
    Company(
      id: 'tesla',
      name: 'Tesla',
      logoUrl: 'assets/images/tesla_logo.png',
      location: 'Surabaya, Indonesia',
      description: 'Electric vehicles and clean energy',
    ),
    Company(
      id: 'spotify',
      name: 'Spotify',
      logoUrl: 'assets/images/spotify_logo.png',
      location: 'Yogyakarta, Indonesia',
      description: 'Audio streaming platform',
    ),
  ];

  static final ValueNotifier<List<Job>>
  _allJobsNotifier = ValueNotifier<List<Job>>([
    // UI/UX Design Jobs
    Job(
      id: 'job_1',
      title: 'Senior UI/UX Designer',
      company: _companies[0], // Apple
      category: JobCategory.uiuxDesign,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 1000,
      maxSalary: 3000,
      description:
          'We are looking for a highly skilled Senior UI/UX Designer to join Apple in Jakarta, Indonesia. The role involves creating intuitive, user-friendly, and visually appealing designs that enhance user experiences across digital platforms. You will work closely with cross-functional teams to ensure design consistency and innovation.',
      requirements: [
        'Bachelor\'s degree in Design, Computer Science, or related field.',
        'Proven experience as a UI/UX Designer with a strong portfolio.',
        'Proficiency in design tools such as Figma, Sketch, Adobe XD, and Photoshop.',
        'Strong understanding of user-centered design principles and usability testing.',
        'Excellent communication and collaboration skills to work effectively with cross-functional teams.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 20)),
      deadlineDate: DateTime(2025, 9, 17),
      startDate: DateTime(2025, 8, 28),
      tags: ['Design', 'Figma', 'UI/UX'],
      capacity: 2,
      experience: '7+ years',
      jobLevel: 'Senior Designer',
    ),
    Job(
      id: 'job_2',
      title: 'Product Designer',
      company: _companies[1], // Google
      category: JobCategory.uiuxDesign,
      type: JobType.fullTime,
      location: 'Surabaya, Indonesia',
      minSalary: 2800,
      maxSalary: 4500,
      description:
          'Google is seeking an experienced Product Designer to lead design initiatives for innovative products. You will be responsible for creating user-centric designs, conducting user research, and collaborating with product teams to deliver exceptional digital experiences.',
      requirements: [
        'Bachelor\'s degree in Design or related field.',
        '5+ years of experience in product design.',
        'Strong portfolio showcasing design thinking and problem-solving.',
        'Expertise in Figma, Sketch, and prototyping tools.',
        'Experience with user research and usability testing.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 15)),
      deadlineDate: DateTime(2025, 11, 20),
      startDate: DateTime(2025, 11, 1),
      tags: ['Product Design', 'User Research', 'Figma'],
      capacity: 3,
      experience: '5+ years',
      jobLevel: 'Senior Level',
    ),
    Job(
      id: 'job_3',
      title: 'UI Designer',
      company: _companies[3], // Meta
      category: JobCategory.uiuxDesign,
      type: JobType.fullTime,
      location: 'Bandung, Indonesia',
      minSalary: 1500,
      maxSalary: 2500,
      description:
          'Meta is looking for a talented UI Designer to create beautiful and functional user interfaces for our social media platforms. You will work with product managers and developers to bring designs to life.',
      requirements: [
        'Bachelor\'s degree in Graphic Design or related field.',
        '3+ years of UI design experience.',
        'Proficiency in Figma, Adobe XD, and Illustrator.',
        'Strong understanding of color theory, typography, and layout.',
        'Ability to work in a fast-paced environment.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 10)),
      deadlineDate: DateTime(2025, 12, 1),
      startDate: DateTime(2025, 11, 15),
      tags: ['UI Design', 'Visual Design', 'Figma'],
      capacity: 1,
      experience: '3+ years',
      jobLevel: 'Mid Level',
    ),

    // Software Development Jobs
    Job(
      id: 'job_4',
      title: 'Full-Stack Developer',
      company: _companies[2], // Microsoft
      category: JobCategory.softwareDevelopment,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 2500,
      maxSalary: 4000,
      description:
          'Microsoft is seeking a skilled Full-Stack Developer to build and maintain web applications. You will work with both frontend and backend technologies to deliver high-quality software solutions.',
      requirements: [
        'Bachelor\'s degree in Computer Science or related field.',
        '4+ years of full-stack development experience.',
        'Proficiency in React, Node.js, and databases.',
        'Experience with cloud platforms (Azure preferred).',
        'Strong problem-solving and debugging skills.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 25)),
      deadlineDate: DateTime(2025, 11, 10),
      startDate: DateTime(2025, 10, 25),
      tags: ['React', 'Node.js', 'Full-Stack'],
      capacity: 2,
      experience: '4+ years',
      jobLevel: 'Senior Level',
    ),
    Job(
      id: 'job_5',
      title: 'Mobile Developer (Flutter)',
      company: _companies[1], // Google
      category: JobCategory.softwareDevelopment,
      type: JobType.fullTime,
      location: 'Surabaya, Indonesia',
      minSalary: 2800,
      maxSalary: 4200,
      description:
          'Build amazing mobile applications with Flutter for Android and iOS platforms. Join Google\'s mobile team to create innovative solutions that reach millions of users worldwide.',
      requirements: [
        'Bachelor\'s degree in Computer Science.',
        '3+ years of Flutter development experience.',
        'Strong knowledge of Dart programming language.',
        'Experience with Firebase and REST APIs.',
        'Published apps on App Store or Google Play.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 18)),
      deadlineDate: DateTime(2025, 12, 5),
      startDate: DateTime(2025, 11, 20),
      tags: ['Flutter', 'Mobile', 'Dart'],
      capacity: 3,
      experience: '3+ years',
      jobLevel: 'Mid to Senior Level',
    ),
    Job(
      id: 'job_6',
      title: 'Software Engineer (Python)',
      company: _companies[4], // Amazon
      category: JobCategory.softwareDevelopment,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 3500,
      maxSalary: 5000,
      description:
          'Amazon is hiring a Software Engineer specializing in Python to work on backend services and data processing systems. You will contribute to building scalable solutions for e-commerce and cloud services.',
      requirements: [
        'Bachelor\'s or Master\'s degree in Computer Science.',
        '5+ years of Python development experience.',
        'Experience with Django or Flask frameworks.',
        'Knowledge of AWS services and microservices architecture.',
        'Strong algorithmic and data structure skills.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 30)),
      deadlineDate: DateTime(2025, 11, 30),
      startDate: DateTime(2025, 12, 15),
      tags: ['Python', 'AWS', 'Backend'],
      capacity: 4,
      experience: '5+ years',
      jobLevel: 'Senior Engineer',
    ),

    // Frontend Development Jobs
    Job(
      id: 'job_7',
      title: 'React Frontend Developer',
      company: _companies[5], // Netflix
      category: JobCategory.frontendDevelopment,
      type: JobType.fullTime,
      location: 'Bali, Indonesia',
      minSalary: 2200,
      maxSalary: 3800,
      description:
          'Netflix is looking for a React Frontend Developer to create stunning user interfaces for our streaming platform. You will work on performance optimization and delivering seamless user experiences.',
      requirements: [
        'Bachelor\'s degree in Computer Science or related field.',
        '3+ years of React development experience.',
        'Strong knowledge of JavaScript, TypeScript, and CSS.',
        'Experience with state management (Redux, Context API).',
        'Understanding of responsive design and web accessibility.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 12)),
      deadlineDate: DateTime(2025, 11, 25),
      startDate: DateTime(2025, 11, 10),
      tags: ['React', 'Frontend', 'TypeScript'],
      capacity: 2,
      experience: '3+ years',
      jobLevel: 'Mid Level',
    ),
    Job(
      id: 'job_8',
      title: 'Vue.js Developer',
      company: _companies[7], // Spotify
      category: JobCategory.frontendDevelopment,
      type: JobType.contract,
      location: 'Yogyakarta, Indonesia',
      minSalary: 2000,
      maxSalary: 3500,
      description:
          'Spotify is seeking a Vue.js Developer for a 6-month contract to build modern web applications for our music streaming platform. You will collaborate with designers and backend engineers.',
      requirements: [
        'Bachelor\'s degree in Computer Science.',
        '2+ years of Vue.js development experience.',
        'Proficiency in JavaScript and Nuxt.js.',
        'Experience with RESTful APIs and GraphQL.',
        'Familiarity with modern frontend build tools.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 8)),
      deadlineDate: DateTime(2025, 12, 10),
      startDate: DateTime(2025, 12, 1),
      tags: ['Vue.js', 'Frontend', 'JavaScript'],
      capacity: 1,
      experience: '2+ years',
      jobLevel: 'Mid Level',
    ),

    // Backend Development Jobs
    Job(
      id: 'job_9',
      title: 'Node.js Backend Developer',
      company: _companies[2], // Microsoft
      category: JobCategory.backendDevelopment,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 2600,
      maxSalary: 4000,
      description:
          'Build scalable backend services with Node.js for Microsoft\'s cloud platform. You will design APIs, work with databases, and ensure high performance and security.',
      requirements: [
        'Bachelor\'s degree in Computer Science.',
        '4+ years of Node.js backend development.',
        'Experience with Express.js and REST APIs.',
        'Strong knowledge of MongoDB or PostgreSQL.',
        'Familiarity with Docker and Kubernetes.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 20)),
      deadlineDate: DateTime(2025, 11, 15),
      startDate: DateTime(2025, 11, 1),
      tags: ['Node.js', 'Backend', 'API'],
      capacity: 3,
      experience: '4+ years',
      jobLevel: 'Senior Level',
    ),
    Job(
      id: 'job_10',
      title: 'Java Spring Developer',
      company: _companies[4], // Amazon
      category: JobCategory.backendDevelopment,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 3000,
      maxSalary: 4500,
      description:
          'Amazon is hiring a Java Spring Developer to work on enterprise backend systems for our e-commerce platform. You will build microservices and work with large-scale distributed systems.',
      requirements: [
        'Bachelor\'s degree in Computer Science.',
        '5+ years of Java development experience.',
        'Expertise in Spring Boot and Spring Cloud.',
        'Experience with microservices architecture.',
        'Knowledge of MySQL, Redis, and message queues.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 28)),
      deadlineDate: DateTime(2025, 11, 5),
      startDate: DateTime(2025, 10, 20),
      tags: ['Java', 'Spring', 'Microservices'],
      capacity: 2,
      experience: '5+ years',
      jobLevel: 'Senior Engineer',
    ),

    // DevOps & Cloud Engineering Jobs
    Job(
      id: 'job_11',
      title: 'DevOps Engineer',
      company: _companies[1], // Google
      category: JobCategory.devopsCloud,
      type: JobType.fullTime,
      location: 'Surabaya, Indonesia',
      minSalary: 3200,
      maxSalary: 5000,
      description:
          'Google is looking for a DevOps Engineer to manage cloud infrastructure, automate deployments, and ensure system reliability. You will work with cutting-edge technologies and tools.',
      requirements: [
        'Bachelor\'s degree in Computer Science or related field.',
        '4+ years of DevOps experience.',
        'Strong knowledge of AWS, GCP, or Azure.',
        'Experience with Docker, Kubernetes, and Terraform.',
        'Proficiency in CI/CD pipelines and automation.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 14)),
      deadlineDate: DateTime(2025, 11, 20),
      startDate: DateTime(2025, 11, 5),
      tags: ['DevOps', 'GCP', 'Kubernetes'],
      capacity: 2,
      experience: '4+ years',
      jobLevel: 'Senior Level',
    ),
    Job(
      id: 'job_12',
      title: 'Cloud Architect',
      company: _companies[4], // Amazon
      category: JobCategory.devopsCloud,
      type: JobType.fullTime,
      location: 'Jakarta, Indonesia',
      minSalary: 4000,
      maxSalary: 6000,
      description:
          'Amazon is seeking an experienced Cloud Architect to design and implement scalable cloud solutions for our global infrastructure. You will lead architectural decisions and mentor engineering teams.',
      requirements: [
        'Bachelor\'s or Master\'s degree in Computer Science.',
        '7+ years of cloud architecture experience.',
        'Expert knowledge of AWS services and best practices.',
        'Experience with multi-region deployments and disaster recovery.',
        'Strong leadership and communication skills.',
      ],
      postedDate: DateTime.now().subtract(Duration(days: 22)),
      deadlineDate: DateTime(2025, 10, 28),
      startDate: DateTime(2025, 10, 15),
      tags: ['AWS', 'Cloud Architecture', 'Leadership'],
      capacity: 1,
      experience: '7+ years',
      jobLevel: 'Principal/Staff Level',
    ),
  ]);

  // Get all jobs
  static List<Job> getAllJobs() {
    return List.from(_allJobsNotifier.value);
  }

  // Get jobs by category
  static List<Job> getJobsByCategory(JobCategory category) {
    return _allJobsNotifier.value
        .where((job) => job.category == category)
        .toList();
  }

  // Get random jobs for recommendations
  static List<Job> getRandomJobs(int count) {
    final shuffled = List<Job>.from(_allJobsNotifier.value)..shuffle();
    return shuffled.take(count).toList();
  }

  // Get popular jobs (most recent)
  static List<Job> getPopularJobs({int limit = 5}) {
    final sorted = List<Job>.from(_allJobsNotifier.value)
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
    return _allJobsNotifier.value.where((job) {
      return job.title.toLowerCase().contains(lowercaseQuery) ||
          job.company.name.toLowerCase().contains(lowercaseQuery) ||
          job.location.toLowerCase().contains(lowercaseQuery) ||
          job.categoryName.toLowerCase().contains(lowercaseQuery) ||
          job.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Toggle bookmark
  static Job toggleBookmark(Job job) {
    final jobs = _allJobsNotifier.value;
    final index = jobs.indexWhere((j) => j.id == job.id);
    if (index != -1) {
      jobs[index] = job.copyWith(isBookmarked: !job.isBookmarked);
      _allJobsNotifier.value = List<Job>.from(jobs);
      return jobs[index];
    }
    return job;
  }
}
