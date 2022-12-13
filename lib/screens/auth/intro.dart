import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mars/screens/auth/widgets/intro_page.dart';

typedef OnNext = void Function();
typedef OnSkip = void Function();

class Intro extends StatefulWidget {
  final OnNext onNext;
  final OnSkip onSkip;
  const Intro({super.key, required this.onNext, required this.onSkip});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final _pageController = PageController();
  int? index;

  Box settings = Hive.box('settings');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  reverse: true,
                  onPageChanged: (value) {
                    if (mounted) {
                      setState(() {
                        index = value;
                      });
                    }
                  },
                  children: const [
                    IntroPage(
                        "assets/animations/sick1.flr",
                        'هي خطوتين بس, تختار الاختصاص الي تريده وتبدا تسأل وتستفسر مثل ما تحب بدون رصيد وبدون دفع, اجمع النقاط بداخل التطبيق واصرفها براحتك على الاستشارات',
                        "اسأل طبيبك",
                        true),
                    IntroPage(
                        "assets/animations/sick2.flr",
                        'ندليك عيادة طبيبك بكل تفاصيلها مثل رقم الحجز وايام الدوام وعنوان وموقع العيادة عالخريطة',
                        "دليل الاطباء",
                        true),
                    IntroPage(
                        "assets/animations/map.flr",
                        'نخلي صيدليتك جوا ايدك بكل مكان, بس اطلب المادة الي تريدها ونوصلها الك لباب البيت',
                        "الصيدلية",
                        true),
                    IntroPage(
                        "assets/animations/confuse.flr",
                        'ما يصير تاخذ اي علاج بدون ما تعرف شنو يشتغل وشلون يشتغل, قاموس الادوية وياك بكلشي تريد تعرفه',
                        "قاموس الادوية",
                        true),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DotsIndicator(
                      reversed: true,
                      dotsCount: 4,
                      position: index != null ? index!.toDouble() : 0,
                      decorator: DotsDecorator(
                          size: const Size.square(5),
                          activeSize: const Size.square(7),
                          activeColor: Theme.of(context).colorScheme.secondary,
                          color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (index != 3) {
                                  _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut);
                                } else {
                                  settings.put('intro', true);

                                  widget.onNext();
                                }
                              },
                              style: TextButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  primary:
                                      Theme.of(context).colorScheme.secondary,
                                  textStyle:
                                      const TextStyle(color: Colors.white)),
                              child: const Text('استمرار'),
                            ),
                            index != 3
                                ? TextButton(
                                    onPressed: () {
                                      settings.put('intro', true);

                                      widget.onSkip();
                                    },
                                    style: TextButton.styleFrom(
                                        primary: Colors.transparent,
                                        textStyle: const TextStyle(
                                            color: Colors.white)),
                                    child: Text(
                                      'تخطي',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
