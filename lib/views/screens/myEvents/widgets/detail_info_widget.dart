import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/event.dart';
import '../../../../data/models/event_status.dart';
import '../../../../services/firebase_auth_service.dart';

class DetailInfoWidget extends StatefulWidget {
  final EventModel event;
  final EventStatusModel? eventStatus;
  final bool checkUserRegister;
  const DetailInfoWidget({
    super.key,
    required this.event,
    required this.checkUserRegister,
    this.eventStatus,
  });

  @override
  State<DetailInfoWidget> createState() => _DetailInfoWidgetState();
}

class _DetailInfoWidgetState extends State<DetailInfoWidget> {
  final _authService = UserAuthService();

  Future<List<Placemark>> _getPlacemarks(
      double latitude, double longitude) async {
    return await placemarkFromCoordinates(latitude, longitude);
  }

  Future<DocumentSnapshot?> _loadCurrentUser() async {
    DocumentSnapshot user = await _authService.getUserInfo(widget.event.userId);
    if (user.exists) {
      return user;
    } else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    DateTime addedDate = widget.event.addedDate.toDate();
    String formattedDate = DateFormat("dd MMMM yyyy").format(addedDate);
    DateTime startTime = widget.event.addedDate.toDate();
    DateTime endTIme = widget.event.endTime.toDate();
    String startTimeFormatted = DateFormat("EEEE, h:mm a").format(startTime);
    String endTimeFormatted = DateFormat("h:mm a").format(endTIme);

    return  SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Card(
                color:  Color(0xff1F41BB),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.calendar_month,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(formattedDate),
              subtitle: Text("$startTimeFormatted - $endTimeFormatted"),
            ),
            FutureBuilder(
              future: _getPlacemarks(widget.event.geoPoint.latitude,
                  widget.event.geoPoint.longitude),
              builder: (context, placemarkSnapshot) {
                if (placemarkSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const ListTile(
                    title: Center(child: CircularProgressIndicator()),
                  );
                } else if (placemarkSnapshot.hasError ||
                    !placemarkSnapshot.hasData) {
                  return ListTile(
                    title: Text(widget.event.name),
                    subtitle: const Text('Error loading location'),
                  );
                } else {
                  final placemarks = placemarkSnapshot.data!;
                  final placemark =
                  placemarks.isNotEmpty ? placemarks.first : null;
                  return ListTile(
                    leading: const Card(
                      color:  Color(0xff1F41BB),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.location_on,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(placemark?.street ?? 'Unknown Street'),
                    subtitle: Text(placemark?.locality ?? "Unknown Country"),
                  );
                }
              },
            ),
            ListTile(
              leading: const Card(
                color:  Color(0xff1F41BB),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.person,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text("${widget.event.userCount}  kishi qatnashmoqda"),
              subtitle: const Text("Siz ham ro'yxatdan o'ting"),
            ),
            FutureBuilder(
              future: _loadCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return const Text("Tashkilotchi ismi noma'lum");
                }
                final user = snapshot.data!;
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Container(
                      clipBehavior: Clip.hardEdge,
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWwfGUCDwrZZK12xVpCOqngxSpn0BDpq6ewQ&s",
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      user['userName'] ?? "Tashkilotchi ismi noma'lum",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text("Tadbir tashkilotchisi"),
                  ),
                );
              },
            ),
            const Gap(20.0),
            const Text(
              "Tadbir haqida",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.event.description,
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );

  }
}
