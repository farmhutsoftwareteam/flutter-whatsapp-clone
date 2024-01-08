import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    supabase: Supabase.instance.client,
  ),
);

class AuthRepository {
  final SupabaseClient supabase;
  AuthRepository({
    required this.supabase,
  });

Future<UserModel?> getCurrentUserData() async {
  try {
    final response = await supabase
        .from('users')
        .select()
        .eq('id', supabase.auth.currentUser?.id as Object)
        .single();

    // If response is already a Map, you don't need to access .data
    return response != null ? UserModel.fromMap(response) : null;
  } catch (error) {
    print('An error occurred while fetching user data: $error');
    return null; // Return null to indicate an error occurred
  }
}

  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      final response = await supabase.auth.signInWithOtp(
        phone : phoneNumber
       
      );
      
      // Store the session or verificationId as needed
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> verifyOTP({
    required BuildContext context,
    required String phoneNumber,
    required String userOTP,
  }) async {
    try {
      final response = await supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: userOTP,
         type: OtpType.sms,
      );
    
      // Navigate to the next screen after successful verification
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setUserState(bool isOnline) async {
    final response = await supabase
        .from('users')
        .update({'isOnline': isOnline})
        .eq('id', supabase.auth.currentUser!.id);
       

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }
}