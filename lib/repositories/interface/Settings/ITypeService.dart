import 'package:invo_mobile/models/Service.dart';

abstract class ITypeService {
  Future<List<Service>> getAll();

  Future<bool>? saveAll(List<Service> temp) {}
}
