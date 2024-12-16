import 'package:bika/src/theme/color.dart';
import 'package:bika/src/api/profile.dart';
import 'package:bika/src/views/toast.dart';
import 'package:flutter/material.dart';

// 签到
class PunchInWidget extends StatefulWidget {
  final bool initialPunchState;
  const PunchInWidget({super.key, required this.initialPunchState});

  @override
  State<PunchInWidget> createState() => _PunchInWidgetState();
}

class _PunchInWidgetState extends State<PunchInWidget> {
  bool _isPunching = false;
  late bool _isPunched;

  @override
  void initState() {
    super.initState();
    _isPunched = widget.initialPunchState;
  }

  void _onPunchButtonClicked() async {
    setState(() {
      _isPunching = true;
    });
    try {
      final punchData = await ProfileApi.punchIn();
      if (punchData.res.status == 'ok') {
        _isPunched = true;
        // toast 提示
        GlobalToast.show('打卡成功',
            debugMessage: "punchInLastDay: ${punchData.res.punchInLastDay}");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPunching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPunched) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              '已打卡',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    } else {
      return TextButton(
        onPressed: () => {_onPunchButtonClicked()},
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primaryColor(context),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isPunching)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 16,
              ),
            const SizedBox(width: 4),
            const Text(
              '打卡',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
  }
}
