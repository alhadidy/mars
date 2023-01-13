import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/screens/home/widgets/quantity_buttons.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Basket extends ConsumerStatefulWidget {
  const Basket({super.key});

  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends ConsumerState<Basket>
    with SingleTickerProviderStateMixin {
  PanelController controller = PanelController();
  ValueNotifier<bool> showTrashButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase db = ref.watch(dbProvider);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'سلة المشتريات',
            textAlign: TextAlign.center,
          ),
          actions: [
            ValueListenableBuilder(
              valueListenable: showTrashButton,
              builder: (BuildContext context, dynamic value, child) {
                return value
                    ? IconButton(
                        onPressed: () {
                          db.localOrdersDao.clearTheOrder();
                        },
                        icon: const FaIcon(FontAwesomeIcons.solidTrashCan))
                    : Container();
              },
            )
          ],
        ),
        body: StreamBuilder<List<LocalOrder>>(
          stream: db.localOrdersDao.watchTheOrder(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data.length == 0) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showTrashButton.value = false;
              });

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                      ),
                      child: Image.asset(
                        'assets/imgs/addToCart.png',
                        height: 500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text('سلة المشتريات فارغة حاليا',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }

            List<LocalOrder> order = snapshot.data;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              showTrashButton.value = true;
            });

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: order.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: index + 1 == order.length
                            ? const EdgeInsets.only(bottom: 100)
                            : const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(order[index].name),
                          ),
                          leading: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.xmark,
                                color: Colors.red),
                            onPressed: () async {
                              await db.localOrdersDao
                                  .deleteFromTheOrder(order[index]);
                            },
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${Methods.formatPrice((Methods.roundPriceWithDiscountIQD(price: order[index].price, discount: order[index].discount) * order[index].quantity))} د.ع'),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: QuantityButtons(order[index]))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: db.localOrdersDao.getOrderTotal(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      int total = snapshot.data;
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/completeOrder');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'تأكيد الطلب',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                            'المجموع: ${Methods.formatPrice(total)} د.ع'),
                                      ],
                                    ),
                                  ))),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ));
  }
}
