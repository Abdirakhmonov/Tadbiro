import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/fire_store_event_service.dart';
import 'event_state.dart';
import 'events_event.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventService eventService;

  EventBloc(this.eventService) : super(EventInitialState()) {
    on<LoadEvents>(_getEventData);
  }

  void _getEventData(
    EventEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoadingState());
    try {
      await emit.forEach(
        eventService.getEvents(),
        onData: (QuerySnapshot snapshot) => EventLoadedState(snapshot.docs),
        onError: (error, stackTrace) => EventErrorState(error.toString()),
      );
    } catch (e) {
      emit(EventErrorState(e.toString()));
    }
  }
}
