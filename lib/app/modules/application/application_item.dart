import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jobhub_jobseeker_ukk/core/theme/app_color.dart';
import 'package:jobhub_jobseeker_ukk/data/models/job.dart';

class ApplicationItem extends StatefulWidget {
  final Job job;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  const ApplicationItem({
    Key? key,
    required this.job,
    this.onTap,
    this.onBookmarkTap,
  }) : super(key: key);

  @override
  _ApplicationItemState createState() => _ApplicationItemState();
}

class _ApplicationItemState extends State<ApplicationItem> {
  bool _isExpanded = false;

  String _formatDate(DateTime d) {
    try {
      return DateFormat('dd MMM yyyy').format(d);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return GestureDetector(
      onTap: widget.onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Adapt sizes based on available width without changing page padding
          final maxW = constraints.maxWidth;
          final bool isCompact = maxW < 360;
          final double logoSize = isCompact ? 40 : 48;
          final double titleSize = isCompact ? 13 : 14;
          final double companySize = isCompact ? 11 : 12;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: Color(0xFFE5E7EB), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          job.company.logoUrl,
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                LucideIcons.building,
                                color: Color(0xFF6B7280),
                                size: logoSize * 0.5,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Title & Company
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            job.company.name,
                            style: TextStyle(
                              fontSize: companySize,
                              fontWeight: FontWeight.w400,
                              color: AppColors.mediumGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Bookmark
                    IconButton(
                      icon: Icon(
                        job.isBookmarked
                            ? Icons.bookmark
                            : LucideIcons.bookmark,
                        size: 20,
                        color:
                            job.isBookmarked
                                ? AppColors.red
                                : AppColors.mediumGrey,
                      ),
                      onPressed: widget.onBookmarkTap,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        job.location,
                        style: TextStyle(
                          fontSize: isCompact ? 11 : 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mediumGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '\$${job.minSalary.toStringAsFixed(0)} – \$${job.maxSalary.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: isCompact ? 11 : 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                AnimatedCrossFade(
                  firstChild: SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      Divider(color: Color(0xFFE5E7EB), height: 1),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                LucideIcons.circleCheck,
                                color: AppColors.lightGreen,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Application sent',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.lightGreen,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _formatDate(job.postedDate),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                LucideIcons.clock,
                                color: AppColors.yellow,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Pending',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.yellow,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              'Still being processed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mediumGrey,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  crossFadeState:
                      _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 200),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isExpanded ? 'Close details' : 'Open details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mediumGrey,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          _isExpanded
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          size: 16,
                          color: AppColors.mediumGrey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
