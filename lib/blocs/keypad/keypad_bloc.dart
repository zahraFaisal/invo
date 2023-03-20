import 'dart:async';

import 'package:invo_mobile/blocs/keypad/keypad_events.dart';

class KeypadBloc{

  String _text = ""; 

  // // shown text 
  // final _inputTextStateController = StreamController<String>.broadcast() ; 
  // StreamSink<String> get _inputTextSink => _inputTextStateController.sink ; 
  // Stream<String> get inputTextStream => _inputTextStateController.stream ; 

   final _outputTextStateController = StreamController<String>.broadcast() ; 
  StreamSink<String> get _outputTextSink => _outputTextStateController.sink ; 
  Stream<String> get outputTextStream => _outputTextStateController.stream ; 



  //event
  final _eventController = StreamController<KeypadEvent>.broadcast();
  Sink<KeypadEvent> get serviceEventSink => _eventController.sink;


  KeypadBloc()
  {
    _eventController.stream.listen(_mapEventToState);

  }

  void _mapEventToState(KeypadEvent event )
  {

    if( event is OnClickButton )
    {

      print(event.buttonText) ; 
    
      if( event.buttonText == "0.5"  )
      {

      }
      else
      {
         _text = _text +  event.buttonText ; 
         _outputTextSink.add(_text) ; 
      }

      print(_text);


  

    //  print( "current text is  : "  + _text.toString() ) ;


    }
    

  }


  void dispose()
  {
   // _inputTextStateController.close() ; 
    _outputTextStateController.close() ; 
    _eventController.close() ; 
  }




  //input text


}