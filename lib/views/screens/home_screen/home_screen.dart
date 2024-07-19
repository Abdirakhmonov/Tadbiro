import 'package:carousel_slider/carousel_slider.dart';
import 'package:examen_4/views/screens/home_screen/widgets/search_field.dart';
import 'package:examen_4/views/screens/notification_screen.dart';
import 'package:examen_4/views/widgets/custom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/event.dart';
import '../../../services/fire_store_event_service.dart';
import '../myEvents/screens/event_details_screen.dart';
import '../myEvents/widgets/my_evets_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget publicText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  final _eventService = EventService();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_active_outlined))
        ],
        title: const Text(
          "Bosh Sahifa",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: MySearchField(),
            ),
          ),
          SliverToBoxAdapter(
            child: publicText("Yaqin 7 kun ichidagi tadbirlar"),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder(
              stream: _eventService.getEventsForNext7Days(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final data = snapshot.data!.docs;
                  return CarouselSlider.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index, realIndex) {
                      final eventJson = data[index];
                      final EventModel event = EventModel.fromJson(eventJson);

                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage(event.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(event.addedDate.toDate().day.toString()),
                                          Text(event.addedDate.toDate().month.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.favorite),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event.name),
                                  Text(event.description),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 250,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.98,
                    ),
                  );
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: publicText("Barcha tadbirlar"),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              bottom: 20.0,
            ),
            sliver: StreamBuilder(
              stream: _eventService.getEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (!snapshot.hasData || snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else {
                  final data = snapshot.data!.docs;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final eventJson = data[index];
                        final EventModel event = EventModel.fromJson(eventJson);

                        return Hero(
                          tag: event.id,
                          child: GetLocationName(
                            event: event,
                            isOrganizer: false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EventDetailsScreen(
                                    event: event,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: data.length,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
