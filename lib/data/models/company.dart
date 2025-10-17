class Company {
  final String id;
  final String name;
  final String logoUrl;
  final String location;
  final String description;

  const Company({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.location,
    required this.description,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'location': location,
      'description': description,
    };
  }
}
