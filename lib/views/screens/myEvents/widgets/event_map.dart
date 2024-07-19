import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../services/location_service.dart';

class EventMap extends StatefulWidget {
  GeoPoint location;
  void Function()? onPressed;
  void Function(Point)? onMapTap;
  EventMap({super.key, required this.location, this.onPressed, this.onMapTap});

  @override
  State<EventMap> createState() => _EventMapState();
}

class _EventMapState extends State<EventMap> {
  late YandexMapController mapController;

  void onMapCreated(YandexMapController controller) async {
    mapController = controller;
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: widget.location.latitude,
            longitude: widget.location.longitude,
          ),
          zoom: 12,
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: Stack(
        children: [
          YandexMap(
            gestureRecognizers: {}..add(
                Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              ),
            onMapCreated: onMapCreated,
            mapObjects: [
              PlacemarkMapObject(
                mapId: const MapObjectId("selected"),
                point: Point(
                    latitude: widget.location.latitude,
                    longitude: widget.location.longitude),
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                      "assets/images/marker.png",
                    ),scale: 0.2
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: const Alignment(1, 0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: "zoomIn",
                    onPressed: () {
                      mapController.moveCamera(
                        CameraUpdate.zoomIn(),
                      );
                    },
                    backgroundColor: Colors.white.withOpacity(0.85),
                    child: const Icon(
                      CupertinoIcons.add,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: "zoomOut",
                    onPressed: () {
                      mapController.moveCamera(
                        CameraUpdate.zoomOut(),
                      );
                    },
                    backgroundColor: Colors.white.withOpacity(0.85),
                    child: const Icon(
                      CupertinoIcons.minus,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
