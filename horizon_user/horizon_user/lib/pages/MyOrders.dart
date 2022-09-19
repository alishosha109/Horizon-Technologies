import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/profile.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:horizonuser/db/crud.dart';
import 'orderSummery.dart';
import 'package:progress_indicators/progress_indicators.dart';


class MyOrders extends StatefulWidget {
  final internet_status;

  const MyOrders({Key key, this.internet_status}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  Methods curdObject=new Methods();
  var orders;
  bool internet = true;

  @override
  void initState() {

    curdObject.get_orders().then((result){
      setState(() {
        orders= result;
        internet=widget.internet_status==null?true:widget.internet_status;

      });
    });



    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(      backgroundColor: Colors.grey[200],

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
        title: Text(getTranslated(context,"My Orders"),
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
            child:main_orders()
        ),

      ),
    );
  }


  Widget main_orders(){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));

    if(orders!=null){
      if(orders.isNotEmpty){
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  for(var i in orders) _buildItem("${i['id']}", "${i['total_price']} EGP")

                ],
              ),
            ),
          ],
        );
      }else{
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildItem(getTranslated(context,"No Active Orders"), ""),


                ],
              ),
            ),
          ],
        );
      }


    }else{
      return Center(child: JumpingDotsProgressIndicator(fontSize: 20.0,));


    }

  }

  Widget _buildItem(String item, String details) {
    return InkWell(
      onTap: () {
        details!=""?Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return Receipt(id:item,internet_status: internet,);
            }
            )):(){};
      },
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Text(
            item,
            style: TextStyle(
                fontWeight: FontWeight.w600
            ),
          ),
          subtitle: Text(details),

        ),
      ),
    );
  }
}