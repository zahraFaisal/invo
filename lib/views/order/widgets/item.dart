import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:invo_mobile/models/menu_item.dart' as mi;
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

class Item extends StatefulWidget {
  final mi.MenuItem item;
  final Void2VoidFunc onTap;
  const Item({Key? key, required this.item, required this.onTap}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemState();
  }
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    String secondaryLang = locator.get<ConnectionRepository>().preference!.secondary_lang_code;
    String lang = locator.get<ConnectionRepository>().terminal!.langauge ?? "";

    String itemName = widget.item.name!;
    if (lang == secondaryLang && widget.item.secondary_name != null && widget.item.secondary_name!.isNotEmpty) {
      itemName = widget.item.secondary_name!;
    }

    print(lang);
    // TODO: implement build
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
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
                color: widget.item.color,
              ),
            ),
            widget.item.imageByte != null
                ? Expanded(
                    child: Image.memory(
                      widget.item.imageByte!,
                      fit: BoxFit.fitWidth,
                    ),
                  )
                : Center(),
            widget.item.imageByte != null
                ? Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      itemName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: widget.item.color,
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Text(
                        itemName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: widget.item.color,
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
                color: widget.item.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
