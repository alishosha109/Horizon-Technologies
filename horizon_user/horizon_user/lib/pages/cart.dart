import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/orderSummery.dart';
import 'package:horizonuser/pages/addAddress.dart';
import 'package:horizonuser/pages/order_made.dart';
import 'package:horizonuser/pages/product_page.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:horizonuser/db/crud.dart';


class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  Methods curdObject=new Methods();

  var pros;
  var total_price;
  bool internet = true;

  @override
  void initState() {
    curdObject.get_cart().then((result){
      curdObject.getorderproducts(result).then((result2){
        curdObject.get_total_price(result2).then((result3){
          setState(() {
            pros = result2;
            total_price = result3;
          });
        });

      });

    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading: Container(),
        title: Text(getTranslated(context,"My Cart"),
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
            child:main_cart()
        ),

      ),
    );
  }


  Widget main_cart(){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));

    if(pros!=null ){
      if(pros.isEmpty){
        return Center(child: Text(getTranslated(context,"No items in the cart")),);
      }else{
        return ListView(
          //shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                for(var i in pros) product("${i['brand']} ${i['model_id']} ${i['Type']} - ${i['processor']}, ${i['ram']} GB RAM, ${i['hard_disk_hdd']} HDD ${i['hard_disk_ssd']} SSD", "${i['price']} ","${i['id']}","${i['img1url']}","${i['new_price']}"),


              ],
            ),Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 60.0,
                width: double.infinity,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(getTranslated(context,"Sub-Total:"),
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 0.3,

                            ),
                          ),Text('$total_price',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 0.3,

                            ),
                          ),Text(getTranslated(context,"EGP"),
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 0.3,

                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                              return AddressInfo(total_price: total_price,);
                            }
                            ));
                          },
                          elevation: 0.5,
                          color: Colors.red,
                          child: Center(
                            child: Text(
                                getTranslated(context,'Complete Order'),
                            ),
                          ),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }

    }else{
      return JumpingDotsProgressIndicator(fontSize: 20.0,);

    }

  }
  Widget product(String name, String price,id,img, String new_price){
    var screenWidth= MediaQuery.of(context).size.width;
    var screenHeight= MediaQuery.of(context).size.height;

    return  Stack(
      children: <Widget>[
        InkWell(
          child: Container(
            margin: EdgeInsets.fromLTRB(screenWidth*0.1, screenHeight*0.01, screenWidth*0.05, screenHeight*0.01),
            height:screenHeight*0.25 ,
            //width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(screenWidth*0.25, screenHeight*0.03,screenHeight*0.03, screenHeight*0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(

                    children: <Widget>[
                      Container(
                        width: screenWidth*0.55,

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
              return ProductPage(id: id,internet_status: internet,);
            }
            ));
          },
        ),
        Positioned(
          left: screenWidth*0.04,
          top: screenHeight*0.02,
          bottom: screenHeight*0.02,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              width: screenWidth*0.27,
              image: NetworkImage("$img"),

            ),
          ),
        ),

      ],
    );
  }
}