#OLD PROJECT GOOGLE SIGN IN


import 'dart:convert';

import 'package:avante/core/analytics/analytics.dart';
import 'package:avante/core/globalcontrollers/device/device_controller.dart';
import 'package:avante/core/services/notifications/notifications_service.dart';
import 'package:avante/features/auth/controller/login_controller.dart';
import 'package:avante/features/cart/controller/cart_controller.dart';
import 'package:avante/features/main/home_screen_main_v2.dart';
import 'package:avante/features/notification/controller/notification_controller.dart';
import 'package:avante/models/failure.dart';
import 'package:avante/models/user.dart';
import 'package:avante/core/services/dio/api_service.dart';
import 'package:avante/core/localdatabase/secure_storage.dart';
import 'package:avante/core/shared/modal/modal.dart';
import 'package:avante/features/auth/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {



  static AuthController controller = Get.find();
  var user = User().obs;
  var isNewUpdating = false.obs;


  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  Future<bool> isUserAuthenticated() async {
    String? user = await SecureStorage().readSecureData('user');
    return user != null;
  }

  Future<User?> getUserDetailsInStorage() async {
    User? user;
    String? currentUser = await SecureStorage().readSecureData('user');
    if (currentUser != null) {
      user = User.fromJson(currentUser);

    }
    return user;
  }

  void logout(BuildContext context) async {
  try {
     Modal.logoutDialog(context);
    var deviceData = await DeviceController.controller.deviceInfo();
    var response = await ApiService.postAuthenticatedResource(
        'logout', {'device_id': deviceData['id']});

    response.fold((failure) {
       Get.back(); // Close the dialog first
      if (failure.statusCode == 401) {
        logoutLocal(context, failure);
      } else {
        Modal.showErrorDialog(context, failure: failure);
      }
    }, (success) async {
      String? userDetails = await SecureStorage().readSecureData('user');

      if (userDetails != null) {
        User user = User.fromJson(userDetails);
        if (user.provider == 'GOOGLE') {
          await googleSignIn.signOut();
        }
      }
      await SecureStorage().deleteSecureData('user');
      CartController.controller.clearCart();
      NotificationController.controller.clearNotifications();
     
        Get.delete<LoginController>();

    
      Get.offAll(() => LoginScreen(), binding: BindingsBuilder(() {
        Get.put(LoginController());
      }));
    });
  } catch (e) {
    await SecureStorage().deleteSecureData('user');
    
      Get.delete<LoginController>();
      Analytics.logEvent(
  name: 'logout',
  parameters: {
    'user': 'has logout'// Quantity in string format
  },
);

    
    Get.offAll(() => LoginScreen(), binding: BindingsBuilder(() {
        Get.put(LoginController());
      }));
  }
}


  void logoutWihtoutContext() async {
    await SecureStorage().deleteSecureData('user');
    //  await googleSignIn.signOut();
    Get.offAll(()=>LoginScreen(), transition: Transition.cupertino);
  }

  void checkIfValid(BuildContext context, User? user) async {
    var response = await ApiService.getAuthenticatedResource('user-details');


    response.fold((failure) {
      if (failure.statusCode == 401) {
        logoutUnAuthenticatedUser(context, failure, user);
      } else {
        Modal.showErrorDialog(context, failure: failure);
      }
    }, (success) {
        // print(success.data);
      // DeviceController.controller.getDeviceInfoAndUpdateToken();
    });
  }

  void getUserDetails(BuildContext context, User? user) async {
    var response = await ApiService.getAuthenticatedResource('user-details');

    response.fold((failure) {
      if (failure.statusCode == 401) {
        logoutUnAuthenticatedUser(context, failure, user);
      } else {
        Modal.showErrorDialog(context, failure: failure);
      }
    }, (success) {
      User userDetails = User.fromMap(success.data['data']);
      SecureStorage().writeSecureData('user', userDetails.toJson());
    });
  }

  void logoutUnAuthenticatedUser(
      BuildContext context, Failure failure, User? user) async {
    Failure newFailure = failure.copyWith(message: 'Session Expired');

    Modal.showErrorDialog(context, failure: newFailure);
    await Future.delayed(Duration(seconds: 1));
    Modal.logoutDialog(
      context,
    );

    await SecureStorage().deleteSecureData('user');
    if (user?.provider == 'GOOGLE') {
      await googleSignIn.signOut();
    }

    await Future.delayed(Duration(seconds: 2), () async {
      Get.offAll(() => LoginScreen(), transition: Transition.cupertino);
    });
  }

  void logoutLocal(BuildContext context, Failure failure) async {
    Failure newFailure = failure.copyWith(message: 'Session Expired');

    Modal.showErrorDialog(context, failure: newFailure);
    await Future.delayed(Duration(seconds: 1));
    Modal.logoutDialog(
      context,
    );

    User? user = await SecureStorage().getUserDetails();

    if (user?.id != null) {
      await SecureStorage().deleteSecureData('user');
      if (user?.provider == 'GOOGLE') {
        await googleSignIn.signOut();
      }

      Get.delete<LoginController>();

       Get.offAll(() => LoginScreen(), binding: BindingsBuilder(() {
        Get.put(LoginController());
      }));
    }
  }

  void getLoginDetails() async {
    User? userDetails = await SecureStorage().getUserDetails();
    if (userDetails != null) {
      user(userDetails);
      // print(user.toJson());

      update();
    }
  }

  void refreshUserDetails() async {}

  void updateUserDetails(User updateUser) {
    user(updateUser);
    update();
  }

  void updateDeviceToken(String deviceID) async {
    User? userDetails = await SecureStorage().getUserDetails();
    String? currentDeviceToken = await NotificationsService().getDeviceToken();

    if (userDetails != null) {
      Map<String, dynamic> data = {
        "user_id": userDetails.id,
        "device_token": currentDeviceToken,
        "device_id": deviceID,
      };

      var response =
          await ApiService.postAuthenticatedResource('register-device', data);
      response.fold((failure) {
        Modal.showToast(msg: failure.message);
      }, (success) {
        
      });
    }
  }




