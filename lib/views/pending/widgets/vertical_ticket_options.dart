import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_bloc.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_event.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_state.dart';
import 'package:invo_mobile/widgets/buttons/secondary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class VerticalTicketOptionsPending extends StatefulWidget {
  final PendingPageBloc bloc;
  VerticalTicketOptionsPending({required this.bloc});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VerticalTicketOptionsPendingState();
  }
}

class _VerticalTicketOptionsPendingState extends State<VerticalTicketOptionsPending> {
  @override
  Widget build(BuildContext context) {
    PendingPageBloc pendingPageBloc = widget.bloc;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
            width: 1,
          )),
      child: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 1.5,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: SecondaryButton(
              onTap: () {
                pendingPageBloc.eventSink.add(AcceptPendingOrder());
              },
              text: AppLocalizations.of(context)!.translate('Accept'),
              isBorderRounded: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: SecondaryButton(
              onTap: () {
                pendingPageBloc.eventSink.add(PrintPendingOrder());
              },
              text: AppLocalizations.of(context)!.translate("Print Ticket"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: SecondaryButton(
              onTap: () {
                pendingPageBloc.eventSink.add(RejectPendingOrder());
              },
              text: AppLocalizations.of(context)!.translate('Reject'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: SecondaryButton(
              onTap: () {},
              text: AppLocalizations.of(context)!.translate("Show Map"),
            ),
          ),
        ],
      ),
    );
  }
}
