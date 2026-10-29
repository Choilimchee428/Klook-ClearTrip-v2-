import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';

/// Screen C — 모의 예약 결과. No booking/receipt/payment is created.
/// C-1 header P04; C-2 status P01; C-3 booking summary P06;
/// C-4 demo status switch P01; C-5 next action P09/P10; C-6 back P03.
class ResultSheet extends StatefulWidget {
  const ResultSheet({super.key, required this.selection});
  final BookingSelection selection;

  static Future<void> show(BuildContext context, BookingSelection selection) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF8F8FB),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.91,
        child: ResultSheet(selection: selection),
      ),
    );
  }

  @override
  State<ResultSheet> createState() => _ResultSheetState();
}

class _ResultSheetState extends State<ResultSheet> {
  DemoBookingStatus _status = DemoBookingStatus.confirmed;

  IconData get _icon => switch (_status) {
    DemoBookingStatus.confirmed => Icons.check_circle_rounded,
    DemoBookingStatus.pending => Icons.schedule_rounded,
    DemoBookingStatus.actionNeeded => Icons.error_outline_rounded,
  };

  Color get _color => switch (_status) {
    DemoBookingStatus.confirmed => const Color(0xFF148765),
    DemoBookingStatus.pending => const Color(0xFFB97B00),
    DemoBookingStatus.actionNeeded => const Color(0xFFD84A37),
  };

  String get _heading => switch (_status) {
    DemoBookingStatus.confirmed => '예약 확정 · Confirmed',
    DemoBookingStatus.pending => '확인 대기 · Pending',
    DemoBookingStatus.actionNeeded => '조치 필요 · Action needed',
  };

  String get _explanation => switch (_status) {
    DemoBookingStatus.confirmed => '모의 예약이 확정 상태로 표시되었습니다.\n실제 예약이나 바우처는 발급되지 않았습니다.',
    DemoBookingStatus.pending => '모의 요청이 접수되었지만 아직 확정되지 않았습니다.\n확정 전에는 사용 가능한 티켓으로 판단하면 안 됩니다.',
    DemoBookingStatus.actionNeeded => '모의 예약에 확인이 필요한 항목이 있습니다.\n날짜와 조건을 다시 검토해 주세요.',
  };

  String get _nextAction => switch (_status) {
    DemoBookingStatus.confirmed => '여행 당일 이용 전 규정과 유효 날짜를 다시 확인합니다.',
    DemoBookingStatus.pending => '현재는 대기 상태입니다. 확정 안내를 확인해야 합니다.',
    DemoBookingStatus.actionNeeded => '이전 화면으로 돌아가 선택 조건을 다시 확인합니다.',
  };

  @override
  Widget build(BuildContext context) {
    final s = widget.selection;
    return SafeArea(child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 660),
      child: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 25), children: [
        // C-1
        Row(children: [
          const Expanded(child: Text('Booking result · Demo',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
          IconButton(tooltip: '닫기', onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close)),
        ]),
        const SizedBox(height: 5),
        const Eyebrow('Step 3 of 3 · Status clarity'),
        const SizedBox(height: 15),
        // C-4 P01 STATE S5: demo-only status, user cannot change a real booking.
        const Text('상태 비교 · 시연용', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 9),
        SizedBox(width: double.infinity, child: SegmentedButton<DemoBookingStatus>(
          segments: const [
            ButtonSegment(value: DemoBookingStatus.confirmed,
              label: Text('확정', style: TextStyle(fontSize: 12))),
            ButtonSegment(value: DemoBookingStatus.pending,
              label: Text('대기', style: TextStyle(fontSize: 12))),
            ButtonSegment(value: DemoBookingStatus.actionNeeded,
              label: Text('조치 필요', style: TextStyle(fontSize: 12))),
          ],
          selected: {_status},
          onSelectionChanged: (values) => setState(() => _status = values.first),
          showSelectedIcon: false,
        )),
        const SizedBox(height: 14),
        // C-2 P01: explicit status label + icon, never color only.
        SectionCard(child: Column(children: [
          Icon(_icon, size: 58, color: _color),
          const SizedBox(height: 12),
          Text(_heading, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _color)),
          const SizedBox(height: 9),
          Text(_explanation, textAlign: TextAlign.center,
            style: const TextStyle(color: muted, height: 1.55)),
        ])),
        const SizedBox(height: 13),
        // C-3 P04/P06: same values as A and B, no invented confirmation number.
        SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('선택한 예약 정보',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(s.product.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          InfoPair(label: '날짜', value: s.displayDate),
          InfoPair(label: '인원', value: '성인 ${s.quantity}명'),
          const Divider(height: 20),
          InfoPair(label: '모의 합계', value: '¥${s.totalPrice}', strong: true),
        ])),
        const SizedBox(height: 13),
        // C-5 P09/P10: state-specific next steps.
        SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('다음에 할 일',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 9),
          Text(_nextAction, style: const TextStyle(height: 1.5)),
        ])),
        const SizedBox(height: 15),
        // C-6 P03: dismiss modal and review B screen.
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('예약 확인 화면으로 돌아가기'),
        )),
        const SizedBox(height: 10),
        const Text('⚠ 위 세 가지 상태는 모두 수업용 모의 결과입니다.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: muted)),
      ]),
    )));
  }
}
