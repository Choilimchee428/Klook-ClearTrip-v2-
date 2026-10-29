import 'package:flutter/material.dart';
import '../api.dart';
import '../models.dart';
import '../widgets.dart';
import 'c_result_sheet.dart';

/// Screen B — 통합 예약 확인 (Unified Booking Review).
/// B-1 AppBar P03/P04; B-2 안내 P02; B-3 정보 카드 P05/P06;
/// B-4 수정 P03; B-5 중요 규정 P05/P08; B-6 정책 Sheet P10;
/// B-7 연락처 안내 P05; B-8 확인 체크 P05; B-9 결과 버튼 P01/P05.
class BookingReviewScreen extends StatefulWidget {
  const BookingReviewScreen({super.key, required this.selection});
  final BookingSelection selection;
  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  bool _acknowledged = false;

  @override
  Widget build(BuildContext context) {
    final selection = widget.selection;
    return Scaffold(
      appBar: AppBar(title: const Text('Review your booking',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
      body: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 850;
        return Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: wide ? 25 : 16, vertical: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // B-2 P02 — what the user should verify now.
              const Eyebrow('Step 2 of 3 · Clear review'),
              const SizedBox(height: 9),
              Text('예약 전, 중요한 내용만\n한눈에 확인하세요.',
                style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 9),
              const Text('날짜·상품·금액·취소 규정을 따로 찾지 않아도 됩니다.',
                style: TextStyle(fontSize: 13, color: muted)),
              const SizedBox(height: 20),
              if (wide)
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: _bookingCard(selection)),
                  const SizedBox(width: 18),
                  Expanded(child: Column(children: [
                    _conditionsCard(selection),
                    const SizedBox(height: 14),
                    _contactCard(),
                  ])),
                ])
              else ...[
                _bookingCard(selection),
                const SizedBox(height: 14),
                _conditionsCard(selection),
                const SizedBox(height: 14),
                _contactCard(),
              ],
              const SizedBox(height: 14),
              _confirmationCard(selection),
              const SizedBox(height: 18),
              const Center(child: Text('수업용 프로토타입 · 결제 및 실제 예약 기능 없음',
                style: TextStyle(fontSize: 11, color: muted))),
            ]),
          ),
        ));
      }),
    );
  }

  Widget _bookingCard(BookingSelection s) => SectionCard(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        const Expanded(child: Text('예약 정보', style: TextStyle(
          fontSize: 17, fontWeight: FontWeight.w800))),
        // B-4 P03: can always return to change selection.
        TextButton.icon(onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('수정하기')),
      ]),
      const SizedBox(height: 9),
      Container(width: double.infinity, padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFFFF5EE),
          borderRadius: BorderRadius.circular(13)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Eyebrow('Your ticket'),
          const SizedBox(height: 7),
          Text(s.product.title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(s.product.subtitle,
            style: const TextStyle(color: muted, fontSize: 12)),
        ])),
      const SizedBox(height: 12),
      InfoPair(label: '이용 날짜', value: s.displayDate),
      InfoPair(label: '인원', value: '성인 ${s.quantity}명'),
      InfoPair(label: '티켓 단가', value: '¥${s.unitPrice}'),
      const Divider(height: 26),
      // B-3 P05/P06: previously split booking and price summaries.
      InfoPair(label: '총 모의 금액', value: '¥${s.totalPrice}', strong: true),
      const Text('실제 결제 금액이 아닌, 화면 검증용 예시 금액입니다.',
        style: TextStyle(fontSize: 11, color: muted)),
    ],
  ));

  Widget _conditionsCard(BookingSelection s) => SectionCard(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Row(children: [
        Icon(Icons.verified_user_outlined, color: Color(0xFFFF5B24)),
        SizedBox(width: 9),
        Expanded(child: Text('중요 예약 조건',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
      ]),
      const SizedBox(height: 10),
      // B-5 P05/P08: high-impact terms shown directly, not truncated.
      const ConditionRow(icon: Icons.bolt_rounded, title: '즉시 확인',
        description: '결과 화면의 상태는 수업용 가상 데이터입니다.'),
      ConditionRow(icon: Icons.event_available_outlined,
        title: '선택한 날짜에만 사용 가능',
        description: '유효 날짜: ${s.displayDate}'),
      ConditionRow(icon: Icons.report_problem_outlined,
        title: s.product.policyTitle,
        description: s.product.policyDescription, alert: true),
      const Divider(height: 23),
      // B-6 P10: actual second GET /policies in a modal sheet.
      TextButton.icon(
        onPressed: () => showModalBottomSheet<void>(
          context: context, isScrollControlled: true, showDragHandle: true,
          builder: (context) => _PolicySheet(productId: s.product.id)),
        icon: const Icon(Icons.menu_book_outlined),
        label: const Text('전체 이용 규정 보기'),
      ),
    ],
  ));

  Widget _contactCard() => const SectionCard(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Icon(Icons.contact_mail_outlined, size: 23, color: Color(0xFFFF5B24)),
        SizedBox(width: 9),
        Expanded(child: Text('연락처 관련 안내',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
      ]),
      SizedBox(height: 10),
      Text('기존 앱에서는 제출 후 일부 정보 수정이 제한될 수 있습니다.\n'
        '이 프로토타입은 개인정보를 수집하지 않습니다.',
        style: TextStyle(color: muted, fontSize: 13, height: 1.55)),
    ],
  ));

  Widget _confirmationCard(BookingSelection selection) => SectionCard(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('최종 확인', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const SizedBox(height: 5),
      const Text('위험 정보는 기본 노출하고 상세 정책만 추가로 열도록 설계했습니다.',
        style: TextStyle(fontSize: 12, color: muted)),
      const SizedBox(height: 12),
      // B-8 P05 · STATE S4: only this checkbox changes B-9 enabled state.
      CheckboxListTile(
        value: _acknowledged,
        onChanged: (value) => setState(() => _acknowledged = value ?? false),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text('날짜, 인원, 금액과 취소 규정을 확인했습니다.',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        subtitle: const Text('체크박스의 효용은 셀프 논증에서 재검토할 설계 가설입니다.',
          style: TextStyle(fontSize: 11, color: muted)),
      ),
      const SizedBox(height: 11),
      // B-9: opens modal C result, not a payment or booking request.
      SizedBox(width: double.infinity, child: FilledButton.icon(
        onPressed: _acknowledged
          ? () => ResultSheet.show(context, selection) : null,
        icon: const Icon(Icons.arrow_forward_rounded),
        label: const Text('모의 예약 결과 보기'),
      )),
    ],
  ));
}

