import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/account.dart';
import 'package:horizonuser/pages/signup.dart';
import 'package:horizonuser/db/crud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Loginpage extends StatefulWidget {
  final internet_status;
  const Loginpage({Key key, this.internet_status}) : super(key: key);
  static String userid;
  static String userid2;
  static String usertoken;
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  bool internet = true;
  Methods crudobj = new Methods();
  String username;
  String password;

  @override
  void initState() {
    setState(() {
      internet = widget.internet_status == null ? true : widget.internet_status;
    });
    super.initState();
  }

  Widget _buildEmailTF() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            getTranslated(context, 'Username or Phone Number'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50.0,
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintText: getTranslated(
                    context, 'Enter your Username or Phone Number'),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return getTranslated(
                      context, 'Enter your Username or Phone Number');
                }
              },
            ),
          ),
          Text(
            getTranslated(context, 'Password'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50.0,
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: true,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: getTranslated(context, 'Enter your Password'),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return getTranslated(context, 'Enter your Password');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

/*  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
        ),
      ),
    );
  }*/

  /*Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
          ),
        ],
      ),
    );
  }*/

  Widget _buildLoginBtn(key) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (internet) {
            if (key.currentState.validate()) {
              bool log = await crudobj.login(username, password);
              if (log) {
                crudobj.writeuserlogin(username, password, null);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new MyHomePage(
                              internet_status: internet,
                            )));
              } else {
                Fluttertoast.showToast(
                    msg: getTranslated(context, 'Wrong username or password'));
              }
            }
          } else {
            Fluttertoast.showToast(
                msg: getTranslated(context, 'Check internet Connection'));
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          getTranslated(context, 'LOGIN'),
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          getTranslated(context, '- OR -'),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          getTranslated(context, 'Sign in with'),
        ),
      ],
    );
  }

  Widget _buildSocialBtn(AssetImage logo) {
    FacebookLogin fbLogin = new FacebookLogin();

    return GestureDetector(
      onTap: () async {
        if (internet) {
          fbLogin.logIn(['email', 'public_profile']).then((result) async {
            switch (result.status) {
              case FacebookLoginStatus.loggedIn:
                var token = result.accessToken.token;
                print(token);
                await crudobj.rigesterbyfb(token).then((result) async {
                  if (result[0]) {
                    crudobj.writeuserlogin("", "", token);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new MyHomePage(
                                  internet_status: internet,
                                )));
                  } else {
                    Fluttertoast.showToast(
                        msg: getTranslated(context, 'An Error Occured'));
                  }
                });
                break;
              case FacebookLoginStatus.cancelledByUser:
                print('Cancelled by you');
                break;
              case FacebookLoginStatus.error:
                Fluttertoast.showToast(
                    msg: getTranslated(context, 'No internet connection'));
                break;
            }
          }).catchError((e) {
            print(e);
          });
        } else {
          Fluttertoast.showToast(
              msg: getTranslated(context, 'No internet connection'));
        }
      },
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return SignUp();
            },
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: getTranslated(context, 'Don\'t have an Account? '),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: getTranslated(context, 'Sign Up'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConnectivityWidget(
        offlineCallback: () {
          internet = false;
        },
        onlineCallback: () {
          internet = true;
        },
        builder: (context, isOnline) => Center(child: main_login()),
      ),
    );
  }

  Widget main_login() {
    ConnectivityUtils.instance.setServerToPing(
        "https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance
        .setCallback((response) => response.contains("This is a test!"));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73AEF5),
                    Color(0xFF61A4F1),
                    Color(0xFF478DE0),
                    Color(0xFF398AE5),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 80.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      getTranslated(context, 'Sign In'),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _buildEmailTF(),
                    SizedBox(
                      height: 20.0,
                    ),
                    //_buildForgotPasswordBtn(),
                    _buildLoginBtn(_formKey),
                    _buildSignInWithText(),
                    _buildSocialBtnRow(),
                    _buildSignupBtn(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
