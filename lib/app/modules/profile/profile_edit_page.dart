import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/date_input.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/notification.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/textfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // Controllers untuk text fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  // Untuk menyimpan nilai birthday yang dipilih
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  // Untuk menyimpan gender yang dipilih
  String? selectedGender;

  // Track changes
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();

    // Listen to text changes
    _nameController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
    _addressController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges =
          _nameController.text.isNotEmpty ||
          _emailController.text.isNotEmpty ||
          _phoneController.text.isNotEmpty ||
          _addressController.text.isNotEmpty ||
          selectedDay != null ||
          selectedMonth != null ||
          selectedYear != null ||
          selectedGender != null;
    });
  }

  void _onUpdatePressed() {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 400 ? 343.0 : screenWidth * 0.85;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Container(
              width: dialogWidth,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure to update your profile?",
                    style: TextStyle(
                      fontSize: screenWidth > 360 ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your profile information will be updated and visible to employers.",
                    style: TextStyle(
                      fontSize: screenWidth > 360 ? 14 : 12,
                      fontWeight: FontWeight.normal,
                      color: AppColors.mediumGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            setState(() {
                              _hasChanges = false;
                            });

                            Navigator.of(context).pop();

                            AppToast.showSuccess(
                              context,
                              title: 'Profile updated successfully!',
                              description:
                                  'Your profile has been updated and is now visible to employers.',
                            );
                          },
                          child: Text(
                            "I'm sure",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth > 360 ? 14 : 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primaryBlue,
                              width: 2,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: screenWidth > 360 ? 14 : 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: AppColors.darkGrey,
            size: 24,
          ),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 35),
          // Wrap with SingleChildScrollView so content can scroll when keyboard appears
          child: SingleChildScrollView(
            // ensure the scroll view resizes when the keyboard appears
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              spacing: 25,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                CustomTextField(
                  label: "Enter your full name",
                  hintText: "Name",
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: "Enter your email",
                  hintText: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: "Enter your phone number",
                  hintText: "Phone",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: "Enter your address",
                  hintText: "Address",
                  controller: _addressController,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                BirthdayInput(
                  onChanged: (day, month, year) {
                    setState(() {
                      selectedDay = day;
                      selectedMonth = month;
                      selectedYear = year;
                    });
                    _checkForChanges();
                    print('Birthday: $day $month $year');
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mediumGrey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        // Male Radio
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGender = 'Male';
                              });
                              _checkForChanges();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color:
                                    selectedGender == 'Male'
                                        ? AppColors.primaryBlue
                                        : Color(0xFFF3F4F6),
                              ),
                              child: Center(
                                child: Text(
                                  'Male',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        selectedGender == 'Male'
                                            ? Colors.white
                                            : Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        // Female Radio
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedGender = 'Female';
                              });
                              _checkForChanges();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color:
                                    selectedGender == 'Female'
                                        ? AppColors.primaryBlue
                                        : Color(0xFFF3F4F6),
                              ),
                              child: Center(
                                child: Text(
                                  'Female',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        selectedGender == 'Female'
                                            ? Colors.white
                                            : Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(35, 40, 35, 50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _hasChanges ? AppColors.primaryBlue : Color(0xFFF3F4F6),
            padding: EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: _hasChanges ? _onUpdatePressed : null,
          child: Text(
            _hasChanges ? 'Update data' : 'Edit your data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _hasChanges ? Colors.white : Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}
