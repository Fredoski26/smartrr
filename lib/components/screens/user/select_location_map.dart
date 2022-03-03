import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:smartrr/services/api_client.dart';

class SelectLocationMap extends StatefulWidget {
  @override
  _SelectLocationMapState createState() => _SelectLocationMapState();
}

class _SelectLocationMapState extends State<SelectLocationMap> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = LatLng(45.52, -122.67);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = LatLng(45.52, -122.67);
  MapType _currentMapType = MapType.normal;
  var location = new Location();
  LocationData currentLocation;

//  final kGoogleApiKey = "AIzaSyCdyE02XLdx7ExfUmx0HEhCkLqhBalMEr4";
  final kGoogleApiKey = "AIzaSyDwOvvKZ2QQnQNkTtJOa9swaPk9Ir8B6jI";

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  Future<LocationData> _getLocation() async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();

      print("locationLatitude: ${currentLocation.latitude}");
      print("locationLongitude: ${currentLocation.longitude}");
      // setState(
      //     () {
      //       _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      //     }); //rebuild the widget after getting the current location of the user
      return currentLocation;
    } on Exception {
      currentLocation = null;
      return currentLocation;
    }
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _getLocation().then((returnedLocation) {
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target:
                  LatLng(returnedLocation.latitude, returnedLocation.longitude),
              zoom: 11.0),
        ),
      );
      _lastMapPosition =
          LatLng(returnedLocation.latitude, returnedLocation.longitude);
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onChooseLocation() {
    print('Current map position: $_lastMapPosition');
    ApiClient()
        .getAddressFromCoordinates(_lastMapPosition.latitude,
            _lastMapPosition.longitude, kGoogleApiKey)
        .then((String addressReturned) {
      Navigator.pop(context, addressReturned);
    });
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Color(0xFFF59405),
      child: Icon(
        icon,
        size: 36,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(bottom: 70),
              child: Icon(
                Icons.location_on,
                size: 50,
                color: Color(0xFFF59405),
              ),
            ),
          )
        ],
      ),
      appBar: AppBar(
        title: Text(
          'Select Location',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      floatingActionButton: button(_onChooseLocation, Icons.check),
    );
  }
}
