import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen_4/views/widgets/image_video_container.dart';
import 'package:examen_4/views/widgets/my_text_field_icon.dart';
import 'package:examen_4/views/widgets/yandex_map.dart';
import '../../../../services/fire_store_event_service.dart';
import '../../../widgets/add_image.dart';
import '../../../widgets/app_function.dart';
import '../../../widgets/check_auth.dart';
import '../../../widgets/my_text_field.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final EventService _eventService = EventService();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final checkAuth = CheckAuth();
  Point? location;
  DateTime? dateTime;
  TimeOfDay? timeOfDay;
  String? imageUrl;
  Timestamp timestampDate = Timestamp.now();
  final _formKey = GlobalKey<FormState>();

  void _onSaveTap() async {
    print(dateTime);
    print(imageUrl);
    print(timeOfDay);
    print(location);
    print(descriptionController.text);
    print(titleController.text);
    if (_formKey.currentState!.validate() &&
        dateTime != null &&
        timeOfDay != null &&
        imageUrl != null &&
        location != null) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      try {
        _eventService.addEvent(
          userId: userId,
          name: titleController.text,
          addedDate: Timestamp.fromDate(
            AppFunctions.combineDateTimeAndTimeOfDay(dateTime!, timeOfDay!),
          ),
          endTime: Timestamp.fromDate(
            AppFunctions.combineDateTimeAndTimeOfDay(dateTime!, timeOfDay!),
          ),
          userCount: 0,
          geoPoint: GeoPoint(location!.latitude, location!.longitude),
          description: descriptionController.text,
          imageUrl: imageUrl!,
        );
        if (mounted) {
          Navigator.of(context).pop();

          AppFunctions.showSnackBar(
            context,
            'New event has been added successully',
          );
        }
      } catch (e) {
        if (mounted) {
          AppFunctions.showErrorSnackBar(context, e.toString());
        }
      }
    } else {
      AppFunctions.showSnackBar(
          context, "Barcha malumotlarni to'ldirishing kerak");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tadbir qo'shish",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyTextField(
                  hintText: "Nomi",
                  controller: titleController,
                  validator: checkAuth.validateUsername,
                ),
                const SizedBox(height: 10),
                MyTextFieldIcon(
                  hintText: dateTime == null
                      ? "Kuni"
                      : '${dateTime!.toLocal()}'.split(' ')[0],
                  readOnly: true,
                  suffixIcon: const Icon(Icons.date_range),
                  onTap: () async {
                    final DateTime? chosenDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now().add(
                        const Duration(days: 1),
                      ),
                      lastDate: DateTime.now().add(
                        const Duration(days: 30),
                      ),
                    );
                    if (chosenDate != null) {
                      setState(() {
                        dateTime = chosenDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                MyTextFieldIcon(
                  hintText:
                      timeOfDay == null ? "Vaqti" : timeOfDay!.format(context),
                  readOnly: true,
                  suffixIcon: const Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? chooseTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (chooseTime != null) {
                      setState(() {
                        timeOfDay = chooseTime;
                        timestampDate = Timestamp.fromDate(
                          DateTime(
                            dateTime!.year,
                            dateTime!.month,
                            dateTime!.day,
                            timeOfDay!.hour,
                            timeOfDay!.minute,
                          ),
                        );
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Tadbir haqida ma'luot",
                  controller: descriptionController,
                  validator: checkAuth.validateUsername,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Rasm yoki video yuklash",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                ImageVideoContainer(
                  title: "Camera",
                  onTap: () async {
                    final String? imageUrlString = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => const ManageMedia(),
                    );
                    if (imageUrlString != null) {
                      setState(() {
                        imageUrl = imageUrlString;
                      });
                    }
                  },
                  icon: Icons.camera_alt_outlined,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Manzilni belgilash",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                YandexMapWidget(
                    onMapTap: (argument) {
                      setState(() {
                        location = argument;
                      });
                    },
                    location: location),
                const SizedBox(height: 15),
                FilledButton(
                  onPressed: _onSaveTap,
                  child: const Text("Qo'shish"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
