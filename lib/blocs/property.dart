import 'dart:async';

import 'package:flutter/material.dart';

class Property<T> {
  Property() {
    _controller.stream.listen((T? data) {
      value = data;
    });
  }

  T? value;
  final _controller = StreamController<T>.broadcast();
  Sink<T> get sink => _controller.sink;
  Stream<T> get stream => _controller.stream;

  sinkValue(T? data) {
    value = data;
    sink.add(data!);
  }

  setValue(T? data) {
    value = data;
  }

  void dispose() {
    _controller.close();
  }
}
