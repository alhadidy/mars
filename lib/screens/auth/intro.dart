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
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height - 26,
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
                    "assets/imgs/art2.png",
                    'مارس كوفي هاوس يقدم لك الجودة التي تستحقها على شكل كوب من القهوة الفاخرة',
                    "مكانك الذي تستحقه",
                  ),
                  IntroPage(
                    "assets/imgs/art1.png",
                    'نعكس لكم تراث مدينة كركوك بكل اطيافها المتحابة تحت سقف الحب والموسيقى',
                    "جزء من تراث المدينة",
                  ),
                  IntroPage(
                    "assets/imgs/art3.png",
                    'توفر اجواء مقاهي مارس المعتكف المثالي للإسترخاء والسكينة التي تحتاجها وسط ضجيج الحياة',
                    "حيث الهدوء والراحة",
                  ),
                  IntroPage(
                    "assets/imgs/art4.png",
                    'النجاح والتفوق يحتاج الى التركيز ورائحة القهوة الطازجة كتلك التي يقدمها مارس دائما مع الكثير من الحب',
                    "الابداع ينطلق من هنا",
                  ),
                  IntroPage(
                    "assets/imgs/art5.png",
                    'جميع خدمات مارس التي تحبونها توفرت الان بين يديكم في اي وقت من خلال هذا التطبيق الالكتروني',
                    "اهلا بكم في مكانكم المفضل",
                  ),
                ],
              ),
              Positioned(
                  bottom: 100,
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      'assets/imgs/patt.png',
                      width: MediaQuery.of(context).size.width,
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          onPressed: () {
                            if (index != 4) {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                            } else {
                              settings.put('intro', true);

                              widget.onNext();
                            }
                          },
                          child: const Text(
                            'استمرار',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                    ),
                  )),
              Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // TextButton(
                          //   onPressed: () {
                          //     if (index != 4) {
                          //       _pageController.nextPage(
                          //           duration:
                          //               const Duration(milliseconds: 300),
                          //           curve: Curves.easeOut);
                          //     } else {
                          //       settings.put('intro', true);

                          //       widget.onNext();
                          //     }
                          //   },
                          //   style: TextButton.styleFrom(
                          //       shape: const RoundedRectangleBorder(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(25)),
                          //       ),
                          //       primary:
                          //           Theme.of(context).colorScheme.secondary,
                          //       textStyle:
                          //           const TextStyle(color: Colors.white)),
                          //   child: const Text('<< استمرار'),
                          // ),
                          index != 4
                              ? TextButton(
                                  onPressed: () {
                                    settings.put('intro', true);

                                    widget.onSkip();
                                  },
                                  style: TextButton.styleFrom(
                                      primary: Colors.transparent,
                                      textStyle:
                                          const TextStyle(color: Colors.white)),
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
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: DotsIndicator(
                    reversed: true,
                    dotsCount: 5,
                    position: index != null ? index!.toDouble() : 0,
                    decorator: DotsDecorator(
                        size: const Size.square(5),
                        activeSize: const Size.square(7),
                        activeColor: Theme.of(context).colorScheme.secondary,
                        color: Colors.yellow.shade200),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
