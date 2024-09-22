import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<LatLng> _coordinates = [];
  final List<LatLng> coordinates = [];
  bool _isTracking = false;
  String? selectedProduct;
  String? selectedOwner;
  String? name;
  String? region;
  String? district;
  String? ward;
  String? village;
  bool serviceEnabled = false;
  bool isFormValid = false;
  String? farmArea; // To store the calculated area

  Future<void> _startTracking() async {
    bool serviceEnabled;
    LocationPermission permission;
    setState(() {
      _isTracking = true;
      _coordinates.clear();
      coordinates.clear(); // Clear coordinates on start
    });

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, prompt the user to enable them
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

      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            distanceFilter: 1, accuracy: LocationAccuracy.best),
      ).listen((Position position) {
        if (_isTracking) {
          setState(() {
            _coordinates.add(LatLng(position.latitude, position.longitude));
            coordinates.add(LatLng(position.latitude, position.longitude));
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
    });
  }

  // Function to calculate the area of the polygon

  void calculatePolygonArea(List<LatLng> coordinates) {
    if (coordinates.length < 3) {
      return; // A polygon needs at least 3 points
    }

    final List<mt.LatLng> latLngs = coordinates
        .map((coord) => mt.LatLng(coord.latitude, coord.longitude))
        .toList();
    final area = mt.SphericalUtil.computeArea(latLngs) as double;

    setState(() {
      farmArea = area.toStringAsFixed(2);
    });
  }

  // Haversine formula for calculating area

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shamba jipya'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          TextButton(
            onPressed: () async {
              try {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  Map<String, dynamic> farmData = {
                    "name": name,
                    "region": region,
                    "district": district,
                    "ward": ward,
                    "village": village,
                    "coordinates": coordinates,
                    "product": selectedProduct,
                    "farm_ownership": selectedOwner,
                    "farmer": user?.uid,
                    "area": farmArea // Add the calculated area
                  };
                  await showDialog(
                    context: context,
                    builder: (context) => FutureProgressDialog(
                      firestore.collection("farms").add(farmData),
                    ),
                  );
                  Navigator.pop(context);
                }
              } catch (error) {
                print("$error");
              }
            },
            child: Text(
              'HIFADHI',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text("Jina la Shamba"),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Jaza jina la shamba",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (newValue) => name = newValue,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Andika jina la shamba";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Shamba lilipo"),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Mkoa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (newValue) => region = newValue,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza Mkoa shamba linapatikana";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Wilaya",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (newValue) => district = newValue,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza wilaya shamba lako lilipo";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Kata",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (newValue) => ward = newValue,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza kata shamba lilipo";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Kijiji",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSaved: (newValue) => village = newValue,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jaza kijiji lilipo";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                const Text("Aina ya zao"),
                const SizedBox(height: 8),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Chagua zao'),
                        value: selectedProduct,
                        onChanged: (String? value) {
                          setState(() {
                            selectedProduct = value;
                          });
                        },
                        items: [
                          "Parachichi",
                          "Kahawa",
                          "Mahindi",
                        ].map((product) {
                          return DropdownMenuItem<String>(
                            value: product,
                            child: Text(product),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Umiliki wa shamba"),
                const SizedBox(height: 8),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Chagua umiliki'),
                        value: selectedOwner,
                        onChanged: (String? value) {
                          if (selectedOwner != null) {
                            setState(() {
                              isFormValid = true;
                              selectedOwner = value;
                            });
                          }
                        },
                        items: [
                          "kukodi",
                          "familia",
                          "langu",
                          "kikundi",
                        ].map((own) {
                          return DropdownMenuItem<String>(
                            value: own,
                            child: Text(own),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Tengeneza ramani ya shamba"),
                const SizedBox(height: 8),
                if (!_isTracking)
                  ElevatedButton(
                    onPressed: _startTracking,
                    child: const Text('Anza kutembea'),
                  ),
                if (_isTracking)
                  ElevatedButton(
                    onPressed: _stopTracking,
                    child: const Text('Acha'),
                  ),
                const SizedBox(height: 20),
                if (_coordinates.length >= 3)
                  ElevatedButton(
                    onPressed: () => calculatePolygonArea(_coordinates),
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
    );
  }
}
