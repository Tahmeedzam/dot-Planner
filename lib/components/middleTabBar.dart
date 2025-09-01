import 'package:flutter/material.dart';

class MiddleTabBar extends StatefulWidget {
  @override
  State<MiddleTabBar> createState() => _MiddleTabBarState();
}

class _MiddleTabBarState extends State<MiddleTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // number of tabs
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            children: [
              // Your TabBar
              TabBar(
                labelColor: Theme.of(context).colorScheme.surfaceDim,
                unselectedLabelColor: Theme.of(
                  context,
                ).colorScheme.surfaceBright,
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
              SizedBox(
                height: 200, // give some height
                child: TabBarView(
                  children: [
                    Center(
                      child: Text(
                        "Content 1",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Content 2",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Content 3",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
