import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:amazon_clone/core/models/user_profile.dart';
import 'package:amazon_clone/core/services/preference_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late final PreferenceService _preferenceService;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _preferenceService = PreferenceServiceFactory.create();
    _loadThemePreference();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneController = TextEditingController(text: widget.userProfile.phoneNumber);
  }

  Future<void> _loadThemePreference() async {
    final isDark = await _preferenceService.getIsDarkMode();
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    try {
      await HapticFeedback.lightImpact();
      // Save changes logic
      Navigator.pop(context);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        backgroundColor: isDarkMode
            ? AppTheme.darkTheme.scaffoldBackgroundColor
            : AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? AppTheme.darkTheme.scaffoldBackgroundColor
              : AppTheme.lightTheme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: isDarkMode
                ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                : AppTheme.lightTheme.textTheme.bodyMedium?.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyLarge?.color
                  : AppTheme.lightTheme.textTheme.bodyLarge?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _saveChanges,
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isDarkMode
                      ? AppTheme.darkTheme.primaryColor
                      : AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed',
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDarkMode
                                  ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                                  : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? (AppTheme.darkTheme.textTheme.bodyMedium?.color ?? Colors.white).withAlpha(127)
                                    : (AppTheme.lightTheme.textTheme.bodyMedium?.color ?? Colors.black).withAlpha(127),
                              ),
                            ),

                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppTheme.darkTheme.primaryColor
                                    : AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isDarkMode
                                ? AppTheme.darkTheme.textTheme.bodyLarge?.color
                                : AppTheme.lightTheme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDarkMode
                                  ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                                  : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? (AppTheme.darkTheme.textTheme.bodyMedium?.color ?? Colors.white).withAlpha(127)
                                    : (AppTheme.lightTheme.textTheme.bodyMedium?.color ?? Colors.black).withAlpha(127),
                              ),
                            ),

                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppTheme.darkTheme.primaryColor
                                    : AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isDarkMode
                                ? AppTheme.darkTheme.textTheme.bodyLarge?.color
                                : AppTheme.lightTheme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDarkMode
                                  ? AppTheme.darkTheme.textTheme.bodyMedium?.color
                                  : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? (AppTheme.darkTheme.textTheme.bodyMedium?.color ?? Colors.white).withAlpha(127)
                                    : (AppTheme.lightTheme.textTheme.bodyMedium?.color ?? Colors.black).withAlpha(127),
                              ),
                            ),

                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppTheme.darkTheme.primaryColor
                                    : AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isDarkMode
                                ? AppTheme.darkTheme.textTheme.bodyLarge?.color
                                : AppTheme.lightTheme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? AppTheme.darkTheme.primaryColor
                                : AppTheme.lightTheme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                            textStyle: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: _saveChanges,
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}