void updateAccountIsNew(BuildContext context) async {

      User? user = await SecureStorage().getUserDetails();
      
      
      var data = {'user_id': user?.id,};
      isNewUpdating(true);
      update();
      var response = await ApiService.patchAuthenticatedResource(
          'update-is-new', data);
      response.fold((failure) {
         isNewUpdating(false);
      update();
        Modal.showErrorDialog(context, failure: failure);
      }, (success) async {
         isNewUpdating(false);
         update();
         var data = success.data['data'];
        User updateUser = user!.copyWith(is_new: false);
        AuthController.controller.updateUserDetails(updateUser);
        SecureStorage().writeSecureData('user', updateUser.toJson());
        update();

        Get.off(()=> HomeScreenMainV2(), transition: Transition.cupertino);

      });
    }

}

SizedBox(
                        height: 50,
                        width: Get.size.width,
                        child: ElevatedButton.icon(
                          style: ELEVATED_BUTTON_SOCIALITE_STYLE,
                          onPressed: () {
                            controller.signInWithGoogle(context);
                          },
                          icon: Container(
                            child: SvgPicture.asset(
                              height: 24,
                              width: 24,
                              'assets/images/google-logo.svg', // Added ".svg" extension
                              semanticsLabel:
                                  'Google Logo', // Adjusted semantics label
                            ),
                          ),
                          label: Text(
                            'Continue with Google',
                            style: Get.textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        )


                        what i like this old proejc tis how it hand eback when no account selected




# IMPLEMENT TO OUR NEW PROJECT BASE ON OUR CURREMT STRUCUTRE 
  now we need to implement it similar to this to our own ofcourse 
  we have already api


  Route::post('sign-in-with-google', [AuthController::class, 'signInWithGoogle']);
  api/sign-in-with-google


  backend 
  <?php

namespace App\Http\Controllers\Api\Mobile;

use App\Helpers\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Laravel\Socialite\Facades\Socialite;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|unique:users,email',
            'password' => 'required|string|min:6|confirmed',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'type' => 'CUSTOMER',
        ]);

        $token = $user->createToken('mobile-app-token')->plainTextToken;
        $user->load('accountInformation');

        return ApiResponse::success([
            'user' => new UserResource($user),
            'token' => $token,
        ], 'Account created successfully.');
    }

    /**
     * Login existing user.
     */
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $credentials['email'])->first();

        if (! $user || ! Hash::check($credentials['password'], $user->password)) {
            return ApiResponse::error(
                'Invalid email or password.',
                401,
                'AUTH_INVALID_CREDENTIALS'
            );
        }

        $token = $user->createToken('mobile-app-token')->plainTextToken;
        $user->load('accountInformation');

        return ApiResponse::success([
            'user' => new UserResource($user),
            'token' => $token,
        ], 'Login successful.');
    }

    /**
     * Logout user (revoke the current token).
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return ApiResponse::success(
            null,
            'Successfully logged out.'
        );
    }

    /**
     * Get currently authenticated user.
     */
    public function user(Request $request)
    {
        $user = $request->user()->load('accountInformation');

        return ApiResponse::success([
            'user' => new UserResource($user),
        ], 'Authenticated user retrieved successfully.');
    }

    /**
     * Sign in or register user with Google.
     */
    public function signInWithGoogle(Request $request)
    {
        $validated = $request->validate([
            'token' => 'required|string',
        ]);

        try {
            $googleUser = Socialite::driver('google')->userFromToken($validated['token']);
        } catch (\Exception $e) {
            return ApiResponse::error(
                'Invalid Google token.',
                401,
                'INVALID_GOOGLE_TOKEN'
            );
        }

        $user = User::where('email', $googleUser->getEmail())->first();

        if ($user) {
            $user->update([
                'provider' => 'GOOGLE',
                'google_id' => $googleUser->getId(),
                'name' => $googleUser->getName(),
                'avatar' => $googleUser->getAvatar(),
                'email_verified_at' => now(),
            ]);
        } else {
            $user = User::create([
                'provider' => 'GOOGLE',
                'google_id' => $googleUser->getId(),
                'email' => $googleUser->getEmail(),
                'name' => $googleUser->getName(),
                'avatar' => $googleUser->getAvatar(),
                'type' => 'CUSTOMER',
                'email_verified_at' => now(),
            ]);
        }

        if (!$user->accountInformation) {
            $user->accountInformation()->create([
                'full_name' => $user->name,
            ]);
        }

        $token = $user->createToken('mobile-app-token')->plainTextToken;
        $user->load('accountInformation');

        return ApiResponse::success([
            'user' => new UserResource($user),
            'token' => $token,
        ], 'Signed in with Google successfully.');
    }
}



we alreayd done the auth repository i think.we juse need to add that and we habe arleady googl sign package 
but first can you check the api if working? 