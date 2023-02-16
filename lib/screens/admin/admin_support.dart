import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/msg.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/firestore/support.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class AdminSupport extends ConsumerStatefulWidget {
  const AdminSupport({Key? key}) : super(key: key);

  @override
  _AdminSupportState createState() => _AdminSupportState();
}

class _AdminSupportState extends ConsumerState<AdminSupport> {
  TextEditingController msgController = TextEditingController();

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Support'),
        ),
        body: const Center(child: Text('حدثت مشكلة اثناء التحميل')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        actions: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.boxArchive))
        ],
      ),
      body: StreamBuilder(
        stream: locator.get<Support>().watchMsgs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Msg> msgs = snapshot.data;
            if (msgs.isEmpty) {
              return const Center(child: Text('لا توجد رسائل حاليا'));
            }
            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                itemCount: msgs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      color: msgs[index].supportId == ''
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Methods.formatTime(msgs[index].time, 'en'),
                                    style: TextStyle(
                                      color: msgs[index].supportId == ''
                                          ? Colors.white
                                          : null,
                                    )),
                                Text(Methods.formatDate(msgs[index].time, 'en'),
                                    style: TextStyle(
                                      color: msgs[index].supportId == ''
                                          ? Colors.white
                                          : null,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(msgs[index].content,
                                style: TextStyle(
                                  color: msgs[index].supportId == ''
                                      ? Colors.white
                                      : null,
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RoundIconButton(
                                size: 36,
                                icon: FontAwesomeIcons.solidPaperPlane,
                                color: Theme.of(context).colorScheme.secondary,
                                onTap: (() {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return AlertDialog(
                                          title: const Text('Replay'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: TextField(
                                                  controller: msgController,
                                                  maxLines: 5,
                                                  minLines: 1,
                                                  autofocus: true,
                                                  decoration: const InputDecoration(
                                                      hintText:
                                                          'شكرا على التواصل مع خدمة العملاء'),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 36,
                                              ),
                                              ElevatedButton(
                                                child: const Text('ارسال'),
                                                onPressed: () async {
                                                  if (msgController
                                                      .text.isEmpty) {
                                                    return;
                                                  }
                                                  await locator
                                                      .get<Support>()
                                                      .addMsg(
                                                        msgs[index].userId,
                                                        msgController.text,
                                                        user.uid,
                                                        msgs[index].fid,
                                                      );
                                                  msgController.text = '';
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }));
                                }),
                              )),
                        ],
                      ));
                },
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('حدثت مشكلة اثناء التحميل'));
          }

          return const Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
          ));
        },
      ),
    );
  }
}
