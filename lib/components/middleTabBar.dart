import 'package:dot_planner/allTabs/notesTab.dart';
import 'package:flutter/material.dart';

class MiddleTabBar extends StatefulWidget {
  final TabController controller; // ✅ receive controller from parent

  const MiddleTabBar({Key? key, required this.controller}) : super(key: key);

  @override
  State<MiddleTabBar> createState() => _MiddleTabBarState();
}

class _MiddleTabBarState extends State<MiddleTabBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar
        TabBar(
          controller: widget.controller, // ✅ use controller here
          labelColor: Theme.of(context).colorScheme.surfaceDim,
          unselectedLabelColor: Theme.of(context).colorScheme.surfaceBright,
          labelStyle: TextStyle(
            fontFamily: 'InterBold',
            color: Theme.of(context).colorScheme.surfaceDim,
            fontSize: 16,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            color: Theme.of(context).colorScheme.surfaceBright,
            fontSize: 16,
          ),
          dividerHeight: 0,
          indicatorColor: Theme.of(context).colorScheme.tertiary,
          indicatorAnimation: TabIndicatorAnimation.elastic,
          tabs: const [
            Tab(text: "Notes"),
            Tab(text: "To-Do"),
            Tab(text: "Calendar"),
          ],
        ),
        const SizedBox(height: 20),

        // TabBarView
        Expanded(
          child: TabBarView(
            controller: widget.controller, // ✅ use same controller
            children: [
              NotesTab(),
              Center(
                child: Text("Content 2", style: TextStyle(color: Colors.white)),
              ),
              Center(
                child: Text("Content 3", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
