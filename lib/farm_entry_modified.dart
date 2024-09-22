import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  final _formKey = GlobalKey<FormBuilderState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> _coordinates = [];
  String? farmArea;

  Future<void> _startTracking() async {
    // ... your existing location permission and tracking logic ...
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return;
        }
      }

      Position position = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
            Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.best)),
      );
      // Position position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.best);
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Ulipo"),
          content: Text("${position.latitude}, ${position.longitude}"),
          actions: [
            TextButton(
                onPressed: () {
                  _coordinates.add({
                    "latitude": position.latitude,
                    "longitude": position.longitude,
                  });
                  Navigator.pop(context);
                },
                child: Text("Tunza"))
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void calculatePolygonArea() {
    if (_coordinates.length < 3) {
      return;
    }

    final List<mt.LatLng> latLngs = _coordinates
        .map((coord) => mt.LatLng(coord['latitude'], coord['longitude']))
        .toList();
    final area = mt.SphericalUtil.computeArea(latLngs) as double;

    setState(() {
      farmArea = area.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shamba jipya'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'name',
                  decoration:
                      const InputDecoration(labelText: 'Jina la shamba'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'region',
                  decoration: const InputDecoration(labelText: 'Mkoa'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'district',
                  decoration: const InputDecoration(labelText: 'Wilaya'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'ward',
                  decoration: const InputDecoration(labelText: 'Kata'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'village',
                  decoration:
                      const InputDecoration(labelText: 'Mtaa au Kijiji'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 20),
                FormBuilderDropdown(
                  name: 'product',
                  decoration: const InputDecoration(
                    labelText: 'Chagua zao',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required()
                  ]), // Required field validator
                  items: const [
                    DropdownMenuItem(
                      value: 'parachichi',
                      child: Text('Parachichi'),
                    ),
                    DropdownMenuItem(
                      value: 'mahindi',
                      child: Text('Mahindi'),
                    ),
                    DropdownMenuItem(
                      value: 'kahawa',
                      child: Text('Kahawa'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FormBuilderDropdown(
                  name: 'farm_ownership',
                  decoration: const InputDecoration(
                    labelText: 'Chagua umiliki wa shamba',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required()
                  ]), // Required field validator
                  items: const [
                    DropdownMenuItem(
                      value: 'langu',
                      child: Text('Langu'),
                    ),
                    DropdownMenuItem(
                      value: 'familia',
                      child: Text('Familia'),
                    ),
                    DropdownMenuItem(
                      value: 'kukodi',
                      child: Text('Kukodi'),
                    ),
                    DropdownMenuItem(
                      value: 'kikundi',
                      child: Text('Kukodi'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Tengeneza ramani ya shamba"),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _startTracking,
                  child: const Text('Chukua pointi'),
                ),
                const SizedBox(height: 20),
                if (_coordinates.length >= 3)
                  ElevatedButton(
                    onPressed: () => calculatePolygonArea(),
                    child: const Text('Hesabu Eneo'),
                  ),
                if (farmArea != null)
                  Text(
                    'Eneo la shamba: $farmArea m²',
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.saveAndValidate()) {
            Map<String, dynamic> farmData = {
              ..._formKey.currentState!.value, // Get all form values at once
              "coordinates": _coordinates,
              "farmer": user?.uid,
              "area": double.parse(farmArea ?? "0"), // Add the calculated area
            };
            try {
              await showDialog(
                context: context,
                builder: (context) => FutureProgressDialog(
                  firestore.collection("farms").add(farmData),
                ),
              );
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Hongera Umefanikiwa kusajiri shamba lako",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.green,
                ),
              );
              await Future.delayed(const Duration(seconds: 3));

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            } catch (error) {
              print(error);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Hujafanikiwa kutengeneza shamba jaribu tena",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
