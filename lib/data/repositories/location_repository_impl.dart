import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<Position> getCurrentLocation() async {
    // 步驟 1: 檢查裝置的定位服務是否已開啟
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 如果定位服務未開啟，拋出一個錯誤，讓上層(Provider)知道
      return Future.error('Location services are disabled.');
    }

    // 步驟 2: 檢查 App 的定位權限狀態
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 如果權限被拒絕，則向使用者發出請求
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 如果使用者在請求後再次拒絕，拋出錯誤
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 如果權限被永久拒絕 (使用者選擇了"不再詢問")，
      // App 無法再次請求權限，只能提示使用者去系統設定中手動開啟
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // 步驟 3: 當權限都通過後，才安全地獲取當前位置並返回
    return await Geolocator.getCurrentPosition();
  }
}