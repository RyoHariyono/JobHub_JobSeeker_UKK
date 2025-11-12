import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/bottom_button.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/notification.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Data models
class EducationLevel {
  final String id;
  final String name;
  final List<String> institutions;
  final List<String>? majors;

  EducationLevel({
    required this.id,
    required this.name,
    required this.institutions,
    this.majors,
  });
}

final List<EducationLevel> educationLevels = [
  EducationLevel(
    id: 'smp',
    name: 'SMP',
    institutions: [
      'SMP Negeri 1 Jakarta',
      'SMP Negeri 2 Bandung',
      'SMP Negeri 3 Surabaya',
      'SMP Swasta Al-Azhar',
      'SMP Santa Ursula',
      'Lainnya',
    ],
    majors: null,
  ),
  EducationLevel(
    id: 'sma',
    name: 'SMA/SMK',
    institutions: [
      'SMA Negeri 1 Jakarta',
      'SMA Negeri 3 Bandung',
      'SMK Telkom Malang',
      'SMA Swasta Binus',
      'SMA Santa Ursula',
      'SMK Negeri 1 Surabaya',
      'Lainnya',
    ],
    majors: ['IPA', 'IPS', 'Teknik', 'Akuntansi', 'Lainnya'],
  ),
  EducationLevel(
    id: 'd3',
    name: 'D3',
    institutions: [
      'Politeknik Negeri Jakarta',
      'Politeknik Bandung',
      'Politeknik Surabaya',
      'Politeknik Telkom',
      'Lainnya',
    ],
    majors: [
      'Teknik Informatika',
      'Teknik Elektro',
      'Akuntansi',
      'Manajemen',
      'Lainnya',
    ],
  ),
  EducationLevel(
    id: 's1',
    name: 'S1',
    institutions: [
      'Universitas Indonesia',
      'Institut Teknologi Bandung',
      'Universitas Gadjah Mada',
      'Institut Teknologi Sepuluh Nopember',
      'Universitas Diponegoro',
      'Universitas Airlangga',
      'Universitas Padjadjaran',
      'Universitas Brawijaya',
      'Universitas Hasanuddin',
      'Lainnya',
    ],
    majors: [
      'Teknik Informatika',
      'Sistem Informasi',
      'Teknik Elektro',
      'Manajemen',
      'Akuntansi',
      'Hukum',
      'Kedokteran',
      'Psikologi',
      'Desain Komunikasi Visual',
      'Ilmu Komunikasi',
      'Ekonomi',
      'Lainnya',
    ],
  ),
  EducationLevel(
    id: 's2',
    name: 'S2',
    institutions: [
      'Universitas Indonesia',
      'Institut Teknologi Bandung',
      'Universitas Gadjah Mada',
      'Institut Teknologi Sepuluh Nopember',
      'Lainnya',
    ],
    majors: ['Teknik Informatika', 'Manajemen', 'Hukum', 'Ekonomi', 'Lainnya'],
  ),
  EducationLevel(
    id: 's3',
    name: 'S3',
    institutions: [
      'Universitas Indonesia',
      'Institut Teknologi Bandung',
      'Universitas Gadjah Mada',
      'Lainnya',
    ],
    majors: ['Teknik Informatika', 'Manajemen', 'Ekonomi', 'Lainnya'],
  ),
];

class AddEducationPage extends StatefulWidget {
  const AddEducationPage({super.key});

  @override
  State<AddEducationPage> createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  String? selectedLevel;
  String? selectedInstitution;
  String? selectedMajor;
  bool isCurrentlyStudying = false;

  TextEditingController yearsStartController = TextEditingController();
  TextEditingController yearsEndController = TextEditingController();
  TextEditingController gpaController = TextEditingController();

  EducationLevel? getCurrentLevel() {
    if (selectedLevel == null) return null;
    return educationLevels.firstWhere((level) => level.id == selectedLevel);
  }

