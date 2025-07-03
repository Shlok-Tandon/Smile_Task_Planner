import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_task_screen.dart';
import 'weekly_planner_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  int _targetIndex = 0;
  bool _isAnimating = false;

  void _handleTaskSaved() {
    setState(() {
      _currentIndex = 0;
      _targetIndex = 0;
    });
  }

  late final List<Map<String, dynamic>> _screens = [
    {'screen': const HomeScreen(), 'key': 'home'},
    {'screen': AddTaskScreen(onSave: _handleTaskSaved), 'key': 'add'},
    {'screen': const WeeklyPlannerScreen(), 'key': 'calendar'},
  ];

  void _animateToIndex(int index) {
    setState(() {
      _targetIndex = index;
      _isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _currentIndex = index;
          _isAnimating = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_screens[_currentIndex]['key']),
          child: _screens[_currentIndex]['screen'],
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(color: Colors.purpleAccent, blurRadius: 10),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            child: Container(
              width: 175,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home_outlined, 0),
                  _buildNavItem(Icons.add, 1),
                  _buildNavItem(Icons.calendar_month_outlined, 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    final isTarget = _targetIndex == index;

    return GestureDetector(
      onTap: () => _animateToIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _isAnimating && isTarget ? 70 : 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(
            _isAnimating && isTarget ? 25 : 50,
          ),
        ),
        child: Icon(
          icon,
          size: 30,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}