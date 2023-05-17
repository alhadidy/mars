import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mars/models/sSettings.dart';
import 'package:mars/services/firestore/settings.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class AdminSettings extends ConsumerStatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends ConsumerState<AdminSettings> {
  TextEditingController deliveryPriceController = TextEditingController();
  TextEditingController rewardController = TextEditingController();

  @override
  void dispose() {
    deliveryPriceController.dispose();
    rewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SSetting settings = ref.watch(shopSettingsProvider);
    deliveryPriceController.text = settings.deliveryPrice.toString();
    rewardController.text = settings.rewardAmount.toString();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          SwitchListTile(
              title: const Text('Activate Maintenance Mode'),
              value: settings.dev,
              onChanged: (value) async {
                if (settings.dev == true) {
                  await locator
                      .get<SSettings>()
                      .updateSettings({'dev': !settings.dev});
                  Navigator.popUntil(context, (route) => route.isFirst);
                  return;
                }
                Methods.showConfirmDialog(context,
                    'عند تفعيل هذا الإختيار لن يستطيع المستخدمون من الوصول الى خدمات التطبيق لحين إلغاء الخيار من قبل أحد المسؤولين',
                    confirmActionText: 'تفعيل وضع الصيانة', () async {
                  Methods.showLoaderDialog(context);
                  await locator
                      .get<SSettings>()
                      .updateSettings({'dev': !settings.dev});
                  Navigator.popUntil(context, (route) => route.isFirst);
                });
              }),
          const Divider(),
          ListTile(
            title: const Text('Delivery Cost'),
            trailing: SizedBox(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: deliveryPriceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) async {
                    int? intValue = int.tryParse(value);
                    if (intValue != null) {
                      return await locator
                          .get<SSettings>()
                          .updateSettings({'deliveryPrice': intValue});
                    }

                    return await locator
                        .get<SSettings>()
                        .updateSettings({'deliveryPrice': 0});
                  },
                )),
          ),
          const Divider(),
          ListTile(
            title: const Text('Reward amount'),
            trailing: SizedBox(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: rewardController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) async {
                    int? intValue = int.tryParse(value);
                    if (intValue != null) {
                      return await locator
                          .get<SSettings>()
                          .updateSettings({'rewardAmount': intValue});
                    }

                    return await locator
                        .get<SSettings>()
                        .updateSettings({'rewardAmount': 0});
                  },
                )),
          ),
        ],
      ),
    );
  }
}
