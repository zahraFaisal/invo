import 'package:flutter/material.dart';
import 'package:invo_mobile/widgets/buttons/secondary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class DriverOptions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DriverOptionsState();
  }
}

class _DriverOptionsState extends State<DriverOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: SecondaryButton(
              text: AppLocalizations.of(context)!.translate("Assign Driver"),
            ),
          ),
          Expanded(
            child: SecondaryButton(
              text: AppLocalizations.of(context)!.translate("Driver Arrival"),
            ),
          ),
          Expanded(
            child: SecondaryButton(
              text: AppLocalizations.of(context)!.translate("Driver Report"),
            ),
          )
        ],
      ),
    );
  }
}
