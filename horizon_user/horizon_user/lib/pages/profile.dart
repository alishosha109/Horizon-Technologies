import 'package:flutter/material.dart';
import 'package:horizonuser/classes/languages.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/MyOrders.dart';
import 'package:horizonuser/pages/MyWishlist.dart';
import 'package:horizonuser/pages/account.dart';
import 'package:horizonuser/pages/settings.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:horizonuser/db/crud.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:horizonuser/pages/login.dart';
import '../main.dart';
import 'about.dart';

class Profile extends StatefulWidget {
  final internet_status;
  const Profile({Key key, this.internet_status}): super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool internet=true;
  Methods crudobj = new Methods();
  var me;

  @override
  void initState() {
    crudobj.get_user().then((result){
      setState(() {
        me = result;
        internet=widget.internet_status==null?true:widget.internet_status;

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight= MediaQuery.of(context).size.height;
    if(me!=null){
      return Scaffold(
        body: ConnectivityWidget(
          offlineCallback: (){
            internet=false;
          },
          onlineCallback: (){
            internet=true;
          },
          builder: (context, isOnline) => Center(
              child: main_prof(context,screenHeight,me,internet)
          ),

        ) ,
      );
    }else{
      return Center(child: JumpingDotsProgressIndicator(color:Colors.black,fontSize: 40.0,));
    }

  }
}

Widget main_prof(context,screenHeight,me,internet){
  ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
  ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));

  Methods crudobj = new Methods();
  void _changeLanguage(Language language)async{
    Locale _temp= await setLocale(language.languageCode);
    Splash.setLocale(context,_temp);
  }

  return Container(
    //color: Colors.black,
    child: Stack(
      children: <Widget>[
        Container(
          height: screenHeight*0.4 ,
          color: Colors.blue[800],
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: DropdownButton(
                    isExpanded: true,
                    underline: SizedBox(),
                    onChanged: (Language language){
                      _changeLanguage(language);
                    },
                    icon:Icon(
                      Icons.language,
                      color: Colors.white,

                    ),
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>((lang)=>DropdownMenuItem(
                      value: lang,
                      child: Row(
                        children: <Widget>[
                          Text(lang.name),
                        ],
                      ),
                    ),
                    ).toList(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:64),
                child: Column(
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(

                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            child: Icon(Icons.person),
                            backgroundColor:
                            Colors.black87,

                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0,),
                    Text("${me['first_name']==""?me['username']:me['first_name'] + " " + me['last_name']}", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      color: Colors.white,
                    ),
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                      onPressed: (){
                        crudobj.signout();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new Loginpage(internet_status: internet,)));
                      },
                      color: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(getTranslated(context,"Log out"), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white

                      ),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),


        Container(
          margin: EdgeInsets.only(top: screenHeight*0.39),
          decoration: BoxDecoration(
            color: Colors.grey[200],
//color: Color(0xededed),

          ),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            padding: const EdgeInsets.all(10.0),
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
            children: <Widget>[
              InkWell(child:card(Icons.shopping_cart,getTranslated(context,"My Orders")), onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> new MyOrders()));

              },),
              InkWell(child: card(Icons.bookmark,getTranslated(context,"My wishlist")), onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> new WishList()));

              },),
              InkWell(child: card(Icons.call,getTranslated(context,"Contact Us")), onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> new About()));

              },),
              InkWell(child: card(Icons.settings,getTranslated(context,"Settings")), onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> new Settings()));

              },),


            ],

          ),
        ),
      ],
    ),
  );
}


Widget card(icon,name){
  return Card(
      child: Container(
        margin: EdgeInsets.all(4.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 40,
            ),
            SizedBox(height: 20,),
            Text(
              name,
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 15
              ),
            ),
          ],
        ) ,
      ),
    );

}



