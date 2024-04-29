import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/directions.dart' as google_directions;
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'; // Import FlutterPolylinePoints

class LocationResult {
  static const String apiKey = 'AIzaSyBHUHiMgQO6m2gWxl2UsGssY7TivMAbYOY'; // Define your API key here

  Future<LatLng> searchLocation(String query) async {
    final places = GoogleMapsPlaces(apiKey: apiKey);
    PlacesSearchResponse response = await places.searchByText(query);
    if (response.isOkay && response.results.isNotEmpty) {
      final place = response.results.first;
      return LatLng(place.geometry!.location.lat, place.geometry!.location.lng);
    } else {
      throw Exception('Failed to retrieve location information');
    }
  }

  Future<void> showRoute({
    required LatLng currentLocation,
    required LatLng destination,
    required GoogleMapController mapController,
    required Set<Polyline> polylines, // Set to hold the polylines
  }) async {
    final directions = google_directions.GoogleMapsDirections(apiKey: apiKey);

    final directionsResponse = await directions.directions(
      google_directions.Location(lat: currentLocation.latitude, lng: currentLocation.longitude),
      google_directions.Location(lat: destination.latitude, lng: destination.longitude),
      travelMode: google_directions.TravelMode.walking, // Use TravelMode.walking
    );

    if (directionsResponse.isOkay) {
      final routes = directionsResponse.routes;
      if (routes.isNotEmpty) {
        final route = routes[0];
        final polylinePoints = PolylinePoints();
        List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(route.overviewPolyline.points);
        List<LatLng> polylineCoordinates = decodedPoints.map((point) => LatLng(point.latitude, point.longitude)).toList();

mapController.animateCamera(CameraUpdate.newLatLngBounds(
  LatLngBounds(
    southwest: LatLng(
      min(currentLocation.latitude, destination.latitude), // Adjusted for southwest latitude
      min(currentLocation.longitude, destination.longitude),
    ),
    northeast: LatLng(
      max(currentLocation.latitude, destination.latitude), // Adjusted for northeast latitude
      max(currentLocation.longitude, destination.longitude),
    ),
  ),
  50, // padding
));


        // Clear existing polylines from the set
        polylines.clear();

        // Add new polyline to the set
        polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          width: 5,
          color: Colors.blue,
        ));
      }
    }
  }
}
