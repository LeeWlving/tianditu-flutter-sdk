import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'tianditu_map_controller.dart';
import 'tianditu_map_models.dart';

/// 使用天地图 WMTS 栅格服务的跨平台 Flutter 地图组件。
class TiandituMap extends StatelessWidget {
  const TiandituMap({
    super.key,
    required this.apiKey,
    this.controller,
    this.initialCamera = const TiandituCameraPosition(
      target: TiandituLatLng(39.9042, 116.4074),
      zoom: 10,
    ),
    this.mapType = TiandituMapType.vector,
    this.showLabels = true,
    this.minZoom = 1,
    this.maxZoom = 18,
    this.markers = const [],
    this.polylines = const [],
    this.polygons = const [],
    this.circles = const [],
    this.userLocation,
    this.onTap,
    this.onLongPress,
    this.onCameraChanged,
    this.backgroundColor = const Color(0xFFF2F4F7),
    this.userAgentPackageName,
    this.showAttribution = true,
  });

  final String apiKey;
  final TiandituMapController? controller;
  final TiandituCameraPosition initialCamera;
  final TiandituMapType mapType;
  final bool showLabels;
  final double minZoom;
  final double maxZoom;
  final List<TiandituMarker> markers;
  final List<TiandituPolyline> polylines;
  final List<TiandituPolygon> polygons;
  final List<TiandituCircle> circles;
  final TiandituUserLocation? userLocation;
  final TiandituMapTapCallback? onTap;
  final TiandituMapTapCallback? onLongPress;
  final TiandituCameraChangedCallback? onCameraChanged;
  final Color backgroundColor;
  final String? userAgentPackageName;
  final bool showAttribution;

  @override
  Widget build(BuildContext context) {
    if (apiKey.trim().isEmpty) {
      return const ColoredBox(
        color: Color(0xFFF2F4F7),
        child: Center(child: Text('请配置天地图 API Key')),
      );
    }

    final layers = _layersFor(mapType);
    return FlutterMap(
      mapController: controller?.delegate,
      options: MapOptions(
        initialCenter: _point(initialCamera.target),
        initialZoom: initialCamera.zoom,
        initialRotation: initialCamera.rotation,
        minZoom: minZoom,
        maxZoom: maxZoom,
        backgroundColor: backgroundColor,
        onTap: (_, point) => onTap?.call(_coordinate(point)),
        onLongPress: (_, point) => onLongPress?.call(_coordinate(point)),
        onPositionChanged: (camera, hasGesture) {
          onCameraChanged?.call(
            TiandituCameraPosition(
              target: _coordinate(camera.center),
              zoom: camera.zoom,
              rotation: camera.rotation,
            ),
            hasGesture,
          );
        },
      ),
      children: [
        _tileLayer(layers.base),
        if (showLabels) _tileLayer(layers.labels),
        if (polygons.isNotEmpty)
          PolygonLayer(
            polygons: polygons
                .map(
                  (polygon) => Polygon(
                    points: polygon.points.map(_point).toList(growable: false),
                    color: polygon.color,
                    borderColor: polygon.borderColor,
                    borderStrokeWidth: polygon.borderStrokeWidth,
                  ),
                )
                .toList(growable: false),
          ),
        if (polylines.isNotEmpty)
          PolylineLayer(
            polylines: polylines
                .map(
                  (polyline) => Polyline(
                    points: polyline.points.map(_point).toList(growable: false),
                    color: polyline.color,
                    strokeWidth: polyline.strokeWidth,
                  ),
                )
                .toList(growable: false),
          ),
        if (circles.isNotEmpty)
          CircleLayer(
            circles: circles
                .map(
                  (circle) => CircleMarker(
                    point: _point(circle.center),
                    radius: circle.radiusInMeters,
                    useRadiusInMeter: true,
                    color: circle.color,
                    borderColor: circle.borderColor,
                    borderStrokeWidth: circle.borderStrokeWidth,
                  ),
                )
                .toList(growable: false),
          ),
        if (userLocation case final location?)
          if (location.showAccuracy && location.accuracyInMeters > 0)
            CircleLayer(
              circles: [
                CircleMarker(
                  point: _point(location.position),
                  radius: location.accuracyInMeters,
                  useRadiusInMeter: true,
                  color: const Color(0x241A73E8),
                  borderColor: const Color(0x661A73E8),
                  borderStrokeWidth: 1,
                ),
              ],
            ),
        if (markers.isNotEmpty || userLocation != null)
          MarkerLayer(
            markers: [
              ...markers.map(
                (marker) => Marker(
                  point: _point(marker.position),
                  width: marker.width,
                  height: marker.height,
                  alignment: marker.alignment,
                  rotate: marker.rotate,
                  child: marker.child,
                ),
              ),
              if (userLocation case final location?)
                Marker(
                  point: _point(location.position),
                  width: 28,
                  height: 28,
                  rotate: true,
                  child: location.marker ?? const _DefaultLocationMarker(),
                ),
            ],
          ),
        if (showAttribution)
          const RichAttributionWidget(
            attributions: [TextSourceAttribution('天地图')],
          ),
      ],
    );
  }

  TileLayer _tileLayer(_TiandituLayer layer) {
    return TileLayer(
      urlTemplate:
          'https://t{s}.tianditu.gov.cn/${layer.matrixSet}/wmts'
          '?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0'
          '&LAYER=${layer.layer}&STYLE=default&TILEMATRIXSET=w'
          '&FORMAT=tiles&TILECOL={x}&TILEROW={y}&TILEMATRIX={z}'
          '&tk=$apiKey',
      minNativeZoom: 1,
      maxNativeZoom: 18,
      subdomains: const ['0', '1', '2', '3', '4', '5', '6', '7'],
      userAgentPackageName: userAgentPackageName ?? 'tianditu_flutter_sdk',
    );
  }

  static LatLng _point(TiandituLatLng point) {
    return LatLng(point.latitude, point.longitude);
  }

  static TiandituLatLng _coordinate(LatLng point) {
    return TiandituLatLng(point.latitude, point.longitude);
  }

  static _TiandituLayers _layersFor(TiandituMapType type) {
    return switch (type) {
      TiandituMapType.vector => const _TiandituLayers(
        base: _TiandituLayer('vec_w', 'vec'),
        labels: _TiandituLayer('cva_w', 'cva'),
      ),
      TiandituMapType.imagery => const _TiandituLayers(
        base: _TiandituLayer('img_w', 'img'),
        labels: _TiandituLayer('cia_w', 'cia'),
      ),
      TiandituMapType.terrain => const _TiandituLayers(
        base: _TiandituLayer('ter_w', 'ter'),
        labels: _TiandituLayer('cta_w', 'cta'),
      ),
    };
  }
}

class _DefaultLocationMarker extends StatelessWidget {
  const _DefaultLocationMarker();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1A73E8),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFFFFF), width: 3),
        boxShadow: const [BoxShadow(color: Color(0x55000000), blurRadius: 4)],
      ),
    );
  }
}

class _TiandituLayers {
  const _TiandituLayers({required this.base, required this.labels});

  final _TiandituLayer base;
  final _TiandituLayer labels;
}

class _TiandituLayer {
  const _TiandituLayer(this.matrixSet, this.layer);

  final String matrixSet;
  final String layer;
}
