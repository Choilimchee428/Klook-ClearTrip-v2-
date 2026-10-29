/// Classroom-only product and booking data. No real inventory, payment or booking.
class TravelProduct {
  const TravelProduct({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.basePrice,
    required this.tags,
    required this.policyTitle,
    required this.policyDescription,
  });

  final String id;
  final String title;
  final String subtitle;
  final int basePrice;
  final List<String> tags;
  final String policyTitle;
  final String policyDescription;

  static TravelProduct? fromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final id = value['id']?.toString(); // json-server v1 uses string IDs.
    final title = value['title'];
    final subtitle = value['subtitle'];
    final basePrice = value['basePrice'];
    if (id == null || title is! String || subtitle is! String ||
        basePrice is! num) {
      return null;
    }
    return TravelProduct(
      id: id,
      title: title,
      subtitle: subtitle,
      basePrice: basePrice.toInt(),
      tags: value['tags'] is List
          ? (value['tags'] as List).whereType<String>().toList()
          : const [],
      policyTitle: value['policyTitle'] is String
          ? value['policyTitle'] as String : '이용 조건 확인',
      policyDescription: value['policyDescription'] is String
          ? value['policyDescription'] as String : '상세 규정을 확인해 주세요.',
    );
  }
}

class BookingSelection {
  const BookingSelection({
    required this.product,
    required this.date,
    required this.unitPrice,
    required this.quantity,
  });
  final TravelProduct product;
  final DateTime date;
  final int unitPrice;
  final int quantity;
  int get totalPrice => unitPrice * quantity;
  String get displayDate => '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
}

enum DemoBookingStatus { confirmed, pending, actionNeeded }
