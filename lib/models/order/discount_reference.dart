import 'package:json_annotation/json_annotation.dart';

import '../discount.dart';

part 'discount_reference.g.dart';

@JsonSerializable()
class DiscountReference {
  int id;
  String name;
  List<DiscountItem>? items;
  DiscountReference({this.id = 0, required this.name, this.items});

  factory DiscountReference.fromJson(Map<String, dynamic> json) {
    List<DiscountItem> _items = List<DiscountItem>.empty(growable: true);
    if (json.containsKey('items') && json['items'] != null)
      for (var item in json['items']) {
        _items.add(DiscountItem.fromJson(item));
      }

    return DiscountReference(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      items: _items,
    );
  }

  Map<String, dynamic> toJson() => _$DiscountReferenceToJson(this);

  factory DiscountReference.fromDiscount(Discount discount) {
    return DiscountReference(id: discount.id, name: discount.name, items: discount.items);
  }
}
