import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/event.dart';
import '../../../../utils/emun.dart';

class GetLocationName extends StatefulWidget {
  final EventModel event;
  final bool isOrganizer;
  final Function() onTap;
  const GetLocationName({
    super.key,
    required this.event,
    required this.isOrganizer,
    required this.onTap,
  });

  @override
  State<GetLocationName> createState() => _GetLocationNameState();
}

class _GetLocationNameState extends State<GetLocationName> {
  Future<List<Placemark>> _getPlacemarks(
      double latitude, double longitude) async {
    return await placemarkFromCoordinates(latitude, longitude);
  }

  EventItems? selectedItem;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPlacemarks(
          widget.event.geoPoint.latitude, widget.event.geoPoint.longitude),
      builder: (context, placemarkSnapshot) {
        if (placemarkSnapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Center(child: CircularProgressIndicator()),
          );
        } else if (placemarkSnapshot.hasError || !placemarkSnapshot.hasData) {
          return ListTile(
            title: Text(widget.event.name),
            subtitle: const Text('Error loading location'),
          );
        } else {
          final placemarks = placemarkSnapshot.data!;
          final placemark = placemarks.isNotEmpty ? placemarks.first : null;

          DateTime addedDate = widget.event.addedDate.toDate();
          String formattedDate =
              DateFormat("hh:mm dd MMMM yyyy").format(addedDate);
          return GestureDetector(
            onTap: widget.onTap,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 100,
                        width: 100,
                        child: Image.network(
                          widget.event.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.1,
                                  child: Text(
                                    widget.event.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(formattedDate),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    CupertinoIcons.location_solid,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text(
                                      placemark?.street ?? 'Unknown Street',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.isOrganizer
                      ? PopupMenuButton<EventItems>(
                          initialValue: selectedItem,
                          onSelected: (EventItems item) {
                            setState(() {
                              selectedItem = item;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<EventItems>>[
                            const PopupMenuItem<EventItems>(
                              value: EventItems.itemOne,
                              child: Text("Tahrirlash"),
                            ),
                            const PopupMenuItem<EventItems>(
                              value: EventItems.itemTwo,
                              child: Text("O'chirish"),
                            ),
                          ],
                        )
                      : IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border, size: 30),
                        ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
