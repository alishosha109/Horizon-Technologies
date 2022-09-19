import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:horizonadminn/classes/language.dart';
import 'package:horizonadminn/history.dart';
import 'package:horizonadminn/orders.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'db/crud.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new Dashboard(

      ),
    );
  }
}


class Dashboard extends StatefulWidget {

  final internet_status;

  const Dashboard({Key key, this.internet_status}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Methods curdObject=new Methods();
  var all_products;
  var all_orders;
  var all_users;
  var not_completed;
  bool internet=true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();


  @override
  void initState() {
    curdObject.add_token();
    curdObject.get_products().then((results){
      setState(() {
        all_products = results;
      });
    });
    curdObject.get_orders().then((results){
      setState(() {
        all_orders = results;
      });

    });

    curdObject.get_users().then((results){
      setState(() {
        all_users = results;
      });

    });

    curdObject.get_not_completed().then((results){
      setState(() {
        not_completed = results;
      });

    });


    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ConnectivityWidget(
        offlineCallback: (){
          internet=false;
        },
        onlineCallback: (){
          internet=true;
        },
        builder: (context, isOnline) => Center(
            child: body(context)
        ),

      ),

    );
  }

  Widget body(BuildContext context){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    var size = MediaQuery.of(context)
        .size;

    if (all_products != null && all_orders != null && all_users != null && not_completed!=null) {

      return RefreshIndicator(
        onRefresh: refreshList2,
        child: Stack(
          children: <Widget>[
            Container(
              // Here the height of the container is 45% of our total height
              height: size.height * .33,
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(height: size.height*0.05,),
                  Align(
                    alignment: Alignment.topLeft,

                  ),
                  Text(
                    " Dashboard",
                    style:

                    Theme
                        .of(context)
                        .textTheme
                        .display1
                        .copyWith(
                        fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  SizedBox(
                    height: size.height*0.05,
                  ),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .74,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      children: <Widget>[
                        InkWell(

                          child: CategoryCard(
                            title: "Orders",
                            col: Colors.green,
                            no: all_orders.length,
                          ),
                          onTap: (){

                          },

                        ),
                        InkWell(
                          child: CategoryCard(
                            title: "  Products",
                            col: Colors.green,
                            no: all_products.length,
                          ),
                          onTap: (){
                            curdObject.get_token();
                                curdObject.add_token();
                          },
                        ),
                        InkWell(
                          child: CategoryCard(
                            title: "Pending Requests",
                            col:Colors.green,
                            no:not_completed.length
                          ),
                          onTap: (){

                          },
                        ),
                        InkWell(
                          child: CategoryCard(
                            title: "Registered Customers",
                            col: Colors.green,
                            no: all_users.length-1,
                          ),
                          onTap: (){

                          },
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );

    }else{
      return JumpingDotsProgressIndicator(
        fontSize: 20.0,
      );
    }

  }

  Future<Null> refreshList2() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(milliseconds: 500));

    curdObject.get_products().then((results){
      setState(() {
        all_products = results;
      });
    });
    curdObject.get_orders().then((results){
      setState(() {
        all_orders = results;
      });

    });

    curdObject.get_users().then((results){
      setState(() {
        all_users = results;
      });

    });

    curdObject.get_not_completed().then((results){
      setState(() {
        not_completed = results;
      });

    });
    return null;
  }
}
class CategoryCard extends StatelessWidget {
  final String title;
  final Color col;
  final int no;

  const CategoryCard({
    Key key, this.title, this.col, this.no,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -15,
            ),
          ],

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$no",
              textAlign: TextAlign.center,
              style:TextStyle(fontSize: 30,
                fontWeight: FontWeight.bold,
                color: col,
              ) ,
            ),
            SizedBox(height: 10,),

            Text(title,
              textAlign: TextAlign.center,
              style:TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }}