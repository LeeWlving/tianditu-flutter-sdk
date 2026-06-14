import 'package:flutter/material.dart';
import 'package:tianditu/tianditu.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const apiKey = String.fromEnvironment('TIANDITU_TK');

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapDemoPage(),
    );
  }
}

class MapDemoPage extends StatefulWidget {
  const MapDemoPage({super.key});

  @override
  State<MapDemoPage> createState() => _MapDemoPageState();
}

class _MapDemoPageState extends State<MapDemoPage> {
  final _controller = TiandituMapController();
  final _locationService = TiandituLocationService();
  var _mapType = TiandituMapType.vector;
  TiandituPosition? _position;
  String? _message;

  Future<void> _locate() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _position = position;
        _message = null;
      });
      _controller.move(position.coordinate, 16);
    } on TiandituLocationException catch (error) {
      if (!mounted) return;
      setState(() => _message = error.message);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const beijing = TiandituLatLng(39.9042, 116.4074);
    return Scaffold(
      appBar: AppBar(
        title: const Text('天地图 Flutter SDK'),
        actions: [
          PopupMenuButton<TiandituMapType>(
            initialValue: _mapType,
            onSelected: (value) => setState(() => _mapType = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: TiandituMapType.vector, child: Text('矢量')),
              PopupMenuItem(value: TiandituMapType.imagery, child: Text('影像')),
              PopupMenuItem(value: TiandituMapType.terrain, child: Text('地形')),
            ],
          ),
        ],
      ),
      body: TiandituMap(
        apiKey: MyApp.apiKey,
        controller: _controller,
        mapType: _mapType,
        initialCamera: const TiandituCameraPosition(target: beijing, zoom: 11),
        markers: const [
          TiandituMarker(
            position: beijing,
            alignment: Alignment.bottomCenter,
            child: Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
        ],
        circles: const [TiandituCircle(center: beijing, radiusInMeters: 1200)],
        userLocation: _position == null
            ? null
            : TiandituUserLocation(
                position: _position!.coordinate,
                accuracyInMeters: _position!.accuracy,
                heading: _position!.heading,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _locate,
        child: const Icon(Icons.my_location),
      ),
      bottomNavigationBar: _message == null
          ? null
          : Material(
              color: Theme.of(context).colorScheme.errorContainer,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_message!),
                ),
              ),
            ),
    );
  }
}
