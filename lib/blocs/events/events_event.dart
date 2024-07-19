import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

abstract class EventEvent {}

class LoadEvents extends EventEvent {}

class AddEvent extends EventEvent {
  final String name;
  final Timestamp addedDate;
  final String addedTime;
  final String description;
  final String imageUrl;
  final String location;
  final String userId;

  AddEvent({
    required this.name,
    required this.addedDate,
    required this.addedTime,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.userId,
  });
}

class EditEvent extends EventEvent {
  final String id;
  final String name;
  final Timestamp addedDate;
  final String addedTime;
  final String description;
  final String imageUrl;
  final String location;

  EditEvent({
    required this.id,
    required this.name,
    required this.addedDate,
    required this.addedTime,
    required this.description,
    required this.imageUrl,
    required this.location,
  });
}

class DeleteEvent extends EventEvent {
  final String id;

  DeleteEvent(this.id);
}
