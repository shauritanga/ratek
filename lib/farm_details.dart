import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ratek/models/farm.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;

class FarmDetails extends StatefulWidget {
  final Farm farm;
  const FarmDetails({
    required this.farm,
    super.key,
  });

  @override
  State<FarmDetails> createState() => _FarmDetailsState();
}

class _FarmDetailsState extends State<FarmDetails> {
  double calculatePolygonArea(coordinates) {
    if (coordinates.length < 3) {
      return 0.0;
    }

    final List<mt.LatLng> latLngs = coordinates
        .map<List<LatLng>>(
            (coord) => mt.LatLng(coord['latitude'], coord['longitude']))
        .toList();
    return mt.SphericalUtil.computeArea(latLngs) as double;
  }

  final _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final farm = widget.farm;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(farm.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Farm details"),
            SizedBox(
              height: size.height * 0.4,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                      farm.coordinates.isNotEmpty
                          ? widget.farm.coordinates[0]['latitude']
                          : 0,
                      farm.coordinates.isNotEmpty
                          ? widget.farm.coordinates[0]['longitude']
                          : 0),
                  initialZoom: 20,
                  cameraConstraint: CameraConstraint.contain(
                    bounds: LatLngBounds(
                      const LatLng(-90, -180),
                      const LatLng(90, 180),
                    ),
                  ),
                ),
                mapController: _mapController,
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
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
                          isFilled: true),
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
            //   trailing: Text("${calculatePolygonArea(farm.coordinates)}"),
            // )
          ],
        ),
      ),
    );
  }
}
