import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

/// 지도 화면(MapScreen) - 구글맵, 위치, 검색 기능을 담당하는 화면
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 구글맵 컨트롤러 (지도를 제어할 때 사용)
  GoogleMapController? mapController;
  // 현재 위치 정보
  Position? currentPosition;
  // 위치 권한 여부
  bool isLocationEnabled = false;
  // 위치 스트림 구독 (실시간 위치 추적)
  StreamSubscription<Position>? positionStreamSubscription;
  // 지도에 표시할 마커들
  Set<Marker> _markers = {};

  // 검색창 컨트롤러
  TextEditingController _searchController = TextEditingController();
  // 검색 결과 리스트
  List<Map<String, dynamic>> _searchResults = [];
  // 검색 중 여부(로딩 표시용)
  bool _isSearching = false;

  // 창원시 기본 좌표 (초기 지도 위치)
  static const LatLng changwonLocation = LatLng(35.2279, 128.6817);

  @override
  void initState() {
    super.initState();
    _checkLocationPermission(); // 위치 권한 확인 및 요청
    _fetchRestaurants();       // DB에서 식당 데이터 불러와 마커 표시
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel(); // 위치 스트림 해제
    _searchController.dispose();         // 검색창 컨트롤러 해제
    super.dispose();
  }

  /// 위치 권한을 확인하고, 허용 시 위치 추적 시작
  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    if (status.isGranted) {
      setState(() {
        isLocationEnabled = true;
      });
      _startLocationTracking();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치 권한이 필요합니다. 설정에서 위치 권한을 허용해주세요.'),
        ),
      );
    }
  }

  /// 실시간 위치 추적을 시작 (10m 이동마다 업데이트)
  void _startLocationTracking() {
    positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        currentPosition = position;
      });
      // 위치가 바뀔 때마다 지도 카메라 이동
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17,
            ),
          ),
        );
      }
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('위치 추적 중 오류가 발생했습니다: $error'),
        ),
      );
    });
  }

  /// 현재 위치를 한 번만 가져와서 지도 카메라 이동
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('위치 서비스가 비활성화되어 있습니다. 설정에서 위치 서비스를 활성화해주세요.'),
          ),
        );
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('위치 권한이 영구적으로 거부되었습니다. 설정에서 위치 권한을 허용해주세요.'),
          ),
        );
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17,
            ),
          ),
        );
      }
    } catch (e) {
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: changwonLocation,
              zoom: 17,
            ),
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('위치를 가져오는데 실패했습니다: $e\n창원시로 이동합니다.'),
        ),
      );
    }
  }

  /// 구글맵 위젯 생성 시 호출 (초기 카메라 위치 세팅)
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentPosition != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
            zoom: 17,
          ),
        ),
      );
    } else {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: changwonLocation,
            zoom: 17,
          ),
        ),
      );
    }
  }

  /// Supabase DB에서 모든 식당 데이터를 불러와 지도에 마커로 표시
  Future<void> _fetchRestaurants() async {
    try {
      final List data = await Supabase.instance.client
          .from('restaurants')
          .select();
      setState(() {
        _markers = data.map((item) {
          return Marker(
            markerId: MarkerId(item['id'].toString()),
            position: LatLng(item['lat'], item['lng']),
            infoWindow: InfoWindow(
              title: item['name'],
              snippet: item['description'] ?? '',
            ),
          );
        }).toSet();
      });
    } catch (e) {
      print('DB에서 식당 정보를 불러오지 못했습니다: $e');
    }
  }

  /// 검색어로 Supabase DB에서 식당 이름을 LIKE 검색하여 결과 리스트로 반환
  Future<void> _searchRestaurants(String query) async {
    setState(() {
      _isSearching = true;
    });
    try {
      final List data = await Supabase.instance.client
          .from('restaurants')
          .select()
          .ilike('name', '%$query%');
      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  /// 검색 결과에서 식당을 선택하면 해당 위치로 지도 이동
  void _moveToRestaurant(Map<String, dynamic> restaurant) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(restaurant['lat'], restaurant['lng']),
            zoom: 17,
          ),
        ),
      );
    }
  }

  /// 지도 화면 UI 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text('내주변'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('메뉴가 곧 추가됩니다!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 구글맵 위젯 (지도 및 마커 표시)
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: currentPosition != null
                  ? LatLng(currentPosition!.latitude, currentPosition!.longitude)
                  : changwonLocation,
              zoom: 17,
            ),
            myLocationEnabled: isLocationEnabled,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            markers: _markers,
          ),
          // 검색창 오버레이 (지도 위에 검색창과 결과 리스트 표시)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // 검색 입력창
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '식당 이름 검색',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchResults = [];
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _searchRestaurants(value);
                      } else {
                        setState(() {
                          _searchResults = [];
                        });
                      }
                    },
                  ),
                ),
                // 검색 결과 리스트
                if (_searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final restaurant = _searchResults[index];
                        return ListTile(
                          title: Text(restaurant['name'] ?? ''),
                          subtitle: restaurant['address'] != null ? Text(restaurant['address']) : null,
                          onTap: () {
                            _moveToRestaurant(restaurant);
                            setState(() {
                              _searchResults = [];
                              _searchController.text = restaurant['name'] ?? '';
                            });
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      // 현재 위치로 이동하는 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
} 