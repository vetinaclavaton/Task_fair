import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(const TaskFairApp());

// ─── Global Group State ───────────────────────────────────────────────────────
class GroupSession {
  final String groupName;
  final List<String> members;
  final List<String> tasks;
  final List<int> assignments; // primary assignee per task
  final List<List<int>> multiAssignments; // full multi-assignee
  final DateTime? deadline;
  final List<int> taskDifficulties;
  final List<List<double>> shapleyScores;
  final Map<int, double> taskProgress;
  final List<String> activityLog;
  final bool isComplete;

  GroupSession({
    required this.groupName,
    required this.members,
    required this.tasks,
    required this.assignments,
    required this.multiAssignments,
    required this.deadline,
    required this.taskDifficulties,
    required this.shapleyScores,
    required this.taskProgress,
    required this.activityLog,
    this.isComplete = false,
  });

  GroupSession copyWith({
    Map<int, double>? taskProgress,
    List<String>? activityLog,
    bool? isComplete,
  }) {
    return GroupSession(
      groupName: groupName,
      members: members,
      tasks: tasks,
      assignments: assignments,
      multiAssignments: multiAssignments,
      deadline: deadline,
      taskDifficulties: taskDifficulties,
      shapleyScores: shapleyScores,
      taskProgress: taskProgress ?? this.taskProgress,
      activityLog: activityLog ?? this.activityLog,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  double get overallProgress {
    if (tasks.isEmpty) return 0.0;
    double total = 0.0;
    taskProgress.forEach((_, p) => total += p);
    return total / tasks.length;
  }
}

class AppState extends ChangeNotifier {
  final List<GroupSession> _groups = [];

  List<GroupSession> get groups => List.unmodifiable(_groups);

  void addGroup(GroupSession session) {
    _groups.add(session);
    notifyListeners();
  }

  void updateGroup(int index, GroupSession session) {
    _groups[index] = session;
    notifyListeners();
  }

  int indexOf(GroupSession session) => _groups.indexOf(session);
}

final appState = AppState();

class TaskFairApp extends StatelessWidget {
  const TaskFairApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFair',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        colorScheme: const ColorScheme.light(primary: Color(0xFFFF8C69)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}