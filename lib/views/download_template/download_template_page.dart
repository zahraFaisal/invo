import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/download_template_page/download_template_page_bloc.dart';
import 'package:invo_mobile/blocs/download_template_page/download_template_page_events.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class DownloadTemplate extends StatefulWidget {
  DownloadTemplate({Key? key}) : super(key: key);

  @override
  _DownloadTemplateState createState() => _DownloadTemplateState();
}

class _DownloadTemplateState extends State<DownloadTemplate> {
  @override
  Widget build(BuildContext context) {
    DownloadTemplatePageBloc downloadTemplatePageBloc = new DownloadTemplatePageBloc();

    return Scaffold(
      body: BlocProvider<DownloadTemplatePageBloc>(
        bloc: downloadTemplatePageBloc,
        child: SafeArea(
          child: Container(
            height: double.infinity,
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                Container(
                  height: 65,
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "List of Templates",
                    style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                  ),
                ),
                StreamBuilder(
                    stream: downloadTemplatePageBloc.templates.stream,
                    builder: (context, snapshot) {
                      return downloadTemplatePageBloc.templates.value != null
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: downloadTemplatePageBloc.templates.value!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      height: 90,
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.clip,
                                              '${downloadTemplatePageBloc.templates.value![index][0]}',
                                              style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              debugPrint(downloadTemplatePageBloc.templates.value![index][1].toString());
                                              if (downloadTemplatePageBloc.templates.value![index][1] == false) {
                                                downloadTemplatePageBloc.download(downloadTemplatePageBloc.templates.value![index][0]);
                                                //downloadTemplatePageBloc.templates.value![index][1] = true;
                                              }
                                            },
                                            child: Text(style: TextStyle(fontSize: 16), downloadTemplatePageBloc.templates.value![index][1] == false ? 'Download' : 'Downloaded'),
                                            //other properties
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : Container();
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: 200,
                  child: PrimaryButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: AppLocalizations.of(context)!.translate('Back'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  listofTemplates() {}
}
