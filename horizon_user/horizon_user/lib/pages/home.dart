import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/about.dart';
import 'package:horizonuser/pages/product_page.dart';
import 'package:horizonuser/pages/search.dart';
import 'package:horizonuser/db/crud.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {

  final internet_status;

  const Home({Key key, this.internet_status}) : super(key: key);

  @override
  State<StatefulWidget> createState()=> _HomeState();
}

class _HomeState extends State<Home> {
  var _tapped = false;
  Methods curdObject=new Methods();
  bool internet=true;

  var recent_products;

  @override
  void initState() {
    curdObject.uploadfavs();
    curdObject.get_products().then((results){
      setState(() {
        internet=widget.internet_status==null?true:widget.internet_status;
        recent_products = results;
      });

    });


    super.initState();
  }


  @override
  Widget build (BuildContext context){


    return Scaffold(      backgroundColor: Colors.grey[200],

      body: ConnectivityWidget(
          offlineCallback: (){
            internet=false;
          },
          onlineCallback: (){
            internet=true;
          },
          builder: (context, isOnline) => Center(
              child: main_w()
          ),

        ),
    );
  }

  Widget main_w(){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    var screenHeight= MediaQuery.of(context).size.height;

    return ListView(
      children: <Widget>[Container(
        margin: EdgeInsets.only(top:20.0,right: 20.0,left: 20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(getTranslated(context,'Horizon Store'),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                  InkWell(
                    child: CircleAvatar(
                      backgroundImage: new AssetImage("assets/hor.jpg"),
                      backgroundColor:
                      Colors.black87,
                      radius: 40,

                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                        return About();
                      }
                      ));
                    },                ),
                ],
              ),
              SizedBox(
                height: screenHeight*0.04,
              ),
              Text(getTranslated(context,"Discover"),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(
                height: screenHeight*0.03,
              ),
              Text(
                getTranslated(context,"Suitable Laptop"),
                style: TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(
                height:screenHeight*0.04,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[800].withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.search, color: Colors.black.withOpacity(0.3),size: 16,),
                              SizedBox(
                                width: 10,
                              ),
                              Text(getTranslated(context,"Find a laptop"),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: 15
                                ),),
                            ],
                          ),
                        ),


                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Search()));

                      },
                    ),

                  ),
                ],
              ),

              SizedBox(
                height: screenHeight*0.06,
              ),
              Text(getTranslated(context,"  Recently Added Laptops"),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),),
              SizedBox(
                height: screenHeight*0.03,
              ),
              Container(
                height: screenHeight*0.400,
                child: recent_products==null? JumpingDotsProgressIndicator(fontSize: 20.0,):recent_products.length >4?ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    homeWidget("${recent_products[0]['brand']} ${recent_products[0]['Type']} ${recent_products[0]['model_id']}", "${recent_products[0]['price']}",recent_products[0]['id'],recent_products[0]['img1url'],"${recent_products[0]['new_price']}"),
                    homeWidget("${recent_products[1]['brand']} ${recent_products[1]['Type']} ${recent_products[1]['model_id']}", "${recent_products[1]['price']}",recent_products[1]['id'],recent_products[1]['img1url'],"${recent_products[1]['new_price']}"),
                    homeWidget("${recent_products[2]['brand']} ${recent_products[2]['Type']} ${recent_products[2]['model_id']}", "${recent_products[2]['price']}",recent_products[2]['id'],recent_products[2]['img1url'],"${recent_products[2]['new_price']}"),
                    homeWidget("${recent_products[3]['brand']}  ${recent_products[3]['Type']} ${recent_products[3]['model_id']}", "${recent_products[3]['price']}",recent_products[3]['id'],recent_products[3]['img1url'],"${recent_products[3]['new_price']}"),


                  ],
                ): ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    for ( int i=0 ;i<recent_products.length;i++ ) homeWidget("${recent_products[i]['brand']} ${recent_products[i]['Type']} ${recent_products[i]['model_id']}", "${recent_products[i]['price']}",recent_products[i]['id'],recent_products[i]['img1url'], "${recent_products[i]['new_price']}")


                  ],

                ),

              )
            ]),
      ),],
    );
  }
  Widget homeWidget(String name, String price,id,img1, String new_price){
    var screenHeight= MediaQuery.of(context).size.height;
    var screenWidth= MediaQuery.of(context).size.width;


    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return ProductPage(id: id,);
        }
        ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: 220.0,
        height: 325.0,
        child: Stack(
          children: <Widget>[
                Container(
                width: 220.0,
                height: screenHeight*0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(

                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(img1),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            /*Positioned(
              bottom: 0,
              right: 5,
              child:FloatingActionButton(
                    heroTag: null ,
                    mini: true,
                    backgroundColor: Colors.blue[800].withOpacity(0.9),
                    child: Icon(
                      _tapped? Icons.bookmark:Icons.bookmark_border,
                      size: 18,
                    ),
                  onPressed: (){
                      setState(() {
                          _tapped=!_tapped;
                      });
                  },
                  ),
            ),*/
            Positioned(
              bottom: screenHeight*0.01,
              left: 20,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name,
                    style: TextStyle(
                      color: Colors.blue[800],
                      //fontWeight: FontWeight.bold,
                    ),
                  ),


                  Wrap(
                    children: <Widget>[
                      //Icon(Icons.attach_money, color: Colors.white,),
                      Text("${new_price!="0"?price:""}",
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text("${new_price!="0"?new_price:price} ${getTranslated(context,"EGP")} ",
                        style: TextStyle(
                          color: Colors.black,
                          //decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width:screenWidth*0.1),
                      new_price!="0"?
                      Container(
                        padding: EdgeInsets.all(2),
                        color: Colors.blue[800].withOpacity(0.5),
                        child: Text("${"${(100-(int.parse(new_price)/int.parse(price))*100).round()}%"}",
                          style: TextStyle(
                            color: Colors.black,

                          ),
                        ),
                      ):
                      Container(),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
