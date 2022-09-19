import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/account.dart';
import 'package:horizonuser/pages/home.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:horizonuser/pages/order_made.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:horizonuser/db/crud.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Cash extends StatefulWidget {
  final fname;
  final lname;
  final build_no;
  final sname;
  final reg;
  final city;
  final phone_number;
  final total_price;
  final ph2;
  final note;
  final promo_index;
  const Cash({Key key,this.note, this.ph2,this.total_price,this.fname, this.lname, this.build_no, this.sname, this.reg, this.city, this.phone_number, this.promo_index}) : super(key: key);
  @override
  _CashState createState() => _CashState();
}

class _CashState extends State<Cash> {
  bool internet = true;
  Methods curdObject=new Methods();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(getTranslated(context,"Payment"),
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
            child:main_pay()
        ),

      ),
    );
  }
  Widget main_pay(){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    return Column(
      children: <Widget>[
        Container(
          //margin: EdgeInsets.only(top: 20),
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(getTranslated(context,"Sub-Total"),
                      style: TextStyle(
                        fontSize:17,
                      ),),
                    Row(
                      children: <Widget>[
                        Text("${widget.total_price} ",
                          style: TextStyle(
                            fontSize:17,
                          ),),
                        Text(getTranslated(context,"EGP"),
                          style: TextStyle(
                            fontSize:17,
                          ),),
                      ],
                    ),


                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(getTranslated(context,"+ Delivery"),
                      style: TextStyle(
                        fontSize:17,
                      ),),
                    Text(getTranslated(context,"0 EGP"),
                      style: TextStyle(
                        fontSize:17,
                      ),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(getTranslated(context,"Order Total"),
                      style: TextStyle(
                        fontSize:19,
                        fontWeight: FontWeight.bold,
                      ),),
                    Row(
                      children: <Widget>[
                        Text("${widget.total_price + 0} ",
                          style: TextStyle(
                            fontSize:19,
                            fontWeight: FontWeight.bold,
                          ),),
                        Text(getTranslated(context,"EGP"),
                          style: TextStyle(
                            fontSize:19,
                            fontWeight: FontWeight.bold,
                          ),),
                      ],
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RaisedButton(
                    onPressed: ()async{
                      showLoadingDialog(context, true);
                      curdObject.post_order(widget.total_price, widget.fname, widget.lname, widget.phone_number, widget.city,widget.reg, widget.sname, widget.build_no, widget.phone_number, widget.ph2,widget.note).then((result){
                          Navigator.of(context).pop();
                        if(result){
                            Fluttertoast.showToast(msg:getTranslated(context, 'Order has been made'));
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                              return Order_Made();
                            }
                            ));
                            curdObject.send_notifications();
                            curdObject.decrease_promo(widget.promo_index);
                            //Firestore.instance.collection("notifications-home").document("$shopn $order_no").setData({'approval':false,});
                          }else{
                            Fluttertoast.showToast(msg: getTranslated(context,'Error'));

                          }
                      });
                    },
                    elevation: 0.5,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        getTranslated(context,'Place Order'),
                      ),
                    ),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),




      ],
    );
  }
  showLoadingDialog(BuildContext context,isloading) async {
    if(isloading){
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {return new WillPopScope(onWillPop: () async => false,
              child: SimpleDialog(backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10,),
                        //Text(getTranslated(context,getTranslated(context,"Please Wait....")),style: TextStyle(color: Colors.blueAccent),)
                      ]),
                    )
                  ]));
          });
    }else{
      return "";
    }

  }
}
