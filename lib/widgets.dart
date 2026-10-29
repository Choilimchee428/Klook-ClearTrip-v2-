import 'package:flutter/material.dart';

const muted = Color(0xFF687183);
const lineColor = Color(0xFFE8EAF0);

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.padding = const EdgeInsets.all(20)});
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: padding, child: child));
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
    style: const TextStyle(color: Color(0xFFFF5B24), fontSize: 11,
      letterSpacing: 1.7, fontWeight: FontWeight.w800));
}

class InfoPair extends StatelessWidget {
  const InfoPair({super.key, required this.label, required this.value, this.strong = false});
  final String label;
  final String value;
  final bool strong;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(color: muted, fontSize: 13))),
      Flexible(child: Text(value, textAlign: TextAlign.end,
        style: TextStyle(fontSize: strong ? 19 : 14,
          fontWeight: strong ? FontWeight.w800 : FontWeight.w700))),
    ]),
  );
}

class ConditionRow extends StatelessWidget {
  const ConditionRow({super.key, required this.icon, required this.title,
    required this.description, this.alert = false});
  final IconData icon;
  final String title;
  final String description;
  final bool alert;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: alert ? const Color(0xFFFFF0E8) : const Color(0xFFECF8F2),
          borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 19,
          color: alert ? const Color(0xFFE86A33) : const Color(0xFF118764))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(color: muted, fontSize: 12, height: 1.4)),
      ])),
    ]),
  );
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      CircularProgressIndicator(), SizedBox(height: 20),
      Text('상품 정보를 불러오는 중…'),
    ]),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.onRetry});
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.inbox_outlined, size: 64, color: muted),
        const SizedBox(height: 18),
        const Text('표시할 여행 상품이 없습니다.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 9),
        const Text('다른 상품을 확인하거나 목록을 다시 불러와 주세요.', textAlign: TextAlign.center),
        if (onRetry != null) ...[
          const SizedBox(height: 14),
          OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('다시 시도')),
        ],
      ]),
    ),
  );
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.wifi_off_rounded, size: 62, color: muted),
        const SizedBox(height: 18),
        const Text('상품을 불러오지 못했습니다.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 9),
        const Text('로컬 서버 연결을 확인해 주세요.\nhttp://localhost:3100/items',
          textAlign: TextAlign.center, style: TextStyle(color: muted)),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('다시 시도')),
      ]),
    ),
  );
}
