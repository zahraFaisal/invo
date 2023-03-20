import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:invo_mobile/blocs/back_office/backoffice/backoffice_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_builder/table_builder_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_builder/table_builder_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_builder/table_builder_state.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/views/back_office/settings/menu_builder/form.dart';
import 'package:invo_mobile/views/back_office/settings/table_builder/table_form.dart';
import 'package:invo_mobile/views/back_office/settings/table_builder/table_picker.dart';
import 'package:invo_mobile/views/back_office/settings/table_builder/table_section_form.dart';
import 'package:invo_mobile/views/back_office/settings/table_builder/table_section_picker.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:invo_mobile/widgets/translation/application.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class TableBuilder extends StatefulWidget {
  bool isActive;
  TableBuilder({Key? key, this.isActive = false}) : super(key: key);

  @override
  _TableBuilderState createState() => _TableBuilderState();
}

bool isTutoActive = false;
GlobalKey _addZoneKey = GlobalKey();
GlobalKey _editZoneKey = GlobalKey();
GlobalKey _selectZoneKey = GlobalKey();
GlobalKey _addTableKey = GlobalKey();
GlobalKey _pickTableKey = GlobalKey();
GlobalKey _selectTableKey = GlobalKey();
GlobalKey _backTableKey = GlobalKey();

SharedPreferences? preferences;
displayZoneShowcase() async {
  preferences = await SharedPreferences.getInstance();
  bool? showcaseVisibilityStatus = preferences!.getBool("showZoneShowcase");

  if (showcaseVisibilityStatus == null) {
    return true;
  }

  return false;
}

setZoneShowcase() {
  preferences!.setBool("showZoneShowcase", false).then((bool success) {
    if (success)
      print("Successfull in writing showshoexase");
    else
      print("some problem occured");
  });
}

displayTableShowcase() async {
  preferences = await SharedPreferences.getInstance();
  bool? showcaseVisibilityStatus = preferences!.getBool("showTableShowcase");

  if (showcaseVisibilityStatus == null) {
    return true;
  }

  return false;
}

setTableShowcase() {
  preferences!.setBool("showTableShowcase", false).then((bool success) {
    if (success)
      print("Successfull in writing showshoexase");
    else
      print("some problem occured");
  });
}

class _TableBuilderState extends State<TableBuilder> {
  late TableBuilderPageBloc tableBuilderPageBloc;
  final GlobalKey<NavigatorState> tableBuilderNavigatorKey = GlobalKey<NavigatorState>();
  late SpecificLocalizationDelegate _localeOverrideDelegate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isTutoActive = widget.isActive;
    tableBuilderPageBloc = TableBuilderPageBloc(BlocProvider.of<NavigatorBloc>(context));
    tableBuilderPageBloc.phase.stream.listen((TableBuilderPhaseState phase) {
      if (phase is SectionsPhase) {
        tableBuilderNavigatorKey.currentState!.pushReplacement(SlideRightRoute(page: TableSections(bloc: tableBuilderPageBloc)));
      } else if (phase is TablesPhase) {
        tableBuilderNavigatorKey.currentState!.pushReplacement(SlideLeftRoute(page: TablesSetupPhase(bloc: tableBuilderPageBloc)));
      }
    });
    _localeOverrideDelegate = SpecificLocalizationDelegate(Locale(locator.get<ConnectionRepository>().terminal!.getLangauge()!));
    applic.onLocaleChanged = onLocaleChange;

    locator.registerSingleton<BackOfficeBloc>(BackOfficeBloc(BlocProvider.of<NavigatorBloc>(context)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: tableBuilderNavigatorKey,
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
        body: SafeArea(child: TableSections(bloc: tableBuilderPageBloc)),
      ),
    );
  }
}

class TableSections extends StatefulWidget {
  final TableBuilderPageBloc bloc;
  TableSections({Key? key, required this.bloc}) : super(key: key);

  @override
  _TableSectionsState createState() => _TableSectionsState();
}

