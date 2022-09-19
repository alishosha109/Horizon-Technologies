import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    var screenWidth= MediaQuery.of(context).size.width;
    var screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();

          },),
        title: Text(getTranslated(context,"About"),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        //padding: const EdgeInsets.all(8.0),

        color:Colors.black12.withOpacity(0.03),
        child: Stack(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Container(
                    width: screenWidth*1,
                    height: screenHeight*0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue[800].withOpacity(0.15),
                    ),
                    child:
                        Padding(
                          padding: EdgeInsets.fromLTRB(screenWidth*0.01, screenHeight*0.1, screenWidth*0.01, screenHeight*0.01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Text(getTranslated(context,"Horizon Store"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),),
                              ),


                              Center(
                                child: Text(getTranslated(context,"Laptops store"),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),),
                              ),

                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.call,
                                              color: Colors.green,
                                              size: 20.0,
                                            ),
                                            SizedBox(width: 10),
                                            Text("01129652356",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                  onTap: () => launch('tel:01129652356')


                              ),

                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on,
                                              color: Colors.red,
                                              size: 20.0,
                                            ),
                                            SizedBox(width: 10),
                                            Text(getTranslated(context,"Location"),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0,
                                              ),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                  onTap: () => launch('https://www.google.com/maps/dir/?api=1&destination=30.036716627295%2C31.214593648911&fbclid=IwAR230kfQOr247IVpfyjE3ouNLr6iqbz_j-q-Cc12bB7JOI_1AuOeFFHcHPE')
                              ),

                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.mail,
                                              color: Colors.blue,
                                              size: 20.0,
                                            ),
                                            SizedBox(width: 10),

                                            Text("storehorizon2020@gmail.com",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0,
                                              ),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                  onTap: () => launch('mailto:storehorizon2020@gmail.com')

                              ),


                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                      child: Image.asset(
                                        'assets/download.jpg',
                                        height: 30.0,
                                        width: 30.0,
                                      ),
                                      onTap: () => launch('https://www.facebook.com/HorizonTechnology.HT/')
                                  ),

                                ],
                              ),
                              SizedBox(height: 5,),
                              //Divider(thickness: 5,),
                              //SizedBox(height: 20,),
                              /*InkWell(
                                onTap: () => launch('tel:01090113033'),
                                child: Center(
                                  child: Text("Developer: Eng/Ali Shosha - 01090113033",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),),
                                ),
                              ),*/
                            ],
                          ),
                        ),


                  ),
                ),
              ),
            ),

          ],
        ),

      ),

    );
  }
}

