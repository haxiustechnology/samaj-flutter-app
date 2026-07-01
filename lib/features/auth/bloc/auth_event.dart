import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String mobile;

  const RegisterEvent({
    required this.name,
    required this.mobile,
  });

  @override
  List<Object?> get props => [name, mobile];
}

class LoginEvent extends AuthEvent {
  final String mobile;

  const LoginEvent({required this.mobile});

  @override
  List<Object?> get props => [mobile];
}

class VerifyOtpEvent extends AuthEvent {
  final String mobile;
  final String otp;

  const VerifyOtpEvent({
    required this.mobile,
    required this.otp,
  });

  @override
  List<Object?> get props => [mobile, otp];
}

class ResendOtpEvent extends AuthEvent {
  final String mobile;

  const ResendOtpEvent({required this.mobile});

  @override
  List<Object?> get props => [mobile];
}

class CompleteRegistrationEvent extends AuthEvent {
  final String firstName;
  final String email;
  final String mobile;

  const CompleteRegistrationEvent({
    required this.firstName,
    required this.email,
    required this.mobile,
  });

  @override
  List<Object?> get props => [firstName, email, mobile];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends AuthEvent {
  final Map<String, dynamic> data;

  const UpdateProfileEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class DeleteAccountEvent extends AuthEvent {
  const DeleteAccountEvent();

  @override
  List<Object?> get props => [];
}


