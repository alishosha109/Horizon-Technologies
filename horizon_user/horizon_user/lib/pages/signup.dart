import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/login.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horizonuser/db/crud.dart';
import 'package:string_validator/string_validator.dart';
import 'package:horizonuser/pages/account.dart';


class SignUp extends StatefulWidget {

  final internet_status;
  const SignUp({Key key, this.internet_status}): super(key: key);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignUp> {
  bool internet=true;
  String username;
  String password1;
  String password2;
  final _formKey = GlobalKey<FormState>();
  Methods crudobj = new Methods();

  @override
  void initState() {
    setState(() {
      internet=widget.internet_status==null?true:widget.internet_status;

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
        getTranslated(context,'Username or Phone Number'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50.0,
            child: TextFormField(
              onChanged: (value){
                setState(() {
                    username=value;
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
                  Icons.account_circle,
                  color: Colors.white,
                ),
                hintText: getTranslated(context,'Enter your Username or Phone Number'),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return getTranslated(context,"Enter your username or Phone Number");
                }
              },
            ),
          ),
          SizedBox(height: 10),


          Text(
          getTranslated(context,'Password'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50.0,
            child: TextFormField(
              onChanged: (value){
                setState(() {
                  password1 = value;
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
                hintText:getTranslated(context, 'Enter your Password'),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return getTranslated(context,"Enter your Password");
                } else if (value.length <8 ) {
                  return getTranslated(context,"At least 8 characters long");
                }else if(isNumeric(value)){
                  return getTranslated(context,"This password is entirely numeric.");
                }
              },
            ),
          ),
          SizedBox(height: 20),

          Text(
          getTranslated(context,'Confirm Password'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50.0,
            child: TextFormField(
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
                hintText: getTranslated(context,'Renter your Password'),
              ),
              validator: (value) {
                if (value != password1) {
                  return getTranslated(context,"Passwords do not match");
                }
              },
            ),
          ),
          SizedBox(height: 20),


          SizedBox(height: 30),
        ],
      ),
    );
  }



  Widget _buildLoginBtn() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async{
          if(internet){
            if (_formKey.currentState.validate()){
              var log = await crudobj.register(username,password1);
              if(log[0]){
                crudobj.writeuserlogin(username, password1,null);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new MyHomePage()));

              }else{
                if(log[1]['username']!=null){
                  if ( log[1]['username'][0] =="A user with that username already exists." ){
                    Fluttertoast.showToast(msg:getTranslated(context, 'username already exists'));
                  }else{
                    Fluttertoast.showToast(msg:getTranslated(context, 'Password is too common'));
                  }
                }


              }
            }


          }else{
            Fluttertoast.showToast(
                msg:getTranslated(context, 'Check internet Connection'));
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
        getTranslated(context,'SIGN UP'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ConnectivityWidget(
        offlineCallback: (){
          internet=false;
        },
        onlineCallback: (){
          internet=true;
        },
        builder: (context, isOnline) => main_si(),

      ) ,
    );
  }

  Widget main_si(){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));

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
                  vertical: 70.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                  getTranslated(context,"Sign Up"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _buildEmailTF(),
                    _buildLoginBtn(),
                    SizedBox(height: 20,),
                    Text(
                      getTranslated(context,"- OR -"),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return Loginpage();
                        },
                        ),);
                      },
                      child: Text(
                        getTranslated(context,"Sign in"),
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
