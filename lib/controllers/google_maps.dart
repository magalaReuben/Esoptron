import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final googleMapControllerProvider = StateProvider<GoogleMapController?>((ref) {
  return null;
});

final mapControllerProvider =
    StateNotifierProvider<MapControllerNotifier, MapState>((ref) {
  return MapControllerNotifier(ref);
});

class MapControllerNotifier extends StateNotifier<MapState> {
  StateNotifierProviderRef<MapControllerNotifier, MapState> ref;
  MapControllerNotifier(this.ref) : super(MapState());
}

class MapState {
  Set<Marker>? markers;
  Set<Circle>? circle;
  List<LatLng>? polylineCoordinates;
  Set<Polyline>? polylines;
  CameraPosition initialLocation;
  Completer<GoogleMapController>? controller = Completer();

  double locationButtonPosition = 116.0;
  BitmapDescriptor? currentUserIcon;
  BitmapDescriptor? destinationIcon;
  Position? currentPosition;
  String? currentLocationName;
  int kilometers;
  String? currentCountryCode;
  //List<MockUserOnMap>? usersInArea;

  MapState({
    this.initialLocation = const CameraPosition(
      target: LatLng(37.43296265331129, -122.08832357078792),
      zoom: 14.4746,
    ),
    this.locationButtonPosition = 116.0,
    this.controller,
    this.kilometers = 1,
    this.currentPosition,
    this.currentLocationName,
    this.currentCountryCode,
    //this.usersInArea,
    this.currentUserIcon,
    this.destinationIcon,
    this.markers,
    this.circle,
    this.polylineCoordinates,
    this.polylines,
    //this.place
  });

  MapState copyWith({
    double? locationButtonPosition,
    Position? currentPosition,
    String? currentCountryCode,
    int? kilometers,
    CameraPosition? initialLocation,
    String? currentLocationName,
    Set<Marker>? markers,
    Set<Circle>? circle,
    BitmapDescriptor? currentUserIcon,
    BitmapDescriptor? destinationIcon,
    List<LatLng>? polylineCoordinatesProvider,
    Set<Polyline>? polylines,
    //List<MockUserOnMap>? usersInArea,
    Completer<GoogleMapController>? controller,
    //PlaceDetail? place,
  }) =>
      MapState(
        //place: place ?? this.place,
        controller: controller ?? this.controller,
        kilometers: kilometers ?? this.kilometers,
        //usersInArea: usersInArea ?? this.usersInArea,
        markers: markers ?? this.markers,
        circle: circle ?? this.circle,
        destinationIcon: destinationIcon ?? this.destinationIcon,
        currentUserIcon: currentUserIcon ?? this.currentUserIcon,
        polylineCoordinates: polylineCoordinatesProvider ?? polylineCoordinates,
        polylines: polylines ?? this.polylines,
        currentLocationName: currentLocationName ?? this.currentLocationName,
        initialLocation: initialLocation ?? this.initialLocation,
        locationButtonPosition:
            locationButtonPosition ?? this.locationButtonPosition,
        currentPosition: currentPosition ?? this.currentPosition,
        currentCountryCode: currentCountryCode ?? this.currentCountryCode,
      );
}
// class MapControllerNotifier extends StateNotifier<MapState> {
  // StateNotifierProviderRef<MapControllerNotifier, MapState> ref;
  // MapControllerNotifier(this.ref)
  //     : super(MapState(
//             markers: {},
//             circle: {},
//             polylineCoordinates: [],
//             polylines: {},
//             usersInArea: [
//               MockUserOnMap(
//                   id: 1,
//                   name: 'Joe',
//                   urlImage: '',
//                   coordinates: Coordinate(0, 0),
//                   calculatedDistance: 1),
//               MockUserOnMap(
//                   id: 2,
//                   name: 'ken',
//                   urlImage: '',
//                   coordinates: Coordinate(0, 0),
//                   calculatedDistance: 1),
//               MockUserOnMap(
//                   id: 3,
//                   name: 'kevin',
//                   urlImage: '',
//                   coordinates: Coordinate(0, 0),
//                   calculatedDistance: 2),
//               MockUserOnMap(
//                   id: 4,
//                   name: 'Tom',
//                   urlImage: '',
//                   coordinates: Coordinate(0, 0),
//                   calculatedDistance: 2),
//               MockUserOnMap(
//                   id: 5,
//                   name: 'Sandra',
//                   urlImage: '',
//                   coordinates: Coordinate(0, 0),
//                   calculatedDistance: 3),
//               MockUserOnMap(
//                   id: 6,
//                   name: 'Ritah',
//                   urlImage: '',
//                   coordinates: Coordinate(0, 0),
//                   calculatedDistance: 3),
//               MockUserOnMap(
//                   id: 7,
//                   name: 'Ambrose',
//                   urlImage: '',
//                   coordinates: Coordinate(0, 0),
//                   calculatedDistance: 4),
//               MockUserOnMap(
//                   id: 8,
//                   name: 'Jennifer',
//                   urlImage: '',
//                   coordinates: Coordinate(0, 0),
//                   calculatedDistance: 4)
//             ])) {
//     _init();
//   }

