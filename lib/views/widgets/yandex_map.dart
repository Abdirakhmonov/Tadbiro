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
    return Column(children: [
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
            onMapTap: widget.onMapTap),
      ),
    ]);
  }
}
