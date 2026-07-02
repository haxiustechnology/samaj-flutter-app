import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samaj/data/repositories/guest_repository.dart';

part 'guest_event.dart';
part 'guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  final GuestRepository guestRepository;

  GuestBloc({required this.guestRepository}) : super(GuestInitial()) {
    on<PragatiListEvent>(_onFetchPragatiMandalList);
    on<ShikshanListEvent>(_onFetchShikshanSamitiList);
    on<NewsListEvent>(_onFetchNewsList);
    on<AdvertiseListEvent>(_onFetchAdvertiseList);
    on<SamuhLagnaListEvent>(_onFetchSamuhLagnaList);
    on<MahilaMandalListEvent>(_onFetchMahilaMandalList);
  }

  Future<void> _onFetchPragatiMandalList(
    PragatiListEvent event,
    Emitter<GuestState> emit,
  ) async {
    emit(GuestLoading());
    try {
      final response = await guestRepository.fetchPragatiMandalList();
      if (response.isSuccess) {
        emit(GuestLoaded(data: response.data!));
      } else {
        emit(GuestError(message: response.message));
      }
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onFetchShikshanSamitiList(
    ShikshanListEvent event,
    Emitter<GuestState> emit,
  ) async {
    emit(GuestLoading());
    try {
      final response = await guestRepository.fetchShikshanSamitiList();
      if (response.isSuccess) {
        emit(GuestLoaded(data: response.data!));
      } else {
        emit(GuestError(message: response.message));
      }
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onFetchNewsList(
    NewsListEvent event,
    Emitter<GuestState> emit,
  ) async {
    emit(GuestLoading());
    try {
      final response = await guestRepository.fetchNewsList();
      if (response.isSuccess) {
        emit(GuestLoaded(data: response.data!));
      } else {
        emit(GuestError(message: response.message));
      }
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onFetchAdvertiseList(
    AdvertiseListEvent event,
    Emitter<GuestState> emit,
  ) async {
    emit(GuestLoading());
    try {
      final response = await guestRepository.fetchAdvertiseList();
      if (response.isSuccess) {
        emit(GuestLoaded(data: response.data!));
      } else {
        emit(GuestError(message: response.message));
      }
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onFetchSamuhLagnaList(
    SamuhLagnaListEvent event,
    Emitter<GuestState> emit,
  ) async {
    emit(GuestLoading());
    try {
      final response = await guestRepository.fetchSamuhLagnaSamitiList();
      if (response.isSuccess) {
        emit(GuestLoaded(data: response.data!));
      } else {
        emit(GuestError(message: response.message));
      }
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }

  Future<void> _onFetchMahilaMandalList(
    MahilaMandalListEvent event,
    Emitter<GuestState> emit,
  ) async {
    emit(GuestLoading());
    try {
      final response = await guestRepository.fetchMahilaMandalSamitiList();
      if (response.isSuccess) {
        emit(GuestLoaded(data: response.data!));
      } else {
        emit(GuestError(message: response.message));
      }
    } catch (e) {
      emit(GuestError(message: e.toString()));
    }
  }
}