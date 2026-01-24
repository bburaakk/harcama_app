import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/subscription.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/notifiers/currency_notifier.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class CreateSubscriptionDialog extends StatefulWidget {
  const CreateSubscriptionDialog({super.key});

  @override
  State<CreateSubscriptionDialog> createState() =>
      _CreateSubscriptionDialogState();
}

class _CreateSubscriptionDialogState extends State<CreateSubscriptionDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  String selectedIcon = '🔄'; // Default icon
  String selectedColor = 'blue'; // Default color
  SubscriptionFrequency selectedFrequency = SubscriptionFrequency.monthly;
  DateTime selectedStartDate = DateTime.now();
  int? selectedBillingDay;

  // Available icons for subscriptions
  final List<String> icons = [
    '🔄',
    '📱',
    '💻',
    '🎵',
    '🎬',
    '☁️',
    '🎮',
    '📺',
    '💳',
    '🏋️',
    '📰',
    '🍕',
  ];

  // Available colors
  final List<String> colors = [
    'blue',
    'purple',
    'orange',
    'green',
    'red',
    'yellow',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currencySymbol = context.watch<CurrencyNotifier>().currencySymbol;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(32),
          border: Border(
            top: BorderSide(color: AppColors.cardBorder(context), width: 2),
            left: BorderSide(color: AppColors.cardBorder(context), width: 2),
            right: BorderSide(color: AppColors.cardBorder(context), width: 2),
            bottom: BorderSide(color: AppColors.cardBorder(context), width: 6),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Center(
                  child: Text(
                    'Yeni Abonelik',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text(context),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Name Field
                Text(
                  'Abonelik Adı',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.progressBackground(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cardBorder(context),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Netflix, Spotify, vb.',
                      hintStyle: TextStyle(
                        color: AppColors.subtitleText(context),
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Amount and Frequency
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tutar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.progressBackground(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.cardBorder(context),
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: TextStyle(
                                  color: AppColors.subtitleText(context),
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                prefixText: '$currencySymbol ',
                                prefixStyle: TextStyle(
                                  color: AppColors.text(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sıklık',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.progressBackground(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.cardBorder(context),
                                width: 2,
                              ),
                            ),
                            child:
                                DropdownButtonFormField<SubscriptionFrequency>(
                                  value: selectedFrequency,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  dropdownColor: AppColors.card(context),
                                  style: TextStyle(
                                    color: AppColors.text(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  items: SubscriptionFrequency.values.map((
                                    frequency,
                                  ) {
                                    String text;
                                    switch (frequency) {
                                      case SubscriptionFrequency.daily:
                                        text = 'Günlük';
                                        break;
                                      case SubscriptionFrequency.weekly:
                                        text = 'Haftalık';
                                        break;
                                      case SubscriptionFrequency.monthly:
                                        text = 'Aylık';
                                        break;
                                      case SubscriptionFrequency.yearly:
                                        text = 'Yıllık';
                                        break;
                                    }
                                    return DropdownMenuItem(
                                      value: frequency,
                                      child: Text(text),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedFrequency = value;
                                        selectedBillingDay = null; // Reset billing day when frequency changes
                                      });
                                    }
                                  },
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Billing Day Selection (only show for weekly, monthly, yearly)
                if (selectedFrequency != SubscriptionFrequency.daily) ...[
                  Text(
                    _getBillingDayLabel(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.progressBackground(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.cardBorder(context),
                        width: 2,
                      ),
                    ),
                    child: DropdownButtonFormField<int>(
                      value: selectedBillingDay,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      dropdownColor: AppColors.card(context),
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontWeight: FontWeight.w600,
                      ),
                      hint: Text(
                        _getBillingDayHint(),
                        style: TextStyle(
                          color: AppColors.subtitleText(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      items: _getBillingDayOptions(),
                      onChanged: (value) {
                        setState(() {
                          selectedBillingDay = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Description Field
                Text(
                  'Açıklama (İsteğe Bağlı)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.progressBackground(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cardBorder(context),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Premium plan, aile paketi vb.',
                      hintStyle: TextStyle(
                        color: AppColors.subtitleText(context),
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Icon Selection
                Text(
                  'İkon Seç',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: icons.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final icon = icons[index];
                      final isSelected = selectedIcon == icon;
                      return PressableContainer(
                        onPressed: () {
                          setState(() {
                            selectedIcon = icon;
                          });
                        },
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.2)
                              : AppColors.progressBackground(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.cardBorder(context),
                            width: 2,
                          ),
                        ),
                        child: Text(icon, style: const TextStyle(fontSize: 20)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Color Selection
                Text(
                  'Renk Seç',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final colorName = colors[index];
                      final isSelected = selectedColor == colorName;
                      Color color;
                      switch (colorName) {
                        case 'blue':
                          color = AppColors.secondaryBlue;
                          break;
                        case 'purple':
                          color = AppColors.primary;
                          break;
                        case 'orange':
                          color = AppColors.secondaryYellow;
                          break;
                        case 'green':
                          color = Colors.green;
                          break;
                        case 'red':
                          color = Colors.red;
                          break;
                        case 'yellow':
                          color = AppColors.secondaryYellow;
                          break;
                        default:
                          color = AppColors.primary;
                      }

                      return PressableContainer(
                        onPressed: () {
                          setState(() {
                            selectedColor = colorName;
                          });
                        },
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? color : color.withOpacity(0.3),
                            width: isSelected ? 3 : 2,
                          ),
                        ),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: PressableContainer(
                        onPressed: () => Navigator.of(context).pop(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.progressBackground(context),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.cardBorder(context),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'İptal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.subtitleText(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PressableContainer(
                        onPressed: _createSubscription,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryDark,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Oluştur',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
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
      ),
    );
  }

  void _createSubscription() {
    if (nameController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm gerekli alanları doldurun')),
      );
      return;
    }

    // Validate billing day for non-daily frequencies
    if (selectedFrequency != SubscriptionFrequency.daily && selectedBillingDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getBillingDayValidationMessage())),
      );
      return;
    }

    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Geçerli bir tutar girin')));
      return;
    }

    final subscription = Subscription(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      amount: amount,
      frequency: selectedFrequency,
      startDate: selectedStartDate,
      nextBillingDate: _calculateNextBillingDate(
        selectedStartDate,
        selectedFrequency,
        selectedBillingDay,
      ),
      status: SubscriptionStatus.active,
      icon: selectedIcon,
      color: selectedColor,
      billingDay: selectedBillingDay,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.of(context).pop(subscription);
  }

  String _getBillingDayLabel() {
    switch (selectedFrequency) {
      case SubscriptionFrequency.weekly:
        return 'Hangi Gün';
      case SubscriptionFrequency.monthly:
        return 'Ayın Kaçı';
      case SubscriptionFrequency.yearly:
        return 'Hangi Tarih';
      default:
        return '';
    }
  }

  String _getBillingDayHint() {
    switch (selectedFrequency) {
      case SubscriptionFrequency.weekly:
        return 'Haftanın gününü seçin';
      case SubscriptionFrequency.monthly:
        return 'Ayın kaçında kesilsin';
      case SubscriptionFrequency.yearly:
        return 'Hangi tarihte kesilsin';
      default:
        return '';
    }
  }

  String _getBillingDayValidationMessage() {
    switch (selectedFrequency) {
      case SubscriptionFrequency.weekly:
        return 'Lütfen haftanın gününü seçin';
      case SubscriptionFrequency.monthly:
        return 'Lütfen ayın kaçında kesilmesini istediğinizi seçin';
      case SubscriptionFrequency.yearly:
        return 'Lütfen hangi tarihte kesilmesini istediğinizi seçin';
      default:
        return '';
    }
  }

  List<DropdownMenuItem<int>> _getBillingDayOptions() {
    switch (selectedFrequency) {
      case SubscriptionFrequency.weekly:
        return [
          const DropdownMenuItem(value: 1, child: Text('Pazartesi')),
          const DropdownMenuItem(value: 2, child: Text('Salı')),
          const DropdownMenuItem(value: 3, child: Text('Çarşamba')),
          const DropdownMenuItem(value: 4, child: Text('Perşembe')),
          const DropdownMenuItem(value: 5, child: Text('Cuma')),
          const DropdownMenuItem(value: 6, child: Text('Cumartesi')),
          const DropdownMenuItem(value: 7, child: Text('Pazar')),
        ];
      case SubscriptionFrequency.monthly:
        return List.generate(31, (index) {
          final day = index + 1;
          return DropdownMenuItem(
            value: day,
            child: Text('$day'),
          );
        });
      case SubscriptionFrequency.yearly:
        // For yearly, we'll use month-day format
        final months = [
          'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
          'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
        ];
        List<DropdownMenuItem<int>> items = [];
        for (int month = 1; month <= 12; month++) {
          final daysInMonth = DateTime(DateTime.now().year, month + 1, 0).day;
          for (int day = 1; day <= daysInMonth; day++) {
            final dayOfYear = DateTime(DateTime.now().year, month, day).difference(
              DateTime(DateTime.now().year, 1, 1)
            ).inDays + 1;
            items.add(DropdownMenuItem(
              value: dayOfYear,
              child: Text('$day ${months[month - 1]}'),
            ));
          }
        }
        return items;
      default:
        return [];
    }
  }

  DateTime _calculateNextBillingDate(
    DateTime startDate,
    SubscriptionFrequency frequency,
    int? billingDay,
  ) {
    switch (frequency) {
      case SubscriptionFrequency.daily:
        return startDate.add(const Duration(days: 1));
      case SubscriptionFrequency.weekly:
        if (billingDay != null) {
          return _getNextWeekday(startDate, billingDay);
        }
        return startDate.add(const Duration(days: 7));
      case SubscriptionFrequency.monthly:
        if (billingDay != null) {
          return _getNextMonthlyDate(startDate, billingDay);
        }
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
      case SubscriptionFrequency.yearly:
        if (billingDay != null) {
          return _getNextYearlyDate(startDate, billingDay);
        }
        return DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
  }

  DateTime _getNextWeekday(DateTime from, int targetWeekday) {
    final currentWeekday = from.weekday;
    int daysUntilTarget = (targetWeekday - currentWeekday + 7) % 7;
    if (daysUntilTarget == 0) daysUntilTarget = 7; // Next week if today is target day
    return DateTime(from.year, from.month, from.day + daysUntilTarget);
  }

  DateTime _getNextMonthlyDate(DateTime from, int targetDay) {
    DateTime nextDate = DateTime(from.year, from.month, targetDay);
    if (nextDate.isBefore(from) || nextDate.isAtSameMomentAs(from)) {
      nextDate = DateTime(from.year, from.month + 1, targetDay);
    }
    
    // Handle month end edge cases
    while (nextDate.day != targetDay) {
      nextDate = DateTime(nextDate.year, nextDate.month + 1, targetDay);
    }
    
    return nextDate;
  }

  DateTime _getNextYearlyDate(DateTime from, int targetDayOfYear) {
    final currentYear = from.year;
    final targetDate = DateTime(currentYear, 1, 1).add(Duration(days: targetDayOfYear - 1));
    
    if (targetDate.isBefore(from) || targetDate.isAtSameMomentAs(from)) {
      return DateTime(currentYear + 1, 1, 1).add(Duration(days: targetDayOfYear - 1));
    }
    
    return targetDate;
  }
}
