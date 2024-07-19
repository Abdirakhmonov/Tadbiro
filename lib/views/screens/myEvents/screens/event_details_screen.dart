import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import '../../../../data/models/event.dart';
import '../../../../services/event_status_service.dart';
import '../../../../services/fire_store_event_service.dart';
import '../../../widgets/app_function.dart';
import '../../home_screen/home_screen.dart';
import '../widgets/detail_info_widget.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;
  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final _eventStatusService = EventStatusService();
    final EventService _eventService = EventService();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    event.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 35,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                )
              ],
            ),
            DetailInfoWidget(
              event: event,
              checkUserRegister: false,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              backgroundColor: Color(0xff1F41BB),
              onPressed: () async {
                final data = await showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildBottomSheet(context);
                  },
                );

                int userCount = data['userCount'];
                final paymentMethod = data['paymentMethod'];
                final currentUser = FirebaseAuth.instance.currentUser!.uid;
                try {
                  _eventStatusService.addEventStatus(
                    userCount: userCount,
                    eventId: event.id,
                    userId: currentUser,
                    paymentMethod: paymentMethod,
                    status: "Register",
                    reminderTime: Timestamp.fromDate(DateTime.now()),
                  );

                  _eventService.editEvent(
                    id: event.id,
                    nweUserCount: event.userCount + userCount,
                  );
                } catch (e) {
                  if (context.mounted) {
                    AppFunctions.showErrorSnackBar(context, e.toString());
                  }
                }
              },
              child: const Text(
                "Ro'yxatdan o'tish",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    int selectedCount = 1;
    String selectedPayment = '';

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Keyingi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Joylar sonini tanlang",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xff1F41BB),
                    ),
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (selectedCount > 1) selectedCount--;
                      });
                    },
                  ),
                  Text(
                    '$selectedCount',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xff1F41BB),
                    ),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        selectedCount++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "To'lov turini tanlang",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Click'),
                trailing: Radio(
                  value: 'Click',
                  groupValue: selectedPayment,
                  onChanged: (String? value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Payme'),
                trailing: Radio(
                  value: 'Payme',
                  groupValue: selectedPayment,
                  onChanged: (String? value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Naqd'),
                trailing: Radio(
                  value: 'Naqd',
                  groupValue: selectedPayment,
                  onChanged: (String? value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FloatingActionButton(
                      backgroundColor: const Color(0xff1F41BB),
                      onPressed: () {
                        Navigator.pop(context, {
                          'userCount': selectedCount,
                          'paymentMethod': selectedPayment,
                        }); // Close bottom sheet
                        _showAlertDialog(context); // Show alert dialog
                      },
                      child: const Text(
                        "Ro'yxatdan o'tish",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/images/success.json'),
              const Text(
                "Tabriklaymiz!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                " Siz ${event.name} tadbiriga muaffaqiyatli ro'yxatdan o'tdingiz.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      backgroundColor: const Color(0xff1F41BB),
                      onPressed: () {
                        _selectDateTime(context);
                      },
                      child: const Text(
                        "Eslatma belgilash",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff1F41BB),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            "Bosh Sahifa",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        Navigator.pop(context);

        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        print('Selected Date and Time: $selectedDateTime');
        // _eventStatusService.editEventStatus(
        //   id: event.id,
        //   newReminderTime: Timestamp.fromDate(selectedDateTime),
        // );
      }
    }
  }
}
