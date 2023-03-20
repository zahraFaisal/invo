import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class MenuGroupListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;

  Property<List<MenuGroup>> list = new Property<List<MenuGroup>>();
  var allItems = List<MenuGroup>.empty(growable: true);

  NavigatorBloc? _navigationBloc;
  bool _isDisposed = false;
  MenuGroupListBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
  }

  void loadList(List<int> except) async {
    allItems = (await connectionRepository!.menuGroupService!.getAll(except: except))!;
    if (_isDisposed == false) list.sinkValue(allItems);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allItems);
    } else {
      list.sinkValue(allItems.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  @override
  void dispose() {
    list.dispose();
  }
}