class _PolicySheet extends StatefulWidget {
  const _PolicySheet({required this.productId});
  final String productId;
  @override
  State<_PolicySheet> createState() => _PolicySheetState();
}

class _PolicySheetState extends State<_PolicySheet> {
  late Future<String> _future;
  @override
  void initState() {
    super.initState();
    _future = fetchPolicyDetails(widget.productId);
  }
  @override
  Widget build(BuildContext context) => SafeArea(child: Padding(
    padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
    child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 650),
      child: Column(mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('상세 이용 규정', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('로컬 json-server · GET /policies',
            style: TextStyle(fontSize: 11, color: muted)),
          const SizedBox(height: 18),
          FutureBuilder<String>(future: _future, builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()));
            }
            if (snap.hasError) {
              return Column(children: [
                const Text('이용 규정을 불러오지 못했습니다.'),
                TextButton(onPressed: () => setState(() {
                  _future = fetchPolicyDetails(widget.productId);
                }), child: const Text('다시 시도')),
              ]);
            }
            return Text(snap.data ?? '안내 없음',
              style: const TextStyle(fontSize: 14, height: 1.7));
          }),
          const SizedBox(height: 20),
          const Text('※ 실제 약관이 아닌 수업용 예시입니다. 실제 이용 시 공식 판매 조건을 확인해야 합니다.',
            style: TextStyle(color: muted, fontSize: 11)),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'))),
        ])),
  ));
}
