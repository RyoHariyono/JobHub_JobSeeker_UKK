import 'company.dart';

enum JobCategory {
  softwareDevelopment,
  frontendDevelopment,
  backendDevelopment,
  devopsCloud,
  uiuxDesign,
}

enum JobType { fullTime, partTime, contract, freelance, internship }

class Job {
  final String id;
  final String title;
  final Company company;
  final JobCategory category;
  final JobType type;
  final String location;
  final double minSalary;
  final double maxSalary;
  final String currency;
  final String description;
  final List<String> requirements;
  final DateTime postedDate;
  final DateTime deadlineDate;
  final bool isBookmarked;
  final List<String> tags;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.category,
    required this.type,
    required this.location,
    required this.minSalary,
    required this.maxSalary,
    this.currency = 'USD',
    required this.description,
    required this.requirements,
    required this.postedDate,
    required this.deadlineDate,
    this.isBookmarked = false,
    this.tags = const [],
  });

  String get categoryName {
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

  String get typeName {
    switch (type) {
      case JobType.fullTime:
        return 'Full Time';
      case JobType.partTime:
        return 'Part Time';
      case JobType.contract:
        return 'Contract';
      case JobType.freelance:
        return 'Freelance';
      case JobType.internship:
        return 'Internship';
    }
  }

  String get salaryRange {
    return '\$${minSalary.toStringAsFixed(0)} - \$${maxSalary.toStringAsFixed(0)}';
  }

  String get daysAgo {
    final difference = DateTime.now().difference(postedDate);
    return '${difference.inDays} Days';
  }

  Job copyWith({
    String? id,
    String? title,
    Company? company,
    JobCategory? category,
    JobType? type,
    String? location,
    double? minSalary,
    double? maxSalary,
    String? currency,
    String? description,
    List<String>? requirements,
    DateTime? postedDate,
    DateTime? deadlineDate,
    bool? isBookmarked,
    List<String>? tags,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      category: category ?? this.category,
      type: type ?? this.type,
      location: location ?? this.location,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      postedDate: postedDate ?? this.postedDate,
      deadlineDate: deadlineDate ?? this.deadlineDate,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tags: tags ?? this.tags,
    );
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      title: json['title'] as String,
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
      category: JobCategory.values[json['category'] as int],
      type: JobType.values[json['type'] as int],
      location: json['location'] as String,
      minSalary: (json['minSalary'] as num).toDouble(),
      maxSalary: (json['maxSalary'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      description: json['description'] as String,
      requirements: List<String>.from(json['requirements'] as List),
      postedDate: DateTime.parse(json['postedDate'] as String),
      deadlineDate: DateTime.parse(json['deadlineDate'] as String),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company.toJson(),
      'category': category.index,
      'type': type.index,
      'location': location,
      'minSalary': minSalary,
      'maxSalary': maxSalary,
      'currency': currency,
      'description': description,
      'requirements': requirements,
      'postedDate': postedDate.toIso8601String(),
      'deadlineDate': deadlineDate.toIso8601String(),
      'isBookmarked': isBookmarked,
      'tags': tags,
    };
  }
}
