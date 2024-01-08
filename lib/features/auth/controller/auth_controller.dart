import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider<UserModel?>((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  // The verifyOTP method in auth_repository.dart does not take a verificationId parameter
  void verifyOTP(BuildContext context, String phoneNumber, String userOTP) {
    authRepository.verifyOTP(
      context: context,
      phoneNumber: phoneNumber,
      userOTP: userOTP,
    );
  }

  // The saveUserDataToFirebase method does not exist in the provided auth_repository.dart
  // You need to implement this method in auth_repository.dart or remove this call
  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    // Implement saveUserDataToFirebase in auth_repository.dart or handle it here
  }

  // The userData method does not exist in the provided auth_repository.dart
  // You need to implement this method in auth_repository.dart or adjust this method
  Stream<UserModel> userDataById(String userId) {
    // Implement userDataById in auth_repository.dart or adjust this method
    throw UnimplementedError();
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}