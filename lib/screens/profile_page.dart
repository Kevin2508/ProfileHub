import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  bool _isEditingAccount = false;
  bool _isEditingContact = false;
  bool _isEditingAbout = false;

  // Controllers for editing profile information
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  // User profile data
  Map<String, dynamic> _userData = {
    'username': 'Profile User',
    'phone': '+1 (555) 123-4567',
    'address': 'New York, USA',
    'website': 'example.com',
    'aboutMe': 'Flutter developer with a passion for creating beautiful and functional mobile applications. Love to explore new technologies and frameworks.',
    'memberSince': 'April 2025',
  };

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user != null) {
        // Reference to Firestore collection
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // If user document exists, get the data
          setState(() {
            _userData = {
              ..._userData,
              ...userDoc.data() as Map<String, dynamic>,
            };
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching profile data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });

      // Initialize controllers with existing data
      _usernameController.text = _userData['username'] ?? 'Profile User';
      _phoneController.text = _userData['phone'] ?? '+1 (555) 123-4567';
      _addressController.text = _userData['address'] ?? 'New York, USA';
      _websiteController.text = _userData['website'] ?? 'example.com';
      _aboutMeController.text = _userData['aboutMe'] ?? 'Flutter developer with a passion for creating beautiful and functional mobile applications.';
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserData(Map<String, dynamic> data) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user != null) {
        // Reference to Firestore collection and document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(data, SetOptions(merge: true));

        setState(() {
          _userData = {
            ..._userData,
            ...data,
          };
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Toggle edit mode for different sections
  void _toggleEditAccount() {
    setState(() {
      _isEditingAccount = !_isEditingAccount;
      if (!_isEditingAccount) {
        // Save changes when exiting edit mode
        _saveUserData({'username': _usernameController.text});
      }
    });
  }

  void _toggleEditContact() {
    setState(() {
      _isEditingContact = !_isEditingContact;
      if (!_isEditingContact) {
        // Save changes when exiting edit mode
        _saveUserData({
          'phone': _phoneController.text,
          'address': _addressController.text,
          'website': _websiteController.text,
        });
      }
    });
  }

  void _toggleEditAbout() {
    setState(() {
      _isEditingAbout = !_isEditingAbout;
      if (!_isEditingAbout) {
        // Save changes when exiting edit mode
        _saveUserData({'aboutMe': _aboutMeController.text});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final theme = Theme.of(context);

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.primaryColor,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        backgroundImage: user?.photoUrl != null
                            ? NetworkImage(user!.photoUrl!)
                            : null,
                        child: user?.photoUrl == null
                            ? Icon(
                          Icons.person,
                          size: 60,
                          color: theme.primaryColor,
                        )
                            : null,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            // Implement photo change functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Photo upload feature coming soon!'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  user?.displayName ?? _userData['username'] ?? 'Profile User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'email@example.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () {
                    // Toggle edit mode for all sections
                    setState(() {
                      _isEditingAccount = !_isEditingAccount;
                      _isEditingContact = !_isEditingContact;
                      _isEditingAbout = !_isEditingAbout;

                      if (!_isEditingAccount && !_isEditingContact && !_isEditingAbout) {
                        // Save all changes when exiting global edit mode
                        _saveUserData({
                          'username': _usernameController.text,
                          'phone': _phoneController.text,
                          'address': _addressController.text,
                          'website': _websiteController.text,
                          'aboutMe': _aboutMeController.text,
                        });
                      }
                    });
                  },
                  icon: Icon(_isEditingAccount || _isEditingContact || _isEditingAbout
                      ? Icons.save
                      : Icons.edit),
                  label: Text(_isEditingAccount || _isEditingContact || _isEditingAbout
                      ? 'Save Changes'
                      : 'Edit Profile'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Account',
            _isEditingAccount
                ? [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(
                  label: 'Username',
                  controller: _usernameController,
                  prefixIcon: Icons.person,
                ),
              ),
              _buildInfoItem(context, 'Email', user?.email ?? 'N/A'),
              _buildInfoItem(context, 'Member Since', _userData['memberSince'] ?? 'April 2025'),
            ]
                : [
              _buildInfoItem(context, 'Username', _userData['username'] ?? 'N/A'),
              _buildInfoItem(context, 'Email', user?.email ?? 'N/A'),
              _buildInfoItem(context, 'Member Since', _userData['memberSince'] ?? 'April 2025'),
            ],
            onEdit: _toggleEditAccount,
            isEditing: _isEditingAccount,
          ),
          const SizedBox(height: 20),
          _buildInfoCard(
            context,
            'Contact Details',
            _isEditingContact
                ? [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(
                  label: 'Address',
                  controller: _addressController,
                  prefixIcon: Icons.location_on,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(
                  label: 'Website',
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                  prefixIcon: Icons.language,
                ),
              ),
            ]
                : [
              _buildInfoItem(context, 'Phone Number', _userData['phone'] ?? 'N/A'),
              _buildInfoItem(context, 'Address', _userData['address'] ?? 'N/A'),
              _buildInfoItem(context, 'Website', _userData['website'] ?? 'N/A'),
            ],
            onEdit: _toggleEditContact,
            isEditing: _isEditingContact,
          ),
          const SizedBox(height: 20),
          _buildInfoCard(
            context,
            'About Me',
            _isEditingAbout
                ? [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _aboutMeController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.brightness == Brightness.dark
                            ? Colors.grey[700]!
                            : Colors.grey[300]!,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[100],
                  ),
                ),
              ),
            ]
                : [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _userData['aboutMe'] ?? 'Flutter developer with a passion for creating beautiful and functional mobile applications.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
            onEdit: _toggleEditAbout,
            isEditing: _isEditingAbout,
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: 'Log Out',
            isOutlined: true,
            backgroundColor: Colors.transparent,
            textColor: Colors.red,
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                      (route) => false,
                );
              }
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context,
      String title,
      List<Widget> children,
      {Function? onEdit,
        bool isEditing = false}
      ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    icon: Icon(
                      isEditing ? Icons.save_outlined : Icons.edit_outlined,
                      size: 20,
                    ),
                    onPressed: () => onEdit(),
                  ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}