import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vigo_smart_app/features/auth/model/marklogin_model.dart';
import 'package:vigo_smart_app/features/auth/viewmodel/getuserdetails_view_model.dart';
import 'package:vigo_smart_app/features/home/view/home_page.dart';
import '../../../core/strings/strings.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils.dart';
import '../../home/viewmodel/modules_view_model.dart';
import '../model/login_model.dart';
import '../session_manager/session_manager.dart';
import '../viewmodel/getlastselfieatt_view_model.dart';
import '../viewmodel/login_sucess_view_model.dart';
import '../viewmodel/login_view_model.dart';
import '../widgets/auth_field.dart';
import '../widgets/privacy_policy.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _partnerCodeController = TextEditingController();
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  final LoginViewModel _viewModel = LoginViewModel();
  final MarkLoginViewModel markLoginViewModel = MarkLoginViewModel();
  final UserViewModel userViewModel = UserViewModel();
  final GetlastselfieattViewModel getlastselfieattViewModel = GetlastselfieattViewModel();

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = "${_partnerCodeController.text}/${_userIDController.text}";
      final loginRequest = LoginRequest(
        grantType: Strings.grantType,
        username: username,
        password: _passwordController.text,
      );

      final success = await _viewModel.makeRequest(loginRequest);

      if (success) {
        final sessionManager = SessionManager();
        await sessionManager.saveLoginInfo(username);

        sessionManager.getToken().then((token) async {
          final String formattedDateTime = Utils.getCurrentFormattedDateTime();
          final String deviceDetails = await Utils.getDeviceDetails(context);
          final String appVersion = await Utils.getAppVersion();
          final String ipAddress = await Utils.getIpAddress();
          final String uniqueId = await Utils.getUniqueID();
          final int battery = await Utils.getBatteryLevel();
          final String? fcmToken = await Utils.getFCMToken();

          final String fullDeviceDetails = "$deviceDetails/$uniqueId/$ipAddress";

          final markLoginModel = MarkLoginModel(
            deviceDetails: fullDeviceDetails,
            punchAction: 'LOGIN.',
            locationDetails: '',
            batteryStatus: '$battery%',
            time: formattedDateTime,
            latLong: '',
            version: 'v$appVersion',
            fcmToken: fcmToken ?? '',
            dataStatus: '',
          );

          final markLoginResponse = await markLoginViewModel.markLogin(token!, markLoginModel);

          if (markLoginResponse is String &&
              markLoginResponse == "Device Logged-In successfully.") {
            Fluttertoast.showToast(
              msg: markLoginResponse,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 17.0,
            );
          }

          ModulesViewModel moduleService = ModulesViewModel();
          List<String> moduleCodes = await moduleService.getModules(token);

          List<String> distinctModuleCodes = moduleCodes.toSet().toList();

          // Save the distinct module codes
          await sessionManager.saveModuleCodes(distinctModuleCodes);

          // Print saved distinct module codes
          sessionManager.getModuleCodes().then((savedModuleCodes) {
            //print(savedModuleCodes);
          });

          sessionManager.saveModuleCodes(moduleCodes);
          sessionManager.getModuleCodes().then((modulesCodes) async {
            //print(modulesCodes);
          });

          userViewModel.getUserDetails(token);
          getlastselfieattViewModel.getLastSelfieAttendance(token);
        }).catchError((error) {
          //print('Error: $error');
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Login failed. Please try again.',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.1,
                vertical: constraints.maxHeight * 0.05,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    _buildLoginImage(constraints),
                    const SizedBox(height: 10),
                    _buildLoginTitle(),
                    const SizedBox(height: 30),
                    AuthField(
                      labelText: Strings.partnerCode,
                      controller: _partnerCodeController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Partner Code is Required';
                        }
                        _partnerCodeController.text = value.trim();
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    AuthField(
                      labelText: Strings.userID,
                      controller: _userIDController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'User ID is Required';
                        }
                        _userIDController.text = value.trim();
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    AuthField(
                      labelText: Strings.password,
                      controller: _passwordController,
                      obscureText: !isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is Required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                    const SizedBox(height: 20),
                    const PrivacyPolicy(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginImage(BoxConstraints constraints) {
    return Image.asset(
      'assets/images/login_image.jpeg',
      height: constraints.maxHeight * 0.2,
    );
  }

  Widget _buildLoginTitle() {
    return const Text(
      Strings.login,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _onSubmit,
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: Pallete.btn1,
        foregroundColor: Pallete.backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text(
        Strings.submit,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
