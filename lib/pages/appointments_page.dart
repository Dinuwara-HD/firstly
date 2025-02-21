import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  DateTime? _selectedDate;
  String? _selectedDoctor;
  String? _selectedTime;
  bool _isOnline = false;
  bool _appointmentBooked = false;
  String? _zoomLink;

  List<String> _doctorIds = [];
  Map<String, List<String>> _doctorSchedules = {};

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  /// Fetch doctor IDs and their available schedules
  Future<void> _fetchDoctors() async {
    try {
      QuerySnapshot doctorsSnapshot =
          await FirebaseFirestore.instance.collection('doctors').get();

      Map<String, List<String>> schedules = {};
      List<String> doctorIds = [];

      for (var doc in doctorsSnapshot.docs) {
        String doctorId = doc.id;
        doctorIds.add(doctorId);

        Map<String, dynamic> availableDates = doc['availableDates'];
        schedules[doctorId] = availableDates.keys.toList();
      }

      setState(() {
        _doctorIds = doctorIds;
        _doctorSchedules = schedules;
      });
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }

  /// Fetch available time slots for the selected doctor & date
  Future<List<String>> _getAvailableTimes(
      String doctorId, String selectedDate) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return List<String>.from(data['availableDates'][selectedDate] ?? []);
    }
    return [];
  }

  /// Book the appointment and store in Firestore
  void _bookAppointment() async {
    if (_selectedDate != null &&
        _selectedTime != null &&
        _selectedDoctor != null) {
      DocumentReference appointmentRef =
          FirebaseFirestore.instance.collection('appointments').doc();

      String formattedDate =
          "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

      String zoomLink =
          "https://zoom.us/j/123456789"; // Replace with actual link

      await appointmentRef.set({
        'doctorId': _selectedDoctor,
        'date': formattedDate,
        'time': _selectedTime,
        'isOnline': _isOnline,
        'zoomLink': zoomLink,
      });

      setState(() {
        _appointmentBooked = true;
        _zoomLink = zoomLink;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select doctor, date, and time')),
      );
    }
  }

  /// Open Zoom meeting link
  void _joinZoomMeeting() async {
    if (_zoomLink == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Zoom link available')),
      );
      return;
    }

    if (await canLaunch(_zoomLink!)) {
      await launch(_zoomLink!);
    } else {
      throw 'Could not launch $_zoomLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Appointments'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose a Doctor:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedDoctor,
              hint: const Text('Select a doctor'),
              items: _doctorIds
                  .map((doctorId) => DropdownMenuItem(
                        value: doctorId,
                        child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('doctors')
                              .doc(doctorId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading...");
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text("Unknown Doctor");
                            }
                            return Text(snapshot.data!.get("name"));
                          },
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDoctor = value;
                  _selectedDate = null;
                  _selectedTime = null;
                });
              },
            ),
            if (_selectedDoctor != null &&
                _doctorSchedules.containsKey(_selectedDoctor))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Choose a Date:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButton<DateTime>(
                    isExpanded: true,
                    value: _selectedDate,
                    hint: const Text('Select a date'),
                    items: _doctorSchedules[_selectedDoctor!]!.map((dateStr) {
                      DateTime date = DateTime.parse(dateStr);
                      return DropdownMenuItem(
                          value: date, child: Text(dateStr));
                    }).toList(),
                    onChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                        _selectedTime = null;
                      });
                    },
                  ),
                ],
              ),
            if (_selectedDate != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Choose a Time:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  FutureBuilder<List<String>>(
                    future: _getAvailableTimes(_selectedDoctor!,
                        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedTime,
                        hint: const Text('Select a time'),
                        items: snapshot.data!.map((time) {
                          return DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedTime = value),
                      );
                    },
                  ),
                ],
              ),
            SwitchListTile(
              title: const Text('Online Video Consultation'),
              value: _isOnline,
              onChanged: (bool value) => setState(() => _isOnline = value),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Book Appointment',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            if (_isOnline && _appointmentBooked)
              Center(
                child: ElevatedButton(
                  onPressed: _joinZoomMeeting,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Join Zoom Meeting',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
