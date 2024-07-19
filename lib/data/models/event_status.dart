import 'package:cloud_firestore/cloud_firestore.dart';

class EventStatusModel {
  final String id;
  final int userCount;
  final String eventId;
  final String userId;
  final String paymentMethod;
  final String status;
  final Timestamp reminderTime;

  EventStatusModel({
    required this.id,
    required this.userCount,
    required this.eventId,
    required this.userId,
    required this.paymentMethod,
    required this.status,
    required this.reminderTime,
  });

  factory EventStatusModel.fromJson(QueryDocumentSnapshot query) {
    return EventStatusModel(
      id: query.id,
      userCount: query['userCount'],
      eventId: query['eventId'],
      userId: query['userId'],
      paymentMethod: query['paymentMethod'],
      status: query['status'],
      reminderTime: query['reminderTime'],
    );
  }
}
