import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/features/home/data/models/item_model.dart';

class ItemRepository {
  Future<List<Item>> getItems() async {
    try {
      final response = await apiClient.dio.get('/items');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => Item.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
