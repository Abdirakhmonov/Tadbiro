
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class EventState {}

class EventInitialState extends EventState {}

class EventLoadingState extends EventState {}

class EventLoadedState extends EventState {
  final List<QueryDocumentSnapshot> events;

  EventLoadedState(this.events);
}

class EventErrorState extends EventState {
  final String message;

  EventErrorState(this.message);
}
