  import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'db/crud.dart';
import 'order_details.dart';


class History extends StatefulWidget {

  final internet_status;

  const History({Key key, this.internet_status}) : super(key: key);
  @override
  _HistoryState createState() => _HistoryState();}

class _HistoryState extends State<History> {
  bool isSearching = false;

  Methods curdObject=new Methods();
  var all_orders;
  bool internet=true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();


  @override
  void initState() {

    curdObject.get_completed().then((results){
      setState(() {
        internet=widget.internet_status==null?true:widget.internet_status;
        all_orders = results;
        print(all_orders.length);
      });

    });


    super.initState();
  }
  @override


  Widget build(BuildContext context) {
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    return
        Scaffold(
          appBar: AppBar(
            title: Text(" History "),

            backgroundColor: Colors.blue[800],
          ),
          body:ConnectivityWidget(
            offlineCallback: (){
              internet=false;
            },
            onlineCallback: (){
              internet=true;
            },
            builder: (context, isOnline) => Stack(
              children: <Widget>[
                Center(
                  child: _orderslist(context),
                ),
              ],
            ),
          ),
          //backgroundColor: Colors.black12,

        );

  }

  Widget _orderslist(BuildContext context) {
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    if (all_orders != null ) {
      if(all_orders.length != 0){
        return RefreshIndicator(
          onRefresh: refreshList2,
          child: ListView.builder(
              itemCount: all_orders.length,
              itemBuilder: (BuildContext context, int index) {
                return  order(
                    total_price: all_orders[index]['total_price'],
                    date_of_order: all_orders[index]['date_of_order'],
                    completed: all_orders[index]['completed'],
                    delivery_fees: all_orders[index]['delivery_fees'],
                    id: all_orders[index]['id'],
                    products: all_orders[index]['products'],
                    type:all_orders[index]["Type"],
                  );
              }),
        );
      }else{
        return Center(child: Text("No orders"));
      }

    } else {
      return JumpingDotsProgressIndicator(
        fontSize: 20.0,
      );
    }
  }


  Future<Null> refreshList2() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(milliseconds: 500));

    curdObject.get_completed().then((results){
      setState(() {
        internet=widget.internet_status==null?true:widget.internet_status;
        all_orders = results;
        print(all_orders.length);
      });

    });
    return null;
  }


}


class order extends StatelessWidget {
  final date_of_order;
  final total_price;
  final id;
  final completed;
  final delivery_fees;
  final products;
  final type;
  Methods crudObject = new Methods();

  order({Key key, this.date_of_order, this.total_price, this.id, this.completed, this.delivery_fees, this.products, this.type}) : super(key: key);



  @override
  Widget build(BuildContext context) {
      return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {return Receipt(id: id,);}));
          },
          child: Card(
            elevation: 2,
            child: ListTile(
              title: Text(
                "$id",
                style: TextStyle(
                    fontWeight: FontWeight.w600
                ),
              ),
              subtitle: Text("$date_of_order"),

            ),
          ),
        );
    }

  }

