import 'package:event_manager/event/event_model.dart';
import 'package:localstore/localstore.dart';

class EventService {
  final db = Localstore.getInstance(useSupportDir: true);

  //tên collection trong localstore
  final path = 'events';

  // hàm tạo lấy ds sự kiện từ localstore
  Future<List<EventModel>> getAllEvents() async {
    final eventsMap = await db.collection(path).get();
    if (eventsMap != null) {
      return eventsMap.entries.map((entry) {
        final eventData = entry.value as Map<String, dynamic>;
        if (!eventData.containsKey('id')) {
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();
    }
    return [];
  }

  // Hàm lưu sự kiện vào localstore
  Future<void> saveEvent(EventModel item) async {
    // nếu id ko tồn tại (tạo mới)thì lấy id ngẫu nhiên
    item.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(item.id).set(item.toMap());
  }

// hàm xóa 1 sự kiện trong localStore
  Future<void> deleteEvent(EventModel item) async {
    await db.collection(path).doc(item.id).set(item.toMap());
  }
}
