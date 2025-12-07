import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kakilima/features/stall/data/models/stall_model.dart';

class StallRemoteDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<StallModel?> getVendorStall(String vendorId) async {
    try {
      final response = await _supabase
          .from('stalls')
          .select()
          .eq('vendor_id', vendorId)
          .maybeSingle();
      
      if (response == null) {
        return null;
      }
      
      return StallModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get vendor stall: $e');
    }
  }

  Future<StallModel> createStall({
    required String vendorId,
    required String name,
    String? nameEnhanced,
    String? description,
    String? photoUrl,
    required double longitude,
    required double latitude,
  }) async {
    try {
      // Check if vendor already has a stall
      final existingStall = await getVendorStall(vendorId);
      if (existingStall != null) {
        throw Exception('Vendor already has a stall');
      }

      final response = await _supabase
          .from('stalls')
          .insert({
            'vendor_id': vendorId,
            'name': name,
            'name_enhanced': nameEnhanced,
            'description': description,
            'photo_url': photoUrl,
            'location': 'POINT($longitude $latitude)',
          })
          .select()
          .single();

      return StallModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create stall: $e');
    }
  }
}