//   Future<void> _setSourceAndDestinationMarkerIcon() async {
//     final Uint8List markerIcon =
//         await Helpers.getBytesFromAsset(AppAssets.destinationPin, 70);
//     final Uint8List destinationIcon =
//         await Helpers.getBytesFromAsset(AppAssets.destinationPin, 70);
//     state = state.copyWith(
//         destinationIcon: BitmapDescriptor.fromBytes(destinationIcon),
//         currentUserIcon: BitmapDescriptor.fromBytes(markerIcon));
//   }

//   void getLocationButtonPosition(double value) {
//     state = state.copyWith(locationButtonPosition: value);
//   }

//   updateKilometers(int kilometers, BuildContext context) {
//     dev.log(kilometers.toString());
//     state = state.copyWith(kilometers: kilometers);
//     _redirectToCurrentUserPosition();
//   }

//   LatLngBounds _getCircleBounds(LatLng center, double radius) {
//     double distanceFromCenterToEdge = radius / (state.kilometers * 1000);
//     LatLng southwest = LatLng(center.latitude - distanceFromCenterToEdge,
//         center.longitude - distanceFromCenterToEdge);
//     LatLng northeast = LatLng(center.latitude + distanceFromCenterToEdge,
//         center.longitude + distanceFromCenterToEdge);
//     return LatLngBounds(southwest: southwest, northeast: northeast);
//   }

//   double calculateEquilibratingValue(double targetValue) {
//     return (300 * targetValue) / (1000);
//   }

//   double _getZoomLevel(LatLngBounds bounds) {
//     double screenWidth = 390.toWidth;
//     double screenHeight = 844.toHeight;
//     double zoomScale = calculateEquilibratingValue((state.kilometers * 1000));
//     print(zoomScale);

//     double latZoomLevel = (log(screenHeight *
//             zoomScale /
//             (bounds.northeast.latitude - bounds.southwest.latitude)) /
//         log(2));
//     double lngZoomLevel = (log(screenWidth *
//             zoomScale /
//             (bounds.northeast.longitude - bounds.southwest.longitude)) /
//         log(2));
//     return min(latZoomLevel, lngZoomLevel) - 1;
//   }

//   addMarkersOnPage(BuildContext context, int searchedDistance, double lat,
//       double lng) async {
//     state.usersInArea?.forEach((element) async {
//       // final userIcon = await BitmapDescriptor.fromBytes(
//       //     await Helpers.getBytesFromAsset(AppAssets.locationPin, 70));
//       final marker = searchedDistance >= element.calculatedDistance
//           ? element.id % 2 == 0
//               ? Marker(
//                   markerId: MarkerId(element.id.toString()),
//                   position: LatLng(
//                       element.coordinates.latitude +
//                           lat +
//                           element.calculatedDistance * 0.0045,
//                       element.coordinates.longitude +
//                           lng +
//                           element.calculatedDistance * 0.0045),
//                   draggable: false,
//                   // infoWindow: InfoWindow(title: element.name),
//                   zIndex: 2,
//                   onTap: () {
//                     showModalBottomSheet(
//                         backgroundColor: Colors.transparent,
//                         isScrollControlled: true,
//                         context: context,
//                         builder: (_) => SetMapProfileDialogWidget(
//                             name: element.name,
//                             imagePath:
//                                 'https://media.istockphoto.com/id/1428235898/photo/stylish-pretty-african-woman-with-afro-hairstyle-posing-near-geometric-wall.webp?b=1&s=170667a&w=0&k=20&c=VTAKEkNcgqskN6fKJraYNTZp6xhNcxusme-uyo6pjsc='));
//                   },
//                   anchor: const Offset(0.5, 0.5),
//                   icon: BitmapDescriptor.defaultMarkerWithHue(
//                       BitmapDescriptor.hueViolet),
//                 )
//               : Marker(
//                   markerId: MarkerId(element.id.toString()),
//                   position: LatLng(
//                       element.coordinates.latitude +
//                           lat -
//                           element.calculatedDistance * 0.0045,
//                       element.coordinates.longitude +
//                           lng -
//                           element.calculatedDistance * 0.0045),
//                   draggable: false,
//                   // infoWindow: InfoWindow(title: element.name),
//                   zIndex: 2,
//                   onTap: () {
//                     showModalBottomSheet(
//                         backgroundColor: Colors.transparent,
//                         isScrollControlled: true,
//                         context: context,
//                         builder: (_) => SetMapProfileDialogWidget(
//                             name: element.name,
//                             imagePath:
//                                 'https://media.istockphoto.com/id/1428235898/photo/stylish-pretty-african-woman-with-afro-hairstyle-posing-near-geometric-wall.webp?b=1&s=170667a&w=0&k=20&c=VTAKEkNcgqskN6fKJraYNTZp6xhNcxusme-uyo6pjsc='));
//                   },
//                   anchor: const Offset(0.5, 0.5),
//                   icon: BitmapDescriptor.defaultMarkerWithHue(
//                       BitmapDescriptor.hueViolet),
//                 )
//           : null;
//       state = state.copyWith(markers: state.markers!..add(marker!));
//     });
//   }

