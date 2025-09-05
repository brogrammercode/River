import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/common_error.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';

class AuthState extends Equatable {
  final UserModel? user;
  final String userID;
  final String token;
  final CommonStatus authInitStatus;
  final CommonStatus loginStatus;
  final CommonStatus registerStatus;
  final CommonStatus logoutStatus;
  final CommonStatus getMeStatus;
  final CommonStatus getTokenStatus;
  final CommonStatus saveTokenStatus;
  final CommonStatus clearTokenStatus;
  final CommonError error;

  const AuthState({
    this.user,
    this.userID = "",
    this.token = "",
    this.authInitStatus = CommonStatus.initial,
    this.loginStatus = CommonStatus.initial,
    this.registerStatus = CommonStatus.initial,
    this.logoutStatus = CommonStatus.initial,
    this.getMeStatus = CommonStatus.initial,
    this.getTokenStatus = CommonStatus.initial,
    this.saveTokenStatus = CommonStatus.initial,
    this.clearTokenStatus = CommonStatus.initial,
    this.error = const CommonError(),
  });

  AuthState copyWith({
    UserModel? user,
    String? userID,
    String? token,
    CommonStatus? authInitStatus,
    CommonStatus? loginStatus,
    CommonStatus? registerStatus,
    CommonStatus? logoutStatus,
    CommonStatus? getMeStatus,
    CommonStatus? getTokenStatus,
    CommonStatus? saveTokenStatus,
    CommonStatus? clearTokenStatus,
    CommonError? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      userID: userID ?? this.userID,
      token: token ?? this.token,
      authInitStatus: authInitStatus ?? this.authInitStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      registerStatus: registerStatus ?? this.registerStatus,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      getMeStatus: getMeStatus ?? this.getMeStatus,
      getTokenStatus: getTokenStatus ?? this.getTokenStatus,
      saveTokenStatus: saveTokenStatus ?? this.saveTokenStatus,
      clearTokenStatus: clearTokenStatus ?? this.clearTokenStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    user,
    userID,
    token,
    authInitStatus,
    loginStatus,
    registerStatus,
    logoutStatus,
    getMeStatus,
    getTokenStatus,
    saveTokenStatus,
    clearTokenStatus,
    error,
  ];
}
