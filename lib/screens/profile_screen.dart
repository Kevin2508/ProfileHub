import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _instituteController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Bio
              TextField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Bio",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Skills
              TextField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: "Skills (comma-separated)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Institute
              TextField(
                controller: _instituteController,
                decoration: const InputDecoration(
                  labelText: "Institute Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Degree
              TextField(
                controller: _degreeController,
                decoration: const InputDecoration(
                  labelText: "Degree",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Experience
              TextField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: "Experience Years",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Location
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Website
              TextField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: "Website (Optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Save profile data logic here
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}