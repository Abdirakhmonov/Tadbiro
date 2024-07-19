import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../utils/themeMode.dart';
import '../screens/myEvents/screens/my_events_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const ListTile(
              title: Text(
                "Abdirahmonov Akromjon",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                "akramjon@gmail.com",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              leading: CircleAvatar(radius: 30),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 4),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyEventsScreen()));
              },
              child: const Row(
                children: [
                  Icon(Icons.person, size: 30),
                  SizedBox(width: 8),
                  Text(
                    "Mening tadbirlarim",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_sharp)
                ],
              ),
            ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return Row(
                  children: [
                    const Icon(Icons.brightness_6),
                    Expanded(
                      child: SwitchListTile(
                        title: const Text(
                          "Dark mode",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        value: themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            ListTile(
              trailing: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                "Log out ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Accountdan chiqib ketmoqchimisiz?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Yo'q"),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context
                                  .read<AuthenticationBloc>()
                                  .add((SignOutEvent()));
                            },
                            child: Text("Ha"),
                          )
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
