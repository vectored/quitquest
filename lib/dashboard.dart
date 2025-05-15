import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final String? email = FirebaseAuth.instance.currentUser?.email;
  DateTime startTime = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, String> _journalEntries = {};
  late Timer _timer;
  late Duration _elapsedTime;

  @override
  void initState() {
    super.initState();
    _loadStartDate();
    _elapsedTime = DateTime.now().difference(startTime);
    _timer = Timer.periodic(const Duration(seconds: 1), _updateElapsedTime);
  }

  Future<void> _loadStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? startDateString = prefs.getString('startDate');
    if (startDateString != null) {
      setState(() {
        startTime = DateTime.parse(startDateString);
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != startTime) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('startDate', picked.toIso8601String());
      setState(() {
        startTime = picked;
        _elapsedTime = DateTime.now().difference(startTime);
      });
    }
  }

  void _updateElapsedTime(Timer timer) {
    setState(() {
      _elapsedTime = DateTime.now().difference(startTime);
    });
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '$days days, $hours:$minutes:$seconds';
  }

  void _showJournalDialog(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    final journalText = _journalEntries[dateKey] ?? '';
    final controller = TextEditingController(text: journalText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Journal Entry"),
          content: TextField(
            controller: controller,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "Write your thoughts...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _journalEntries[dateKey] = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  List<DateTime> getCleanDays(DateTime startDate, DateTime endDate) {
    List<DateTime> cleanDays = [];
    DateTime currentDay = startDate;

    while (currentDay.isBefore(endDate) || isSameDay(currentDay, endDate)) {
      cleanDays.add(
        DateTime(currentDay.year, currentDay.month, currentDay.day),
      );
      currentDay = currentDay.add(const Duration(days: 1));
    }

    return cleanDays;
  }

  @override
  Widget build(BuildContext context) {
    final cleanDays = getCleanDays(startTime, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "End Clean Streak",
            onPressed: () {
              setState(() {
                startTime = DateTime.now();
                _journalEntries.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Clean streak reset.")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Sign Out",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome $email ٩(^ᗜ^ )و ´-",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectStartDate(context),
                child: const Text("Set Clean Start Date"),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Text(
                "You have been clean for: ${_formatDuration(_elapsedTime)} ٩(^ᗜ^ )و ",
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2020, 1, 1),
                  lastDay: DateTime.now(),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, _) {
                      final isCleanDay = cleanDays.any(
                        (cleanDay) =>
                            cleanDay.year == day.year &&
                            cleanDay.month == day.month &&
                            cleanDay.day == day.day,
                      );

                      if (isCleanDay) {
                        return GestureDetector(
                          onTap: () {
                            _showJournalDialog(day);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA8DADC).withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }

                      return null;
                    },
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!selectedDay.isAfter(DateTime.now())) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _showJournalDialog(selectedDay);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Future entries are not allowed."),
                        ),
                      );
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chatroom');
                    },
                    child: const Text('AI Chatroom'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/resources');
                    },
                    child: const Text('Resources'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
