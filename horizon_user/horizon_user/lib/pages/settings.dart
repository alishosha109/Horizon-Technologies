import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/profile.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:horizonuser/db/crud.dart';
import 'package:horizonuser/pages/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatefulWidget {
  final internet_status;
  const Settings({Key key, this.internet_status}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Methods crudobj = new Methods();
  var org_email;
  var org_fname;
  var org_lname;
  var change_email;
  var change_fname;
  var chenge_lname;
  var me;
  bool internet = true;


  @override
  void initState() {
    crudobj.get_user().then((result){
      setState(() {
        me = result;
        internet=widget.internet_status==null?true:widget.internet_status;
        org_fname = me['first_name'];
        org_lname = me['last_name'];
        org_email = me['email'];
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading:IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
          ),
          onPressed: (){
            Navigator.of(context).pop();

          },        ) ,
        title: Text(getTranslated(context,"Settings"),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ConnectivityWidget(
        offlineCallback: (){
          internet=false;
        },
        onlineCallback: (){
          internet=true;
        },
        builder: (context, isOnline) => Center(
            child:main_settings()
        ),

      ),
    );
  }

  Widget main_settings(){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    var screenWidth= MediaQuery.of(context).size.width;
    var screenHeight= MediaQuery.of(context).size.height;
    if(me!=null){
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Wrap(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(Icons.person),
                      radius:30.0,
                    ),
                    SizedBox(width: 20,),
                    Text("${org_fname=="" ?me['username']:org_fname + " " + org_lname}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth*0.04,
                      ),)
                  ],
                ),
              ],
            ),
            Text(
                getTranslated(context,"Email"),
                style: TextStyle(
                  color: Colors.grey,
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text(
                        '${org_email==""?"No Email":org_email}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth*0.045,
                        )
                    ),
                  ),
                ),
                IconButton(
                  icon:Icon(
                    Icons.edit,
                    color: Colors.grey[400],
                  ),
                  onPressed: (){
                    if(internet){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            content: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  change_email = value;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: getTranslated(context,"Enter New Email"),
                                  icon: Icon(Icons.phone),
                                  border: InputBorder.none),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(getTranslated(context,"Apply")),
                                onPressed: () {
                                  crudobj.editemail(change_email).then((result){
                                    setState(() {
                                      org_email=change_email;
                                    });
                                    Navigator.of(context).pop();
                                  });


                                },

                              ),
                              FlatButton(
                                child: Text(getTranslated(context,"Cancel")),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },

                              ),
                            ],
                          );

                        },
                      );
                    }else{
                      Fluttertoast.showToast(
                          msg: getTranslated(context,"No internet Connetion"));
                    }
                  },
                ),
              ],
            ),

              Text(
    getTranslated(context,"First Name"),
                style: TextStyle(
                  color: Colors.grey,
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(
                      '${org_fname==""?"No Firstname":org_fname}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth*0.045,
                      )
                  ),
                ),
                IconButton(
                  icon:Icon(
                    Icons.edit,
                    color: Colors.grey[400],
                  ),
                  onPressed: (){

                    if(internet){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            content: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  change_fname = value;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText:getTranslated(context, "Enter First Name"),
                                  icon: Icon(Icons.person),
                                  border: InputBorder.none),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(getTranslated(context,"Apply")),
                                onPressed: () {
                                  crudobj.edit_first_name(change_fname).then((result){
                                    setState(() {
                                      org_fname=change_fname;
                                    });
                                    Navigator.of(context).pop();
                                  });


                                },

                              ),
                              FlatButton(
                                child: Text(getTranslated(context,"Cancel")),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },

                              ),
                            ],
                          );

                        },
                      );
                    }else{
                      Fluttertoast.showToast(
                          msg: getTranslated(context,"No internet Connetion"));
                    }
                  },
                ),
              ],
            ),
            Text(
    getTranslated(context,"Last Name"),
                style: TextStyle(
                  color: Colors.grey,
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(
                      '${org_lname==""?"No Lastname":org_lname}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth*0.045,
                      )
                  ),
                ),
                IconButton(
                  icon:Icon(
                    Icons.edit,
                    color: Colors.grey[400],
                  ),
                  onPressed: (){

                    if(internet){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            content: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  chenge_lname = value;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText:getTranslated(context, "Enter Last Name"),
                                  icon: Icon(Icons.person),
                                  border: InputBorder.none),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(getTranslated(context,"Apply")),
                                onPressed: () {
                                  crudobj.edit_last_name(chenge_lname).then((result){
                                    setState(() {
                                      org_lname=chenge_lname;
                                    });
                                    Navigator.of(context).pop();
                                  });


                                },

                              ),
                              FlatButton(
                                child: Text(getTranslated(context,"Cancel")),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },

                              ),
                            ],
                          );

                        },
                      );
                    }else{
                      Fluttertoast.showToast(
                          msg: getTranslated(context,"No internet Connetion"));
                    }


                  },
                ),
              ],
            ),
            Divider(
              height: 20.0,
              color: Colors.grey[800],
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: InkWell(
                child: Text(getTranslated(context,"Sign out"),style: TextStyle(
                  fontWeight: FontWeight.w100,
                ),),
                onTap: (){
                  crudobj.signout();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new Loginpage(internet_status: internet,)));

                },
              ),
            ),
          ],
        ),
      );
    }else{
      return Center(
        child: JumpingDotsProgressIndicator(
          fontSize: 20.0,
        ),
      );
    }

  }
}
