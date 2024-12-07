import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? position;
  GoogleMapController? _mapController;
  Marker? _currentMarker;
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    listenCurrentLocation();
  }

  Future<void> listenCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            timeLimit: Duration(seconds: 10),
            accuracy: LocationAccuracy.bestForNavigation,
          ),
        ).listen((pos) {
          updateLocation(pos);
        });
      } else {
        Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        getCurrentLocation();
      } else {
        Geolocator.openAppSettings();
      }
    }
  }

  Future<void> getCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnabled = await checkGPSServiceEnable();
      if (isServiceEnabled) {
        Position p = await Geolocator.getCurrentPosition();
        updateLocation(p);
      } else {
        Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        getCurrentLocation();
      } else {
        Geolocator.openAppSettings();
      }
    }
  }

  void updateLocation(Position pos) {
    LatLng newPosition = LatLng(pos.latitude, pos.longitude);

    setState(() {
      position = pos;

      _polylineCoordinates.add(newPosition);
      _polylines = {
        Polyline(
          polylineId: const PolylineId("tracking_polyline"),
          points: _polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      };

      _currentMarker = Marker(
        markerId: const MarkerId("current_location"),
        position: newPosition,
        infoWindow: InfoWindow(
          title: "My current location",
          snippet: "Lat: ${pos.latitude}, Lng: ${pos.longitude}",
        ),
      );

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(newPosition),
      );
    });
  }

  Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> checkGPSServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Google Maps and Geo Locator'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          zoom: 16,
          target: LatLng(0, 0),
        ),
        markers: _currentMarker != null ? {_currentMarker!} : {},
        polylines: _polylines,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
      ),
    );
  }
}
