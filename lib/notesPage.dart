import 'package:dot_planner/components/customeAppBar.dart';
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
                alignment: Alignment.center,
                child: Text(
                  'All Notes',
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.surfaceDim,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
