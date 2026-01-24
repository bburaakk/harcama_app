import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/l10n/app_localizations.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late PageController _pageController;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  final int _initialPage = 1200;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate;
    _focusedDay = widget.initialDate;
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getDateFromIndex(int index) {
    final base = widget.initialDate;
    return DateTime(base.year, base.month + (index - _initialPage));
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.subtitleText(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: Text(
                DateFormat('MMMM yyyy', locale).format(_focusedDay),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text(context),
                ),
              ),
            ),
          ),

          // Calendar PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _focusedDay = _getDateFromIndex(index);
                });
              },
              itemBuilder: (context, index) {
                final monthDate = _getDateFromIndex(index);
                return _buildMonthPage(context, monthDate);
              },
            ),
          ),
          
          // Apply Button Footer
          Container(
            padding: EdgeInsets.only(
              left: 24, 
              right: 24, 
              top: 16,
              bottom: 24 + MediaQuery.of(context).padding.bottom
            ),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              border: Border(
                top: BorderSide(
                  color: AppColors.cardBorder(context),
                  width: 1,
                ),
              ),
            ),
            child: PressableContainer(
              onPressed: () {
                Navigator.pop(context, _selectedDay);
              },
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  l10n.applySelection,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthPage(BuildContext context, DateTime monthDate) {
    final locale = Localizations.localeOf(context).toString();
    final knownSunday = DateTime(2024, 1, 7); 
    final weekDays = List.generate(7, (index) {
      return DateFormat.E(locale).format(knownSunday.add(Duration(days: index)));
    });

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((day) => 
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 48) / 7,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.subtitleText(context),
                      letterSpacing: 1,
                    ),
                  ),
                )
              ).toList(),
            ),
            const SizedBox(height: 12),
            
            // Days grid
            _buildCalendarGrid(context, monthDate),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, DateTime monthDate) {
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final firstDayOfWeek = DateTime(monthDate.year, monthDate.month, 1).weekday % 7;
    final prevMonthDays = DateTime(monthDate.year, monthDate.month, 0).day;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadowColor = isDark ? AppColors.cardBorder(context) : AppColors.cardShadowLight;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        // Previous month days
        if (index < firstDayOfWeek) {
          final day = prevMonthDays - (firstDayOfWeek - index - 1);
          return Center(
            child: Text(
              '$day',
              style: TextStyle(
                color: AppColors.subtitleText(context).withOpacity(0.3),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
        }
        
        // Current month days
        final day = index - firstDayOfWeek + 1;
        if (day <= daysInMonth) {
          final currentDate = DateTime(monthDate.year, monthDate.month, day);
          final isSelected = isSameDay(_selectedDay, currentDate);
          final isToday = isSameDay(DateTime.now(), currentDate);
          
          // Check bounds
          if (currentDate.isBefore(widget.firstDate) || currentDate.isAfter(widget.lastDate)) {
             return Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: AppColors.subtitleText(context).withOpacity(0.3),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              );
          }

          return PressableContainer(
            onPressed: () {
              setState(() {
                _selectedDay = currentDate;
              });
            },
            padding: EdgeInsets.zero,
            pressOffset: 4,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.card(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : (isToday ? AppColors.primary.withOpacity(0.5) : AppColors.cardBorder(context)),
                width: isToday ? 2 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? AppColors.primaryDark : shadowColor,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.text(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }
        
        // Next month days
        final nextMonthDay = day - daysInMonth;
        return Center(
          child: Text(
            '$nextMonthDay',
            style: TextStyle(
              color: AppColors.subtitleText(context).withOpacity(0.3),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}
