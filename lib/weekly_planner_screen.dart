import 'package:flutter/material.dart';

class WeeklyPlannerScreen extends StatefulWidget {
  const WeeklyPlannerScreen({super.key});

  @override
  State<WeeklyPlannerScreen> createState() => _WeeklyPlannerScreenState();
}

class _WeeklyPlannerScreenState extends State<WeeklyPlannerScreen> {
  final List<Map<String, dynamic>> _weeklyTasks = [
    {"title": "Team Strategy Meeting", "done": false},
    {"title": "UX Research Session", "done": false},
    {"title": "Client Call", "done": false},
    {"title": "Code Review", "done": false},
    {"title": "Design Mockups", "done": false},
  ];

  void toggleTask(int index, bool? value) {
    setState(() {
      _weeklyTasks[index]["done"] = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: const Text(
          "Your Weekly Planner",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Here's a list of all your upcoming tasks and meetings. Stay organized and keep track of your schedule. Simply check off tasks if you complete them",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _weeklyTasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = _weeklyTasks[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: task["done"],
                        onChanged: (value) => toggleTask(index, value),
                        activeColor: Colors.orange,
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.white38),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task["title"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: task["done"] ? Colors.white38 : Colors.white,
                            decoration: task["done"]
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
