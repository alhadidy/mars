import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/user.dart';
import 'package:mars/models/user_appointment.dart';
import 'package:mars/services/firestore/appointments.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenadarPage extends ConsumerStatefulWidget {
  const CalenadarPage({Key? key}) : super(key: key);

  @override
  _CalenadarPageState createState() => _CalenadarPageState();
}

class _CalenadarPageState extends ConsumerState<CalenadarPage> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('نظم وقتك'),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('نظم وقتك'),
        ),
        body: FirestoreListView(
          emptyBuilder: (context) {
            return const Center(
              child: Text(
                'لم تقم بتحديد اي مواعيد',
                textAlign: TextAlign.center,
              ),
            );
          },
          loadingBuilder: (context) {
            return Container(
              height: 300,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
          query: locator
              .get<Appointments>()
              .getAppointmentsQuery(userId: user.uid),
          itemBuilder: (context, snapshot) {
            UserAppointmet appointment = UserAppointmet.fromDoc(snapshot);

            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: appointment.color,
                  child: const FaIcon(FontAwesomeIcons.clock),
                ),
                trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Methods.formatDate(appointment.time, 'ar'),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        Methods.formatTime(appointment.time, 'ar'),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ]),
                title: Text(appointment.name),
                subtitle: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('من: '),
                          Text(Methods.formatDateShorter(appointment.time)),
                          const Text(' - '),
                          Text(Methods.formatTime(appointment.time, 'ar')),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('لغاية: '),
                          Text(Methods.formatDateShorter(appointment.time)),
                          const Text(' - '),
                          Text(Methods.formatTime(appointment.time, 'ar')),
                        ],
                      ),
                      const Divider(),
                      Text(appointment.notes),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
