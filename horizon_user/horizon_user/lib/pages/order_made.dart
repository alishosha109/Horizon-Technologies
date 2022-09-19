import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/account.dart';



class Order_Made extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(

            Icons.arrow_back,
            size: 20.0,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => new MyHomePage()));


          },),


      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),

              child: Container(

                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                ),
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: new AssetImage("assets/tick.png"),
                  backgroundColor: Colors.white,


                ),
              ),

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Wrap(children: <Widget>[
              Text(getTranslated(context,"Order has been made successfully :)"),style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),)
            ],),
          )
        ],
      ),

    );
  }
}
