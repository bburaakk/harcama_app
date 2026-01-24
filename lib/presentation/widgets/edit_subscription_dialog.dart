import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/subscription.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/notifiers/currency_notifier.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class EditSubscriptionDialog extends StatefulWidget {
  final Subscription subscription;
  
  const EditSubscriptionDialog({
    super.key,
    required this.subscription,
  });

  @override
  State<EditSubscriptionDialog> createState() => _EditSubscriptionDialogState();
}

class _EditSubscriptionDialogState extends State<EditSubscriptionDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  late String selectedIcon;
  late String selectedColor;
  late SubscriptionFrequency selectedFrequency;
  late int? selectedBillingDay;

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
    nameController = TextEditingController(text: widget.subscription.name);
    descriptionController = TextEditingController(text: widget.subscription.description);
    amountController = TextEditingController(text: widget.subscription.amount.toString());
    selectedIcon = widget.subscription.icon;
    selectedColor = widget.subscription.color;
    selectedFrequency = widget.subscription.frequency;
    selectedBillingDay = widget.subscription.billingDay;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Aboneliği Düzenle',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text(context),
                      ),
                    ),
                    PressableContainer(
                      onPressed: () => _showDeleteDialog(),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.2), width: 2),
                      ),
                      child: Icon(
                        Symbols.delete_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
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
                            child: DropdownButtonFormField<SubscriptionFrequency>(
                              value: selectedFrequency,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              dropdownColor: AppColors.card(context),
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontWeight: FontWeight.w600,
                              ),
                              items: SubscriptionFrequency.values.map((frequency) {
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
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
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
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
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
                        onPressed: _updateSubscription,
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
                            'Güncelle',
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

  void _updateSubscription() {
    if (nameController.text.trim().isEmpty || amountController.text.trim().isEmpty) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir tutar girin')),
      );
      return;
    }

    final updatedSubscription = widget.subscription.copyWith(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      amount: amount,
      frequency: selectedFrequency,
      icon: selectedIcon,
      color: selectedColor,
      billingDay: selectedBillingDay,
      updatedAt: DateTime.now(),
    );

    Navigator.of(context).pop(updatedSubscription);
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card(context),
        title: Text(
          'Aboneliği Sil',
          style: TextStyle(
            color: AppColors.text(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          '${widget.subscription.name} aboneliğini silmek istediğinizden emin misiniz?',
          style: TextStyle(
            color: AppColors.subtitleText(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'İptal',
              style: TextStyle(
                color: AppColors.subtitleText(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close delete dialog
              Navigator.of(context).pop('delete'); // Close edit dialog with delete result
            },
            child: const Text(
              'Sil',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}