//   void addDestinationMarker(PlaceDetail place, BuildContext context) async {
//     print('we are adding marker');

//     final marker = Marker(
//       markerId: const MarkerId('Destination'),
//       position: LatLng(place.lat, place.long),
//       draggable: false,
//       // infoWindow: InfoWindow(title: place.label),
//       zIndex: 2,
//       onTap: () {
//         showModalBottomSheet(
//             backgroundColor: Colors.transparent,
//             isScrollControlled: true,
//             context: context,
//             builder: (_) => const SetMapProfileDialogWidget(
//                 name: 'Joe',
//                 imagePath:
//                     'https://media.istockphoto.com/id/1428235898/photo/stylish-pretty-african-woman-with-afro-hairstyle-posing-near-geometric-wall.webp?b=1&s=170667a&w=0&k=20&c=VTAKEkNcgqskN6fKJraYNTZp6xhNcxusme-uyo6pjsc='));
//       },
//       anchor: const Offset(0.5, 0.5),
//       icon: state.destinationIcon ?? BitmapDescriptor.defaultMarker,
//     );
//     state = state.copyWith(
//         markers: state.markers!
//           ..removeWhere((mar) => mar.markerId == marker.markerId));

//     state = state.copyWith(markers: state.markers!..add(marker));

//     // ref.read(googleMapControllerProvider.notifier).state!.animateCamera(
//     //     CameraUpdate.newCameraPosition(
//     //         CameraPosition(target: LatLng(place.lat, place.long), zoom: 14)));
//     // await Future.delayed(const Duration(seconds: 5));
//     _calculateDistanceBetweenPointsAndGetPolyLineCoordinates(
//         state.currentPosition!.latitude,
//         state.currentPosition!.longitude,
//         place.lat,
//         place.long);
//     _redirectToCurrentUserPosition();

//     var points = Helpers.getCoordinatesInCircle(place.lat, place.long,
//         (state.kilometers * 1000), (state.kilometers * 1000) * 2);
//     print(points);
//     state = state.copyWith(place: place);
//   }

//   void _redirectToCurrentUserPosition() {
//     state.circle!.clear();
//     final circle = Circle(
//         radius: (state.kilometers * 1000),
//         zIndex: 10,
//         fillColor: AppColors.primary.withOpacity(.1),
//         strokeColor: AppColors.secondary.withOpacity(.5),
//         strokeWidth: 1,
//         center: LatLng(
//             state.currentPosition!.latitude, state.currentPosition!.longitude),
//         circleId: const CircleId('Destination'));
//     state = state.copyWith(circle: state.circle!..add(circle));
//     LatLngBounds bounds = _getCircleBounds(circle.center, circle.radius);
//     LatLng southwest = bounds.southwest;
//     LatLng northeast = bounds.northeast;
//     LatLng center = LatLng(
//       (southwest.latitude + northeast.latitude) / 2,
//       (southwest.longitude + northeast.longitude) / 2,
//     );

//     double zoomLevel = _getZoomLevel(bounds);
//     CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(center, zoomLevel);
//     ref
//         .read(googleMapControllerProvider.notifier)
//         .state!
//         .animateCamera(cameraUpdate);
//   }

