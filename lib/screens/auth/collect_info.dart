import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/user.dart';
import 'package:mars/models/user_info.dart';
import 'package:mars/services/firestore/users.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/providers.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class CollectInfo extends ConsumerStatefulWidget {
  const CollectInfo({Key? key}) : super(key: key);

  @override
  _CollectInfoState createState() => _CollectInfoState();
}

class _CollectInfoState extends ConsumerState<CollectInfo> {
  DateTime _selectedDate = DateTime.now();
  String gender = 'ذكر';
  bool validate = false;
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'المعلومات الشخصية',
          style: GoogleFonts.tajawal(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'الجنس',
                style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Center(
              child: ToggleButtons(
                selectedBorderColor: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                children: [
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('ذكر',
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(FontAwesomeIcons.mars),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('أنثى',
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FaIcon(FontAwesomeIcons.venus),
                        )
                      ],
                    ),
                  ),
                ],
                isSelected: [gender == 'ذكر', gender == 'أنثى'],
                onPressed: (index) {
                  setState(() {
                    if (index == 0) {
                      gender = 'ذكر';
                    } else {
                      gender = 'أنثى';
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'تاريخ الميلاد',
                style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 250,
              child: ScrollDatePicker(
                selectedDate: _selectedDate,
                locale: const Locale('en'),
                indicator: Container(
                    height: 40,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                onDateTimeChanged: (DateTime value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'العنوان',
                style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: controller,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                      errorText: validate ? 'الرجاء تحديد العنوان' : null,
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2)),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    onPressed: () async {
                      if (controller.text == '') {
                        setState(() {
                          validate = true;
                        });
                        return;
                      }

                      await locator.get<Users>().setUserInfos(
                          user!.uid,
                          UserInfo(
                              birth: _selectedDate,
                              gender: gender,
                              address: controller.text));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'حفظ المعلومات',
                        style: GoogleFonts.tajawal(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 2.5),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
