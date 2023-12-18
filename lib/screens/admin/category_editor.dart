import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mars/models/category.dart';
import 'package:mars/services/firestore/categories.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';

class CategoryEditor extends StatefulWidget {
  final Category? category;
  const CategoryEditor({Key? key, this.category}) : super(key: key);

  @override
  State<CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  late bool update;
  TextEditingController nameController = TextEditingController();
  String image = '';
  int order = 1;
  @override
  void initState() {
    widget.category == null ? update = false : update = true;

    if (update) {
      nameController.text = widget.category!.name;
      order = widget.category!.order;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(update ? 'Edit Category' : 'Add Category'),
        actions: [
          update
              ? IconButton(
                  onPressed: () async {
                    Methods.showLoaderDialog(context);

                    await locator
                        .get<Categories>()
                        .deleteCategory(id: widget.category!.fid);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: const FaIcon(FontAwesomeIcons.trash))
              : Container(),
          IconButton(
              onPressed: () async {
                Methods.showLoaderDialog(context);
                if (update) {
                  await locator.get<Categories>().updateCategory(
                      fid: widget.category!.fid,
                      name: nameController.text,
                      image: image == '' ? null : File(image),
                      updateImage: image.isNotEmpty,
                      order: order);
                } else {
                  await locator.get<Categories>().addCategory(
                      name: nameController.text,
                      image: image == '' ? null : File(image),
                      order: order);
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
                        imageUrl: widget.category!.imgUrl,
                        errorWidget: (context, url, error) {
                          return Container(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey,
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.image,
                                size: 100,
                              ),
                            ),
                          );
                        },
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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'الأسم'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Order'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            order++;
                          });
                        },
                        icon: const FaIcon(FontAwesomeIcons.plus))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    order.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                CircleAvatar(
                  child: IconButton(
                      onPressed: () {
                        if (order <= 1) {
                          return;
                        }
                        setState(() {
                          order--;
                        });
                      },
                      icon: const FaIcon(FontAwesomeIcons.minus)),
                ),
              ],
            ),
          )
        ]),
      )),
    );
  }
}
