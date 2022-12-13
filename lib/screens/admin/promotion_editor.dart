import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mars/models/category.dart';
import 'package:mars/models/item.dart';
import 'package:mars/models/promo.dart';
import 'package:mars/services/firestore/categories.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/firestore/promos.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';

class PromotionEditor extends StatefulWidget {
  final Promo? promo;
  const PromotionEditor({Key? key, this.promo}) : super(key: key);

  @override
  State<PromotionEditor> createState() => _PromotionEditorState();
}

class _PromotionEditorState extends State<PromotionEditor> {
  late bool update;
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController subBodyController = TextEditingController();
  String image = '';
  String selectedCategory = '';
  bool active = false;
  @override
  void initState() {
    widget.promo == null ? update = false : update = true;

    if (update) {
      nameController.text = widget.promo!.name;
      titleController.text = widget.promo!.title;
      subTitleController.text = widget.promo!.subtitle;
      bodyController.text = widget.promo!.body;
      subBodyController.text = widget.promo!.subbody;
      active = widget.promo!.active;
    }

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    titleController.dispose();
    subTitleController.dispose();
    bodyController.dispose();
    subBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(update ? 'Edit Promotion' : 'Add Promotion'),
        actions: [
          update
              ? IconButton(
                  onPressed: () async {
                    Methods.showLoaderDialog(context);

                    await locator.get<Promos>().deletePromo(widget.promo!.fid);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: const FaIcon(FontAwesomeIcons.trash))
              : Container(),
          IconButton(
              onPressed: () async {
                Methods.showLoaderDialog(context);

                if (update) {
                  await locator.get<Promos>().updatePromo(
                        id: widget.promo!.fid,
                        name: nameController.text,
                        title: titleController.text,
                        subTitle: subTitleController.text,
                        body: bodyController.text,
                        subBody: subBodyController.text,
                        image: File(image),
                        updateImage: image.isNotEmpty,
                        active: active,
                      );
                } else {
                  await locator.get<Promos>().addPromo(
                        name: nameController.text,
                        title: titleController.text,
                        subTitle: subTitleController.text,
                        body: bodyController.text,
                        subBody: subBodyController.text,
                        image: File(image),
                        active: active,
                      );
                }
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk)),
        ],
      ),
      body: SingleChildScrollView(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(children: [
          Stack(
            children: [
              InkWell(
                onTap: () async {
                  PickedFile? file = await ImagePicker.platform
                      .pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    setState(() {
                      image = file.path;
                    });
                  }
                },
                child: update
                    ? image.isNotEmpty
                        ? Image.file(
                            File(image),
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            imageUrl: widget.promo!.imgUrl,
                          )
                    : image.isNotEmpty
                        ? Image.file(
                            File(image),
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey,
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.image,
                                size: 100,
                              ),
                            ),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 28,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          active = !active;
                        });
                      },
                      icon: active
                          ? const FaIcon(FontAwesomeIcons.solidEye)
                          : const FaIcon(FontAwesomeIcons.solidEyeSlash)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'الأسم'),
            ),
          ),
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'العنوان'),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: subTitleController,
                decoration: const InputDecoration(labelText: 'العنوان الثانوي'),
              ),
            ),
          ),
          SizedBox(
            // height: 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: bodyController,
                decoration: const InputDecoration(labelText: 'التفاصيل'),
              ),
            ),
          ),
          SizedBox(
            // height: 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: subBodyController,
                decoration:
                    const InputDecoration(labelText: 'التفاصيل الثانوية'),
              ),
            ),
          ),
        ]),
      )),
    );
  }
}
