import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapWidget extends StatefulWidget {
  void Function(Point?) onMapTap;
  Point? location;
  YandexMapWidget({super.key, required this.onMapTap, required this.location});

  @override
  State<YandexMapWidget> createState() => _YandexMapWidgetState();
}

class _YandexMapWidgetState extends State<YandexMapWidget> {
  YandexMapController? controller;
  String address = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              child: YandexMap(
                gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(
                    () => EagerGestureRecognizer())),
                onMapCreated: (YandexMapController yandexMapController) {
                  controller = yandexMapController;
                },
                mapObjects: [
                  if (widget.location != null)
                    PlacemarkMapObject(
                      mapId: const MapObjectId('selected_point'),
                      point: widget.location!,
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                              "assets/images/marker.png"),
                          scale: 0.2,
                        ),
                      ),
                    ),
                ],
                onMapTap: widget.onMapTap,
              ),
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
                        controller?.moveCamera(
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
                        controller?.moveCamera(
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
      ],
    );
  }
}
