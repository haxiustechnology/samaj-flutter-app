
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';


class AuthViewModel {
  final AuthBloc authBloc;

  AuthViewModel(this.authBloc);

  void register(String name, String mobile) {
    authBloc.add(RegisterEvent(name: name, mobile: mobile));
  }

  void login(String mobile) {
    authBloc.add(LoginEvent(mobile: mobile));
  }

  void verifyOtp(String mobile, String otp) {
    authBloc.add(VerifyOtpEvent(mobile: mobile, otp: otp));
  }

  void resendOtp(String mobile) {
    authBloc.add(ResendOtpEvent(mobile: mobile));
  }

  void completeRegistration(
    String firstName,
    String email,
    String mobile,
  ) {
    authBloc.add(CompleteRegistrationEvent(
      firstName: firstName,
      email: email,
      mobile: mobile,
    ));
  }
}


