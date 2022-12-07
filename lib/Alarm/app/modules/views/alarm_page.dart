import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:merokarobar/Alarm/alarm_helper.dart';
import 'package:merokarobar/Alarm/app/data/models/alarm_info.dart';
import 'package:merokarobar/Alarm/app/data/theme_data.dart';
import 'package:merokarobar/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  AlarmPageState createState() => AlarmPageState();
}

class AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  late String _alarmTimeString;
  final bool _isRepeatSelected = false;
  final AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Alarm',
            style: TextStyle(fontFamily: 'avenir', fontWeight: FontWeight.w700, color: CustomColors.primaryTextColor, fontSize: 24),
          ),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;
                  return ListView(
                    children: snapshot.data!.map<Widget>((alarm) {
                      var alarmTime = DateFormat('hh:mm aa').format(alarm.alarmDateTime!);
                      var gradientColor = GradientTemplate.gradientTemplate[alarm.gradientColorIndex!].colors;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColor,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradientColor.last.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(4, 4),
                            ),
                          ],
                          borderRadius: const BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.label,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      alarm.title!,
                                      style: const TextStyle(color: Colors.white, fontFamily: 'avenir'),
                                    ),
                                  ],
                                ),
                                Switch(
                                  onChanged: (bool value) {},
                                  value: true,
                                  activeColor: Colors.white,
                                ),
                              ],
                            ),
                            const Text(
                              'Mon-Fri',
                              style: TextStyle(color: Colors.white, fontFamily: 'avenir'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  alarmTime,
                                  style: const TextStyle(color: Colors.white, fontFamily: 'avenir', fontSize: 24, fontWeight: FontWeight.w700),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                    onPressed: () {
                                      deleteAlarm(alarm.id);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).followedBy([
                      if (_currentAlarms!.length < 5)
                        DottedBorder(
                          strokeWidth: 2,
                          color: CustomColors.clockOutline,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(24),
                          dashPattern: const [5, 4],
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.clockBG,
                              borderRadius: const BorderRadius.all(Radius.circular(24)),
                            ),
                            child: MaterialButton(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      child: StatefulBuilder(
                                        builder: (context, setModalState) {
                                          return Container(
                                            padding: const EdgeInsets.all(32),
                                            child: Form(
                                              key: formGlobalKey,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      var selectedTime = await showTimePicker(
                                                        context: context,
                                                        initialTime: TimeOfDay.now(),
                                                      );
                                                      if (selectedTime != null) {
                                                        final now = DateTime.now();
                                                        var selectedDateTime =
                                                            DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
                                                        _alarmTime = selectedDateTime;
                                                        setModalState(() {
                                                          _alarmTimeString = DateFormat('HH:mm').format(selectedDateTime);
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      _alarmTimeString,
                                                      style: const TextStyle(fontSize: 32),
                                                    ),
                                                  ),
                                                  const ListTile(
                                                    title: Text('Title'),
                                                  ),
                                                  SizedBox(
                                                      width: MediaQuery.of(context).size.width / 1.4,
                                                      child: TextFormField(
                                                          textCapitalization: TextCapitalization.words,
                                                          controller: title,
                                                          // controller: countrycode,
                                                          validator: (text) {
                                                            if (text == null || text.isEmpty) {
                                                              return 'Title can\'t be empty';
                                                            }

                                                            return null;
                                                          },
                                                          maxLength: 12,
                                                          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Enter Title"))),
                                                  const ListTile(title: Text('Message')),
                                                  SizedBox(
                                                      width: MediaQuery.of(context).size.width / 1.4,
                                                      child: TextFormField(
                                                          textCapitalization: TextCapitalization.words,
                                                          controller: message,
                                                          validator: (text) {
                                                            if (text == null || text.isEmpty) {
                                                              return 'Message can\'t be empty';
                                                            }

                                                            return null;
                                                          },
                                                          maxLength: 50,
                                                          keyboardType: TextInputType.name,
                                                          decoration:
                                                              const InputDecoration(border: OutlineInputBorder(), hintText: "Enter Message"))),
                                                  const SizedBox(height: 10),
                                                  FloatingActionButton.extended(
                                                    onPressed: () {
                                                      if (formGlobalKey.currentState!.validate()) {
                                                        onSaveAlarm(_isRepeatSelected, title.text, message.text);
                                                      }
                                                    },
                                                    icon: const Icon(Icons.alarm),
                                                    label: const Text('Save'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                                // scheduleAlarm();
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/add_alarm.png',
                                    scale: 1.5,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Add Alarm',
                                    style: TextStyle(color: Colors.white, fontFamily: 'avenir'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        const Center(
                            child: Text(
                          'Only 5 alarms allowed!',
                          style: TextStyle(color: Colors.white),
                        )),
                    ]).toList(),
                  );
                }
                return const Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void scheduleAlarm(DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo, String message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: '@mipmap/ic_launcher',
      // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    tz.initializeTimeZones();
    var locations = tz.timeZoneDatabase.locations;
    final locationName = tz.getLocation(locations.keys.first); //Asia/Calcutta
    tz.setLocalLocation(locationName);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      alarmInfo.title,
      message,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    // }
  }

  void onSaveAlarm(bool isRepeating, var title, var message) {
    DateTime? scheduleAlarmDateTime;
    if (_alarmTime!.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = _alarmTime;
    } else {
      scheduleAlarmDateTime = _alarmTime!.add(const Duration(days: 1));
    }

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: title,
    );
    _alarmHelper.insertAlarm(alarmInfo);
    if (scheduleAlarmDateTime != null) {
      scheduleAlarm(scheduleAlarmDateTime, alarmInfo, message);
    }
    Navigator.pop(context);
    loadAlarms();
  }

  void deleteAlarm(int? id) {
    _alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }
}