  // Responsive methods
  double _getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 18;
    if (width > 600) return 16;
    return 16;
  }

  double _getLabelFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 15;
    if (width > 600) return 14.5;
    return 14;
  }

  double _getBodyFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 14.5;
    if (width > 600) return 13.5;
    return 15;
  }

  bool _isValidYear(String input) {
    if (input.isEmpty) return false;
    final year = int.tryParse(input);
    if (year == null) return false;
    final currentYear = DateTime.now().year;
    return year >= 1900 && year <= currentYear;
  }

  bool _isValidGPA(String input) {
    if (input.isEmpty) return false;
    final gpa = double.tryParse(input);
    if (gpa == null) return false;
    return gpa >= 0 && gpa <= 4;
  }

  bool _isValidForm() {
    bool hasValidPeriod = true;
    if (yearsStartController.text.isNotEmpty &&
        !_isValidYear(yearsStartController.text)) {
      hasValidPeriod = false;
    }
    if (!isCurrentlyStudying &&
        yearsEndController.text.isNotEmpty &&
        !_isValidYear(yearsEndController.text)) {
      hasValidPeriod = false;
    }

    bool hasValidGPA = true;
    if (gpaController.text.isNotEmpty && !_isValidGPA(gpaController.text)) {
      hasValidGPA = false;
    }

    return selectedLevel != null &&
        selectedInstitution != null &&
        (getCurrentLevel()?.majors == null || selectedMajor != null) &&
        hasValidPeriod &&
        hasValidGPA;
  }

  Widget _devider() {
    return Column(
      children: [
        SizedBox(height: 25),
        Divider(height: 0, color: Color(0xFFE5E7EB)),
        SizedBox(height: 25),
      ],
    );
  }

  Widget _buildLevelButton(EducationLevel level) {
    final isSelected = selectedLevel == level.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLevel = level.id;
          selectedInstitution = null;
          selectedMajor = null;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.primaryBlue : Color(0xFFF3F4F6),
        ),
        child: Text(
          level.name,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildYearsInput(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: label,
          hintStyle: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          setState(() {});
        },
        enabled: !(label == 'Period end' && isCurrentlyStudying),
      ),
    );
  }

  Widget _buildInputField(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkGrey,
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: AppColors.mediumGrey, fontSize: 14),
                  ),
                ),
                SizedBox(width: 3),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.mediumGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInstitutionPicker() {
    if (selectedLevel == null) return;
    final level = getCurrentLevel();
    if (level == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Container(
              width: 40,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Pilih Institusi Pendidikan',
              style: TextStyle(
                fontSize: _getTitleFontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(height: 24, thickness: 1, color: Color(0xFFE5E7EB)),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      level.institutions.map((institution) {
                        return ListTile(
                          title: Text(
                            institution,
                            style: TextStyle(
                              fontSize: _getBodyFontSize(context),
                            ),
                          ),
                          onTap: () {
                            setState(() => selectedInstitution = institution);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _showMajorPicker() {
    if (selectedLevel == null) return;
    final level = getCurrentLevel();
    if (level?.majors == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Container(
              width: 40,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Pilih Jurusan Pendidikan',
              style: TextStyle(
                fontSize: _getTitleFontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(height: 24, thickness: 1, color: Color(0xFFE5E7EB)),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      (level?.majors ?? []).map((major) {
                        return ListTile(
                          title: Text(
                            major,
                            style: TextStyle(
                              fontSize: _getBodyFontSize(context),
                            ),
                          ),
                          onTap: () {
                            setState(() => selectedMajor = major);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
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
                    "Are you sure to update your education?",
                    style: TextStyle(
                      fontSize: screenWidth > 360 ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your education information will be updated and visible to employers.",
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
                          onPressed: () => context.go('/education'),
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

  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 120;
    if (width > 768) return 80;
    if (width > 600) return 50;
    return 30;
  }

  double _getButtonFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 768) return 16;
    if (width > 600) return 15.5;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

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
          onPressed: () => context.go('/education'),
        ),
        title: Text(
          "Add Education",
          style: TextStyle(
            fontSize: _getLabelFontSize(context) + 2,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          _getHorizontalPadding(context),
          30,
          _getHorizontalPadding(context),
          35,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Level",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children:
                        educationLevels
                            .map((level) => _buildLevelButton(level))
                            .toList(),
                  ),
                ],
              ),
              _devider(),
              Column(
                spacing: 20,
                children: [
                  _buildInputField(
                    'Institution',
                    selectedInstitution ?? 'Choose institution',
                    selectedLevel == null ? () {} : _showInstitutionPicker,
                  ),
                  if (getCurrentLevel()?.majors != null)
                    _buildInputField(
                      'Major',
                      selectedMajor ?? 'Choose major',
                      selectedLevel == null ? () {} : _showMajorPicker,
                    ),
                ],
              ),
              _devider(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isCurrentlyStudying = !isCurrentlyStudying;
                  });
                },
                child: Row(
                  children: [
                    Transform.translate(
                      offset: Offset(-12, 0),
                      child: Checkbox(
                        value: isCurrentlyStudying,
                        onChanged: (value) {
                          setState(() {
                            isCurrentlyStudying = value ?? false;
                          });
                        },
                        activeColor: AppColors.primaryBlue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Are you still studying here?',
                        style: TextStyle(
                          fontSize: _getBodyFontSize(context),
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _devider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Period start",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.mediumGrey,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildYearsInput('e.g. 2020', yearsStartController),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Period end",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.mediumGrey,
                          ),
                        ),
                        SizedBox(height: 8),
                        isCurrentlyStudying
                            ? Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Now',
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            : _buildYearsInput('e.g. 2024', yearsEndController),
                      ],
                    ),
                  ),
                ],
              ),
              if (isMobile) SizedBox(height: 25),
              if (!isMobile) _devider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          "GPA",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.mediumGrey,
                          ),
                        ),
                        _buildYearsInput('e.g. 3.75', gpaController),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButton(
        label: _isValidForm() ? "Insert education" : "Fill all fields",
        onPressed: _showSuccessDialog,
        isDisabled: !_isValidForm(),
      ),
    );
  }
}
