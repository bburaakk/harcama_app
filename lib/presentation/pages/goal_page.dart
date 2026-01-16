import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/widgets/create_goal_dialog.dart';
import 'package:harcama_app/presentation/notifiers/goal_notifier.dart';
import 'package:harcama_app/domain/entities/goal.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  @override
  Widget build(BuildContext context) {
    final goalNotifier = context.watch<GoalNotifier>();
    final goals = goalNotifier.goals;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                l10n.youHaveActiveGoals(goals.length),
                style: TextStyle(
                  color: AppColors.text(context),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.youreDoingGreat,
                style: TextStyle(
                  color: AppColors.subtitleText(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      context: context,
                      icon: Symbols.analytics_rounded,
                      title: l10n.totalProgress,
                      value: '${(goalNotifier.totalProgress * 100).toInt()}%',
                      subtitle: l10n.thisWeekProgress,
                      backgroundColor: AppColors.secondaryBlue.withOpacity(0.1),
                      borderColor: AppColors.secondaryBlue.withOpacity(0.2),
                      iconColor: AppColors.secondaryBlue,
                      subtitleColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      context: context,
                      icon: Symbols.local_fire_department_rounded,
                      title: l10n.activeStreak,
                      value: '${goalNotifier.activeStreakDays} ${l10n.days}',
                      subtitle: l10n.keepTheFireBurning,
                      backgroundColor: AppColors.secondaryYellow.withOpacity(
                        0.1,
                      ),
                      borderColor: AppColors.secondaryYellow.withOpacity(0.2),
                      iconColor: Colors.orange,
                      subtitleColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                l10n.yourGoals,
                style: TextStyle(
                  color: AppColors.text(context),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              // Goal Cards Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 80,
                ),
                itemCount: goals.length + 1, // +1 for add goal card
                itemBuilder: (context, index) {
                  if (index == goals.length) {
                    // Add Goal Card
                    return _addGoalCard(context);
                  }
                  final goal = goals[index];
                  return _goalCard(context: context, goal: goal);
                },
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color backgroundColor,
    required Color borderColor,
    required Color iconColor,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.text(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppColors.text(context),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalCard({required BuildContext context, required Goal goal}) {
    // Icon mapping
    final iconMap = {
      '🏖️': Symbols.beach_access_rounded,
      '🛡️': Symbols.shield_with_heart_rounded,
      '💻': Symbols.laptop_mac_rounded,
      '🚗': Symbols.directions_car_rounded,
      '🏠': Symbols.home_rounded,
      '🎯': Symbols.target_rounded,
    };

    // Color mapping
    final colorMap = {
      'orange': AppColors.secondaryYellow,
      'blue': AppColors.secondaryBlue,
      'purple': AppColors.primary,
      'green': AppColors.primary,
      'red': Colors.red,
      'yellow': AppColors.secondaryYellow,
    };

    final iconData = iconMap[goal.icon] ?? Symbols.target_rounded;
    final color = colorMap[goal.color] ?? AppColors.primary;
    final colorDark = color == AppColors.primary
        ? AppColors.primaryDark
        : color == AppColors.secondaryYellow
        ? AppColors.secondaryYellowDark
        : color == AppColors.secondaryBlue
        ? AppColors.secondaryBlueDark
        : color;

    return PressableContainer(
      onPressed: () {},
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.card(context),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.cardShadow(context),
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: colorDark, size: 20, weight: 700),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    goal.title.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.subtitleText(context),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "₺${goal.currentAmount.toStringAsFixed(0)}/₺${goal.targetAmount.toStringAsFixed(0)}",
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.progressBackground(context),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: goal.progress,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addGoalCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PressableContainer(
      onPressed: () async {
        final result = await showDialog<Goal>(
          context: context,
          builder: (context) => const CreateGoalDialog(),
        );

        if (result != null) {
          context.read<GoalNotifier>().addItem(result);
        }
      },
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.progressBackground(context).withOpacity(0.5),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            color: AppColors.subtitleText(context),
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.newGoal,
            style: TextStyle(
              color: AppColors.subtitleText(context),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
