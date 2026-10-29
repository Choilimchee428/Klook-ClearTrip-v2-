import 'package:flutter/material.dart';
import '../api.dart';
import '../models.dart';
import '../widgets.dart';
import 'b_detail_screen.dart';

/// Screen A — 상품 및 옵션 선택.
/// A-1 AppBar P04; A-2 상품 카드 P02/P06; A-3 선택 P07;
/// A-4 날짜/가격 P05/P06; A-5 인원 P03/P05; A-6 조건 P06;
/// A-7 총액 P01; A-8 확인 이동 P03/P05.
class PackageSelectionScreen extends StatefulWidget {
  const PackageSelectionScreen({super.key});
  @override
  State<PackageSelectionScreen> createState() => _PackageSelectionScreenState();
}

class _PackageSelectionScreenState extends State<PackageSelectionScreen> {
  late Future<List<TravelProduct>> _future;
  String? _chosenId;
  int _dayIndex = 1;
  int _quantity = 1;
  bool _showDemo = false;
  String _demoMode = 'normal';
  final List<DateTime> _dates = [
    DateTime(2026, 10, 30), DateTime(2026, 10, 31), DateTime(2026, 11, 1),
  ];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    // Actual HTTP GET; Future stored outside build to avoid repeated requests.
    _future = Future<List<TravelProduct>>.delayed(
      const Duration(milliseconds: 650), fetchProducts,
    );
  }

  void _retry() => setState(() {
    _demoMode = 'normal';
    _refresh();
  });

  int _priceFor(TravelProduct p, int i) => p.basePrice + (i == 0 ? -42 : 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.explore_rounded, color: Color(0xFFFF5B24), size: 27),
          SizedBox(width: 10),
          Text('Klook', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
          SizedBox(width: 8),
          Text('ClearTrip v2', style: TextStyle(fontSize: 12, color: muted, fontWeight: FontWeight.w600)),
        ]),
        actions: [
          Tooltip(message: '상태 화면 시연', child: IconButton(
            icon: Icon(_showDemo ? Icons.tune_rounded : Icons.science_outlined),
            onPressed: () => setState(() => _showDemo = !_showDemo),
          )),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(children: [
        if (_showDemo) _demoBar(),
        Expanded(child: FutureBuilder<List<TravelProduct>>(
          future: _future,
          builder: (context, snap) {
            if (_demoMode == 'loading') return const LoadingState();
            if (_demoMode == 'error') return ErrorState(onRetry: _retry);
            if (_demoMode == 'empty') return EmptyState(onRetry: _retry);
            if (snap.connectionState != ConnectionState.done) return const LoadingState();
            if (snap.hasError) return ErrorState(onRetry: _retry);
            final products = snap.data ?? [];
            if (products.isEmpty) return EmptyState(onRetry: _retry);
            final selected = products.firstWhere(
              (p) => p.id == _chosenId, orElse: () => products.first,
            );
            return _responsiveBody(products, selected);
          },
        )),
      ]),
    );
  }

  Widget _demoBar() => Container(
    color: const Color(0xFFFFF1E9),
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
    child: Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8, runSpacing: 0, children: [
      const Text('화면 상태 시연', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      for (final item in const [('normal', 'GET 정상'), ('loading', '로딩'), ('error', '오류'), ('empty', '빈 상태')])
        ChoiceChip(
          label: Text(item.$2, style: const TextStyle(fontSize: 11)),
          selected: _demoMode == item.$1,
          visualDensity: VisualDensity.compact,
          onSelected: (_) => setState(() {
            _demoMode = item.$1;
            if (_demoMode == 'normal') _refresh();
          }),
        ),
      const Text('※ 시연용 상태', style: TextStyle(color: muted, fontSize: 10)),
    ]),
  );

  Widget _responsiveBody(List<TravelProduct> products, TravelProduct selected) {
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 900;
      return Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: wide ? 26 : 16, vertical: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _hero(),
            const SizedBox(height: 24),
            if (wide)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 6, child: _productList(products, selected)),
                const SizedBox(width: 22),
                Expanded(flex: 5, child: _selectionPanel(selected)),
              ])
            else ...[
              _productList(products, selected),
              const SizedBox(height: 18),
              _selectionPanel(selected),
            ],
            const SizedBox(height: 25),
            const Center(child: Text('수업용 비공식 UX/UI 프로토타입 · 실제 결제 및 예약 불가',
              textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 11))),
          ]),
        ),
      ));
    });
  }

  Widget _hero() => Container(
    width: double.infinity,
    constraints: const BoxConstraints(minHeight: 176),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFFFF713C), Color(0xFFFFA65B), Color(0xFFFBD7A2)],
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(children: [
      Positioned(right: -25, top: -55, child: Container(width: 230, height: 230,
        decoration: BoxDecoration(shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.28), width: 40)))),
      Positioned(right: 34, bottom: -10, child: Icon(Icons.attractions_rounded, size: 145,
        color: Colors.white.withValues(alpha: 0.7))),
      Padding(padding: const EdgeInsets.all(25), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('OSAKA · JAPAN',
            style: TextStyle(letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 14),
          const Text('설레는 여행,\n확실한 예약.',
            style: TextStyle(fontSize: 29, height: 1.24, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 13),
          Text('중요한 예약 조건을 한눈에 확인하세요.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 12)),
        ],
      )),
    ]),
  );

  Widget _productList(List<TravelProduct> products, TravelProduct selected) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Eyebrow('01 · Explore'),
      const SizedBox(height: 5),
      Text('여행 상품 선택', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 7),
      const Text('로컬 json-server의 GET /items에서 불러온 실제 모의 데이터입니다.',
        style: TextStyle(color: muted, fontSize: 12)),
      const SizedBox(height: 15),
      for (final p in products) ...[
        _productTile(p, p.id == selected.id),
        const SizedBox(height: 10),
      ],
    ],
  );

  Widget _productTile(TravelProduct p, bool selected) => Material(
    color: selected ? const Color(0xFFFFF6F0) : Colors.white,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => setState(() {
        _chosenId = p.id; // STATE S1: 선택 상품 → A-2/A-3/A-7.
        _quantity = 1;
      }),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? const Color(0xFFFF7A49) : lineColor,
            width: selected ? 1.8 : 1),
        ),
        child: Row(children: [
          Container(width: 72, height: 72,
            decoration: BoxDecoration(color: const Color(0xFFFFE8D7), borderRadius: BorderRadius.circular(13)),
            child: Icon(p.id == 'usj' ? Icons.attractions_outlined :
              p.id == 'osaka' ? Icons.local_activity_outlined : Icons.train_outlined,
              size: 39, color: const Color(0xFFFF5B24))),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 4),
            Text(p.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: muted)),
            const SizedBox(height: 7),
            Text('¥${p.basePrice} 부터', style: const TextStyle(
              fontWeight: FontWeight.w900, color: Color(0xFFFF5B24), fontSize: 15)),
          ])),
          Icon(selected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: selected ? const Color(0xFFFF5B24) : muted),
        ]),
      ),
    ),
  );

  Widget _selectionPanel(TravelProduct product) {
    final unit = _priceFor(product, _dayIndex);
    final selection = BookingSelection(
      product: product, date: _dates[_dayIndex], unitPrice: unit, quantity: _quantity,
    );
    return SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Eyebrow('02 · Select your options'),
      const SizedBox(height: 7),
      Text('날짜 및 인원 선택', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Text(product.title, style: const TextStyle(fontSize: 12, color: muted)),
      const SizedBox(height: 22),
      const Text('이용 날짜', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
      const SizedBox(height: 9),
      // A-4 P05/P06 · STATE S2: date changes displayed price and review summary.
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (var i = 0; i < _dates.length; i++)
          ChoiceChip(
            selected: _dayIndex == i,
            label: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('${_dates[i].month}/${_dates[i].day}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('¥${_priceFor(product, i)}', style: const TextStyle(fontSize: 11)),
            ]),
            onSelected: (_) => setState(() => _dayIndex = i),
          ),
      ]),
      const SizedBox(height: 19),
      const Text('인원', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      // A-5 P03/P05 · STATE S3: quantity changes total.
      Row(children: [
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('성인', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('만 12세 이상 · 최대 10명', style: TextStyle(fontSize: 11, color: muted)),
        ])),
        IconButton.outlined(onPressed: _quantity > 1
          ? () => setState(() => _quantity--) : null,
          icon: const Icon(Icons.remove)),
        SizedBox(width: 32, child: Text('$_quantity', textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w800))),
        IconButton.outlined(onPressed: _quantity < 10
          ? () => setState(() => _quantity++) : null,
          icon: const Icon(Icons.add)),
      ]),
      const Divider(height: 29),
      // A-6 P06 · visible critical policy before tapping forward.
      const ConditionRow(icon: Icons.event_available_outlined,
        title: '선택한 날짜에만 사용 가능', description: '유효 날짜를 확인해 주세요.'),
      ConditionRow(icon: Icons.info_outline_rounded,
        title: product.policyTitle,
        description: product.policyDescription, alert: true),
      const Divider(height: 28),
      // A-7 P01: real-time visible total for classroom-only simulated data.
      InfoPair(label: '최종 모의 금액 · $_quantity명', value: '¥${selection.totalPrice}', strong: true),
      const SizedBox(height: 12),
      // A-8 P03/P05 · Navigator.push to Screen B.
      SizedBox(width: double.infinity, child: FilledButton.icon(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => BookingReviewScreen(selection: selection))),
        icon: const Icon(Icons.fact_check_outlined),
        label: const Text('예약 내용 확인하기'),
      )),
    ]));
  }
}
