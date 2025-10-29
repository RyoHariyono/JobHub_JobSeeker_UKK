import 'dart:io';
import 'package:dashed_border/dashed_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/shared/widgets/notification.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UploadCvPage extends StatefulWidget {
  const UploadCvPage({super.key});

  @override
  State<UploadCvPage> createState() => _UploadCvPageState();
}

class _UploadCvPageState extends State<UploadCvPage> {
  String? _selectedFileName;
  String? _confirmedFileName;
  bool _isConfirmed = false;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'PDF'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final ext = (file.extension ?? '').toLowerCase();
        if (ext != 'pdf') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Please select a PDF file.')));
          return;
        }

        setState(() {
          _selectedFileName = file.name;
          _isConfirmed = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick file')));
    }
  }

  void _onEditPressed() {
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
                    "Are you sure to upload this CV?",
                    style: TextStyle(
                      fontSize: screenWidth > 360 ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Don't worry, you can change your CV later.",
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
                              _confirmedFileName = _selectedFileName;
                              _isConfirmed = true;
                              _selectedFileName = null;
                            });

                            Navigator.of(context).pop();

                            AppToast.showSuccess(
                              context,
                              title: 'CV uploaded successfully!',
                              description:
                                  'Your new CV has been uploaded and is now visible to employers.',
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
  Widget build(BuildContext context) {
    final hasNewFile =
        _selectedFileName != null && _selectedFileName!.isNotEmpty;
    final hasConfirmedFile =
        _confirmedFileName != null && _confirmedFileName!.isNotEmpty;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizing
    final uploadContainerPadding =
        screenHeight > 700 ? 60.0 : screenHeight * 0.08;
    final iconSize = screenWidth > 360 ? 25.0 : 22.0;
    final uploadTextSize = screenWidth > 360 ? 12.0 : 11.0;
    final titleTextSize = screenWidth > 360 ? 14.0 : 13.0;
    final subtitleTextSize = screenWidth > 360 ? 12.0 : 11.0;
    final cardIconSize = screenWidth > 360 ? 24.0 : 22.0;
    final cardTextSize = screenWidth > 360 ? 14.0 : 13.0;
    final buttonTextSize = screenWidth > 360 ? 16.0 : 14.0;
    final appBarTextSize = screenWidth > 360 ? 16.0 : 15.0;
    final spacingAfterUpload = screenHeight > 700 ? 50.0 : screenHeight * 0.06;

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
          "Upload CV",
          style: TextStyle(
            fontSize: appBarTextSize,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: uploadContainerPadding,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        hasNewFile ? AppColors.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        hasNewFile
                            ? null
                            : DashedBorder(
                              color: AppColors.primaryBlue,
                              width: 2.0,
                              dashLength: 20.0,
                              dashGap: 15.0,
                            ),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.upload,
                          size: iconSize,
                          color:
                              hasNewFile ? Colors.white : AppColors.mediumGrey,
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            hasNewFile
                                ? _selectedFileName!
                                : "Drop your CV or \nupload from your device",
                            style: TextStyle(
                              fontSize: uploadTextSize,
                              fontWeight: FontWeight.w500,
                              color:
                                  hasNewFile
                                      ? Colors.white
                                      : AppColors.darkGrey,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacingAfterUpload),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your CV",
                    style: TextStyle(
                      fontSize: titleTextSize,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "right now",
                    style: TextStyle(
                      fontSize: subtitleTextSize,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF5F7394).withOpacity(0.10),
                      offset: Offset(2, 2),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.clipboardType,
                      size: cardIconSize,
                      color: AppColors.primaryBlue,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hasConfirmedFile
                            ? _confirmedFileName!
                            : 'No CV uploaded',
                        style: TextStyle(
                          fontSize: cardTextSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(35, 40, 35, 50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                hasNewFile ? AppColors.primaryBlue : Color(0xFFF3F4F6),
            padding: EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: hasNewFile ? _onEditPressed : null,
          child: Text(
            hasNewFile ? 'Upload CV' : 'Select your CV',
            style: TextStyle(
              fontSize: buttonTextSize,
              fontWeight: FontWeight.w600,
              color: hasNewFile ? Colors.white : Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}
