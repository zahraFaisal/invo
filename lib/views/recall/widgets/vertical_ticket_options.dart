import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_bloc.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_event.dart';
import 'package:invo_mobile/widgets/buttons/secondary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class VerticalTicketOptions extends StatefulWidget {
  final RecallPageBloc bloc;
  VerticalTicketOptions({required this.bloc});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VerticalTicketOptionsState();
  }
}

class _VerticalTicketOptionsState extends State<VerticalTicketOptions> {
  @override
  Widget build(BuildContext context) {
    RecallPageBloc recallPageBloc = widget.bloc;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
            width: 1,
          )),
      child: recallPageBloc.selectedService.value!.id != 77
          ? GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 1.5,
              children: <Widget>[
                (recallPageBloc.order!.isEditBtnVisible)
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: SecondaryButton(
                          onTap: () {
                            recallPageBloc.eventSink.add(EditOrder());
                          },
                          text: AppLocalizations.of(context)!.translate('Edit Order'),
                        ),
                      )
                    : SizedBox(),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: SecondaryButton(
                    onTap: () {
                      recallPageBloc.eventSink.add(PrintOrder());
                    },
                    text: AppLocalizations.of(context)!.translate("Print Ticket"),
                  ),
                ),
                (recallPageBloc.order!.isPayBtnVisible)
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: SecondaryButton(
                          onTap: () {
                            recallPageBloc.eventSink.add(PayOrder());
                          },
                          text: AppLocalizations.of(context)!.translate("Pay"),
                        ),
                      )
                    : SizedBox(),
                (recallPageBloc.order!.isVoidBtnVisible)
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: SecondaryButton(
                          onTap: () {
                            recallPageBloc.eventSink.add(VoidOrder());
                          },
                          text: AppLocalizations.of(context)!.translate("Void Ticket"),
                        ),
                      )
                    : SizedBox(),
                (recallPageBloc.order!.isEditBtnVisible)
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: SecondaryButton(
                          onTap: () {
                            recallPageBloc.eventSink.add(FollowUpOrder());
                          },
                          text: AppLocalizations.of(context)!.translate("Follow Up"),
                        ),
                      )
                    : SizedBox(),
                (recallPageBloc.order!.isSurchargeBtnVisible)
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: SecondaryButton(
                          onTap: () {
                            recallPageBloc.eventSink.add(SurchargeOrder());
                          },
                          text: AppLocalizations.of(context)!.translate("Subcharge"),
                        ),
                      )
                    : SizedBox(),
                (recallPageBloc.order!.isDiscountBtnVisible)
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: SecondaryButton(
                          onTap: () {
                            recallPageBloc.eventSink.add(DiscountOrder());
                          },
                          text: AppLocalizations.of(context)!.translate("Discount"),
                        ),
                      )
                    : SizedBox(),

                // Container(
                //   margin: EdgeInsets.only(bottom: 5),
                //   child: SecondaryButton(
                //     text: AppLocalizations.of(context)!.translate("Send Email"),
                //   ),
                // ),
                // Container(
                //   child: SecondaryButton(
                //     text: AppLocalizations.of(context)!.translate("Show Map"),
                //   ),
                // ),
              ],
            )
          : GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 1.5,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: SecondaryButton(
                    onTap: () {},
                    text: AppLocalizations.of(context)!.translate('Accept'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: SecondaryButton(
                    onTap: () {
                      recallPageBloc.eventSink.add(PrintOrder());
                    },
                    text: AppLocalizations.of(context)!.translate("Print Ticket"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: SecondaryButton(
                    onTap: () {},
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
