import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/product_page.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:horizonuser/db/crud.dart';

class Receipt extends StatefulWidget {
  final internet_status;
  final id;

  const Receipt({Key key, this.internet_status, this.id}) : super(key: key);
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {

  Methods curdObject=new Methods();
  var order;
  var products;
  var order2;
  bool internet = true;

  @override
  void initState() {

    curdObject.get_sp_order(widget.id).then((result){

      curdObject.getorderproducts(result[0]['products']).then((result2){
        setState(() {
          order= result[0];
          order2=result[1];
          products = result2;
          internet=widget.internet_status==null?true:widget.internet_status;

        });
      });

    });



    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.blue[800],

        title: Text(getTranslated(context,"Order Details"),
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
            child:single_ord()
        ),

      ),
    );
  }

  Widget single_ord(){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));

    if(order!=null){
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //margin: EdgeInsets.only(top: 20),
                height: 100,
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
                        children: <Widget>[
                          Text(getTranslated(context,"Order ID:"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:17,
                            ),),
                          Text("${order['id']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:17,
                            ),),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(getTranslated(context,"Date: "),
                            style: TextStyle(
                              fontSize:14,
                              color: Colors.black.withOpacity(0.5),
                            ),), Text("${order['date_of_order']} ",
                            style: TextStyle(
                              fontSize:14,
                              color: Colors.black.withOpacity(0.5),
                            ),),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(getTranslated(context,"Total: "),
                            style: TextStyle(
                              fontSize:14,
                              color: Colors.black.withOpacity(0.5),
                            ),),Text(" ${order['total_price']} ",
                            style: TextStyle(
                              fontSize:14,
                              color: Colors.black.withOpacity(0.5),
                            ),),
                        ],
                      ),

                    ],
                  ),
                ),

              ),
            ),
            SizedBox(height: 5),
            Container(
              //margin: EdgeInsets.only(top: 20),
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(getTranslated(context,"Order Details"),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize:16,
                  ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                children: <Widget>[
                  for(var i in products) product("${i['brand']} ${i['model_id']} ${i['Type']} - ${i['processor']}, ${i['ram']} GB RAM, ${i['hard_disk_hdd']} HDD ${i['hard_disk_ssd']} SSD", "${i['price']}","${i['id']}","${i['img1url']}","${i['new_price']}"),
                ],
              )
            ),
            Container(
              //margin: EdgeInsets.only(top: 20),
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(getTranslated(context,"Delivery"),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize:16,
                  ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //margin: EdgeInsets.only(top: 20),
                height: 80,
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
                      Text(getTranslated(context,"Payment Method"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:17,
                        ),),
                      Text(getTranslated(context, "${order['Type']}"),
                        style: TextStyle(
                          fontSize:14,
                          color: Colors.black.withOpacity(0.5),
                        ),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //margin: EdgeInsets.only(top: 20),
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(getTranslated(context,"Shipping Information"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:17,
                            ),),
                          Text("${order2.split(",")[8].split(":")[1].substring(1,(order2.split(",")[8].split(":")[1]).length-1)}",
                            style: TextStyle(
                              fontSize:14,
                              color: Colors.black.withOpacity(0.5),
                            ),),
                          Text("${order2.split(",")[10].split(":")[1].substring(1,(order2.split(",")[10].split(":")[1]).length-1)}",
                            style: TextStyle(
                              fontSize:14,
                              color: Colors.black.withOpacity(0.5),
                            ),),
                          Text("${order2.split(",")[11].split(":")[1].substring(1,(order2.split(",")[11].split(":")[1]).length-1)}",
                            style: TextStyle(
                              fontSize:14,
                              color: Colors.black.withOpacity(0.5),
                            ),),
                          Text("${order2.split(",")[12].split(":")[1].substring(1,(order2.split(",")[12].split(":")[1]).length-1)}",
                            style: TextStyle(
                              fontSize:14,
                              color: Colors.black.withOpacity(0.5),
                            ),),
                          Text("${order2.split(",")[13].split(":")[1].substring(1,(order2.split(",")[13].split(":")[1]).length-1)}",
                            style: TextStyle(
                              fontSize:14,
                              color: Colors.black.withOpacity(0.5),
                            ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //margin: EdgeInsets.only(top: 20),
                height: 100,
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
                      Text(getTranslated(context,"Shipping Status"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:17,
                        ),),
                      Text(getTranslated(context,"${order['completed'] ? "Completed" : "Pending"}"),
                        style: TextStyle(
                          fontSize:14,
                          color: Colors.black.withOpacity(0.5),
                        ),),
                      Text("${order['completed'] ? "" : getTranslated(context, "Your order will arrive in 3 or 4 days")}",
                        style: TextStyle(
                          fontSize:14,
                          color: Colors.black.withOpacity(0.5),
                        ),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),

          ],
        ),
      );
    }else{
      return Center(child: JumpingDotsProgressIndicator(fontSize: 20.0,));

    }

  }

Widget product(String name, String price,id,img, String new_price){
  return  Stack(
    children: <Widget>[
      InkWell(
        child: Container(
          margin: EdgeInsets.fromLTRB(40.0, 5.0, 0.0, 5.0),
          height: 170.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 231.0,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        //overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20.0),


                Container(
                  padding: EdgeInsets.all(5.0),
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue[800].withOpacity(.4),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      new_price!="0"?Text(
                        price,
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ):Container(),
                      Text(
                        "${new_price!="0"?new_price:price} ${getTranslated(context,"EGP")}",
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
            return ProductPage(id: id,);
          }
          ));
        },
      ),
      Positioned(
        left: 20.0,
        top: 15.0,
        bottom: 15.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image(
            width: 110.0,
            image: NetworkImage(img),

          ),
        ),
      ),
    ],
  );
}
}
