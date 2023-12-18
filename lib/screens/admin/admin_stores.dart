import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mars/models/store.dart';
import 'package:mars/services/firestore/stores.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:path/path.dart' as p;

class AdminStores extends StatefulWidget {
  const AdminStores({Key? key}) : super(key: key);

  @override
  State<AdminStores> createState() => _AdminStoresState();
}

class _AdminStoresState extends State<AdminStores> {
  GoogleMapController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
        actions: [
          IconButton(
              onPressed: () {
                addStore(null);
              },
              icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: StreamBuilder(
        stream: locator.get<Stores>().watchStores(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          List<Store> stores = snapshot.data;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(stores[index].name),
                  subtitle: Text(stores[index].address),
                  onLongPress: () {
                    Methods.showConfirmDialog(
                        context, 'سوف تقوم بحذف هذا المتجر بشكل نهائي!',
                        () async {
                      Navigator.pop(context);
                      locator.get<Stores>().deleteStore(stores[index].fid);
                    }, confirmActionText: 'حذف');
                  },
                  onTap: (() {
                    addStore(stores[index]);
                  }),
                );
              },
            ),
          );
        },
      ),
    );
  }

  addStore(Store? store) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    String? image;
    CameraPosition? position;
    bool showMap = false;
    bool showError = false;

    if (store != null) {
      nameController.text = store.name;
      addressController.text = store.address;
      phoneController.text = store.phone;

      position = CameraPosition(
          target: LatLng(store.location.latitude, store.location.longitude),
          zoom: 18);
    }

    CameraPosition _initialPosition;

    if (position == null) {
      _initialPosition = const CameraPosition(
        target: LatLng(35.4666, 44.3799),
        zoom: 18,
      );
    } else {
      _initialPosition = position;
    }

    showDialog(
        context: context,
        builder: ((dialogContext) {
          return StatefulBuilder(builder: (dialogContext, dialogState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              contentPadding: const EdgeInsets.all(8),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: showMap
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 500,
                          child: Stack(
                            children: [
                              GoogleMap(
                                  onMapCreated: (_controller) {
                                    controller = _controller;
                                  },
                                  onCameraMove: (_position) {
                                    dialogState(
                                      () {
                                        position = _position;
                                      },
                                    );
                                  },
                                  zoomControlsEnabled: false,
                                  initialCameraPosition: _initialPosition),
                              Align(
                                child: FaIcon(
                                  FontAwesomeIcons.crosshairs,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    child: IconButton(
                                        onPressed: () {
                                          dialogState(
                                            () {
                                              showMap = false;
                                            },
                                          );
                                        },
                                        icon: const FaIcon(
                                            FontAwesomeIcons.arrowLeft)),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    child: IconButton(
                                        onPressed: () async {
                                          if (controller == null) {
                                            return;
                                          }
                                          try {
                                            LatLng latLng = await Methods
                                                .determinePosition();
                                            controller!.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                    CameraPosition(
                                                        zoom: 18,
                                                        target: latLng)));
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        icon: const FaIcon(
                                            FontAwesomeIcons.crosshairs)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: 'الاسم',
                                ),
                              ),
                              TextField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  hintText: 'العنوان',
                                ),
                              ),
                              TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: 'رقم الهاتف',
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  PickedFile? file = await ImagePicker.platform
                                      .pickImage(source: ImageSource.gallery);
                                  if (file != null) {
                                    dialogState(() {
                                      image = file.path;
                                    });
                                  }
                                },
                                child: store != null && image == null
                                    ? CachedNetworkImage(
                                        height: 150,
                                        imageUrl: store.imgUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey.shade200,
                                        height: 150,
                                        width: double.infinity,
                                        child: image == null
                                            ? const Center(
                                                child: FaIcon(
                                                    FontAwesomeIcons.image),
                                              )
                                            : Image.file(File(image!)),
                                      ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    dialogState(
                                      () {
                                        showMap = true;
                                      },
                                    );
                                  },
                                  child: position == null
                                      ? const Text('Select Location')
                                      : const Text('Change Location')),
                              showError
                                  ? const Text('Complete required Data')
                                  : Container(),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if ((image == null && store == null) ||
                                          nameController.text == '' ||
                                          addressController.text == '' ||
                                          phoneController.text == '' ||
                                          position == null) {
                                        dialogState(
                                          () {
                                            showError = true;
                                          },
                                        );
                                        return;
                                      }
                                      Navigator.pop(context);

                                      Methods.showLoaderDialog(context);

                                      FirebaseStorage storage =
                                          FirebaseStorage.instance;

                                      if (store == null) {
                                        String fileName =
                                            Methods.getRandomString(10);
                                        String ext = p.extension(image!);

                                        await storage
                                            .ref('stores/$fileName$ext')
                                            .putFile(File(image!))
                                            .then((p0) async {
                                          String url = await storage
                                              .ref('stores/$fileName$ext')
                                              .getDownloadURL();
                                          await locator.get<Stores>().addStore(
                                              name: nameController.text,
                                              address: addressController.text,
                                              phone: phoneController.text,
                                              imgUrl: url,
                                              location: GeoPoint(
                                                  position!.target.latitude,
                                                  position!.target.longitude));
                                        });
                                      } else {
                                        if (image == null) {
                                          await locator
                                              .get<Stores>()
                                              .updateStore(
                                                  fid: store.fid,
                                                  name: nameController.text,
                                                  address:
                                                      addressController.text,
                                                  phone: phoneController.text,
                                                  imgUrl: store.imgUrl,
                                                  location: GeoPoint(
                                                      position!.target.latitude,
                                                      position!
                                                          .target.longitude));
                                        } else {
                                          String fileName =
                                              Methods.getRandomString(10);
                                          String ext = p.extension(image!);

                                          await storage
                                              .ref('stores/$fileName$ext')
                                              .putFile(File(image!))
                                              .then((p0) async {
                                            String url = await storage
                                                .ref('stores/$fileName$ext')
                                                .getDownloadURL();
                                            await locator
                                                .get<Stores>()
                                                .updateStore(
                                                    fid: store.fid,
                                                    name: nameController.text,
                                                    address:
                                                        addressController.text,
                                                    phone: phoneController.text,
                                                    imgUrl: url,
                                                    location: GeoPoint(
                                                        position!
                                                            .target.latitude,
                                                        position!
                                                            .target.longitude));
                                          });
                                        }
                                      }

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Save')),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            );
          });
        }));
  }
}
