import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/reward.dart';
import 'package:mars/models/sSettings.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/firestore/rewards.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class RewardPoints extends ConsumerStatefulWidget {
  const RewardPoints({Key? key}) : super(key: key);

  @override
  _RewardPointsState createState() => _RewardPointsState();
}

class _RewardPointsState extends ConsumerState<RewardPoints> {
  @override
  Widget build(BuildContext context) {
    SSetting? settings = ref.watch(shopSettingsProvider);
    UserModel? user = ref.watch(userProvider);
    int rewardAmount = settings?.rewardAmount ?? 0;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reward Points'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Reward ' + rewardAmount.toString() + ' Points',
                                style: GoogleFonts.tajawal(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "You will be adding $rewardAmount points to the user's points, to change the standard reward amount contact your active admin. \n\n You can not reward the same user more than one time each hour.",
                                style: GoogleFonts.tajawal(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    if (user == null) {
                                      return;
                                    }
                                    String barcodeScanRes =
                                        await FlutterBarcodeScanner.scanBarcode(
                                            '#ff6666',
                                            'Cancel',
                                            true,
                                            ScanMode.QR);
                                    if (barcodeScanRes == '-1') {
                                      return;
                                    }
                                    int? amount = settings?.rewardAmount;
                                    if (amount == null || amount == 0) {
                                      return;
                                    }
                                    Methods.showLoaderDialog(context);
                                    await locator.get<Rewards>().addReward(
                                        barcodeScanRes, user.uid, amount);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  icon: const FaIcon(FontAwesomeIcons.qrcode),
                                  label: const Text('مسح رمز المستخدم'))
                            ],
                          ),
                        );
                      });
                },
                icon: const FaIcon(FontAwesomeIcons.coins))
          ],
        ),
        body: StreamBuilder<List<Reward>>(
          stream: locator.get<Rewards>().watchRewards(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Reward>> snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
              ));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Rewards Found'));
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            List<Reward> payments = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: payments.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RoundIconButton(
                                onTap: null,
                                size: 32,
                                icon: payments[index].status == 'pendding'
                                    ? FontAwesomeIcons.solidHourglass
                                    : payments[index].status == 'completed'
                                        ? FontAwesomeIcons.checkDouble
                                        : FontAwesomeIcons.xmark,
                                color: payments[index].status == 'pendding'
                                    ? Colors.amber
                                    : payments[index].status == 'completed'
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  Methods.formatPrice(payments[index].amount) +
                                      ' points'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(Methods.formatDate(
                                  payments[index].timestamp, 'en')),
                              Text(Methods.formatTime(
                                  payments[index].timestamp, 'en')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    payments[index].error == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              payments[index].error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                  ],
                );
              },
            );
          },
        ));
  }
}
