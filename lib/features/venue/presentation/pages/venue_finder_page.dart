import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/venue_entity.dart';

class VenueFinderPage extends StatefulWidget {
  const VenueFinderPage({super.key});

  @override
  State<VenueFinderPage> createState() => _VenueFinderPageState();
}

class _VenueFinderPageState extends State<VenueFinderPage> {
  // Static seed data for Phase 1 as per PRD
  final List<VenueEntity> _venues = const [
    VenueEntity(
      id: 'v1',
      name: 'Gelora Bung Karno (GBK)',
      address: 'Jl. Pintu Satu Senayan, Jakarta Pusat',
      latitude: -6.218335,
      longitude: 106.802216,
      sportsAvailable: ['Running', 'Badminton', 'Football'],
      rating: 4.8,
      imageUrl: 'https://placeholder.com/gbk', // Placeholder
      priceRange: 'Gratis - Berbayar',
    ),
    VenueEntity(
      id: 'v2',
      name: 'Candra Wijaya Int. Badminton Center',
      address: 'Jl. Jalur Sutera, Alam Sutera',
      latitude: -6.2235,
      longitude: 106.6496,
      sportsAvailable: ['Badminton'],
      rating: 4.9,
      imageUrl: 'https://placeholder.com/candra', // Placeholder
      priceRange: 'Rp 100k - 200k / jam',
    ),
    VenueEntity(
      id: 'v3',
      name: 'Gor Kuningan',
      address: 'Jl. HR Rasuna Said, Jakarta Selatan',
      latitude: -6.2222,
      longitude: 106.8322,
      sportsAvailable: ['Badminton', 'Basketball'],
      rating: 4.5,
      imageUrl: 'https://placeholder.com/gor', // Placeholder
      priceRange: 'Rp 50k - 150k / jam',
    ),
  ];

  final MapController _mapController = MapController();
  LatLng _currentLocation = const LatLng(-6.2088, 106.8456); // Default: Jakarta Center
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });
      _mapController.move(_currentLocation, 12.0);
    }
  }

  void _recenter() {
    _mapController.move(_currentLocation, 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          // Flutter Map Background
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                // CartoDB Dark Matter for dark style
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.kelompok7.athlix',
              ),
              MarkerLayer(
                markers: [
                  // Venue Markers
                  ..._venues.map((venue) => Marker(
                    point: LatLng(venue.latitude, venue.longitude),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        // Handle marker tap
                        _mapController.move(LatLng(venue.latitude, venue.longitude), 15.0);
                      },
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.neonBlue,
                        size: 40,
                      ),
                    ),
                  )),
                  // Current Location Marker
                  if (!_isLoadingLocation)
                    Marker(
                      point: _currentLocation,
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 10),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Top Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: const TextField(
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Cari nama venue atau lokasi...',
                        hintStyle: TextStyle(color: AppColors.textTertiary),
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textTertiary),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Venue List
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 280,
              padding: const EdgeInsets.only(bottom: 100), // padding for bottom nav
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _venues.length,
                itemBuilder: (context, index) {
                  final venue = _venues[index];
                  return _buildVenueCard(venue);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          backgroundColor: AppColors.bgSecondary,
          onPressed: _recenter,
          child: _isLoadingLocation 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
              : const Icon(Icons.my_location_rounded, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildVenueCard(VenueEntity venue) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 90,
            decoration: const BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/300x120/1A2540/00D4FF?text=Venue+Image'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgPrimary.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.neonGold, size: 14),
                    const SizedBox(width: 4),
                    Text('${venue.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  venue.address,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.sell_outlined, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(venue.priceRange, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
