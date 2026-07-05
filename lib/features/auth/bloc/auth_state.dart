import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';


abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LogoutLoading extends AuthState {}

class DeleteAccountLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel? user;
  final String? message;

  const AuthSuccess({this.user, this.message});

  @override
  List<Object?> get props => [user, message];
}

class OtpSent extends AuthState {
  final String mobile;
  final String message;

  const OtpSent({
    required this.mobile,
    required this.message,
  });

  @override
  List<Object?> get props => [mobile, message];
}

class OtpVerified extends AuthState {
  final String token;
  final UserModel? user;

  const OtpVerified({
    required this.token,
    this.user,
  });

  @override
  List<Object?> get props => [token, user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutSuccess extends AuthState {
  final String message;

  const LogoutSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}


