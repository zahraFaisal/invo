import 'package:invo_mobile/models/Number.dart';

class TaxReportModel {
  double tax1;
  double transaction_total;
  double total_tax_amount;
  double non_taxable;
  double taxable_amount;
  String tax1_name;
  TaxReportModel({
    this.tax1 = 0,
    this.transaction_total = 0,
    this.total_tax_amount = 0,
    this.non_taxable = 0,
    this.taxable_amount = 0,
    this.tax1_name = "",
  });

  factory TaxReportModel.fromMap(Map<String, dynamic> map) {
    TaxReportModel taxReportModel = TaxReportModel();
    taxReportModel.tax1 = map['tax1'];
    taxReportModel.transaction_total = map['transaction_total'];
    taxReportModel.total_tax_amount = map['total_tax_amount'];
    taxReportModel.non_taxable = map['non_taxable'];
    taxReportModel.taxable_amount = map['taxable_amount'];
    taxReportModel.tax1_name = map['tax1_name'];
    return taxReportModel;
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'tax1': tax1 == null ? 0.0 : tax1,
      'transaction_total': transaction_total == null ? 0.0 : transaction_total,
      'total_tax1_amount': total_tax_amount == null ? 0.0 : total_tax_amount,
      'non_taxable': non_taxable == null ? 0.0 : non_taxable,
      'taxable_amount': taxable_amount == null ? 0.0 : taxable_amount,
      'tax1_name': tax1_name,
      'tax1_txt': tax1_txt
    };
    return map;
  }

  String get transaction_total_sale {
    return Number.getNumber(transaction_total);
  }

  String get non_taxable_sale {
    return Number.getNumber(this.non_taxable);
  }

  String get total_sale {
    return Number.getNumber((this.transaction_total) + (this.non_taxable));
  }

  String get total_tax1_amount {
    return Number.getNumber(this.total_tax_amount);
  }

  String get tax1_txt {
    return tax1.toString() + "%";
  }

  String get taxName {
    return tax1_name.toString() + "(" + tax1_txt + ")";
  }
}
