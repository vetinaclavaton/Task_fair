import 'package:flutter/material.dart';
import 'task.dart';
import 'main.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    appState.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    appState.removeListener(_onStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNavBar(context),
              _buildHero(context),
              _buildStepsSection(),
              if (appState.groups.isNotEmpty) _buildMyGroupsSection(context),
              _buildFeatureCards(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Text(
            'TaskFair',
            style: TextStyle(
              color: kPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TaskSetupPage()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: kPrimary.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'New Group',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: _blob(80, kAccent.withValues(alpha: 0.3)),
          ),
          Positioned(
            bottom: -15,
            left: 40,
            child: _blob(60, kSecondary.withValues(alpha: 0.25)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('✨', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 6),
                    Text(
                      'Powered by Shapley Value Theory',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tasks distributed.\nFairly. 🎉',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'TaskFair uses cooperative game theory to assign group work to the most capable member — based on honest skill self-ratings.',
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TaskSetupPage()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Create a Group',
                            style: TextStyle(
                              color: kPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: kPrimary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── My Groups Section ──────────────────────────────────────────────────────
  Widget _buildMyGroupsSection(BuildContext context) {
    final activeGroups = appState.groups
        .where((g) => g.overallProgress < 1.0)
        .toList();
    final doneGroups = appState.groups
        .where((g) => g.overallProgress >= 1.0)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('MY GROUPS (${appState.groups.length})'),
          const SizedBox(height: 14),

          // Active groups
          if (activeGroups.isNotEmpty) ...[
            const Text(
              'IN PROGRESS',
              style: TextStyle(
                color: kTextLight,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            ...activeGroups.map(
              (g) => _groupCard(context, g, isDone: false),
            ),
          ],

          // Done groups
          if (doneGroups.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'COMPLETED',
              style: TextStyle(
                color: kTextLight,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            ...doneGroups.map(
              (g) => _groupCard(context, g, isDone: true),
            ),
          ],
        ],
      ),
    );
  }

  Widget _groupCard(
    BuildContext context,
    GroupSession group, {
    required bool isDone,
  }) {
    final pct = (group.overallProgress * 100).toInt();
    final daysLeft = group.deadline != null
        ? group.deadline!.difference(DateTime.now()).inDays.clamp(0, 99999)
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardPage(
              groupName: group.groupName,
              members: group.members,
              tasks: group.tasks,
              assignments: group.assignments,
              deadline: group.deadline,
              taskDifficulties: group.taskDifficulties,
              initialProgress: group.taskProgress,
              initialActivityLog: group.activityLog,
              sessionIndex: appState.indexOf(group),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDone
                ? const Color(0xFF2D9E7E).withValues(alpha: 0.4)
                : kBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.groupName,
                        style: const TextStyle(
                          color: kTextDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${group.members.length} members · ${group.tasks.length} tasks',
                        style: const TextStyle(
                          color: kTextMid,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDone
                        ? kMint.withValues(alpha: 0.3)
                        : kPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isDone ? '✅ Done' : '$pct%',
                    style: TextStyle(
                      color: isDone ? const Color(0xFF2D9E7E) : kPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: group.overallProgress,
                minHeight: 7,
                backgroundColor: kBorder,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDone ? const Color(0xFF2D9E7E) : kPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Member avatars
                SizedBox(
                  width: 70,
                  height: 22,
                  child: Stack(
                    children: group.members
                        .take(4)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (e) => Positioned(
                            left: e.key * 16.0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: getAvatarColor(
                                  e.key,
                                ).withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: kCard,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  e.value[0].toUpperCase(),
                                  style: TextStyle(
                                    color: getAvatarColor(e.key),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Spacer(),
                if (group.deadline != null)
                  Text(
                    isDone
                        ? 'Completed'
                        : (daysLeft != null ? '$daysLeft days left' : ''),
                    style: TextStyle(
                      color: isDone
                          ? const Color(0xFF2D9E7E)
                          : (daysLeft != null && daysLeft <= 3
                              ? Colors.redAccent
                              : kTextLight),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: kTextLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsSection() {
    final steps = [
      _StepData('01', '👥', 'Group Setup', 'Name your group & add members'),
      _StepData(
        '02',
        '⭐',
        'Rate Skills',
        'Each member rates their ability 1–5 per task',
      ),
      _StepData(
        '03',
        '⚡',
        'Compute',
        'Shapley algorithm calculates fair scores',
      ),
      _StepData('04', '🎯', 'Get Results', 'Best-fit member earns each task'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('HOW IT WORKS'),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                steps.length,
                (i) => Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _stepItem(steps[i])),
                      if (i < steps.length - 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            width: 16,
                            height: 1.5,
                            color: kBorder,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepItem(_StepData s) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: kBg,
            shape: BoxShape.circle,
            border: Border.all(color: kBorder, width: 1.5),
          ),
          child: Center(
            child: Text(s.emoji, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          s.number,
          style: const TextStyle(
            color: kPrimary,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          s.label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kTextDark,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          s.desc,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kTextLight,
            fontSize: 9.5,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCards() {
    final features = [
      _FeatureData(
        '🎓',
        'For Students',
        kMint,
        const Color(0xFF2D9E7E),
        'Perfect for group projects, research papers, presentations, or any team activity.',
      ),
      _FeatureData(
        '⚖️',
        'Provably Fair',
        kPurple,
        const Color(0xFF6B4FCF),
        'Shapley values satisfy efficiency, symmetry & fairness — no manager bias.',
      ),
      _FeatureData(
        '🚀',
        'Instant Results',
        kAccent,
        const Color(0xFFB5750A),
        'Once all ratings are collected, the algorithm runs instantly.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('WHY TASKFAIR'),
          const SizedBox(height: 14),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _featureCard(f),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard(_FeatureData f) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: f.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(f.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.title,
                  style: TextStyle(
                    color: f.color,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  f.desc,
                  style: const TextStyle(
                    color: kTextMid,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: const TextStyle(
      color: kTextLight,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 2.0,
    ),
  );

  Widget _blob(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _StepData {
  final String number, emoji, label, desc;
  const _StepData(this.number, this.emoji, this.label, this.desc);
}

class _FeatureData {
  final String emoji, title, desc;
  final Color bg, color;
  const _FeatureData(this.emoji, this.title, this.bg, this.color, this.desc);
}