import 'package:dot_planner/components/customeAppBar.dart';
import 'package:dot_planner/components/middleTabBar.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              CustomAppBar(),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'All Notes',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.surfaceDim,
                      ),
                    ),
                    Text(
                      '2 Notes',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.surfaceBright,
                      ),
                    ),
                  ],
                ),
              ),
              // Container(height: 5, color: Colors.amber),
              Expanded(child: MiddleTabBar()),
              FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
            ],
          ),
        ),
      ),
    );
  }
}
