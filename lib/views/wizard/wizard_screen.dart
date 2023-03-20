// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/wizard/wizard_page_bloc.dart';
import 'package:invo_mobile/blocs/wizard/wizard_page_event.dart';
import 'package:invo_mobile/views/wizard/image_wizard.dart';
import 'package:invo_mobile/views/wizard/image_wizard_portrait.dart';
import 'package:invo_mobile/views/blocProvider.dart';

import 'dart:async';

import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';

class WizardScreen extends StatefulWidget {
  WizardScreen({
    Key? key,
  }) : super(key: key);
  @override
  _WizardScreenState createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> with WidgetsBindingObserver {
  late WizardPageBloc wizardPageBloc;
  final myController = TextEditingController();
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  List<DropdownMenuItem<int>> types = List<DropdownMenuItem<int>>.empty(growable: true);
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStateKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStateKey3 = GlobalKey<FormState>();
  var height;

  bool firstPage = false;
  bool secondPage = false;
  bool lastPage = false;
  int _currentPage = 0;
  void initState() {
    super.initState();
    wizardPageBloc = WizardPageBloc(BlocProvider.of<NavigatorBloc>(context));

    types.add(DropdownMenuItem(
      value: 1,
      child: Text("Cash"),
    ));
    types.add(DropdownMenuItem(
      value: 2,
      child: Text("Card"),
    ));
    types.add(DropdownMenuItem(
      value: 3,
      child: Text("cheque"),
    ));
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 16.0,
      width: 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color.fromARGB(255, 66, 156, 180),
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: BlocProvider<WizardPageBloc>(
        bloc: wizardPageBloc,
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            if (orientation == Orientation.portrait) {
              return portrait(orientation);
            } else {
              return landscape(orientation);
            }
          },
        ),
      ),
    );
  }

  void checkFirstForm() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (await wizardPageBloc.asyncValidateFirstForm(wizardPageBloc.wizard.value!)) {
      _formStateKey.currentState!.validate();
      _formStateKey.currentState!.save();
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      _formStateKey.currentState!.validate();
    }
  }

  void checkSecondForm() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (await wizardPageBloc.asyncValidateSecondForm(wizardPageBloc.wizard.value!)) {
      if (_formStateKey2.currentState!.validate()) _formStateKey2.currentState!.save();

      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      _formStateKey2.currentState!.validate();
    }
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (await wizardPageBloc.asyncValidateFinalForm(wizardPageBloc.wizard.value!)) {
      _formStateKey3.currentState!.validate();
      _formStateKey3.currentState!.save();
    } else {
      _formStateKey3.currentState!.validate();
    }
  }

  Widget portrait(Orientation orientation) {
    return forms2(orientation);
  }

  Widget landscape(Orientation orientation) {
    return forms(orientation);
  }

  Widget forms2(Orientation orientation) {
    return StreamBuilder(
        stream: wizardPageBloc.wizard.stream,
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            // resizeToAvoidBottomPadding: false,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                color: Color.fromRGBO(2, 4, 74, 1),
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Install", style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                      Text(
                        "Follow the simple 3 steps to complete the form:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Container(
                        child: Divider(
                          color: Colors.grey,
                          height: 5,
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: [
                            SingleChildScrollView(
                              child: Container(
                                  child: Form(
                                key: _formStateKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Step 1/3",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    Text(
                                      "Lets start with your company information",
                                      style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Please fill the details below and choose the logo",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    Container(
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 36,
                                      ),
                                    ),
                                    Container(
                                      // padding: EdgeInsets.only(top: 100.0, left: 30),
                                      child: Center(
                                        child: ImageWizardPortrait(
                                          onPick: (String image) {
                                            wizardPageBloc.wizard.value!.image_path = image;
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 1.8,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              "Company Name",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(5.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(37, 205, 137, 1),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              style: TextStyle(color: Colors.white),
                                              onChanged: (value) {
                                                setState(() {
                                                  wizardPageBloc.wizard.value!.company_name = value;
                                                });
                                              },
                                              onSaved: (value) {
                                                wizardPageBloc.wizard.value!.company_name = value!;
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter some text';
                                                } else if (wizardPageBloc.company_name_validation != "") {
                                                  return wizardPageBloc.company_name_validation;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              "Company Phone",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: TextFormField(
                                              onSaved: (value) {
                                                wizardPageBloc.wizard.value!.phone = value!;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  wizardPageBloc.wizard.value!.phone = value;
                                                });
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter some text';
                                                } else if (wizardPageBloc.phone_validation != "") {
                                                  return wizardPageBloc.phone_validation;
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.phone,
                                              style: TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(5.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(37, 205, 137, 1),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              "Company Address 1",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: TextFormField(
                                              onChanged: (value) {
                                                setState(() {
                                                  wizardPageBloc.wizard.value!.company_address1 = value;
                                                });
                                              },
                                              onSaved: (value) {
                                                wizardPageBloc.wizard.value!.company_address1 = value!;
                                              },
                                              style: TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(5.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(37, 205, 137, 1),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              "Company Address 2",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            onSaved: (value) {
                                              wizardPageBloc.wizard.value!.company_address2 = value!;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                wizardPageBloc.wizard.value!.company_address2 = value;
                                              });
                                            },
                                            validator: (value) {
                                              return null;
                                            },
                                            style: TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(5.0),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Color.fromRGBO(37, 205, 137, 1),
                                                  width: 1.5,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // MediaQuery.of(context).viewInsets.bottom > 100
                                    //     ? SizedBox(
                                    //         height: 250,
                                    //       )
                                    //     : SizedBox(
                                    //         height: 0,
                                    //       ),
                                  ],
                                ),
                              )),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                height: height * 0.9,
                                child: Form(
                                  key: _formStateKey2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Step 2/3",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Text(
                                        "Your user profile",
                                        style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Please enter your username and password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Container(
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 36,
                                        ),
                                      ),
                                      Container(
                                        width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 1.8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                "User Name",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: TextFormField(
                                                onSaved: (value) {
                                                  wizardPageBloc.wizard.value!.admin_name = value!;
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    wizardPageBloc.wizard.value!.admin_name = value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter some text';
                                                  } else if (wizardPageBloc.admin_name_validation != "") {
                                                    return wizardPageBloc.admin_name_validation;
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(5.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Color.fromRGBO(37, 205, 137, 1),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                "Pass Code",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: TextFormField(
                                                onSaved: (value) {
                                                  wizardPageBloc.wizard.value!.pass_code = value!;
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    wizardPageBloc.wizard.value!.pass_code = value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter some text';
                                                  } else if (wizardPageBloc.pass_code_validation != "") {
                                                    return wizardPageBloc.pass_code_validation;
                                                  }
                                                  return null;
                                                },
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(5.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Color.fromRGBO(37, 205, 137, 1),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                height: height * 0.9,
                                child: Form(
                                  key: _formStateKey3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Step 3/3",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Text(
                                        "Currency",
                                        style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Please enter the currency and choose decimal point",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      Container(
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 36,
                                        ),
                                      ),
                                      Container(
                                        width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 1.8,
                                        // padding: EdgeInsets.all(18),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: TextFormField(
                                                initialValue: wizardPageBloc.wizard.value!.symbol,
                                                onSaved: (value) {
                                                  wizardPageBloc.wizard.value!.symbol = value!;
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    wizardPageBloc.wizard.value!.symbol = value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter some text';
                                                  } else if (wizardPageBloc.symbol_validation != "") {
                                                    return wizardPageBloc.symbol_validation;
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(color: Colors.white),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(5.0),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Color.fromRGBO(37, 205, 137, 1),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(left: 5),
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.white),
                                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                ),
                                              ),
                                              child: DropdownButtonFormField<int>(
                                                icon: Icon(Icons.arrow_drop_down),
                                                iconSize: 24,
                                                elevation: 16,
                                                isExpanded: true,
                                                value: wizardPageBloc.wizard.value!.dicamal,
                                                hint: Text(
                                                  'Select Decimal',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    wizardPageBloc.wizard.value!.dicamal = value!;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null) {
                                                    setState(() {
                                                      wizardPageBloc.wizard.value!.dicamal = 2;
                                                    });
                                                    return 'Please enter some text';
                                                  } else if (wizardPageBloc.dicamal_validation != "") {
                                                    return wizardPageBloc.dicamal_validation;
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(color: Colors.black),
                                                items: <int>[
                                                  0,
                                                  1,
                                                  2,
                                                  3,
                                                ].map<DropdownMenuItem<int>>((int value) {
                                                  return DropdownMenuItem<int>(
                                                    value: value,
                                                    child: Text(
                                                      0.toStringAsFixed(value),
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _currentPage == 0
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 140,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(37, 205, 137, 1)),
                                      shape: MaterialStateProperty.all(
                                        new RoundedRectangleBorder(
                                            //side: BorderSide(color: Colors.white, width: 1.5),
                                            borderRadius: new BorderRadius.circular(20.0)),
                                      )),
                                  onPressed: () {
                                    if (_formStateKey.currentState != null) {
                                      checkFirstForm();
                                    } else if (_formStateKey2.currentState != null) {
                                      checkSecondForm();
                                    }
                                  },
                                  child: Text(
                                    "Next",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      (_currentPage == 1 || _currentPage == 2)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 5),
                                  width: 140,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(37, 205, 137, 1)),
                                        shape: MaterialStateProperty.all(
                                          new RoundedRectangleBorder(
                                              //side: BorderSide(color: Colors.white, width: 1.5),
                                              borderRadius: new BorderRadius.circular(20.0)),
                                        )),
                                    onPressed: () {
                                      if (_formStateKey2.currentState != null)
                                        _pageController.previousPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                      else if (_formStateKey3.currentState != null)
                                        _pageController.previousPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                          size: 13.0,
                                        ),
                                        Text(
                                          'Back',
                                          style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _currentPage == 2
                                    ? Container(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Color.fromRGBO(37, 205, 137, 1)),
                                              shape: MaterialStateProperty.all(
                                                new RoundedRectangleBorder(
                                                    //side: BorderSide(color: Colors.white, width: 1.5),
                                                    borderRadius: new BorderRadius.circular(20.0)),
                                              )),
                                          onPressed: () {
                                            if (_formStateKey3.currentState != null) {
                                              save();

                                              wizardPageBloc.eventSink.add(WizardCreateDB(wizardPageBloc.wizard.value!));
                                            }
                                          },
                                          child: Text(
                                            'Get Started',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 140,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Color.fromRGBO(37, 205, 137, 1)),
                                              shape: MaterialStateProperty.all(
                                                new RoundedRectangleBorder(
                                                    //side: BorderSide(color: Colors.white, width: 1.5),
                                                    borderRadius: new BorderRadius.circular(20.0)),
                                              )),
                                          onPressed: () {
                                            if (_formStateKey.currentState != null) {
                                              checkFirstForm();
                                            } else if (_formStateKey2.currentState != null) {
                                              checkSecondForm();
                                            }
                                          },
                                          child: Text(
                                            "Next",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget forms(Orientation orientation) {
    return StreamBuilder(
        stream: wizardPageBloc.wizard.stream,
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                color: Color.fromRGBO(2, 4, 74, 1),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Install", style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                      Text(
                        "Follow the simple 3 steps to complete the form:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Container(
                        child: Divider(
                          color: Colors.grey,
                          height: 5,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    "Lets Go!",
                                    style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Company Information & Upload",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Text(
                                    "Almost there",
                                    style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Loging Information",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Text(
                                    "Last Step",
                                    style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Currency",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                ],
                              ),
                            ),
                            Column(children: [
                              Container(
                                width: 40,
                                height: orientation == Orientation.portrait ? height * 0.04 : height * 0.05,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(width: 4, color: Color.fromRGBO(255, 255, 255, 0.2))),
                                child: Icon(
                                  Icons.circle,
                                  size: 10.0,
                                  color: _currentPage >= 0 ? Color.fromRGBO(37, 205, 137, 1) : Color.fromRGBO(255, 255, 255, 0),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: orientation == Orientation.portrait ? height * 0.09 : height * 0.16,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(width: 4, color: Color.fromRGBO(255, 255, 255, 0.2))),
                                child: Icon(
                                  Icons.circle,
                                  size: 10.0,
                                  color: _currentPage >= 1 ? Color.fromRGBO(37, 205, 137, 1) : Color.fromRGBO(255, 255, 255, 0),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: orientation == Orientation.portrait ? height * 0.1 : height * 0.16,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(width: 4, color: Color.fromRGBO(255, 255, 255, 0.2))),
                                child: Icon(
                                  Icons.circle,
                                  size: 10.0,
                                  color: _currentPage >= 2 ? Color.fromRGBO(37, 205, 137, 1) : Color.fromRGBO(255, 255, 255, 0),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: height * 0.17,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                            ]),
                            Expanded(
                              child: PageView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _pageController,
                                onPageChanged: (int page) {
                                  setState(() {
                                    _currentPage = page;
                                  });
                                },
                                children: [
                                  SingleChildScrollView(
                                    child: Container(
                                        child: Form(
                                      key: _formStateKey,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 30),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                // ignore: prefer_const_constructors
                                                Text(
                                                  "Step 1/3",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                                Text(
                                                  "Lets start with your company information",
                                                  style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  "Please fill the details below and choose the logo",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                                Container(
                                                  child: Divider(
                                                    color: Colors.grey,
                                                    height: 36,
                                                  ),
                                                ),
                                                Container(
                                                  width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 1.8,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                        child: Text(
                                                          "Company Name",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.all(5.0),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Color.fromRGBO(37, 205, 137, 1),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Colors.grey,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            errorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Colors.red,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Colors.red,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                          ),
                                                          style: TextStyle(color: Colors.white),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              wizardPageBloc.wizard.value!.company_name = value;
                                                            });
                                                          },
                                                          onSaved: (value) {
                                                            wizardPageBloc.wizard.value!.company_name = value!;
                                                          },
                                                          validator: (value) {
                                                            if (value!.isEmpty) {
                                                              return 'Please enter some text';
                                                            } else if (wizardPageBloc.company_name_validation != "") {
                                                              return wizardPageBloc.company_name_validation;
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                        child: Text(
                                                          "Company Phone",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                        child: TextFormField(
                                                          onSaved: (value) {
                                                            wizardPageBloc.wizard.value!.phone = value!;
                                                          },
                                                          onChanged: (value) {
                                                            setState(() {
                                                              wizardPageBloc.wizard.value!.phone = value;
                                                            });
                                                          },
                                                          validator: (value) {
                                                            if (value!.isEmpty) {
                                                              return 'Please enter some text';
                                                            } else if (wizardPageBloc.phone_validation != "") {
                                                              return wizardPageBloc.phone_validation;
                                                            }
                                                            return null;
                                                          },
                                                          keyboardType: TextInputType.phone,
                                                          style: TextStyle(color: Colors.white),
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.all(5.0),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Color.fromRGBO(37, 205, 137, 1),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Colors.grey,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            errorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Colors.red,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Colors.red,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                        child: Text(
                                                          "Company Address 1",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                        child: TextFormField(
                                                          onChanged: (value) {
                                                            setState(() {
                                                              wizardPageBloc.wizard.value!.company_address1 = value;
                                                            });
                                                          },
                                                          onSaved: (value) {
                                                            wizardPageBloc.wizard.value!.company_address1 = value!;
                                                          },
                                                          style: TextStyle(color: Colors.white),
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.all(5.0),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Color.fromRGBO(37, 205, 137, 1),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                              borderSide: BorderSide(
                                                                color: Colors.grey,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                        child: Text(
                                                          "Company Address 2",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        onSaved: (value) {
                                                          wizardPageBloc.wizard.value!.company_address2 = value!;
                                                        },
                                                        onChanged: (value) {
                                                          setState(() {
                                                            wizardPageBloc.wizard.value!.company_address2 = value;
                                                          });
                                                        },
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        style: TextStyle(color: Colors.white),
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.all(5.0),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Color.fromRGBO(37, 205, 137, 1),
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Colors.grey,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                MediaQuery.of(context).viewInsets.bottom > 100
                                                    ? SizedBox(
                                                        height: 250,
                                                      )
                                                    : SizedBox(
                                                        height: 0,
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 100.0, left: 30),
                                            child: Center(
                                              child: ImageWizard(
                                                onPick: (String image) {
                                                  wizardPageBloc.wizard.value!.image_path = image;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ),
                                  SingleChildScrollView(
                                    child: Container(
                                      height: height * 0.9,
                                      child: Form(
                                        key: _formStateKey2,
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Step 2/3",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              Text(
                                                "Your user profile",
                                                style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Please enter your username and password",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              Container(
                                                child: Divider(
                                                  color: Colors.grey,
                                                  height: 36,
                                                ),
                                              ),
                                              Container(
                                                width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 1.8,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: Text(
                                                        "User Name",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: TextFormField(
                                                        onSaved: (value) {
                                                          wizardPageBloc.wizard.value!.admin_name = value!;
                                                        },
                                                        onChanged: (value) {
                                                          setState(() {
                                                            wizardPageBloc.wizard.value!.admin_name = value;
                                                          });
                                                        },
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter some text';
                                                          } else if (wizardPageBloc.admin_name_validation != "") {
                                                            return wizardPageBloc.admin_name_validation;
                                                          }
                                                          return null;
                                                        },
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.all(5.0),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Color.fromRGBO(37, 205, 137, 1),
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Colors.grey,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          errorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Colors.red,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          focusedErrorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Colors.red,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                        ),
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: Text(
                                                        "Pass Code",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: TextFormField(
                                                        onSaved: (value) {
                                                          wizardPageBloc.wizard.value!.pass_code = value!;
                                                        },
                                                        onChanged: (value) {
                                                          setState(() {
                                                            wizardPageBloc.wizard.value!.pass_code = value;
                                                          });
                                                        },
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter some text';
                                                          } else if (wizardPageBloc.pass_code_validation != "") {
                                                            return wizardPageBloc.pass_code_validation;
                                                          }
                                                          return null;
                                                        },
                                                        keyboardType: TextInputType.number,
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.all(5.0),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Color.fromRGBO(37, 205, 137, 1),
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Colors.grey,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          errorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Colors.red,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          focusedErrorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Colors.red,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                        ),
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Container(
                                      height: height * 0.9,
                                      child: Form(
                                        key: _formStateKey3,
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Step 3/3",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              Text(
                                                "Currency",
                                                style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Please enter the currency and choose decimal point",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              Container(
                                                child: Divider(
                                                  color: Colors.grey,
                                                  height: 36,
                                                ),
                                              ),
                                              Container(
                                                width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 1.8,
                                                padding: EdgeInsets.all(18),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: TextFormField(
                                                        initialValue: wizardPageBloc.wizard.value!.symbol,
                                                        onSaved: (value) {
                                                          wizardPageBloc.wizard.value!.symbol = value!;
                                                        },
                                                        onChanged: (value) {
                                                          setState(() {
                                                            wizardPageBloc.wizard.value!.symbol = value;
                                                          });
                                                        },
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter some text';
                                                          } else if (wizardPageBloc.symbol_validation != "") {
                                                            return wizardPageBloc.symbol_validation;
                                                          }
                                                          return null;
                                                        },
                                                        style: TextStyle(color: Colors.white),
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.all(5.0),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Color.fromRGBO(37, 205, 137, 1),
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            borderSide: BorderSide(
                                                              color: Colors.grey,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(left: 5),
                                                      decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.white),
                                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                        ),
                                                      ),
                                                      child: DropdownButtonFormField<int>(
                                                        icon: Icon(Icons.arrow_drop_down),
                                                        iconSize: 24,
                                                        elevation: 16,
                                                        isExpanded: true,
                                                        value: wizardPageBloc.wizard.value!.dicamal,
                                                        hint: Text(
                                                          'Select Decimal',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onChanged: (int? value) {
                                                          setState(() {
                                                            wizardPageBloc.wizard.value!.dicamal = value!;
                                                          });
                                                        },
                                                        validator: (value) {
                                                          if (value == null) {
                                                            setState(() {
                                                              wizardPageBloc.wizard.value!.dicamal = 2;
                                                            });
                                                            return 'Please enter some text';
                                                          } else if (wizardPageBloc.dicamal_validation != "") {
                                                            return wizardPageBloc.dicamal_validation;
                                                          }
                                                          return null;
                                                        },
                                                        style: TextStyle(color: Colors.black),
                                                        items: <int>[
                                                          0,
                                                          1,
                                                          2,
                                                          3,
                                                        ].map<DropdownMenuItem<int>>((int value) {
                                                          return DropdownMenuItem<int>(
                                                            value: value,
                                                            child: Text(
                                                              0.toStringAsFixed(value),
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _currentPage == 0
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 140,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 205, 137, 1)),
                                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ))),
                                  onPressed: () {
                                    if (_formStateKey.currentState != null) {
                                      checkFirstForm();
                                    } else if (_formStateKey2.currentState != null) {
                                      checkSecondForm();
                                    }
                                  },
                                  child: Text(
                                    "Next",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      (_currentPage == 1 || _currentPage == 2)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 5),
                                  width: 140,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 205, 137, 1)),
                                        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ))),
                                    onPressed: () {
                                      if (_formStateKey2.currentState != null)
                                        // ignore: curly_braces_in_flow_control_structures
                                        _pageController.previousPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                      else if (_formStateKey3.currentState != null)
                                        _pageController.previousPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: <Widget>[
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                          size: 13.0,
                                        ),
                                        Text(
                                          'Back',
                                          style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _currentPage == 2
                                    ? Container(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 205, 137, 1)),
                                              shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ))),
                                          onPressed: () {
                                            if (_formStateKey3.currentState != null) {
                                              save();
                                              wizardPageBloc.eventSink.add(WizardCreateDB(wizardPageBloc.wizard.value!));
                                            }
                                          },
                                          child: Text(
                                            'Get Started',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 140,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 205, 137, 1)),
                                              shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ))),
                                          onPressed: () {
                                            if (_formStateKey.currentState != null) {
                                              checkFirstForm();
                                            } else if (_formStateKey2.currentState != null) {
                                              checkSecondForm();
                                            }
                                          },
                                          child: Text(
                                            "Next",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
