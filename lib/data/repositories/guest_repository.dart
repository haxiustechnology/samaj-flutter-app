import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/api_response.dart';
import '../models/pragati_mandal_model.dart';
import '../models/shikshan_samiti_model.dart';
import '../models/news_model.dart';
import '../models/advertise_model.dart';
import '../models/samuh_lagna_samiti_model.dart';
import '../models/mahila_mandal_samiti_model.dart';
import '../models/gallery_model.dart';
import '../models/event_model.dart';

class GuestRepository {
  Future<ApiResponse<List<PragatiMandalModel>>> fetchPragatiMandalList() async {
    return _fetchList<PragatiMandalModel>(
      ApiEndpoints.pragatiMandal,
      (json) => PragatiMandalModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<ShikshanSamitiModel>>> fetchShikshanSamitiList() async {
    return _fetchList<ShikshanSamitiModel>(
      ApiEndpoints.shikshanSamiti,
      (json) => ShikshanSamitiModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<NewsModel>>> fetchNewsList() async {
    return _fetchList<NewsModel>(
      ApiEndpoints.news,
      (json) => NewsModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<AdvertiseModel>>> fetchAdvertiseList() async {
    return _fetchList<AdvertiseModel>(
      ApiEndpoints.advertise,
      (json) => AdvertiseModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<SamuhLagnaSamitiModel>>> fetchSamuhLagnaSamitiList() async {
    return _fetchList<SamuhLagnaSamitiModel>(
      ApiEndpoints.samuhLagnaSamiti,
      (json) => SamuhLagnaSamitiModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<MahilaMandalSamitiModel>>> fetchMahilaMandalSamitiList() async {
    return _fetchList<MahilaMandalSamitiModel>(
      ApiEndpoints.mahilaMandalSamiti,
      (json) => MahilaMandalSamitiModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<GalleryModel>>> fetchGalleryList() async {
    return _fetchList<GalleryModel>(
      ApiEndpoints.gallery,
      (json) => GalleryModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<EventModel>>> fetchUpcomingEventsList() async {
    return _fetchList<EventModel>(
      ApiEndpoints.upcomingEvents,
      (json) => EventModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<T>>> _fetchList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await ApiClient.dio.get(endpoint);
      return ApiResponse<List<T>>.fromJson(
        response.data as Map<String, dynamic>,
        dataParser: (data) => (data as List<dynamic>)
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? e.message ?? 'Failed to fetch data',
        code: e.response?.statusCode ?? 500,
      );
    }
  }
}