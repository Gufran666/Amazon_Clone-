import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';

class OrderTrackingMapScreen extends StatefulWidget {
  const OrderTrackingMapScreen({super.key});

  @override
  State<OrderTrackingMapScreen> createState() => _OrderTrackingMapScreenState();
}

class _OrderTrackingMapScreenState extends State<OrderTrackingMapScreen> with SingleTickerProviderStateMixin {
  late GoogleMapController _mapController;
  late AnimationController _pulseController;
  late Marker _currentLocationMarker;
  late Marker _deliveryLocationMarker;
  late Polyline _deliveryRoute;
  late LatLng _currentLocation;
  late LatLng _deliveryLocation;
  int _remainingHours = 24;

  @override
  void initState() {
    super.initState();
    _currentLocation = const LatLng(40.7128, -74.0060);
    _deliveryLocation = const LatLng(34.0522, -118.2437);
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _initializeMarkers();
    _initializeRoute();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _initializeMarkers() {
    _currentLocationMarker = Marker(
      markerId: const MarkerId('current_location'),
      position: _currentLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(title: 'Current Location'),
    );

    _deliveryLocationMarker = Marker(
      markerId: const MarkerId('delivery_location'),
      position: _deliveryLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Delivery Location'),
    );
  }

  void _initializeRoute() {
    _deliveryRoute = Polyline(
      polylineId: const PolylineId('delivery_route'),
      color: AppTheme.darkTheme.primaryColor.withAlpha(178),
      width: 4,
      points: [
        _currentLocation,
        LatLng(38.8977, -77.0365),
        LatLng(39.7392, -89.6242),
        LatLng(33.4484, -112.0740),
        _deliveryLocation,
      ],
    );
  }

  void _startCountdownTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingHours > 0) {
          _remainingHours--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Delivery Map',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 4,
              ),
              markers: {_currentLocationMarker, _deliveryLocationMarker},
              polylines: {_deliveryRoute},
              onMapCreated: (controller) {
                _mapController = controller;
                _animateCameraToRoute();
              },
              zoomControlsEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                children: [
                  _buildDeliveryTimeOverlay(),
                  const SizedBox(height: 16),
                  _buildZoomControls(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animateCameraToRoute() {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            (_currentLocation.latitude + _deliveryLocation.latitude) / 2,
            (_currentLocation.longitude + _deliveryLocation.longitude) / 2,
          ),
          zoom: 3.5,
        ),
      ),
    );
  }

  Widget _buildDeliveryTimeOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(178),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.primaryColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimated Delivery',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_remainingHours > 0 ? 'In $_remainingHours hours' : 'Now delivering'}',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppTheme.darkTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomControls() {
    return Column(
      children: [
        FloatingActionButton(
          backgroundColor: Colors.black.withAlpha(178),
          foregroundColor: AppTheme.darkTheme.textTheme.bodyLarge!.color,
          mini: true,
          onPressed: () {
            HapticFeedback.lightImpact();
            _mapController.animateCamera(CameraUpdate.zoomIn());
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          backgroundColor: Colors.black.withAlpha(178),
          foregroundColor: AppTheme.darkTheme.textTheme.bodyLarge!.color,
          mini: true,
          onPressed: () {
            HapticFeedback.lightImpact();
            _mapController.animateCamera(CameraUpdate.zoomOut());
          },
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}