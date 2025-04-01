import 'package:intl/intl.dart';

String formatUpdatedTime(String? isoTime) {
  if (isoTime == null || isoTime.isEmpty) return '未知时间';
  try {
    DateTime utcTime = DateTime.parse(isoTime);
    DateTime localTime = utcTime.toLocal();
    return DateFormat('yyyy-MM-dd HH:mm').format(localTime);
  } catch (e) {
    return '格式错误';
  }
}
