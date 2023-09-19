// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

class TableEventsExample extends StatefulWidget {
  const TableEventsExample({super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  // CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }

    print(_selectedEvents.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            // calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.green, // Warna latar belakang tanggal yang dipilih
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey,
              ),
              outsideDaysVisible: false, // Apakah tanggal di luar bulan aktif harus ditampilkan
            ),
            onDaySelected: _onDaySelected,
            // onFormatChanged: (format) {
            //   if (_calendarFormat != format) {
            //     setState(() {
            //       _calendarFormat = format;
            //     });
            //   }
            // },
            onFormatChanged: null,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Bulan'
            },
            headerStyle: const HeaderStyle(
              titleCentered: true,
            ),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final eventCount = events.length;

                bool isSelectedDay = isSameDay(date, _selectedDay);
                bool isToday = isSameDay(date, DateTime.now());

                Color markerColor = Colors.grey; // Warna default

                if (isSelectedDay) {
                  markerColor = Colors.grey; // Warna untuk tanggal yang dipilih
                } else if (isToday) {
                  markerColor = Colors.green; // Warna untuk hari ini
                }

                if (eventCount > 0) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: markerColor,
                      ),
                      width: 20,
                      height: 20,
                      child: Center(
                        child: Text(
                          '$eventCount',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return null; // Return null jika tidak ada indikator yang perlu digambar
                }
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if(_selectedEvents.value.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text(
                      'Tidak ada acara pada hari ini.',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  );
                }else{
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () => print('${value[index]}'),
                            title: Text('${value[index]}'),
                          ),
                        );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}