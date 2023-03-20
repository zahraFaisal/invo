// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderHeader _$OrderHeaderFromJson(Map<String, dynamic> json) {
  return OrderHeader(
      id: json['id'] as int,
      terminal_id: json['terminal_id'] as int,
      ticket_number: json['ticket_number'] as int,
      GUID: json['GUID'] as String,
      service_id: json['service_id'] as int,
      service: json['service'] == null ? null : ServiceReference.fromJson(json['service'] as Map<String, dynamic>),
      employee_id: json['employee_id'] as int,
      employee: json['employee'] == null ? null : EmployeeReference.fromJson(json['employee'] as Map<String, dynamic>),
      dinein_table_id: json['dinein_table_id'] as int,
      dinein_table: json['dinein_table'] == null ? null : DineInTableReference.fromJson(json['dinein_table'] as Map<String, dynamic>),
      discount_id: json['discount_id'] as int,
      discount: json['discount'] == null ? null : DiscountReference.fromJson(json['discount'] as Map<String, dynamic>),
      discount_amount: (json['discount_amount'] as num).toDouble(),
      discount_percentage: json['discount_percentage'] as bool,
      surcharge: json['surcharge'] != null ? SurchargeReference.fromJson(json['surcharge'] as Map<String, dynamic>) : json['surcharge'],
      surcharge_amount: (json['surcharge_amount'] as num).toDouble(),
      surcharge_percentage: json['surcharge_percentage'] as bool,
      customer: json['customer'] == null ? null : CustomerReference.fromJson(json['customer'] as Map<String, dynamic>),
      customer_id_number: json['customer_id_number'] as int,
      customer_contact: json['customer_contact'] as String,
      customer_address: json['customer_address'] as String,
      driver: json['driver'] == null ? null : EmployeeReference.fromJson(json['driver'] as Map<String, dynamic>),
      depature_time: json['depature_time'] == null ? null : DateTime.parse(json['depature_time'] as String),
      arrival_time: json['arrival_time'] == null ? null : DateTime.parse(json['arrival_time'] as String),
      total_tax: (json['total_tax'] as num).toDouble(),
      total_tax2: (json['total_tax2'] as num).toDouble(),
      total_tax3: (json['total_tax3'] as num).toDouble(),
      grand_price: (json['grand_price'] as num).toDouble(),
      status: json['status'] as int,
      date_time: json['date_time'] == null ? null : DateTime.parse(json['date_time'] as String),
      no_of_guests: json['no_of_guests'] as int,
      Smallest_currency: (json['Smallest_currency'] as num).toDouble(),
      total_charge_per_hour: (json['total_charge_per_hour'] as num).toDouble(),
      Round_Type: json['Round_Type'] as int,
      charge_after: json['charge_after'] as int,
      Label: json['Label'] as String,
      charge_per_hour: (json['charge_per_hour'] as num).toDouble(),
      minimum_charge: (json['minimum_charge'] as num).toDouble(),
      min_charge: (json['min_charge'] as num).toDouble(),
      discount_actual_amount: (json['discount_actual_amount'] as num).toDouble(),
      surcharge_actual_amount: (json['surcharge_actual_amount'] as num).toDouble(),
      sub_total_price: (json['sub_total_price'] as num).toDouble(),
      delivery_charge: (json['delivery_charge'] as num).toDouble(),
      surcharge_apply_tax1: json['surcharge_apply_tax1'] as bool,
      surcharge_apply_tax2: json['surcharge_apply_tax2'] as bool,
      surcharge_apply_tax3: json['surcharge_apply_tax3'] as bool,
      tax1: (json['tax1'] as num).toDouble(),
      tax2: (json['tax2'] as num).toDouble(),
      tax3: (json['tax3'] as num).toDouble(),
      tax2_tax1: json['tax2_tax1'] as bool,
      transaction: (json['transaction'] as List).map((e) => e == null ? OrderTransaction() : OrderTransaction.fromJson(e as Map<String, dynamic>)).toList(),
      payments: [])
    ..Rounding = (json['Rounding'] as num).toDouble()
    ..item_total = (json['item_total'] as num).toDouble()
    ..taxable1_amount = (json['taxable1_amount'] as num).toDouble()
    ..taxable2_amount = (json['taxable2_amount'] as num).toDouble()
    ..taxable3_amount = (json['taxable3_amount'] as num).toDouble();
}

