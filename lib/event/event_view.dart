import 'package:event_manager/event/event_data_source.dart';
import 'package:event_manager/event/event_detail_view.dart';
import 'package:event_manager/event/event_model.dart';
import 'package:event_manager/event/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  final eventService = EventService();
//danh sách sk
  List<EventModel> items = [];
  //tạo calendar controller để điều khiển sfCalendar
  final calendarController = CalendarController();
  @override
  void initState() {
    super.initState();
    calendarController.view = CalendarView.day;
    loadEvents();
  }

  Future<void> loadEvents() async {
    final events = await eventService.getAllEvents();
    setState(() {
      items = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(al.appTitle),
        actions: [
          PopupMenuButton<CalendarView>(
            onSelected: (value) {
              setState(() {
                calendarController.view = value;
              });
            },
            itemBuilder: (context) => CalendarView.values.map((view) {
              return PopupMenuItem<CalendarView>(
                value: view,
                child: ListTile(
                  title: Text(view.name),
                ),
              );
            }).toList(),
            icon: getCalendarViewIcon(calendarController.view!),
          ),
          IconButton(
              onPressed: () {
                calendarController.displayDate = DateTime.now();
              },
              icon: const Icon(Icons.today_outlined)),
          IconButton(onPressed: loadEvents, icon: const Icon(Icons.refresh))
        ],
      ),
      body: SfCalendar(
        controller: calendarController,
        dataSource: EventDataSource(items),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        //nhấn giữ cell để thêm sự kiện
        onLongPress: (details) {
          // nếu k có sự kiện trong cell
          if (details.targetElement == CalendarElement.calendarCell) {
            // tạo 1 đối tượng sự kiện theo thời gian lịch giao diện
            final newEvent = EventModel(
                startTime: details.date!,
                endTime: details.date!.add(const Duration(hours: 1)),
                subject: '');
            //điều hướng và định tuyến bằng cách đưa new Event vào detail view
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return EventDetailView(event: newEvent);
              },
            )).then((value) async {
              // sau khi pop ở detail view
              if (value == true) {
                await loadEvents();
              }
            });
          }
        },
        //chạm vào sự kiện để xem và cập nhật
        onTap: (details) {
          //khi chạm vào sự kiện -> sửa or xóa
          if (details.targetElement == CalendarElement.appointment) {
            final event = details.appointments!.first;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return EventDetailView(event: event);
              },
            ));
          }
        },
      ),
    );
  }

  // hàm lấy icon tương ứng calendar vỉew
  Icon getCalendarViewIcon(CalendarView view) {
    switch (view) {
      case CalendarView.day:
        return const Icon(Icons.calendar_view_day_outlined);
      case CalendarView.week:
        return const Icon(Icons.calendar_view_week_outlined);
      case CalendarView.workWeek:
        return const Icon(Icons.work_history_outlined);
      case CalendarView.month:
        return const Icon(Icons.calendar_view_month_outlined);
      case CalendarView.schedule:
        return const Icon(Icons.schedule_outlined);

      default:
        return const Icon(Icons.calendar_today_outlined);
    }
  }
}