//   Future<Uint8List> _fetchNetworkImage(String imageUrl) async {
//     final response = await Dio().get(imageUrl);
//     return response.data.bodyBytes;
//   }

//   Future<BitmapDescriptor> _createCustomIcon(String imageUrl) async {
//     final imageBytes = await _fetchNetworkImage(imageUrl);
//     return BitmapDescriptor.fromBytes(imageBytes);
//   }

//   Future<void> initUserCountryCode() async {
//     if (state.currentPosition!.latitude > 0.0 &&
//         state.currentPosition!.longitude > 0.0) {
//       var addresses = await placemarkFromCoordinates(
//           state.currentPosition!.latitude, state.currentPosition!.longitude);
//       var code = addresses.first.isoCountryCode;
//       state = state.copyWith(currentCountryCode: code);
//     }
//   }

//   setNewDestinationPlace(PlaceDetail place) {
//     state = state.copyWith(place: place);
//   }

//   void updateMapController(GoogleMapController controller) {
//     // rootBundle.loadString('assets/map_style.txt').then((string) {
//     //   controller.setMapStyle(string);
//     // });
//     ref.read(googleMapControllerProvider.notifier).state = controller;
//   }

//   Future<void> _init() async {
//     getCurrentLocation();
//     _setSourceAndDestinationMarkerIcon();
//   }

//   // Method for retrieving the current location
//   Future<void> getCurrentLocation() async {
//     await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true)
//         .then((Position? position) async {
//       if (position == null) {
//         dev.log('getting new location');
//         await Geolocator.getCurrentPosition(
//                 forceAndroidLocationManager: true,
//                 desiredAccuracy: LocationAccuracy.bestForNavigation)
//             .then((Position position) async {
//           state = state.copyWith(currentPosition: position);