Map<String, dynamic> _$OrderHeaderToJson(OrderHeader instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'ticket_number': instance.ticket_number,
    'service': instance.service,
    'employee': instance.employee,
    'PrintCopy': instance.PrintCopy ?? 0,
    'print_time': instance.print_time != null ? "/Date(" + (instance.print_time!.millisecondsSinceEpoch + new DateTime.now().timeZoneOffset.inMilliseconds).toString() + ")/" : instance.print_time //if invo need the print time
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  void writeNotDefault(String key, dynamic value) {
    if (value is double || value is int) {
      if (value != 0) {
        val[key] = value;
      }
    } else if (value is bool) {
      if (value != false) {
        val[key] = value;
      }
    }
  }

  List _transaction = [];
  for (var item in instance.transaction) {
    _transaction.add(item.toJson());
  }

  List _payments = [];
  for (var item in instance.payments) {
    _payments.add(item.toJson());
  }
  writeNotDefault('service_id', instance.service_id);
  writeNotDefault('terminal_id', instance.terminal_id);
  writeNotDefault('employee_id', instance.employee_id);
  writeNotNull('dinein_table_id', instance.dinein_table_id);
  writeNotNull('dinein_table', instance.dinein_table);
  writeNotNull('date_time', "/Date(" + (instance.date_time!.millisecondsSinceEpoch + new DateTime.now().timeZoneOffset.inMilliseconds).toString() + ")/");
  writeNotNull('discount_id', instance.discount_id == 0 ? null : instance.discount_id);
  writeNotNull('discount', instance.discount);
  writeNotDefault('discount_percentage', instance.discount_percentage);
  writeNotDefault('discount_amount', instance.discount_amount);
  writeNotNull('surcharge', instance.surcharge);
  writeNotDefault('surcharge_percentage', instance.surcharge_percentage);
  writeNotDefault('surcharge_amount', instance.surcharge_amount);
  writeNotNull('customer', instance.customer);
  writeNotNull('customer_id_number', instance.customer_id_number);
  writeNotNull('customer_contact', instance.customer_contact);
  writeNotNull('customer_address', instance.customer_address);
  writeNotDefault('no_of_guests', instance.no_of_guests);
  writeNotDefault('minimum_charge', instance.minimum_charge);
  writeNotDefault('charge_per_hour', instance.charge_per_hour);
  writeNotDefault('charge_after', instance.charge_after);
  val['status'] = instance.status;
  writeNotNull('Label', instance.Label);
  writeNotDefault('total_tax', instance.total_tax);
  writeNotDefault('total_tax2', instance.total_tax2);
  writeNotDefault('total_tax3', instance.total_tax3);
  writeNotDefault('total_charge_per_hour', instance.total_charge_per_hour);
  val['grand_price'] = instance.grand_price;
  val['GUID'] = instance.GUID;
  writeNotDefault('Smallest_currency', instance.Smallest_currency);
  val['Round_Type'] = instance.Round_Type;
  writeNotDefault('Rounding', instance.Rounding);
  // val['transaction'] = instance.transaction;
  val['transaction'] = _transaction;

  val['payments'] = _payments;
  writeNotDefault('item_total', instance.item_total);
  writeNotDefault('delivery_charge', instance.delivery_charge);
  writeNotDefault('min_charge', instance.min_charge);
  writeNotDefault('discount_actual_amount', instance.discount_actual_amount);
  writeNotDefault('surcharge_actual_amount', instance.surcharge_actual_amount);
  writeNotDefault('sub_total_price', instance.sub_total_price);
  writeNotDefault('tax1', instance.tax1);
  writeNotDefault('tax2', instance.tax2);
  writeNotDefault('tax3', instance.tax3);
  writeNotDefault('tax2_tax1', instance.tax2_tax1);
  writeNotDefault('taxable1_amount', instance.taxable1_amount);
  writeNotDefault('taxable2_amount', instance.taxable2_amount);
  writeNotDefault('taxable3_amount', instance.taxable3_amount);
  writeNotDefault('surcharge_apply_tax1', instance.surcharge_apply_tax1);
  writeNotDefault('surcharge_apply_tax2', instance.surcharge_apply_tax2);
  writeNotDefault('surcharge_apply_tax3', instance.surcharge_apply_tax3);
  writeNotNull('driver', instance.driver);
  writeNotNull('depature_time', instance.depature_time?.toIso8601String());
  writeNotNull('arrival_time', instance.arrival_time?.toIso8601String());
  return val;
}
