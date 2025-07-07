import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/restaurant.dart';

/// Supabase 연동 및 식당 데이터 관리 서비스
class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  /// 모든 식당 리스트 조회
  Future<List<Restaurant>> fetchRestaurants() async {
    final response = await client.from('restaurants').select().order('id');
    return (response as List)
        .map((item) => Restaurant.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  /// 이름으로 식당 검색 (LIKE 쿼리)
  Future<List<Restaurant>> searchRestaurants(String keyword) async {
    final response = await client
        .from('restaurants')
        .select()
        .ilike('name', '%$keyword%')
        .order('id');
    return (response as List)
        .map((item) => Restaurant.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  /// id로 단일 식당 조회
  Future<Restaurant?> getRestaurantById(int id) async {
    final response = await client
        .from('restaurants')
        .select()
        .eq('id', id)
        .single();
    if (response == null) return null;
    return Restaurant.fromMap(response as Map<String, dynamic>);
  }
} 