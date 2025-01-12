import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(11.572543, 104.893275), zoom: 20);
  GoogleMapController? mapController;
  String address = 'Loading ...';
  bool isLoading = true;
  Timer? _timer;
  int _start = 2;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, ask the user to enable them
      await Geolocator.openLocationSettings();
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied, handle appropriately
        setState(() {
          address = 'Location permission denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      setState(() {
        address = 'Location permission permanently denied';
      });
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 20,
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );

    getLocationAddress(LatLng(position.latitude, position.longitude));
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController mapsearch = TextEditingController();
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue[600],
      //   title: const Text('Select Location'),
      // ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) => mapController = controller,
            onCameraMove: (position) {
              setState(() {
                isLoading = true;
                address = 'Loading ...';
              });
              delayTwoSecondToGetAddress(position.target);
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 32,
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.red,
              size: 64,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ColoredBox(
              color: Colors.white,
              child: SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 48,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pop(context, address);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            "Select This Location",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  void getLocationAddress(LatLng location) async {
    try {
      // Fetch address details from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark mark = placemarks.first;

        // Format the detailed address
        String detailedAddress = [
          mark.name, // Name or house number
          mark.street, // Street name
          mark.subLocality, // Sub-locality
          mark.locality, // Locality or city
          mark.administrativeArea, // State or province
          mark.country // Country
        ].where((element) => element != null && element.isNotEmpty).join(", ");

        // Update state with the formatted address
        setState(() {
          address = detailedAddress;
          isLoading = false;
        });
      } else {
        setState(() {
          address = "Unable to determine address.";
        });
      }
    } catch (e) {
      setState(() {
        address = "Error fetching address: $e";
      });
    }
  }

  void delayTwoSecondToGetAddress(LatLng location) {
    _timer?.cancel();
    _start = 1;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          getLocationAddress(location);
        } else {
          _start--;
        }
      },
    );
  }
}
