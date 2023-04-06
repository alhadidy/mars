import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mars/models/store.dart';
import 'package:mars/services/firestore/stores.dart';
import 'package:mars/services/locator.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({Key? key}) : super(key: key);

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  bool firstLoad = true;
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CarouselController carouselController = CarouselController();
  late Future<List<Store>> getStores;
  List<Store>? stores;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.4383527, 44.3762012),
    zoom: 18,
  );

  void _addMarker(String id, String name, GeoPoint location) {
    final MarkerId markerId = MarkerId(id);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        location.latitude,
        location.longitude,
      ),
      onTap: () {
        if (stores == null) {
          return;
        }
        int index = stores!.indexWhere((element) => element.fid == id);
        carouselController.animateToPage(index);
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    getStores = locator.get<Stores>().getStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                firstLoad) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
            firstLoad = false;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    initialCameraPosition: _initialPosition,
                    markers: Set<Marker>.of(markers.values),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                        future: getStores,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          stores = snapshot.data;
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            _addMarker(stores![0].fid, stores![0].name,
                                stores![0].location);
                          });

                          return CarouselSlider.builder(
                            carouselController: carouselController,
                            itemCount: stores!.length,
                            options: CarouselOptions(
                                viewportFraction: 0.9,
                                enableInfiniteScroll: false,
                                reverse: true,
                                onPageChanged: (index, rason) async {
                                  final GoogleMapController controller =
                                      await _controller.future;
                                  controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              zoom: 18,
                                              target: LatLng(
                                                  stores![index]
                                                      .location
                                                      .latitude,
                                                  stores![index]
                                                      .location
                                                      .longitude))));
                                  _addMarker(
                                      stores![index].fid,
                                      stores![index].name,
                                      stores![index].location);
                                }),
                            itemBuilder: (context, index, indexs) {
                              return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(23)),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: stores![index].imgUrl,
                                              height: 200,
                                              errorWidget:
                                                  (context, url, error) {
                                                return Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.brown,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          23))),
                                                );
                                              },
                                            ),
                                          ),
                                        )),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  stores![index].name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      stores![index].address,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
