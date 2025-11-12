import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

  Widget _devider() {
    return Column(
      children: [
        SizedBox(height: 25),
        Divider(height: 0, color: Color(0xFFE5E7EB)),
        SizedBox(height: 25),
      ],
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final institutions = [
          'Universitas Indonesia',
          'Institut Teknologi Bandung',
          'Universitas Gadjah Mada',
          'Institut Teknologi Sepuluh Nopember',
          'Universitas Diponegoro',
          'Universitas Airlangga',
          'Universitas Padjadjaran',
          'Universitas Brawijaya',
          'Universitas Hasanuddin',
          'SMK Telkom Malang',
          'SMA Negeri 1 Jakarta',
          'Lainnya',
        ];

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
                      institutions.map((institution) {
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final major = [
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
        ];

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
                      major.map((major) {
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
          onPressed: () => context.go('/education'),
        ),
        title: Text(
          "Add Education",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 35),
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
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFF3F4F6),
                        ),
                        child: Text(
                          "SMP",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFF3F4F6),
                        ),
                        child: Text(
                          "SMA/SMK",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFF3F4F6),
                        ),
                        child: Text(
                          "D3",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryBlue,
                        ),
                        child: Text(
                          "S1",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFF3F4F6),
                        ),
                        child: Text(
                          "S2",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFF3F4F6),
                        ),
                        child: Text(
                          "S3",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
                    _showInstitutionPicker,
                  ),
                  _buildInputField(
                    'Major',
                    selectedMajor ?? 'Choose major',
                    _showMajorPicker,
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
                    Text(
                      'Are you still studying here?',
                      style: TextStyle(
                        fontSize: _getBodyFontSize(context),
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
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
                        _buildYearsInput('Period start', yearsStartController),
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
                                    color: Color(0xFF6B7280),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            : _buildYearsInput(
                              'Period end',
                              yearsEndController,
                            ),
                      ],
                    ),
                  ),
                ],
              ),
              _devider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "GPA",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.mediumGrey,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildYearsInput('Your GPA', gpaController),
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: () => context.go('/education/add-education'),
          child: Text(
            "Insert education",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
