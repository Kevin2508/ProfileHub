import 'package:flutter/material.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock user data (replace with actual data from Firebase or backend)
    final Map<String, String?> userData = {
      "name": "John Doe",
      "email": "user@example.com", // This is fetched from Firebase
      "bio": "Software Engineer passionate about coding.",
      "skills": "Flutter, Dart, Firebase",
      "institute": "ABC University",
      "degree": "B.Sc. in Computer Science",
      "yearsExperience": "3",
      "location": "San Francisco, CA",
      "company": "Tech Corp",
      "position": "Senior Developer",
      "website": "https://johndoe.dev",
      "profilePicture": null, // Optional profile picture URL
    };

    // Check if required fields are filled
    bool isProfileComplete = userData["name"] != null &&
        userData["bio"] != null &&
        userData["skills"] != null &&
        userData["institute"] != null &&
        userData["degree"] != null &&
        userData["yearsExperience"] != null &&
        userData["location"] != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Center(
        child: isProfileComplete
            ? _buildPortfolio(userData)
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Complete Your Profile",
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Profile Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: const Text("Go to Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolio(Map<String, String?> userData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              if (userData["profilePicture"] != null)
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userData["profilePicture"]!),
                  ),
                ),
              const SizedBox(height: 16),
              // Name
              Text(
                userData["name"]!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Bio
              Text(
                userData["bio"]!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Skills
              const Text(
                "Skills:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userData["skills"]!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Institute & Degree
              Text(
                "${userData["degree"]} from ${userData["institute"]}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Experience & Location
              Text(
                "${userData["yearsExperience"]} years experience, based in ${userData["location"]}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Company & Position (Optional)
              if (userData["company"] != null && userData["position"] != null)
                Text(
                  "Currently working at ${userData["company"]} as ${userData["position"]}",
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 16),
              // Website (Optional)
              if (userData["website"] != null)
                Text(
                  "Website: ${userData["website"]}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}