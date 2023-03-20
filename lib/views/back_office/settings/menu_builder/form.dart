import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:invo_mobile/blocs/back_office/backoffice/backoffice_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/menu_builder/menu_builder_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/menu_builder/menu_builder_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/menu_builder/menu_builder_state.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart' as mi;
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/views/back_office/Menu_items/menu_group/form.dart';
import 'package:invo_mobile/views/back_office/Menu_items/menu_items/form.dart';
import 'package:invo_mobile/views/back_office/Menu_items/menu_type/form.dart';
import 'package:invo_mobile/widgets/pickers/pick_menu_group.dart';
import 'package:invo_mobile/widgets/pickers/pick_menu_item.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:invo_mobile/widgets/translation/application.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sqflite/sql.dart';
import 'package:collection/collection.dart';

import '../../../blocProvider.dart';

class MenuBuilderForm extends StatefulWidget {
  bool isTut;
  MenuBuilderForm({Key? key, this.isTut = false}) : super(key: key);

  @override
  _MenuBuilderFormState createState() => _MenuBuilderFormState();
}

bool isTutActive = false;
GlobalKey _menuKey = GlobalKey();
GlobalKey _addMenuKey = GlobalKey();
GlobalKey _selectMenuKey = GlobalKey();
GlobalKey _editMenuKey = GlobalKey();

GlobalKey _groupKey = GlobalKey();
GlobalKey _addGroupKey = GlobalKey();
GlobalKey _selectGroupKey = GlobalKey();
GlobalKey _pickGroupKey = GlobalKey();
GlobalKey _editGroupKey = GlobalKey();

GlobalKey _addItemKey = GlobalKey();
GlobalKey _selectItemKey = GlobalKey();
GlobalKey _pickItemKey = GlobalKey();
GlobalKey _editItemKey = GlobalKey();

SharedPreferences? preferences;
displayMenuShowcase() async {
  preferences = await SharedPreferences.getInstance();
  bool? showcaseVisibilityStatus = preferences!.getBool("showMenuShowcase");

  if (showcaseVisibilityStatus == null) {
    return true;
  }

  return false;
}

setMenuShowcase() {
  preferences!.setBool("showMenuShowcase", false).then((bool success) {
    if (success)
      print("Successfull in writing showshoexase");
    else
      print("some problem occured");
  });
}

displayGroupShowcase() async {
  preferences = await SharedPreferences.getInstance();
  bool? showcaseVisibilityStatus = preferences!.getBool("showGroupShowcase");

  if (showcaseVisibilityStatus == null) {
    return true;
  }

  return false;
}

setGroupShowcase() {
  preferences!.setBool("showGroupShowcase", false).then((bool success) {
    if (success)
      print("Successfull in writing showshoexase");
    else
      print("some problem occured");
  });
}

displayItemShowcase() async {
  preferences = await SharedPreferences.getInstance();
  bool? showcaseVisibilityStatus = preferences!.getBool("showItemShowcase");

  if (showcaseVisibilityStatus == null) {
    return true;
  }

  return false;
}

setItemShowcase() {
  preferences!.setBool("showItemShowcase", false).then((bool success) {
    if (success)
      print("Successfull in writing showshoexase");
    else
      print("some problem occured");
  });
}

class _MenuBuilderFormState extends State<MenuBuilderForm> {
  late MenuBuilderPageBloc bloc;
  final GlobalKey<NavigatorState> menuBuilderNavigatorKey = GlobalKey<NavigatorState>();
  late SpecificLocalizationDelegate _localeOverrideDelegate;
  void initState() {
    super.initState();
    isTutActive = widget.isTut;
    bloc = new MenuBuilderPageBloc(BlocProvider.of<NavigatorBloc>(context));
    bloc.phase.stream.listen((MenuBuilderPhaseState phase) {
      if (phase is MenuPhase) {
        menuBuilderNavigatorKey.currentState!.pushReplacement(new SlideRightRoute(page: MenuTypeStep(bloc: bloc)));
      } else if (phase is MenuGroupPhase) {
        if (phase.forward) {
          menuBuilderNavigatorKey.currentState!.pushReplacement(new SlideLeftRoute(page: MenuGroupStep(bloc: bloc)));
        } else {
          menuBuilderNavigatorKey.currentState!.pushReplacement(new SlideRightRoute(page: MenuGroupStep(bloc: bloc)));
        }
      } else if (phase is MenuItemPhase) {
        menuBuilderNavigatorKey.currentState!.pushReplacement(new SlideLeftRoute(page: MenuItemStep(bloc: bloc)));
      }
    });
    _localeOverrideDelegate = new SpecificLocalizationDelegate(new Locale(locator.get<ConnectionRepository>().terminal!.getLangauge()!));
    applic.onLocaleChanged = onLocaleChange;

    locator.registerSingleton<BackOfficeBloc>(new BackOfficeBloc(BlocProvider.of<NavigatorBloc>(context)));
  }

