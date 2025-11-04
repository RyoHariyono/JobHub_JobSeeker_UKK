import 'package:flutter/material.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const CustomDropdown({
    Key? key,
    this.value,
    required this.items,
    required this.hintText,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
            );
          }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.mediumGrey,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.darkGrey,
      ),
      dropdownColor: Colors.white,
    );
  }
}

// Birthday Input Component with Interactive Dropdowns
class BirthdayInput extends StatefulWidget {
  final void Function(String? day, String? month, String? year)? onChanged;
  final String? initialDay;
  final String? initialMonth;
  final String? initialYear;

  const BirthdayInput({
    Key? key,
    this.onChanged,
    this.initialDay,
    this.initialMonth,
    this.initialYear,
  }) : super(key: key);

  @override
  State<BirthdayInput> createState() => _BirthdayInputState();
}

class _BirthdayInputState extends State<BirthdayInput> {
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  // Month list
  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // Days per month
  final Map<String, int> daysInMonth = {
    'Januari': 31,
    'Februari': 29,
    'Maret': 31,
    'April': 30,
    'Mei': 31,
    'Juni': 30,
    'Juli': 31,
    'Agustus': 31,
    'September': 30,
    'Oktober': 31,
    'November': 30,
    'Desember': 31,
  };

  // Generate day list berdasarkan bulan yang dipilih
  List<String> get days {
    int maxDays = 31;
    if (selectedMonth != null && daysInMonth.containsKey(selectedMonth)) {
      maxDays = daysInMonth[selectedMonth]!;
    }
    return List.generate(maxDays, (i) => (i + 1).toString().padLeft(2, '0'));
  }

  // Generate year list (1950-current year)
  List<String> get years {
    final currentYear = DateTime.now().year;
    return List.generate(
      currentYear - 1950 + 1,
      (i) => (1950 + i).toString(),
    ).reversed.toList();
  }

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDay;
    selectedMonth = widget.initialMonth;
    selectedYear = widget.initialYear;
  }

  void _onValueChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(selectedDay, selectedMonth, selectedYear);
    }
  }

  InputDecoration _buildDropdownDecoration({String? hintText}) {
    return InputDecoration(
      fillColor: Colors.transparent,
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 14,
        color: AppColors.mediumGrey,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EAED), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EAED), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EAED), width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      errorStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFFEF4444),
        fontWeight: FontWeight.w500,
        height: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your birthday',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.mediumGrey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Day Dropdown
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value:
                    selectedDay != null && days.contains(selectedDay)
                        ? selectedDay
                        : null,
                items:
                    days
                        .map(
                          (day) => DropdownMenuItem(
                            value: day,
                            alignment: Alignment.center,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDay = value;
                  });
                  _onValueChanged();
                },
                decoration: _buildDropdownDecoration(hintText: 'Day'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                ),
                alignment: Alignment.center,
                icon: const SizedBox.shrink(),
                isExpanded: true,
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 15),
            // Month Dropdown
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String>(
                value: selectedMonth,
                items:
                    months
                        .map(
                          (month) => DropdownMenuItem(
                            value: month,
                            alignment: Alignment.center,
                            child: Text(
                              month,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value;
                    // Reset day if it exceeds the days in the selected month
                    if (selectedDay != null &&
                        int.parse(selectedDay!) > (daysInMonth[value] ?? 31)) {
                      selectedDay = null;
                    }
                  });
                  _onValueChanged();
                },
                decoration: _buildDropdownDecoration(hintText: 'Month'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                ),
                alignment: Alignment.center,
                icon: const SizedBox.shrink(),
                isExpanded: true,
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 15),
            // Year Dropdown
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value: selectedYear,
                items:
                    years
                        .map(
                          (year) => DropdownMenuItem(
                            value: year,
                            alignment: Alignment.center,
                            child: Text(
                              year,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedYear = value;
                  });
                  _onValueChanged();
                },
                decoration: _buildDropdownDecoration(hintText: 'Year'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                ),
                alignment: Alignment.center,
                icon: const SizedBox.shrink(),
                isExpanded: true,

                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
