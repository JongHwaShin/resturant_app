import 'package:geolocator/geolocator.dart';

/// 위치 관련 서비스
class LocationService {
  /// 위치 권한 요청 및 확인
  Future<bool> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  /// 현재 위치 가져오기
  Future<Position?> getCurrentPosition() async {
    bool hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return null;
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
} 