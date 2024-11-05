
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vigo_smart_app/features/auth/model/marklogin_model.dart';
import 'package:vigo_smart_app/features/auth/viewmodel/checksession_view_model.dart';
import 'package:vigo_smart_app/features/auth/viewmodel/getuserdetails_view_model.dart';
import 'package:vigo_smart_app/features/home/view/home_page.dart';
import '../../../core/strings/strings.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils.dart';
import '../../home/viewmodel/modules_view_model.dart';
import '../model/checksession_model.dart';
import '../model/login_model.dart';
import '../session_manager/session_manager.dart';
import '../viewmodel/getlastselfieatt_view_model.dart';
import '../viewmodel/login_sucess_view_model.dart';
import '../viewmodel/login_view_model.dart';
import '../viewmodel/support_contact_view_model.dart';
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


  String ivr = '';
  String? whatsAppNum = '';
  String appName = '';



  final LoginViewModel _viewModel = LoginViewModel();
  final MarkLoginViewModel markLoginViewModel = MarkLoginViewModel();
  final UserViewModel userViewModel = UserViewModel();
  final GetLastSelfieAttViewModel getLastSelfieAttViewModel = GetLastSelfieAttViewModel();
  final CheckSessionViewModel checkSessionViewModel = CheckSessionViewModel();

  @override
  void initState() {
    super.initState();
    _loadAppName();
    fetchAndPrintSupportContact();
  }


// Usage in function
  Future<void> fetchAndPrintSupportContact() async {
    final supportContactViewModel = SupportContactViewModel();
    final supportContact = await supportContactViewModel.getSupportContact();
    if (supportContact != null) {
      setState(() {
        ivr = supportContact.ivr;
        whatsAppNum = supportContact.whatsapp;
      });
      print('IVR: ${supportContact.ivr}, WhatsApp: ${supportContact.whatsapp}');
    } else {
      print('Failed to fetch support contact.');
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
                    const SizedBox(height: 20),
                    _buildLoginImage(),
                    const SizedBox(height: 10),
                    _buildAppTitle(),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 30),
                    _buildSubmitButton(),
                    const SizedBox(height: 20),
                    const PrivacyPolicy(),
                    const SizedBox(height: 30),
                    _buildSupportContact(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSupportContact() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _launchDialer(ivr),
                child: Image.asset(
                  'assets/images/ic_help_desk.webp',
                  width: 30,
                  height: 30,
                ),
              ),
              GestureDetector(
                onTap: () => _launchDialer(ivr),
                child: Text(
                  ivr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5), // Spacer

        // WhatsApp support
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _launchWhatsApp(whatsAppNum!),
                child: Image.asset(
                  'assets/images/ic_whatsapp.webp', // Specify your image path
                  width: 30, // Set desired width
                  height: 30, // Set desired height
                ),
              ),
              GestureDetector(
                onTap: () => _launchWhatsApp(whatsAppNum!),
                child: Text(
                  whatsAppNum!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Function to launch the Dialer
  Future<void> _launchDialer(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $number';
    }
  }

  // Function to launch WhatsApp
  Future<void> _launchWhatsApp(String number) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {
        'phone': number,
        'text': 'Hello',
      },
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      throw 'Could not launch WhatsApp with $number';
    }
  }



  Future<dynamic> _onSubmit() async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) return;
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final username = "${_partnerCodeController.text}/${_userIDController.text}";
        final loginRequest = LoginRequest(
          grantType: Strings.grantType,
          username: username,
          password: _passwordController.text,
        );

        final String?  error = await _viewModel.makeRequest(loginRequest);

        if (error == null) {
          // Login was successful
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
            print(fcmToken);

            final String fullDeviceDetails = "$deviceDetails/$uniqueId/$ipAddress";

            final markLoginModel = MarkLoginModel(
              deviceDetails: fullDeviceDetails,
              punchAction: 'LOGIN',
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
                fontSize: 18.0,
              );
            }

            ModulesViewModel moduleService = ModulesViewModel();
            List<String> moduleCodes = await moduleService.getModules(token);

            List<String> distinctModuleCodes = moduleCodes.toSet().toList();

            // Save the distinct module codes
            await sessionManager.saveModuleCodes(distinctModuleCodes);

            // Print saved distinct module codes
            sessionManager.getModuleCodes().then((savedModuleCodes) {
              // print(savedModuleCodes);
            });

            sessionManager.saveModuleCodes(moduleCodes);
            sessionManager.getModuleCodes().then((modulesCodes) async {
              // print(modulesCodes);
            });

            userViewModel.getUserDetails(token);
            getLastSelfieAttViewModel.getLastSelfieAttendance(token);
            checkSessionViewModel.checkSession(token, CheckSessionModel as CheckSessionModel );
          }).catchError((error) {
            print('Error: $error');
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // Display the error message returned by makeRequest
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                error,
                style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      }
      catch (e) {
        // Handle any uncaught exceptions
        print('General exception: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'An error occurred. Please try again.',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }
  }

  Widget _buildLoginImage() {
    return Image.asset(
      'assets/images/app_logo.webp',
      height: 150
    );
  }

  Future<void> _loadAppName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
    });
  }

  Widget _buildAppTitle() {
    return FutureBuilder<String>(
      future: getAppVersion(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        final version = snapshot.data ?? '';
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appName, // Assuming appName is defined elsewhere
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'v$version',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }


  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
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
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Show dialog to ask user to turn on internet connection
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("No Internet Connection"),
          content:
          const Text("Please turn on the internet connection to proceed."),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }


}
