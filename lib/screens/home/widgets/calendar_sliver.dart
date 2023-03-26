import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/home/widgets/home_title.dart';
import 'package:mars/services/firestore/appointments.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarSliver extends ConsumerStatefulWidget {
  const CalendarSliver({Key? key}) : super(key: key);

  @override
  _CalendarSliverState createState() => _CalendarSliverState();
}

class _CalendarSliverState extends ConsumerState<CalendarSliver> {
  CalendarController calendarController = CalendarController();
  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  late DateTime startDate;
  late DateTime endDate;

  DateTime visibleDate = DateTime.now();

  _AppointmentDataSource? _events;

  Color selectedColor = Colors.yellow;

  @override
  void initState() {
    startDate = DateTime.now();

    endDate = DateTime.now();

    super.initState();
  }

  @override
  void dispose() {
    calendarController.dispose();
    nameController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    if (user == null) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(
            child: Text('حدثت مشكلة اثناء تحميل بيانات المستخدم'),
          ),
        ),
      );
    }
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/calendarPage');
                      },
                      icon: const FaIcon(FontAwesomeIcons.chevronLeft))),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: HomeTabTitle(
                  icon: FontAwesomeIcons.calendar,
                  title: 'نظم وقتك',
                  titleColor: Colors.black,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              FutureBuilder<List<Appointment>>(
                  future: locator
                      .get<Appointments>()
                      .getAppointments(userId: user.uid, date: DateTime.now()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    }

                    if (snapshot.data == null) {
                      return Container();
                    }

                    List<Appointment> appointments = snapshot.data!;

                    _events = _getCalendarDataSource(user.uid, appointments);

                    return SfCalendar(
                      controller: calendarController,
                      view: CalendarView.timelineDay,
                      onTap: (details) {
                        if (details.appointments != null) {
                          return;
                        }
                        visibleDate = details.date ?? DateTime.now();
                        showMeetingDialog(user);
                      },
                      onViewChanged: (details) {
                        visibleDate = details.visibleDates[0];
                      },
                      dataSource: _events,
                      todayHighlightColor:
                          Theme.of(context).colorScheme.secondary,
                      backgroundColor: Colors.grey[200],
                      loadMoreWidgetBuilder: (BuildContext context,
                          LoadMoreCallback loadMoreAppointments) {
                        return FutureBuilder<void>(
                          future: loadMoreAppointments(),
                          builder: (context, snapShot) {
                            if (snapShot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  height: calendarController.view ==
                                          CalendarView.schedule
                                      ? 50
                                      : double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Theme.of(context).colorScheme.primary,
                                      )));
                            }

                            return const SizedBox();
                          },
                        );
                      },
                      appointmentBuilder:
                          (context, calendarAppointmentDetails) {
                        final Appointment meeting =
                            calendarAppointmentDetails.appointments.first;
                        return CircleAvatar(
                          backgroundColor: meeting.color,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              child: Text(
                                meeting.subject,
                                style: TextStyle(
                                    color:
                                        meeting.color.computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white),
                              ),
                            ),
                          )),
                        );
                      },
                    );
                  }),
              Positioned(
                  right: 0,
                  child: Row(
                    children: [
                      // IconButton(
                      //     onPressed: () {
                      //       showMeetingDialog(user);
                      //     },
                      //     icon: FaIcon(
                      //       FontAwesomeIcons.plus,
                      //       color: Theme.of(context).colorScheme.primary,
                      //     )),
                      IconButton(
                          onPressed: () {
                            calendarController.displayDate = DateTime.now();
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.calendarDay,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  showMeetingDialog(UserModel user) {
    startDate = visibleDate;
    endDate = startDate.add(const Duration(hours: 1));
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return AlertDialog(
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.isEmpty) {
                            return;
                          }
                          Methods.showLoaderDialog(context);
                          await locator.get<Appointments>().addNewAppointment(
                              userId: user.uid,
                              startDate: startDate,
                              endDate: endDate,
                              name: nameController.text,
                              color: selectedColor,
                              notes: notesController.text);

                          final Appointment app = Appointment(
                              startTime: startDate,
                              endTime: endDate,
                              subject: nameController.text,
                              notes: notesController.text,
                              color: selectedColor);

                          _events?.appointments!.add(app);
                          _events?.notifyListeners(
                              CalendarDataSourceAction.add, <Appointment>[app]);

                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Add')),
                  ),
                )
              ],
              title: const Text(
                'اضافة موعد',
                textDirection: TextDirection.rtl,
              ),
              insetPadding: const EdgeInsets.symmetric(vertical: 0),
              contentPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: 'الاسم'),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    // DateTime? date = await showDatePicker(
                                    //   context: context,
                                    //   initialDate: DateTime.now(),
                                    //   firstDate: DateTime.now(),
                                    //   lastDate: DateTime.now()
                                    //       .add(const Duration(days: 31)),
                                    // );
                                  },
                                  child: Text(Methods.formatDate(
                                      Timestamp.fromDate(startDate), 'ar'))),
                              TextButton(
                                  onPressed: () async {
                                    // TimeOfDay? time = await showTimePicker(
                                    //   context: context,
                                    //   initialTime: TimeOfDay.now(),
                                    // );
                                  },
                                  child: Text(Methods.formatTime(
                                      Timestamp.fromDate(startDate), 'ar'))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    // DateTime? date = await showDatePicker(
                                    //   context: context,
                                    //   initialDate: DateTime.now(),
                                    //   firstDate: DateTime.now(),
                                    //   lastDate: DateTime.now()
                                    //       .add(const Duration(days: 31)),
                                    // );
                                  },
                                  child: Text(Methods.formatDate(
                                      Timestamp.fromDate(endDate), 'ar'))),
                              TextButton(
                                  onPressed: () async {
                                    // TimeOfDay? time = await showTimePicker(
                                    //   context: context,
                                    //   initialTime: TimeOfDay.now(),
                                    // );
                                  },
                                  child: Text(Methods.formatTime(
                                      Timestamp.fromDate(endDate), 'ar'))),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: notesController,
                            maxLines: null,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: 'التفاصيل'),
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: BlockPicker(
                            pickerColor: const Color(0xff443a49),
                            onColorChanged: (color) {},
                            layoutBuilder: (context, colors, child) {
                              return Wrap(
                                alignment: WrapAlignment.center,
                                children: colors.map((color) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setDialogState(
                                          () {
                                            selectedColor = color;
                                          },
                                        );
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      child: CircleAvatar(
                                        backgroundColor: color,
                                        child: selectedColor == color
                                            ? Container(
                                                width: 16,
                                                height: 16,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        }).then((value) {
      visibleDate = DateTime.now();

      nameController.text = '';
      selectedColor = Colors.yellow;
      notesController.text = '';
    });
  }
}

_AppointmentDataSource _getCalendarDataSource(String userId, appointments) {
  return _AppointmentDataSource(appointments, userId);
}

class _AppointmentDataSource extends CalendarDataSource {
  final String userId;

  _AppointmentDataSource(List<Appointment> source, this.userId) {
    appointments = source;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    final List<Appointment> meetings = await locator
        .get<Appointments>()
        .getAppointments(userId: userId, date: startDate);

    for (final Appointment meeting in meetings) {
      if (appointments!.contains(meeting)) {
        return;
      }

      appointments!.add(meeting);
    }

    notifyListeners(CalendarDataSourceAction.add, meetings);
  }
}