  @override
  dispose() {
    super.dispose();
    bloc.dispose();
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: menuBuilderNavigatorKey,
      supportedLocales: applic.supportedLocales(),
      localizationsDelegates: [
        _localeOverrideDelegate,
        GlobalMaterialLocalizations.delegate,
        //GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedocals) {
        for (var supportedocal in supportedocals) {
          if (supportedocal.languageCode == locale!.languageCode) {
            return supportedocal;
          }
        }

        return supportedocals.first;
      },
      home: Scaffold(
        body: SafeArea(
          child: MenuTypeStep(
            bloc: bloc,
          ),
        ),
      ),
    );
  }
}

class MenuTypeStep extends StatefulWidget {
  final MenuBuilderPageBloc? bloc;
  MenuTypeStep({Key? key, this.bloc}) : super(key: key);

  @override
  _MenuTypeStepState createState() => _MenuTypeStepState();
}

class _MenuTypeStepState extends State<MenuTypeStep> {
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) => Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                isTutActive
                    ? Container(
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[900]!,
                            border: Border.all(
                              color: Colors.blueGrey[900]!,
                              width: 5,
                            )),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.translate("Menu Builder"),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              )),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                Center(child: navigation()),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.blueGrey[900]!,
                      width: 5,
                    )),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: list(),
                        ),
                        actionButtons(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navigation() {
    return Container(
      height: 60,
      width: 170 * 3.0,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Center(
        child: ListView(scrollDirection: Axis.horizontal, children: [
          CustomPaint(
            child: Container(
              width: 170,
              height: 60,
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.translate("Menus"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )),
            ),
            painter: PhasePainter(strokeColor: Colors.blueGrey[900]!, paintingStyle: PaintingStyle.fill),
          ),
          CustomPaint(
            child: Container(
              width: 170,
              height: 60,
              child: SizedBox(
                child: Center(
                    child: AutoSizeText(
                  AppLocalizations.of(context)!.translate("Menu Groups"),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                )),
              ),
            ),
            painter: Phase2Painter(strokeColor: Colors.grey, paintingStyle: PaintingStyle.fill),
          ),
          CustomPaint(
            child: Container(
              width: 170,
              height: 60,
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.translate("Menu Items"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )),
            ),
            painter: Phase3Painter(strokeColor: Colors.grey, paintingStyle: PaintingStyle.fill),
          ),
        ]),
      ),
    );
  }

  Widget actionButtons(BuildContext context) {
    displayMenuShowcase().then((status) {
      if (status && isTutActive) {
        WidgetsBinding.instance!.addPostFrameCallback((_) => ShowCaseWidget.of(context)!.startShowCase([
              _addMenuKey,
              _selectMenuKey,
              _editMenuKey,
            ]));
        setMenuShowcase();
      }
    });
    return Container(
      width: 140,
      padding: EdgeInsets.all(5),
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Showcase(
                  key: _addMenuKey,
                  description: AppLocalizations.of(context)!.translate('Add a new menu'),
                  descTextStyle: TextStyle(fontSize: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ButtonTheme(
                    minWidth: 140,
                    height: 70,
                    child: ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context)!.translate("Add Menu"),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MenuTypeForm(0);
                          },
                        );

                        widget.bloc!.loadMenuTypes();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate('Drag menu to trash to delete it'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          DragTarget<MenuType>(
            onAccept: (MenuType menu) {
              widget.bloc!.removeMenu(menu);
            },
            builder: (context, List<MenuType?> candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {
                return Icon(
                  Icons.delete_forever,
                  size: 100,
                );
              } else {
                return Icon(
                  Icons.delete,
                  size: 100,
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget list() {
    int numberOfColumn = 3;
    if (screenWidth <= 500) {
      numberOfColumn = 1;
    } else if (screenWidth <= 800) {
      numberOfColumn = 2;
    }
    return Container(
      margin: EdgeInsets.all(10),
      child: StreamBuilder(
        stream: widget.bloc!.menuTypes.stream,
        initialData: widget.bloc!.menuTypes.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (widget.bloc!.menuTypes.value == null)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (widget.bloc!.menuTypes.value!.length == 0) {}

          return GridView.builder(
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return menuTypeButton(widget.bloc!.menuTypes.value![index], index);
            },
            itemCount: widget.bloc!.menuTypes.value!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3,
              crossAxisCount: numberOfColumn,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        },
      ),
    );
  }

  Widget menuTypeButton(MenuType menu, int index) {
    if (index == 0) {
      return Draggable<MenuType>(
        data: menu,
        feedback: Container(
          color: Colors.blueGrey[900]!,
          child: Center(
              child: Text(
            menu.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration: TextDecoration.none,
              color: Colors.white,
            ),
          )),
        ),
        child: ButtonTheme(
          minWidth: 140,
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    border: Border(
                        right: BorderSide(
                      color: Colors.white,
                    ))),
                child: Showcase(
                  key: _editMenuKey,
                  description: AppLocalizations.of(context)!.translate('Tap to edit menu'),
                  descTextStyle: TextStyle(fontSize: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  child: IconButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MenuTypeForm(menu.id);
                        },
                      );
                      widget.bloc!.loadMenuTypes();
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Showcase(
                  key: _selectMenuKey,
                  description: AppLocalizations.of(context)!.translate('Tap to add a group to your menu'),
                  descTextStyle: TextStyle(fontSize: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton(
                    child: Hero(
                      tag: menu.id,
                      child: Text(
                        menu.name,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                    ),
                    onPressed: () {
                      widget.bloc!.eventSink.add(MenuClicked(menu: menu));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Draggable<MenuType>(
        data: menu,
        feedback: Container(
          color: Colors.blueGrey[900]!,
          child: Center(
              child: Text(
            menu.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration: TextDecoration.none,
              color: Colors.white,
            ),
          )),
        ),
        child: ButtonTheme(
          minWidth: 140,
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    border: Border(
                        right: BorderSide(
                      color: Colors.white,
                    ))),
                child: IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MenuTypeForm(menu.id);
                      },
                    );
                    widget.bloc!.loadMenuTypes();
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  child: Hero(
                    tag: menu.id,
                    child: Text(
                      menu.name,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                  ),
                  onPressed: () {
                    setMenuShowcase();
                    widget.bloc!.eventSink.add(MenuClicked(menu: menu));
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class MenuGroupStep extends StatefulWidget {
  final MenuBuilderPageBloc? bloc;
  MenuGroupStep({Key? key, this.bloc}) : super(key: key);

  @override
  _MenuGroupStepState createState() => _MenuGroupStepState();
}

class _MenuGroupStepState extends State<MenuGroupStep> {
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ShowCaseWidget(
        builder: Builder(
          builder: (context) => Scaffold(
            body: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  isTutActive
                      ? Container(
                          margin: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[900]!,
                              border: Border.all(
                                color: Colors.blueGrey[900]!,
                                width: 5,
                              )),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)!.translate("Menu Builder"),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                )),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  Center(child: navigation()),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.blueGrey[900]!,
                        width: 5,
                      )),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: list(),
                          ),
                          actionButtons(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget navigation() {
    return Container(
      height: 60,
      width: 170 * 3.0,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Center(
        child: ListView(scrollDirection: Axis.horizontal, children: [
          InkWell(
            onTap: () {
              widget.bloc!.eventSink.add(GoToMenuPhase());
            },
            child: Showcase(
              key: _menuKey,
              description: AppLocalizations.of(context)!.translate('Tap to go back to Menu'),
              descTextStyle: TextStyle(fontSize: 18),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomPaint(
                child: Container(
                  width: 170,
                  height: 60,
                  child: Center(
                      child: Hero(
                    tag: widget.bloc!.selectedMenu!.id,
                    child: Text(
                      widget.bloc!.selectedMenu!.name,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  )),
                ),
                painter: PhasePainter(strokeColor: Colors.blueGrey[900]!, paintingStyle: PaintingStyle.fill),
              ),
            ),
          ),
          CustomPaint(
            child: Container(
              width: 170,
              height: 60,
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.translate("Menu Groups"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )),
            ),
            painter: Phase2Painter(strokeColor: Colors.blueGrey[900]!, paintingStyle: PaintingStyle.fill),
          ),
          CustomPaint(
            child: Container(
              width: 170,
              height: 60,
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.translate("Menu Items"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )),
            ),
            painter: Phase3Painter(strokeColor: Colors.grey, paintingStyle: PaintingStyle.fill),
          ),
        ]),
      ),
    );
  }

  Widget actionButtons(BuildContext context) {
    displayGroupShowcase().then((status) {
      if (status && isTutActive) {
        WidgetsBinding.instance!.addPostFrameCallback((_) => ShowCaseWidget.of(context)!.startShowCase([
              _menuKey,
              _addGroupKey,
              _pickGroupKey,
              _selectGroupKey,
              _editGroupKey,
            ]));
        setGroupShowcase();
      }
    });

    return Container(
      width: 140,
      padding: EdgeInsets.all(5),
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Showcase(
                  key: _addGroupKey,
                  description: AppLocalizations.of(context)!.translate('Add a group'),
                  descTextStyle: TextStyle(fontSize: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ButtonTheme(
                    minWidth: 140,
                    height: 70,
                    child: ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context)!.translate("Add Group"),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MenuGroupForm(0, widget.bloc!.selectedMenu!.id);
                          },
                        );

                        widget.bloc!.loadMenuGroups();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Showcase(
                  key: _pickGroupKey,
                  description: AppLocalizations.of(context)!.translate('Select a group from list'),
                  descTextStyle: TextStyle(fontSize: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ButtonTheme(
                    minWidth: 140,
                    height: 70,
                    child: ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context)!.translate("Pick Group"),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                      ),
                      onPressed: () async {
                        List<MenuGroup> temp = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            List<int> selectedIds = List<int>.empty(growable: true);
                            for (var item in widget.bloc!.menuGroups.value!) {
                              selectedIds.add(item.id);
                            }
                            return PickMenuGroup(
                              selectedIds: selectedIds,
                            );
                          },
                        );

                        widget.bloc!.pickGroups(temp);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate('Drag menu to trash to delete it'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          DragTarget<MenuGroup>(
            onAccept: (MenuGroup group) {
              widget.bloc!.removeGroup(group);
            },
            builder: (context, List<MenuGroup?> candidateData, rejectedData) {
              if (candidateData.length > 0) {
                return Icon(
                  Icons.delete_forever,
                  size: 100,
                );
              } else {
                return Icon(
                  Icons.delete,
                  size: 100,
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget list() {
    int numberOfColumn = 3;
    if (screenWidth <= 500) {
      numberOfColumn = 1;
    } else if (screenWidth <= 800) {
      numberOfColumn = 2;
    }
    return Container(
      margin: EdgeInsets.all(10),
      child: StreamBuilder(
        stream: widget.bloc!.menuGroups.stream,
        initialData: widget.bloc!.menuGroups.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (widget.bloc!.menuGroups.value == null)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (widget.bloc!.menuGroups.value!.length == 0) {}

          return GridView.builder(
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return menuGroupButton(widget.bloc!.menuGroups.value![index], index);
            },
            itemCount: widget.bloc!.menuGroups.value!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3,
              crossAxisCount: numberOfColumn,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        },
      ),
    );
  }

  Widget menuGroupButton(MenuGroup group, int index) {
    if (index == 0) {
      return Draggable<MenuGroup>(
        data: group,
        feedback: groupBtn(group),
        child: ButtonTheme(
          minWidth: 140,
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    border: Border(
                        right: BorderSide(
                      color: Colors.white,
                    ))),
                child: Showcase(
                  key: _editGroupKey,
                  description: AppLocalizations.of(context)!.translate('Tap to edit group'),
                  descTextStyle: TextStyle(fontSize: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  child: IconButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MenuGroupForm(group.id, widget.bloc!.selectedMenu!.id);
                        },
                      );

                      widget.bloc!.loadMenuGroups();
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Showcase(key: _selectGroupKey, description: AppLocalizations.of(context)!.translate('Tap to add an item to your group'), descTextStyle: TextStyle(fontSize: 18), contentPadding: const EdgeInsets.symmetric(horizontal: 12), child: groupBtn(group)),
              ),
            ],
          ),
        ),
      );
    } else {
      return Draggable<MenuGroup>(
        data: group,
        feedback: groupBtn(group),
        child: ButtonTheme(
          minWidth: 140,
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    border: Border(
                        right: BorderSide(
                      color: Colors.white,
                    ))),
                child: IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MenuGroupForm(group.id, widget.bloc!.selectedMenu!.id);
                      },
                    );

                    widget.bloc!.loadMenuGroups();
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: (groupBtn(group)),
              ),
            ],
          ),
        ),
      );
    }
  }

  groupBtn(MenuGroup group) {
    return ElevatedButton(
      child: Hero(
        tag: "MenuGroup_" + group.id.toString(),
        child: Text(
          group.name,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(group.getColorFromHex())),
      ),
      onPressed: () {
        widget.bloc!.eventSink.add(MenuGroupClicked(group));
      },
    );
  }
}

class MenuItemStep extends StatefulWidget {
  final MenuBuilderPageBloc? bloc;
  MenuItemStep({Key? key, this.bloc}) : super(key: key);
  @override
  _MenuItemStepState createState() => _MenuItemStepState();
}

class _MenuItemStepState extends State<MenuItemStep> {
  double screenWidth = 0;
  late Orientation orientation;
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    orientation = MediaQuery.of(context).orientation;
    return SafeArea(
      child: ShowCaseWidget(
          builder: Builder(
        builder: (context) => Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                isTutActive
                    ? Container(
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[900]!,
                            border: Border.all(
                              color: Colors.blueGrey[900]!,
                              width: 5,
                            )),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.translate("Menu Builder"),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              )),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                Center(child: navigation()),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.blueGrey[900]!,
                      width: 5,
                    )),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: list(),
                        ),
                        actionButtons(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget navigation() {
    return Container(
      height: 60,
      width: 170 * 3.0,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Center(
        child: ListView(scrollDirection: Axis.horizontal, children: [
          InkWell(
            onTap: () {
              widget.bloc!.eventSink.add(GoToMenuPhase());
            },
            child: CustomPaint(
              child: Container(
                width: 170,
                height: 60,
                child: Center(
                    child: Text(
                  widget.bloc!.selectedMenu!.name,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                )),
              ),
              painter: PhasePainter(strokeColor: Colors.blueGrey[900]!, paintingStyle: PaintingStyle.fill),
            ),
          ),
          InkWell(
            onTap: () {
              widget.bloc!.eventSink.add(GoToMenuGroupPhase());
            },
            child: Showcase(
              key: _groupKey,
              description: AppLocalizations.of(context)!.translate("Tap to go back to groups"),
              descTextStyle: TextStyle(fontSize: 18),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomPaint(
                child: Container(
                  width: 170,
                  height: 60,
                  child: Center(
                      child: Hero(
                    tag: "MenuGroup_" + widget.bloc!.selectedGroup!.id.toString(),
                    child: Text(
                      widget.bloc!.selectedGroup!.name,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  )),
                ),
                painter: Phase2Painter(strokeColor: Colors.blueGrey[900]!, paintingStyle: PaintingStyle.fill),
              ),
            ),
          ),
          CustomPaint(
            child: Container(
              width: 170,
              height: 60,
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.translate("Menu Items"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )),
            ),
            painter: Phase3Painter(strokeColor: Colors.blueGrey[900]!, paintingStyle: PaintingStyle.fill),
          ),
        ]),
      ),
    );
  }

  Widget nextTutorialButton() {
    if (isTutActive) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ButtonTheme(
          minWidth: 140,
          height: 70,
          child: ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.translate("Next Tutorial"),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen[900]!),
            ),
            onPressed: () {
              widget.bloc!.navigateNextTutorial();
            },
            // disabledColor: Colors.grey,
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget actionButtons(BuildContext context) {
    displayItemShowcase().then((status) {
      if (status && isTutActive) {
        WidgetsBinding.instance!.addPostFrameCallback((_) => ShowCaseWidget.of(context)!.startShowCase([
              _groupKey,
              _selectItemKey,
              _addItemKey,
              _pickItemKey,
            ]));
        setItemShowcase();
      }
    });

    return Container(
      width: 140,
      padding: EdgeInsets.all(5),
      color: Colors.grey[200],
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Showcase(
            key: _addItemKey,
            description: AppLocalizations.of(context)!.translate("add an item"),
            descTextStyle: TextStyle(fontSize: 18),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            child: ButtonTheme(
              minWidth: 140,
              height: 70,
              child: ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.translate("Add Item"),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                ),
                onPressed: (widget.bloc!.selectedItemGroup != null && widget.bloc!.selectedItemGroup!.id == 0) || orientation == Orientation.portrait
                    ? () async {
                        mi.MenuItem? menuItem = await showDialog<mi.MenuItem>(
                          context: context,
                          builder: (BuildContext context) {
                            return MenuItemForm();
                          },
                        );

                        if (menuItem != null) {
                          MenuItemGroup itemGroup = new MenuItemGroup(index: 0);
                          itemGroup.menu_item_id = menuItem.id;

                          if (orientation == Orientation.landscape) {
                            itemGroup.index = widget.bloc!.selectedItemGroup!.index;
                          } else {
                            itemGroup.index = 0;
                          }
                          itemGroup.double_width = false;
                          itemGroup.double_height = false;
                          itemGroup.menu_group_id = widget.bloc!.selectedGroup!.id;
                          widget.bloc!.saveMenuItemGroup(itemGroup);
                          widget.bloc!.selectedItemGroup = null;
                          setState(() {});
                        }
                      }
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Showcase(
            key: _pickItemKey,
            description: AppLocalizations.of(context)!.translate("Tap to pick an item from is of items"),
            descTextStyle: TextStyle(fontSize: 18),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            child: ButtonTheme(
              minWidth: 140,
              height: 70,
              child: ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.translate("Pick Item"),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                ),
                onPressed: (widget.bloc!.selectedItemGroup != null && widget.bloc!.selectedItemGroup!.id == 0) || orientation == Orientation.portrait
                    ? () async {
                        List<MenuItemList> temp = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            List<int> selectedIds = List<int>.empty(growable: true);
                            for (var item in widget.bloc!.menuItems.value!) {
                              selectedIds.add(item.menu_item_id);
                            }
                            return PickMenuItem(
                              selectedIds: selectedIds,
                            );
                          },
                        );

                        widget.bloc!.pickItem(temp);
                        widget.bloc!.selectedItemGroup = null;
                        setState(() {});
                      }
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ButtonTheme(
            minWidth: 140,
            height: 70,
            child: ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.translate("Edit Item"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  } else {
                    return Colors.blueGrey[900]!;
                  }
                }),
              ),
              onPressed: widget.bloc!.selectedItemGroup != null && widget.bloc!.selectedItemGroup!.id > 0
                  ? () async {
                      mi.MenuItem? menuItem = await showDialog<mi.MenuItem>(
                        context: context,
                        builder: (BuildContext context) {
                          return MenuItemForm(id: widget.bloc!.selectedItemGroup!.menu_item_id);
                        },
                      );
                      widget.bloc?.selectedItemGroup!.menu_item = menuItem;
                      widget.bloc!.loadMenuItems();
                    }
                  : null,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ButtonTheme(
            minWidth: 140,
            height: 70,
            child: ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.translate("Unpin Item"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  } else {
                    return Colors.blueGrey[900]!;
                  }
                }),
              ),
              onPressed: widget.bloc!.selectedItemGroup != null && widget.bloc!.selectedItemGroup!.id > 0
                  ? () async {
                      widget.bloc!.unPinItem();
                    }
                  : null,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          orientation == Orientation.landscape
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ButtonTheme(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                            backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey;
                              } else {
                                return Colors.blueGrey[900]!;
                              }
                            }),
                          ),
                          child: Center(
                            child: Text(
                              "\u2B0C",
                              style: TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: widget.bloc!.selectedItemGroup != null && widget.bloc!.selectedItemGroup!.id > 0
                              ? () async {
                                  widget.bloc!.doubleWidth();
                                }
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ButtonTheme(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                            backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey;
                              } else {
                                return Colors.blueGrey[900]!;
                              }
                            }),
                          ),
                          child: Center(
                            child: Text(
                              "\u2B0D",
                              style: TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: widget.bloc!.selectedItemGroup != null && widget.bloc!.selectedItemGroup!.id > 0
                              ? () {
                                  widget.bloc!.doubleHeight();
                                }
                              : null,
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          nextTutorialButton(),
        ],
      ),
    );
  }

  Widget list() {
    int numberOfColumn = 3;
    if (screenWidth <= 400) {
      numberOfColumn = 1;
    } else if (screenWidth <= 800) {
      numberOfColumn = 2;
    }
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: StreamBuilder(
        stream: widget.bloc!.menuItems.stream,
        initialData: widget.bloc!.menuItems.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (widget.bloc!.menuItems.value == null)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (widget.bloc!.menuItems.value!.length == 0) {}

          if (orientation == Orientation.portrait) {
            return GridView.builder(
              padding: EdgeInsets.all(0),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: numberOfColumn, childAspectRatio: 1),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 3, right: 3, bottom: 3),
                  child: index == 0
                      ? Showcase(key: _selectItemKey, description: AppLocalizations.of(context)!.translate("Tap to pick an item"), descTextStyle: TextStyle(fontSize: 18), contentPadding: const EdgeInsets.symmetric(horizontal: 12), child: itemBtn(widget.bloc!.menuItems.value![index]))
                      : itemBtn(widget.bloc!.menuItems.value![index]),
                );
              },
              itemCount: widget.bloc!.menuItems.value!.length,
            );
          } else {
            List<MenuItemGroup> list = widget.bloc!.menuItems.value!.toList();

            MenuItemGroup? temp;
            for (var i = 0; i < 36; i++) {
              if (list.where((f) => f.index == i).length > 1) {
                int index = i;
                for (var item in list.where((f) => f.index == i)) {
                  item.index = index++;
                }
              }

              if (list.where((f) => f.index == i).length == 0) {
                list.add(new MenuItemGroup(id: 0, double_height: false, double_width: false, index: i, menu_item: mi.MenuItem(id: 0, name: "New")));
              }
            }

            list.sort((prev, next) {
              if (prev == null || next == null) return 0;
              if (prev.index == null) prev.index = 0;
              if (next.index == null) next.index = 0;
              if (prev.index > next.index) {
                return 1;
              } else {
                return -1;
              }
            });

            try {
              for (var item in list.where((f) => f.menu_item_id != null).toList()) {
                if (item.index == null) item.index = 0;

                // temp = list.firstWhereOrNull((f) => f.index == item.index,
                //     orElse: () => null);
                // if (temp != null && temp.menu_item == null) list.remove(temp);

                if (item.double_height) {
                  temp = list.firstWhereOrNull((f) => f.index == item.index + 6);
                  if (temp != null && temp.menu_item_id == null) list.remove(temp);
                }

                if (item.double_width) {
                  temp = list.firstWhereOrNull((f) => f.index == item.index + 1);
                  if (temp != null && temp.menu_item_id == null) list.remove(temp);
                }

                if (item.double_height && item.double_width) {
                  temp = list.firstWhereOrNull((f) => f.index == item.index + 7);
                  if (temp != null && temp.menu_item_id == null) list.remove(temp);
                }
              }
            } catch (e) {
              print("error" + e.toString());
            }

            list.sort((prev, next) {
              if (prev == null || next == null) return 0;
              if (prev.index == null) prev.index = 0;
              if (next.index == null) next.index = 0;
              if (prev.index > next.index) {
                return 1;
              } else {
                return -1;
              }
            });

            return StaggeredGridView.countBuilder(
              controller: scrollController,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              crossAxisCount: 6,
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                if (list[index] != null && list[index].menu_item != null) {
                  if (index == 0) {
                    return Showcase(key: _selectItemKey, description: AppLocalizations.of(context)!.translate("Tap to add/edit an item"), descTextStyle: TextStyle(fontSize: 18), child: menuItemButton(list[index]));
                  } else {
                    return menuItemButton(list[index]);
                  }
                } else {
                  return Center();
                }
              },
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              staggeredTileBuilder: (int index) {
                temp = list[index];
                if (temp != null && temp!.menu_item != null) {
                  return StaggeredTile.count(temp!.double_width ? 2 : 1, temp!.double_height ? 2 : 1);
                } else
                  return StaggeredTile.count(1, 1);
              },
            );
          }
        },
      ),
    );
  }

  void _incrementDown(PointerEvent details) {
    _updateLocation(details);
  }

  void _incrementUp(PointerEvent details) {
    _updateLocation(details);
  }

  double lastPosition = 0;

  void _updateLocation(PointerEvent details) {
    if ((lastPosition - (details.position.dy - 200)).abs() > 100) {
      lastPosition = (details.position.dy - 200);
      scrollController.animateTo(lastPosition, duration: new Duration(milliseconds: 500), curve: Curves.ease);
      print(details.position.dy);
    }
  }

  Widget menuItemButton(MenuItemGroup item) {
    if (item.id == 0 || item.id == null) {
      return DragTarget<MenuItemGroup>(
        onAccept: (MenuItemGroup _item) {
          widget.bloc!.updateItemPosition(_item, item.index);
          // MenuItemGroup temp = widget.bloc.menuItems.value.firstWhereOrNull((f) =>
          //     f.menu_group_id == _item.menu_group_id &&
          //     f.menu_item_id == _item.menu_item_id);
          // temp.index = item.index;
          // setState(() {});
        },
        builder: (context, List<MenuItemGroup?> candidateData, rejectedData) {
          MenuItemGroup temp = item;
          if (candidateData.isNotEmpty) {
            temp = candidateData.first!;
          }

          return itemBtn(temp);
        },
      );
    } else {
      return Listener(
        onPointerDown: _incrementDown,
        onPointerMove: _updateLocation,
        onPointerUp: _incrementUp,
        child: LongPressDraggable(
          feedback: Container(
            color: Colors.white,
            child: Center(
                child: Text(
              item.menu_item!.name!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                decoration: TextDecoration.none,
                color: item.menu_item!.color,
              ),
            )),
          ),
          data: item,
          childWhenDragging: Container(),
          child: itemBtn(item),
        ),
      );
    }
  }

  Widget itemBtn(MenuItemGroup item) {
    return InkWell(
      onTap: () {
        if (widget.bloc!.selectItem(item)) setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: widget.bloc!.selectedItemGroup == null ? Colors.grey : (widget.bloc!.selectedItemGroup!.index == item.index ? Colors.red : Colors.grey),
              blurRadius: 5.0,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                color: item.id == 0 ? Colors.black26 : item.menu_item!.color,
              ),
            ),
            item.menu_item!.imageByte != null
                ? Expanded(
                    child: Image.memory(
                      item.menu_item!.imageByte!,
                      fit: BoxFit.fitWidth,
                    ),
                  )
                : Center(),
            item.menu_item!.imageByte != null
                ? Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      item.menu_item!.name!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: item.id == 0 ? Colors.black26 : item.menu_item!.color,
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Text(
                        item.menu_item!.name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: item.id == 0 ? Colors.black26 : item.menu_item!.color,
                        ),
                      ),
                    ),
                  ),
            Container(
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                color: item.id == 0 ? Colors.black26 : item.menu_item!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhasePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  PhasePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, y)
      ..lineTo(x - 20, y)
      ..lineTo(x, y / 2)
      ..lineTo(x - 20, 0);
  }

  @override
  bool shouldRepaint(PhasePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor || oldDelegate.paintingStyle != paintingStyle || oldDelegate.strokeWidth != strokeWidth;
  }
}

class Phase2Painter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  Phase2Painter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(20, y / 2)
      ..lineTo(0, y)
      ..lineTo(x - 20, y)
      ..lineTo(x, y / 2)
      ..lineTo(x - 20, 0);
  }

  @override
  bool shouldRepaint(Phase2Painter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor || oldDelegate.paintingStyle != paintingStyle || oldDelegate.strokeWidth != strokeWidth;
  }
}

class Phase3Painter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  Phase3Painter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(20, y / 2)
      ..lineTo(0, y)
      ..lineTo(x, y)
      ..lineTo(x, 0);
  }

  @override
  bool shouldRepaint(Phase3Painter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor || oldDelegate.paintingStyle != paintingStyle || oldDelegate.strokeWidth != strokeWidth;
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget? page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page!,
          transitionDuration: Duration(milliseconds: 650),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget? page;
  SlideLeftRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page!,
          transitionDuration: Duration(milliseconds: 650),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(2, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
