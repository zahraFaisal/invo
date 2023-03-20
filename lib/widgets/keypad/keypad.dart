import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:invo_mobile/blocs/keypad/keypad_bloc.dart';
import 'package:invo_mobile/blocs/keypad/keypad_events.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

typedef String2VoidFunc = void Function(String);

class Keypad extends StatefulWidget {
  final bool isButtonOfHalfInclude;
  final bool isButtonOfDotInclude;
  final bool isTelephoneStyle;
  final int maxLength;
  final String EnterText;
  final bool isPassword;
  final String2VoidFunc? onChange;
  const Keypad({Key? key, this.isButtonOfHalfInclude = false, this.isButtonOfDotInclude = false, this.isTelephoneStyle = false, required this.EnterText, this.isPassword = false, this.onChange, this.maxLength = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KeypadState();
  }
}

class KeypadState extends State<Keypad> {
  final keypadBloc = KeypadBloc();

  String text = "";

  void updateNumber(double number) {
    setState(() {
      text = number.toString();
    });
  }

  void clear() {
    setState(() {
      text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Center(
      child: AutoSizeText(
        widget.EnterText,
        maxLines: 1,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );

    if (text != "") {
      String pass = text;
      print(widget.isPassword);
      if (widget.isPassword) {
        pass = "";
        for (var i = 0; i < text.length; i++) {
          pass += "*";
        }
      }

      textWidget = Center(
        child: AutoSizeText(
          pass,
          maxLines: 1,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
        ),
      );
    }

    bool dotButton = (widget.isButtonOfDotInclude == null) ? false : widget.isButtonOfDotInclude;
    bool halfButton = (widget.isButtonOfHalfInclude == null) ? false : widget.isButtonOfHalfInclude;

    Widget addationBtn = SizedBox();
    if (halfButton) {
      addationBtn = Expanded(
        flex: 1,
        child: KeypadButton(
          text: "0.5",
          onTap: () {
            if (!text.contains(".5")) {
              setState(() {
                this.text = this.text + ".5";
              });
              if (widget.onChange != null) {
                widget.onChange!(this.text);
              }
            }
          },
        ),
      );
    } else if (dotButton) {
      addationBtn = Expanded(
        flex: 1,
        child: KeypadButton(
          text: ".",
          onTap: () {
            if (!text.contains(".")) {
              setState(() {
                this.text = this.text + ".";
              });
              if (widget.onChange != null) {
                widget.onChange!(this.text);
              }
            }
          },
        ),
      );
    }

    List<Widget> _numbers = List<Widget>.empty(growable: true);
    _numbers.add((widget.isTelephoneStyle) ? _1to3Widget() : _7to9Widget());
    _numbers.add(_4to6Widget());
    _numbers.add((widget.isTelephoneStyle) ? _7to9Widget() : _1to3Widget());

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      width: 5.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 3, child: textWidget),
                      Expanded(
                          flex: 2,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  if (this.text.length > 0) {
                                    this.text = this.text.substring(0, this.text.length - 1);
                                    if (widget.onChange != null) {
                                      widget.onChange!(this.text);
                                    }
                                  }
                                });
                              },
                              child: Image.asset(
                                "assets/icons/deleteiconwhite.png",
                                width: 90,
                                height: 90,
                              )))
                    ],
                  ))),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: _numbers,
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: KeypadButton(
                  text: AppLocalizations.of(context)!.translate('Clear'),
                  onTap: () {
                    setState(() {
                      this.text = "";
                      if (widget.onChange != null) {
                        widget.onChange!(this.text);
                      }
                    });
                  },
                ),
              ),
              Expanded(
                flex: (dotButton || halfButton) ? 1 : 2,
                child: KeypadButton(
                  text: "0",
                  onTap: () {
                    numberClick("0");
                  },
                ),
              ),
              addationBtn
            ],
          ),
        ),
      ],
    );
  }

  Widget _7to9Widget() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: KeypadButton(
              text: "7",
              onTap: () {
                numberClick("7");
              },
            ),
          ),
          Expanded(
            child: KeypadButton(
              text: "8",
              onTap: () {
                numberClick("8");
              },
            ),
          ),
          Expanded(
            child: KeypadButton(
              text: "9",
              onTap: () {
                numberClick("9");
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _4to6Widget() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: KeypadButton(
              text: "4",
              onTap: () {
                numberClick("4");
              },
            ),
          ),
          Expanded(
            child: KeypadButton(
              text: "5",
              onTap: () {
                numberClick("5");
              },
            ),
          ),
          Expanded(
            child: KeypadButton(
              text: "6",
              onTap: () {
                numberClick("6");
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _1to3Widget() {
    return Expanded(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        Expanded(
          child: KeypadButton(
            text: "1",
            onTap: () {
              numberClick("1");
            },
          ),
        ),
        Expanded(
          child: KeypadButton(
            text: "2",
            onTap: () {
              numberClick("2");
            },
          ),
        ),
        Expanded(
          child: KeypadButton(
            text: "3",
            onTap: () {
              numberClick("3");
            },
          ),
        ),
      ]),
    );
  }

  void numberClick(String number) {
    if (widget.maxLength != null && widget.maxLength > 0) {
      if (text.length < widget.maxLength) {
        setState(() {
          this.text = this.text + number;
        });
      }
    } else {
      setState(() {
        this.text = this.text + number;
      });
    }

    if (widget.onChange != null) {
      widget.onChange!(this.text);
    }
  }

  // void changeText(String enteredText) {

  //   print("text before changed " + this.text   ) ;

  //   // if (enteredText == "0.5") {

  //   //   this.text = this.text + ".5" ;

  //   // } else if (enteredText.length > 13) {

  //   //   setState(() {
  //   //     this.text = "";
  //   //     this.text = this.text + enteredText;
  //   //   });

  //   // } else {

  //   //   setState(() {
  //   //     this.text = this.text + enteredText ;
  //   //   });

  //   }
  //   print("text after changed " + this.text  ) ;
  // }

  @override
  void dispose() {
    super.dispose();
    keypadBloc.dispose();
  }
}
