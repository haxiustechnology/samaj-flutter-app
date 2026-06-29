part of 'guest_bloc.dart';

abstract class GuestState {}

class GuestInitial extends GuestState {}

class GuestLoading extends GuestState {}

class GuestLoaded extends GuestState {
  final List<dynamic> data;

  GuestLoaded({required this.data});
}

class GuestError extends GuestState {
  final String message;

  GuestError({required this.message});
}