import 'package:invo_mobile/models/custom/customer_list.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/customer/customer_address.dart';
import 'package:invo_mobile/models/customer/customer_contact.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/interface/Customer/ICustomerService.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';

import '../sqlite_repository.dart';

class CustomerService implements ICustomerService {
  @override
  Future<Customer?>? get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> customer = (await database!.query("Customers", where: "id_number = ?", whereArgs: [id])).first;
    Customer temp = Customer.fromMap(customer);

    List<Map<String, dynamic>> tempContacts = (await database.query("Customer_contacts", where: "customer_id_number = ?", whereArgs: [id])).toList();
    temp.contacts = [];
    for (var item in tempContacts) {
      temp.contacts.add(CustomerContact.fromMap(item));
    }

    List<Map<String, dynamic>> tempAddresses =
        (await database.query("Customer_addresses", where: "customer_id_number = ?", whereArgs: [id])).toList();
    temp.addresses = [];
    for (var item in tempAddresses) {
      temp.addresses.add(CustomerAddress.fromMap(item));
    }
    return temp;
  }

  @override
  Future<Customer?> getByPhone(String phone) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> customer = (await database!.query("Customer_contacts", where: "contact = ?", whereArgs: [phone]));

    if (customer != null && customer.length > 0) {
      int id = customer[0]['customer_id_number'];
      return await get(id);
    } else {
      return null;
    }
  }

  // "SELECT Top " + limit + @" name,contact as customer_contact,customer_id_number as customer_id
  //                                             FROM Customer_contacts As Contact
  //                                             INNER JOIN Customers on contact.customer_id_number = Customers.id_number
  //                                             Where (type = 1 or type = 2) " + condition + " Order by name"

  @override
  Future<List<CustomerList>?>? getAllCustomers(String _filter) async {
    Database? database = await SqliteRepository().db;
    List<CustomerList> customers = [];
    String condition = "";
    if (_filter != null && _filter != "") {
      condition = " and (name Like '%" + _filter + "%' or contact Like '%" + _filter + "%' or [MSC] = '" + _filter + "')";
    }

    List<String> col = ["name", "contact as customer_contact", "customer_id_number as customer_id"];
    List<Map<String, dynamic>> customer = (await database!.query(
        "Customer_contacts As Contact INNER JOIN Customers on contact.customer_id_number = Customers.id_number",
        columns: col,
        where: "(type = 1 or type = 2) " + condition + " Order by name",
        limit: 10));
    if (customer != null && customer.length > 0) {
      for (var item in customer) {
        customers.add(new CustomerList.fromMap(item));
      }
      return customers;
    } else {
      return [];
    }
  }

  @override
  Future<Customer?> save(Customer customer) async {
    final Database? database = await SqliteRepository().db;
    int customerId;
    if (customer.id_number == 0 || customer.id_number == null)
      customerId = await database!.insert('Customers', customer.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      customerId = customer.id_number;
      await database!.update('Customers', customer.toMap(),
          where: "id_number = ?", whereArgs: [customer.id_number], conflictAlgorithm: ConflictAlgorithm.replace);
    }
    customer.id_number = customerId;

    for (var contact in customer.contacts) {
      contact.customer_id_number = customerId;
      if (contact.id == 0 || contact.id == null) {
        contact.id = await database.insert('Customer_contacts', contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      } else {
        await database.update('Customer_contacts', contact.toMap(),
            where: "id = ?", whereArgs: [contact.id], conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    for (var address in customer.addresses) {
      address.customer_id_number = customerId;
      if (address.id == 0 || address.id == null) {
        address.id = await database.insert('Customer_addresses', address.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      } else {
        await database.update('Customer_addresses', address.toMap(),
            where: "id = ?", whereArgs: [address.id], conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    return customer;
  }

  @override
  Future<bool?>? saveIfNotExists(List<Customer> customers, List<PriceLabel> prices) async {
    try {
      final Database? database = await SqliteRepository().db;

      PriceLabel? tempPrice;
      CustomerContact? tempContact;
      List<Customer> customerList = [];
      for (var customer in customers) {
        tempContact = customer.contacts.firstWhereOrNull((f) => f.type == 1);
        if (tempContact != null) {
          var length = (await database!.query("Customer_contacts", where: "contact = ?", whereArgs: [tempContact.contact])).length;
          if (length == 0) {
            if (prices != null) {
              tempPrice = prices.firstWhereOrNull((f) => f.id == customer.price_id);
              if (tempPrice != null) {
                Map<String, dynamic> priceLabel = (await database.query("price_labels", where: "name = ?", whereArgs: [tempPrice.name])).first;

                customer.price_id = priceLabel['id'];
              }
            }

            customerList.add(customer);
          }
        }

        int customer_id = 0;
        for (var item in customerList) {
          item.id_number = 0;
          customer_id = await database!.insert('Customers', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
          if (customer_id > 0) {
            for (var contact in item.contacts) {
              contact.customer_id_number = customer_id;
              contact.id = await database.insert('Customer_contacts', contact.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
            }
            for (var address in item.addresses) {
              address.customer_id_number = customer_id;
              address.id = await database.insert('Customer_addresses', address.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
            }
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Customer>?>? getAll() async {
    Database? database = await SqliteRepository().db;
    List<Customer> customersList = [];
    List<Map<String, dynamic>> customers = (await database!.query("Customers"));
    Customer temp;
    for (var customer in customers) {
      temp = Customer.fromMap(customer);
      List<Map<String, dynamic>> tempContacts =
          (await database.query("Customer_contacts", where: "customer_id_number = ?", whereArgs: [temp.id_number])).toList();
      temp.contacts = [];
      for (var item in tempContacts) {
        temp.contacts.add(CustomerContact.fromMap(item));
      }

      List<Map<String, dynamic>> tempAddresses =
          (await database.query("Customer_addresses", where: "customer_id_number = ?", whereArgs: [temp.id_number])).toList();
      temp.addresses = [];
      for (var item in tempAddresses) {
        temp.addresses.add(CustomerAddress.fromMap(item));
      }
      customersList.add(temp);
    }

    return customersList;
  }
}
