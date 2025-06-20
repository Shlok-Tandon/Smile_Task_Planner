import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'calendar_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String name = "Shlok Tandon";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<Map> taskList = [];
  late TabController _tabController;

  void loadTasks() {
    final box = Hive.box('tasksBox');
    setState(() {
      taskList = box.values.cast<Map>().toList().reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    loadTasks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadTasks();
  }

  void deleteTask(Map task) async {
    final box = Hive.box('tasksBox');
    final keyToDelete = box.keys.firstWhere(
          (key) => box.get(key) == task,
      orElse: () => null,
    );
    if (keyToDelete != null) {
      await box.delete(keyToDelete);
      loadTasks();
    }
  }

  Widget buildTaskCard(Map task, bool isFirst) {
    DateTime dt = DateTime.parse(task['timestamp']);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(dt);
    String formattedTime = DateFormat('hh:mm a').format(dt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFirst ? Colors.orange[700] : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color:Colors.white70
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.alarm),
              const SizedBox(width: 10,),
              Text(
                formattedTime,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color:  Colors.white70
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            task['title'],
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5
            ),
          ),
          const SizedBox(height: 8),
          if (task['meetingLink'] != null && task['meetingLink'].toString().isNotEmpty)
            Row(
              children: [
                const Icon(Icons.link, size: 18, color: Colors.orangeAccent),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    task['meetingLink'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.orangeAccent,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: ()=> deleteTask(task),
              child: const Icon(Icons.delete, color: Colors.red)
            ),
          ),
        ],
      ),
    );
  }


  Widget buildTaskList(List<Map> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text("No tasks yet", style: TextStyle(color: Colors.white54)),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start  ,
                children: [
                  const Text(
                    "All Scheduled",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3
                      ),
                    ),
                  const SizedBox(height: 5),
                  Text(
                    "for Today (${tasks.length})",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3
                      ),
                    ),
                ],
              ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return buildTaskCard(tasks[index], index == 0);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/avatar.png"),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Welcome", style: TextStyle(fontSize: 14, color: Colors.white54)),
                    Text(HomeScreen.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            actions: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CalendarScreen()),
                        );
                      },
                      backgroundColor: Colors.transparent,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 25,),
                    ),

                  ),
                  Positioned(
                    right: 10,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Text("2", style: TextStyle(fontSize: 10, color: Colors.black)),
                    ),
                  ),
                ],
              )
            ],
            bottom: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white
              ),
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: [
                Tab(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24)
                  ),
                  child: const Text('All', style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                  ),
                )
                ),
                Tab(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24)
                  ),
                  child: const Text('Tasks', style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                  ),
                )
                ),
                Tab(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24)
                  ),
                  child: const Text('Notes', style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                  ),
                )
                ),
                Tab(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24)
                  ),
                  child: const Text('Events', style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                  ),
                )
                )
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white38,
              indicatorColor: Colors.orange,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              buildTaskList(taskList),
              buildTaskList(taskList),
              buildTaskList([]),
              buildTaskList([]),
            ],
          ),
        );
  }
}
