import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 16,
                target: LatLng(23.825727354726975, 90.39409529417753),
              ),
            ),
          );
        },
        child: Icon(Icons.location_history),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          zoom: 16,
          target: LatLng(23.825727354726975, 90.39409529417753),
        ),
        onTap: (LatLng? latLng) {
          print(latLng);
        },
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        trafficEnabled: true,
        markers: <Marker>{
          const Marker(
            markerId: MarkerId('initial-position'),
            position: LatLng(23.825727354726975, 90.39409529417753),
          ),
          Marker(
            markerId: MarkerId('home'),
            position: LatLng(23.829996901806666, 90.3908333927393),
            infoWindow: InfoWindow(
              onTap: () {
                print('on tap home');
              },
              title: 'Home',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            draggable: true,
            onDragStart: (LatLng onStartLatLng) {
              print('on Start:$onStartLatLng');
            },
            onDragEnd: (LatLng onStopLatLng) {
              print('on End:$onStopLatLng');
            },
          ),
        },
        circles: <Circle>{
          Circle(
            circleId: CircleId('initial-circle'),
            center: LatLng(23.828547154682408, 90.3930814191699),
            fillColor: Colors.red.withOpacity(0.5),
            radius: 400,
            strokeColor: Colors.blue,
            strokeWidth: 1,
            visible: true,
            onTap: () {
              print('Entered into Dengue Zone');
            },
          ),
          Circle(
            circleId: CircleId('blue-circle'),
            center: LatLng(23.824762462400827, 90.39804350584745),
            fillColor: Colors.blue.withOpacity(0.5),
            radius: 600,
            strokeColor: Colors.blue,
            strokeWidth: 1,
            visible: true,
            onTap: () {
              print('Entered into Dengue Zone');
            },
          ),
        },
        polylines: <Polyline>{
          const Polyline(
            color: Colors.green,
            width: 14,
            jointType: JointType.bevel,
            polylineId: PolylineId('random'),
            points: <LatLng>[
              LatLng(23.82748444632007, 90.39134837687016),
              LatLng(23.825981304852075, 90.39223954081535),
              LatLng(23.824949552700605, 90.39145465940237),
              LatLng(23.823738061551015, 90.39240315556526),
            ],
          ),
        },
        polygons: <Polygon>{
          Polygon(polygonId: PolygonId('uniq-c'), points: [
            LatLng(23.824186774655168, 90.3960569947958),
            LatLng(23.82199564140985, 90.39536230266094),
            LatLng(23.822728681426327, 90.39532944560051)
          ])
        },
      ),
    );
  }
}
