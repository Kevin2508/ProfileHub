class UserProfile {
  String name;
  String bio;
  String skills;
  String instituteName;
  String degree;
  String company;
  String position;
  String yearsOfExperience;
  String location;
  String website;
  String? profilePictureUrl;

  UserProfile({
    required this.name,
    required this.bio,
    required this.skills,
    required this.instituteName,
    required this.degree,
    required this.company,
    required this.position,
    required this.yearsOfExperience,
    required this.location,
    required this.website,
    this.profilePictureUrl,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      name: data['name'],
      bio: data['bio'],
      skills: data['skills'],
      instituteName: data['instituteName'],
      degree: data['degree'],
      company: data['company'],
      position: data['position'],
      yearsOfExperience: data['yearsOfExperience'],
      location: data['location'],
      website: data['website'],
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bio': bio,
      'skills': skills,
      'instituteName': instituteName,
      'degree': degree,
      'company': company,
      'position': position,
      'yearsOfExperience': yearsOfExperience,
      'location': location,
      'website': website,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}