class _TableSectionsState extends State<TableSections> {
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
                // Center(child: navigation()),
                isTutoActive
                    ? Container(
                        margin: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[900],
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
                                AppLocalizations.of(context)!.translate("Table Setup"),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              )),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
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

  Widget actionButtons(BuildContext context) {
    displayZoneShowcase().then((status) {
      if (status && isTutoActive) {
        WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(context)!.startShowCase([
              _addZoneKey,
              _selectZoneKey,
              _editZoneKey,
            ]));
        setZoneShowcase();
      }
    });
    return Container(
      width: 140,
      padding: const EdgeInsets.all(5),
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                Showcase(
                  key: _addZoneKey,
                  description: AppLocalizations.of(context)!.translate("Add a new Table sections"),
                  descTextStyle: const TextStyle(fontSize: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ButtonTheme(
                    minWidth: 140,
                    height: 70,
                    child: ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context)!.translate("Add Table Section"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                            return TableSectionForm(0);
                          },
                        );
                        widget.bloc.loadTableGroups();
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonTheme(
                  minWidth: 140,
                  height: 70,
                  child: ElevatedButton(
                    child: const Text(
                      "Pick Table Section",
                      textAlign: TextAlign.center,
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
                          return TableSectionPicker();
                        },
                      );
                      widget.bloc.loadTableGroups();
                    },
                  ),
                ),
                endTutorialButton(),
              ],
            ),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Drag section to trash to delete it"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          DragTarget<DineInGroup>(
            onAccept: (DineInGroup group) {
              widget.bloc.removeTable(group);
            },
            builder: (context, List<DineInGroup?> candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {
                return const Icon(
                  Icons.delete_forever,
                  size: 100,
                );
              } else {
                return const Icon(
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

  Widget endTutorialButton() {
    if (isTutoActive) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ButtonTheme(
          minWidth: 140,
          height: 70,
          child: ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.translate("End Tutorial"),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen[900]!),
                shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ))),
            onPressed: () {
              widget.bloc.navigateEndTutorial();
            },
            // disabledColor: Colors.grey,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget list() {
    int numberOfColumn = 3;
    if (screenWidth <= 500) {
      numberOfColumn = 1;
    } else if (screenWidth <= 800) {
      numberOfColumn = 2;
    }
    return Container(
      margin: const EdgeInsets.all(10),
      child: StreamBuilder(
        stream: widget.bloc.sections.stream,
        initialData: widget.bloc.sections.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (widget.bloc.sections.value == null)
            return const Center(
              child: const CircularProgressIndicator(),
            );

          if (widget.bloc.sections.value!.length == 0) {}

          return GridView.builder(
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return sectionButtonWithKey(widget.bloc.sections.value![index], index);
              } else
                return sectionButton(widget.bloc.sections.value![index], index);
            },
            itemCount: widget.bloc.sections.value!.length,
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

  Widget sectionButtonWithKey(DineInGroup group, int index) {
    return Draggable<DineInGroup>(
      data: group,
      feedback: Container(
        color: Colors.blueGrey[900],
        child: Center(
            child: Text(
          group.name,
          style: const TextStyle(
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
                border: const Border(
                  right: const BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              child: Showcase(
                key: _editZoneKey,
                description: AppLocalizations.of(context)!.translate('Tap to edit section'),
                descTextStyle: const TextStyle(fontSize: 18),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                child: IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return TableSectionForm(group.id);
                      },
                    );

                    widget.bloc.loadTableGroups();
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Showcase(
                key: _selectZoneKey,
                description: AppLocalizations.of(context)!.translate('Add/Edit a table in that section'),
                descTextStyle: const TextStyle(fontSize: 18),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  child: Hero(
                    tag: group.id,
                    child: Text(
                      group.name,
                      style: const TextStyle(
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
                    widget.bloc.eventSink.add(SectionClicked(group: group));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionButton(DineInGroup group, int index) {
    return Draggable<DineInGroup>(
      data: group,
      feedback: Container(
        color: Colors.blueGrey[900],
        child: Center(
            child: Text(
          group.name,
          style: const TextStyle(
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
                border: const Border(
                  right: const BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              child: IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TableSectionForm(group.id);
                    },
                  );

                  widget.bloc.loadTableGroups();
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                child: Hero(
                  tag: group.id,
                  child: Text(
                    group.name,
                    style: const TextStyle(
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
                  widget.bloc.eventSink.add(SectionClicked(group: group));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

GlobalKey _tableCanvas = GlobalKey();

class TablesSetupPhase extends StatefulWidget {
  final TableBuilderPageBloc bloc;

  TablesSetupPhase({Key? key, required this.bloc}) : super(key: key);

  @override
  _TablesSetupPhaseState createState() => _TablesSetupPhaseState();
}

class _TablesSetupPhaseState extends State<TablesSetupPhase> {
  @override
  Widget build(BuildContext context) {
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
                  Center(child: navigation()),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.blueGrey[900]!,
                        width: 5,
                      )),
                      // padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: StreamBuilder(
                          stream: widget.bloc.tables.stream,
                          initialData: widget.bloc.tables.value,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            List<Widget> tables = List<Widget>.empty(growable: true);
                            if (widget.bloc.tables.value != null)
                              // ignore: curly_braces_in_flow_control_structures
                              for (var item in widget.bloc.tables.value!) {
                                tables.add(TableWidget(
                                  item,
                                  widget.bloc,
                                  onPositionChangeEnd: () {
                                    widget.bloc.saveTablePosition(item);
                                  },
                                ));
                              }

                            return Showcase(
                              key: _selectTableKey,
                              description: AppLocalizations.of(context)!.translate('Tap to Edit/Hide and Hold to drag/change position of table'),
                              descTextStyle: const TextStyle(fontSize: 18),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Stack(
                                key: _tableCanvas,
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: tables,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [floatingActionButton(context), floatingActionButtonPick(context)]),
          ),
        ),
      ),
    );
  }

  Widget floatingActionButtonPick(BuildContext context) {
    // displayTableShowcase().then((status) {
    //   if (status && isTutoActive) {
    //     WidgetsBinding.instance.addPostFrameCallback(
    //         (_) => ShowCaseWidget.of(context).startShowCase([
    //               _addTableKey,
    //               _selectTableKey,
    //               _backTableKey,
    //             ]));
    //   }
    // });
    return TextButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return TablePicker(widget.bloc.selectedSection!.id);
          },
        );
        widget.bloc.loadDineInTables(widget.bloc.selectedSection!.id);
      },
      child: Showcase(
        key: _pickTableKey,
        description: 'pick table',
        descTextStyle: const TextStyle(fontSize: 18),
        contentPadding: const EdgeInsets.all(5),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(
            right: 20,
            bottom: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: const Center(
            child: const Text(
              "Pick",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget floatingActionButton(BuildContext context) {
    displayTableShowcase().then((status) {
      if (status && isTutoActive) {
        WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(context)!.startShowCase([
              _addTableKey,
              _selectTableKey,
              _backTableKey,
            ]));
      }
    });
    return TextButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return TableForm(0, widget.bloc.selectedSection!.id);
          },
        );
        widget.bloc.loadDineInTables(widget.bloc.selectedSection!.id);
      },
      child: Showcase(
        key: _addTableKey,
        description: AppLocalizations.of(context)!.translate('Add a new table'),
        descTextStyle: const TextStyle(fontSize: 18),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(
            right: 20,
            bottom: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: const Center(
            child: const Text(
              "Add",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // Widget floatingActionButton(BuildContext context) {
  //   displayTableShowcase().then((status) {
  //     if (status && isTutoActive) {
  //       WidgetsBinding.instance.addPostFrameCallback(
  //           (_) => ShowCaseWidget.of(context).startShowCase([
  //                 _addTableKey,
  //                 _selectTableKey,
  //                 _backTableKey,
  //               ]));
  //     }
  //   });
  //   return FlatButton(
  //     onPressed: () async {
  //       await showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return TableForm(0, widget.bloc.selectedSection.id);
  //         },
  //       );
  //       widget.bloc.loadDineInTables(widget.bloc.selectedSection.id);
  //     },
  //     child: Showcase(
  //       key: _addTableKey,
  //       description: AppLocalizations.of(context)!.translate('Add a new table'),
  //       descTextStyle: TextStyle(fontSize: 18),
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 12),
  //       child: Container(
  //         margin: EdgeInsets.only(
  //           right: 20,
  //           bottom: 20,
  //         ),
  //         width: 50,
  //         height: 50,
  //         decoration: BoxDecoration(
  //           color: Colors.green,
  //           borderRadius: BorderRadius.all(Radius.circular(50)),
  //         ),
  //         child: Icon(
  //           Icons.add,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget navigation() {
    return TextButton(
      onPressed: () {
        setTableShowcase();
        widget.bloc.eventSink.add(GoToSectionPhase());
      },
      child: Row(
        children: <Widget>[
          Showcase(key: _backTableKey, description: AppLocalizations.of(context)!.translate('Tap Here to Go Back'), descTextStyle: const TextStyle(fontSize: 18), contentPadding: const EdgeInsets.symmetric(horizontal: 12), child: const Icon(Icons.arrow_back)),
          Hero(
            tag: widget.bloc.selectedSection!.id,
            child: Text(
              widget.bloc.selectedSection!.name,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 20,
                color: Colors.blueGrey[900],
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            AppLocalizations.of(context)!.translate("Tap to Edit/Hide \n Hold table to move it"),
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}

class TableWidget extends StatefulWidget {
  final DineInTable table;
  final Void2VoidFunc onPositionChangeEnd;
  final TableBuilderPageBloc bloc;
  TableWidget(this.table, this.bloc, {Key? key, required this.onPositionChangeEnd}) : super(key: key);

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  late double screenWidth;

  double xPosition = 0;
  double yPosition = 0;

  bool draggable = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    xPosition = widget.table.X;
    yPosition = widget.table.Y;
  }

  @override
  Widget build(BuildContext context) {
    try {
      RenderBox box = _tableCanvas.currentContext!.findRenderObject() as RenderBox;
      screenWidth = box.size.width;
    } catch (e) {}

    var item = widget.table;
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onTapUp: (TapUpDetails info) async {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

          String? option = await showMenu(
              context: context,
              position: RelativeRect.fromRect(
                Rect.fromPoints(
                  box.localToGlobal(const Offset(0, 0), ancestor: overlay),
                  box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
                ),
                Offset.zero & overlay.size,
              ),
              items: <PopupMenuEntry<String>>[
                PopupMenuItem(
                  value: "Title",
                  child: Center(child: Text(AppLocalizations.of(context)!.translate("Table ") + item.name)),
                ),
                PopupMenuItem(
                  value: "Edit",
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.edit),
                        Text(AppLocalizations.of(context)!.translate("Edit")),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: "Hide",
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.delete),
                      Text(AppLocalizations.of(context)!.translate("Hide")),
                    ],
                  ),
                )
              ]);

          if (option == "Edit") {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return TableForm(item.id, item.table_group_id);
              },
            );

            widget.bloc.loadDineInTables(item.table_group_id);
          } else if (option == "Hide") {
            print("Hide");
            widget.bloc.eventSink.add(HideTable(tableId: item.id, groupId: item.table_group_id));
          }
        },
        onLongPressEnd: (LongPressEndDetails info) {
          item.savePostion(xPosition, yPosition);
          if (widget.onPositionChangeEnd != null) widget.onPositionChangeEnd();

          setState(() {
            draggable = false;
          });
        },
        onLongPressStart: (info) {
          setState(() {
            draggable = true;
          });
        },
        onLongPressMoveUpdate: (LongPressMoveUpdateDetails info) {
          RenderBox box = _tableCanvas.currentContext!.findRenderObject() as RenderBox;
          setState(() {
            draggable = true;
            xPosition = box.globalToLocal(info.globalPosition).dx - (item.tableImage.width! / 2);

            yPosition = box.globalToLocal(info.globalPosition).dy - (item.tableImage.height! / 2);

            if (xPosition < 0)
              xPosition = 0;
            else if (xPosition > (box.size.width - item.tableImage.width!)) xPosition = (box.size.width - item.tableImage.width!);

            if (yPosition < 0)
              yPosition = 0;
            else if (yPosition > (box.size.height - item.tableImage.height!)) yPosition = (box.size.height - item.tableImage.height!);
          });
        },
        child: tableWidget(item, item.tableImage.width!, item.tableImage.height!),
      ),
    );
  }

  Widget tableWidget(DineInTable item, double width, double height) {
    double w = width;
    double h = height;

    if (draggable) {
      w -= 50;
      h -= 50;
    }

    return Container(
      width: width,
      height: height,
      child: Column(
        children: <Widget>[
          draggable
              ? Container(
                  height: 25,
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.black,
                  ),
                )
              : const Center(),
          Row(
            children: <Widget>[
              draggable
                  ? const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                    )
                  : const Center(),
              Container(
                child: Stack(
                  children: <Widget>[
                    Transform.rotate(
                      angle: item.angle,
                      child: Container(
                        width: w,
                        height: h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage(item.tableImage.image_green!),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: w,
                      height: h,
                      child: Center(
                        child: Container(
                          child: AutoSizeText(
                            item.name,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              draggable
                  ? const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                    )
                  : const Center(),
            ],
          ),
          draggable
              ? Container(
                  height: 25,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                )
              : const Center(),
        ],
      ),
    );
  }

  getLeftPosition(double i) {
    double percentage = i / 1024;
    return screenWidth * percentage;
  }
}
