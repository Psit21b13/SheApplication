import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:womenCare/services/firebaseAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:womenCare/screens/signUpPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:womenCare/utils/constants.dart';

import 'package:womenCare/utils/scrollBehavior.dart';

// import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/loginpage";
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final spinkit = SpinKitFadingCircle(
  //   color: Constants.primaryDark,
  // );

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool guestLogin = false;
  bool passwordVisible;

  // static var uri =
  //     "https://5edsoijsi3.execute-api.us-west-2.amazonaws.com/prod/mobistay-getuservalidity";

  // static BaseOptions options = BaseOptions(
  //     baseUrl: uri,
  //     responseType: ResponseType.plain,
  //     connectTimeout: 30000,
  //     receiveTimeout: 30000,
  //     validateStatus: (code) {
  //       if (code >= 200) {
  //         return true;
  //       }
  //     });
  // static Dio dio = Dio(options);

  // Future<dynamic> _loginUser(String email, String password) async {
  //   try {
  //     Options options = Options(
  //       contentType: ContentType.parse('application/json'),
  //     );

  //     Response response = await dio.post(uri,
  //         data: {"username": email, "password": password}, options: options);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       var responseJson = json.decode(response.data);
  //       return responseJson;
  //     } else if (response.statusCode == 401) {
  //       throw Exception("Incorrect Email/Password");
  //     } else
  //       throw Exception('Authentication Error');
  //   } on DioError catch (exception) {
  //     if (exception == null ||
  //         exception.toString().contains('SocketException')) {
  //       throw Exception("Network Error");
  //     } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
  //         exception.type == DioErrorType.CONNECT_TIMEOUT) {
  //       throw Exception(
  //           "Could'nt connect, please ensure you have a stable network.");
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  // final LocalAuthentication _localAuthentication = LocalAuthentication();
  // String _authorizedOrNot = "Not Authorized";

  // Future<void> _authorizeNow() async {
  //   bool isAuthorized = false;
  //   try {
  //     if (await _localAuthentication.canCheckBiometrics) {
  //       try {
  //         isAuthorized = await _localAuthentication.authenticateWithBiometrics(
  //           localizedReason: "Authenticate to Login",
  //           useErrorDialogs: false,
  //           stickyAuth: true,
  //         );
  //       } on PlatformException catch (e) {
  //         print(e);
  //       }
  //     }
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     if (isAuthorized) {
  //       _authorizedOrNot = "Authorized";
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute<Null>(builder: (BuildContext context) {
  //         return new PageSelect(
  //             // user: user, // send info to the homepage
  //             );
  //       }));
  //     } else {
  //       _authorizedOrNot = "Not Authorized";
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _authCheck();
    passwordVisible = false;
  }

  Future<void> _authCheck() async {
    // prefs = await SharedPreferences.getInstance();
    // var id = prefs.getInt('user_id') ?? 0;
    // if (id != 0) {
    //   _authorizeNow();
    // }
  }

  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final img1 = Hero(
      tag: 'mainLogo-tag',
      child: Container(
        height: 250,
        width: 250,
        child: Image.asset(
          "images/mainLogo.png",
          fit: BoxFit.cover,
        ),
      ),
    );

    // final img = Hero(
    //   tag: 'pg',
    //   child: CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     radius: 57.0,
    //     child: Image.asset('assets/images/log.png'),
    //   ),
    // );

    final register = FlatButton(
      child: const Text.rich(
        TextSpan(
          text: 'Not a member? ', // default text style
          children: <TextSpan>[
            TextSpan(
                text: 'Register here.',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    fontSize: 17)),
          ],
        ),
      ),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterPage())),
    );

    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 18.0, right: 18.0),
            children: <Widget>[
              img1,
              // img,
              SizedBox(height: 30.0),
              Container(
                child: new Form(
                    key: formKey,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _usernameFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _usernameFocus, _passwordFocus);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'email',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          controller: _emailController,
                          validator: (value) =>
                              value.isEmpty ? 'Email can\'t be empty' : null,
                          onSaved: (value) => _emailController.text,
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocus,
                          obscureText: (passwordVisible) ? false : true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.vpn_key),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          controller: _passwordController,
                          validator: (value) =>
                              value.isEmpty ? 'Password can\'t be empty' : null,
                          onSaved: (value) => _passwordController.text,
                        ),
                        SizedBox(height: 5.0),
                        Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              // child: FlatButton(
                              //     child: Text(
                              //       'Forgot password?',
                              //       style: TextStyle(color: Colors.black),
                              //     ),
                              //     onPressed: () {
                              //       Navigator.pushNamed(context, '/signUp');

                              //       //  Navigator.push(
                              //       //     context,
                              //       //     MaterialPageRoute(
                              //       //         builder: (context) => Forgotpassword())),
                              //     }),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onPressed: !_isLoading && !guestLogin
                                ? () async {
                                    try {
                                      final form = formKey.currentState;
                                      AuthenticationService authService =
                                          AuthenticationService();
                                      if (form.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        AuthResult result =
                                            await authService.loginWithEmail(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text);
                                        print("result--->" +
                                            result.user.toString());
                                        if (result != null) {
                                          await AuthenticationService.prefs
                                              .setString(
                                                  'user_id', result.user.uid);
                                          await AuthenticationService.prefs
                                              .setBool('login_status', true);
                                          print("user id set in prefs   " +
                                              AuthenticationService.prefs
                                                  .get('user_id'));

                                          Navigator.pushReplacementNamed(
                                              context, '/pageselect');
                                          Fluttertoast.showToast(
                                              msg: "Login successful",
                                              backgroundColor: Colors.grey);
                                        } else {
                                          print(result.toString());
                                          Fluttertoast.showToast(
                                              msg: "Login unsuccessful",
                                              backgroundColor: Colors.grey);
                                        }
                                      }
                                    } catch (e) {
                                      // Fluttertoast.showToast(
                                      //     msg: "Login failed",
                                      //     backgroundColor: Colors.grey);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                : () {},
                            padding: EdgeInsets.all(9),
                            color:  Constants.primaryLight,
                            child: !_isLoading
                                ? Text('Log In',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold))
                                : CircularProgressIndicator(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onPressed: !_isLoading && !guestLogin
                                ? () async {
                                    try {
                                      setState(() {
                                        guestLogin = true;
                                      });
                                      AuthenticationService.prefs =
                                          await SharedPreferences.getInstance();
                                      await AuthenticationService.prefs
                                          .setBool('login_status', false);
                                      Navigator.pushReplacementNamed(
                                          context, '/pageselect');
                                      setState(() {
                                        guestLogin = false;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        guestLogin = false;
                                      });
                                    }
                                  }
                                : () {},
                            padding: EdgeInsets.all(9),
                            color:  Constants.primaryLight,
                            child: !guestLogin
                                ? Text('Guest',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold))
                                : CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    )),
              ),
              register
            ],
          ),
          // isLoading: _isLoading,
          // // opacity: 0.3,
          // progressIndicator: spinkit,
        ),
      ),
    );
  }
}

_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