//           ref.read(googleMapControllerProvider.notifier).state!.animateCamera(
//                 CameraUpdate.newCameraPosition(
//                   CameraPosition(
//                     target: LatLng(position.latitude, position.longitude),
//                     zoom: 14.4746,
//                   ),
//                 ),
//               );
//           final locatonName = await Helpers.getLocationName(
//               position.latitude, position.longitude);
//           initUserCountryCode();
//           state = state.copyWith(currentLocationName: locatonName);
//         });
//       } else {
//         state = state.copyWith(currentPosition: position);
//         ref.read(googleMapControllerProvider.notifier).state!.animateCamera(
//               CameraUpdate.newCameraPosition(
//                 CameraPosition(
//                   target: LatLng(position.latitude, position.longitude),
//                   zoom: 14.4746,
//                 ),
//               ),
//             );
//         final locatonName = await Helpers.getLocationName(
//             position.latitude, position.longitude);
//         initUserCountryCode();
//         state = state.copyWith(currentLocationName: locatonName);
//       }
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   Future<void> getCurrentLocationSettings() async {
//     await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true)
//         .then((Position? position) async {
//       if (position == null) {
//         dev.log('getting new location');
//         await Geolocator.getCurrentPosition(
//                 forceAndroidLocationManager: true,
//                 desiredAccuracy: LocationAccuracy.bestForNavigation)
//             .then((Position position) async {
//           final locatonName = await Helpers.getLocationName(
//               position.latitude, position.longitude);
//           state = state.copyWith(
//               currentLocationName: locatonName, currentPosition: position);
//         });
//       } else {
//         state = state.copyWith(currentPosition: position);
//         final locatonName = await Helpers.getLocationName(
//             position.latitude, position.longitude);
//         state = state.copyWith(
//             currentLocationName: locatonName, currentPosition: position);
//       }
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   final PolylinePoints _polylinePoints = PolylinePoints();

//   Future _calculateDistanceBetweenPointsAndGetPolyLineCoordinates(
//     double startLatitude,
//     double startLongitude,
//     double destLat,
//     double destLong,
//   ) async {
//     final lines = state.polylineCoordinates!;

//     dev.log('calulate Distance Between Points And Get PolyLine Coordinates');
// // Initializing PolylinePoints

//     // Generating the list of coordinates to be used for
//     // drawing the polylines
//     final polyLines = await _polylinePoints.getRouteBetweenCoordinates(
//       Env.googleAPIKey, // Google Maps API Key
//       PointLatLng(startLatitude, startLongitude),
//       PointLatLng(destLat, destLong),
//       travelMode: TravelMode.driving,
//     );
//     dev.log('polylines ');
//     print(polyLines.points);
//     if (polyLines.points.isNotEmpty) {
//       //remove pre- existent polylineCoordinates
//       state.polylineCoordinates!.clear();
//       for (var element in polyLines.points) {
//         state.polylineCoordinates!
//             .add(LatLng(element.latitude, element.longitude));
//       }
//       var totalDistance = 0.0;
//       for (var i = 0; i < state.polylineCoordinates!.length - 1; i++) {
//         totalDistance += Helpers.getDistance(
//           state.polylineCoordinates![i].latitude,
//           state.polylineCoordinates![i].longitude,
//           state.polylineCoordinates![i + 1].latitude,
//           state.polylineCoordinates![i + 1].longitude,
//         );
//       }
//       // ref.read(distanceProvider.notifier).state = totalDistance;
//       // if (ref.watch(distanceProvider) > 10) {
//       //   ref
//       //       .read(bookingControllerProvider.notifier)
//       //       .updatePaymentMethod('Card');
//       // }

//       Polyline polyline = Polyline(
//         zIndex: 20,
//         polylineId: const PolylineId('poly'),
//         color: AppColors.secondary,
//         points: lines,
//         width: 5,
//       );
//       state = state.copyWith(polylines: state.polylines!..add(polyline));
//       // polylinesNotify.state.add(polyline);
//       // ref
//       //     .read(googleMapControllerProvider.notifier)
//       //     .state!
//       //     .moveCamera(CameraUpdate.newLatLng(LatLng(
//       //       startLatitude,
//       //       startLongitude,
//       //     )));
//     } else {
//       Fluttertoast.cancel();
//       Fluttertoast.showToast(
//           msg:
//               'Sorry we could not draw routes from your location to where you are going');
//       dev.log('error for polylinepoints ${polyLines.errorMessage}');
//     }

//     // print(result.points);

//     // Adding the coordinates to the list
//   }
// }

// class MapState {
//   Set<Marker>? markers;
//   Set<Circle>? circle;
//   List<LatLng>? polylineCoordinates;
//   Set<Polyline>? polylines;
//   CameraPosition initialLocation;
//   Completer<GoogleMapController>? controller = Completer();

//   double locationButtonPosition = 116.0;
//   BitmapDescriptor? currentUserIcon;
//   BitmapDescriptor? destinationIcon;
//   Position? currentPosition;
//   String? currentLocationName;
//   int kilometers;
//   String? currentCountryCode;
//   List<MockUserOnMap>? usersInArea;
//   PlaceDetail? place;

//   MapState(
//       {this.initialLocation = const CameraPosition(
//         target: LatLng(37.43296265331129, -122.08832357078792),
//         zoom: 14.4746,
//       ),
//       this.locationButtonPosition = 116.0,
//       this.controller,
//       this.kilometers = 1,
//       this.currentPosition,
//       this.currentLocationName,
//       this.currentCountryCode,
//       this.usersInArea,
//       this.currentUserIcon,
//       this.destinationIcon,
//       this.markers,
//       this.circle,
//       this.polylineCoordinates,
//       this.polylines,
//       this.place});

//   MapState copyWith({
//     double? locationButtonPosition,
//     Position? currentPosition,
//     String? currentCountryCode,
//     int? kilometers,
//     CameraPosition? initialLocation,
//     String? currentLocationName,
//     Set<Marker>? markers,
//     Set<Circle>? circle,
//     BitmapDescriptor? currentUserIcon,
//     BitmapDescriptor? destinationIcon,
//     List<LatLng>? polylineCoordinatesProvider,
//     Set<Polyline>? polylines,
//     List<MockUserOnMap>? usersInArea,
//     Completer<GoogleMapController>? controller,
//     PlaceDetail? place,
//   }) =>
//       MapState(
//         place: place ?? this.place,
//         controller: controller ?? this.controller,
//         kilometers: kilometers ?? this.kilometers,
//         usersInArea: usersInArea ?? this.usersInArea,
//         markers: markers ?? this.markers,
//         circle: circle ?? this.circle,
//         destinationIcon: destinationIcon ?? this.destinationIcon,
//         currentUserIcon: currentUserIcon ?? this.currentUserIcon,
//         polylineCoordinates: polylineCoordinatesProvider ?? polylineCoordinates,
//         polylines: polylines ?? this.polylines,
//         currentLocationName: currentLocationName ?? this.currentLocationName,
//         initialLocation: initialLocation ?? this.initialLocation,
//         locationButtonPosition:
//             locationButtonPosition ?? this.locationButtonPosition,
//         currentPosition: currentPosition ?? this.currentPosition,
//         currentCountryCode: currentCountryCode ?? this.currentCountryCode,
//       );
// }
