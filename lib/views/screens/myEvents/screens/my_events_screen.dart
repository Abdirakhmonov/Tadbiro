import 'package:examen_4/views/screens/myEvents/screens/ishtirok_etganlarim.dart';
import 'package:flutter/material.dart';

import 'add_event_screen.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEventScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text(
            "Mening tadbirlarim",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Tashkil qilganlarim"),
              Tab(text: "Yaqinda"),
              Tab(text: "Ishtirok etganlarim"),
              Tab(text: "Bekor qilganlarim"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrganizerEventsPage(),
            Container(),
            Container(),
            Container()
          ],
        ),
      ),
    );
  }
}
