import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:ratek/farm_entry_modified.dart';
import 'package:ratek/providers/farm.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;

class MyFarmsScreen extends ConsumerStatefulWidget {
  const MyFarmsScreen({super.key});

  @override
  ConsumerState<MyFarmsScreen> createState() => _MyFarmsScreenState();
}

class _MyFarmsScreenState extends ConsumerState<MyFarmsScreen> {
  double calculatePolygonArea(coordinates) {
    if (coordinates.length < 3) {
      return 0.0;
    }

    final List<mt.LatLng> latLngs = coordinates
        .map((coord) => mt.LatLng(coord['latitude'], coord['longitude']))
        .toList();
    return mt.SphericalUtil.computeArea(latLngs) as double;
  }

  final _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final asyncValue = ref.watch(farmProvider);
    return asyncValue.when(
        loading: () => Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        error: (error, stackTrace) => Text("$error"),
        data: (data) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Mashamba"),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            backgroundColor: const Color.fromARGB(255, 221, 221, 221),
            body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final farm = data[index];
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            useSafeArea: true,
                            isScrollControlled: true,
                            showDragHandle: true,
                            context: context,
                            builder: (context) => DraggableScrollableSheet(
                              initialChildSize: 1.0,
                              minChildSize: 1.0,
                              maxChildSize: 1.0,
                              builder: (context, controller) => Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(),
                                child: ListView(
                                  children: [
                                    const Text("Ramani ya Shamba"),
                                    SizedBox(
                                      height: 400,
                                      width: double.infinity,
                                      child: FlutterMap(
                                        options: MapOptions(
                                          initialCenter: LatLng(
                                              farm.coordinates.isNotEmpty
                                                  ? farm.coordinates[0]
                                                      ['latitude']
                                                  : 0,
                                              farm.coordinates.isNotEmpty
                                                  ? farm.coordinates[0]
                                                      ['longitude']
                                                  : 0),
                                          initialZoom: 16.0,
                                          // cameraConstraint:
                                          //     CameraConstraint.contain(
                                          //   bounds: LatLngBounds(
                                          //     const LatLng(-90, -180),
                                          //     const LatLng(90, 180),
                                          //   ),
                                          // ),
                                        ),
                                        mapController: _mapController,
                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            userAgentPackageName:
                                                'com.example.app',
                                          ),
                                          PolygonLayer(
                                            polygons: [
                                              Polygon(
                                                points: farm.coordinates
                                                    .map(
                                                      (coordinate) => LatLng(
                                                        coordinate['latitude'],
                                                        coordinate['longitude'],
                                                      ),
                                                    )
                                                    .toList(),
                                                color: Colors.redAccent,
                                                isFilled: true,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text("Zao"),
                                      trailing: Text(farm.product),
                                    ),
                                    const Divider(thickness: 0.5),
                                    ListTile(
                                      title: const Text("Mkoa"),
                                      trailing: Text(farm.region),
                                    ),
                                    const Divider(thickness: 0.5),
                                    ListTile(
                                      title: const Text("Wilaya"),
                                      trailing: Text(farm.district),
                                    ),
                                    const Divider(thickness: 0.5),
                                    ListTile(
                                      title: const Text("Kata"),
                                      trailing: Text(farm.ward),
                                    ),
                                    const Divider(thickness: 0.5),
                                    ListTile(
                                      title: const Text("Kijiji/Mtaa"),
                                      trailing: Text(farm.village),
                                    ),
                                    const Divider(thickness: 0.5),
                                    // ListTile(
                                    //   title: const Text("Ukubwa wa shamba"),
                                    //   trailing: Text(
                                    //       "${calculatePolygonArea(farm.coordinates as List<LatLng>)}"),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: size.height * 0.22,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade50,
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.22,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      farm.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    Text("Kata: ${farm.ward}"),
                                    Text("Kijiji: ${farm.village}"),
                                    // Text(
                                    //     "Ukubwa wa shamba: skwea mita ${calculatePolygonArea(farm.coordinates)}"),
                                  ],
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.chevronRight,
                                size: 22,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            ],
                          ),
                        ),
                      );
                    })),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return const Tracking();
                      },
                      fullscreenDialog: true),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
        });
  }
}
