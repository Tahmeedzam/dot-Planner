import 'package:dot_planner/addNote/createNote.dart';
import 'package:dot_planner/components/customeAppBar.dart';
import 'package:dot_planner/components/middleTabBar.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _titles = ['All Notes', 'To-do Tasks', 'Calendar'];
  final List<String> _subTitles = ['2 Notes', '5 Tasks', '3 Events Today'];
  int notesCount = 0;
  int tasksCount = 0;
  int eventsTodayCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // rebuild UI when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = _tabController.index; // current tab index

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              CustomAppBar(),

              // Top container that changes with tab
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _titles[index],
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.surfaceDim,
                      ),
                    ),
                    Text(
                      _subTitles[index],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.surfaceBright,
                      ),
                    ),
                  ],
                ),
              ),

              // Pass the same controller to MiddleTabBar
              Expanded(child: MiddleTabBar(controller: _tabController)),

              // Single + button in bottom right
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  onPressed: () {
                    switch (_tabController.index) {
                      case 0:
                        // Create Note
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const CreateNote(),
                          ),
                        );
                        break;
                      case 1:
                        // Create Task
                        print("Add Task");
                        break;
                      case 2:
                        // Create Event
                        print("Add Event");
                        break;
                    }
                  },
                  child: Icon(
                    Icons.add,
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
