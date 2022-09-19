import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:horizonadminn/product_page.dart';
import 'db/crud.dart';
import 'package:progress_indicators/progress_indicators.dart';



class ProductList extends StatefulWidget {
  //final Destination destination;
  final internet_status;

  const ProductList({Key key, this.internet_status}) : super(key: key);

  //MyApp({this.destination});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Methods curdObject=new Methods();
  var all_products;



  bool internet=true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    curdObject.get_products().then((results){
      setState(() {
        all_products = results;
      });
    });




    super.initState();
  }



  @override

  Widget build(BuildContext context) {
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black12.withOpacity(0.05),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[800],
        actions: <Widget>[
          new Container()
        ],
        title: Text("Laptops",
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
            child: _orderslist(context)
        ),

      ),
    );
  }
  Widget _orderslist(BuildContext context) {
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    if (all_products != null ) {
      if(all_products.length != 0){


        return RefreshIndicator(
            onRefresh: refreshList2,
            child: ListView(children: <Widget>[
              Column(children: <Widget>[
                for(var i in all_products) product("${i['brand']} ${i['model_id']} ${i['Type']} - ${i['processor']}, ${i['ram']} GB RAM, ${i['hard_disk_hdd']} HDD ${i['hard_disk_ssd']} SSD", "${i['price']} EGP","${i['id']}","${i['img1url']}"),

              ],)
            ],)
        );
      }else{
        return Center(child: Text("No Products"));
      }

    } else {
      return JumpingDotsProgressIndicator(
        fontSize: 20.0,
      );
    }
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
                        Text("Please Wait....",style: TextStyle(color: Colors.blueAccent),)
                      ]),
                    )
                  ]));
          });
    }else{
      return "";
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
    return null;
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();

      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        curdObject.get_products().then((result){
          Navigator.of(context).pop();
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> new ProductList(internet_status: internet,)));
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Clear liked stores"),
      content: Text("Are you sure you want to clear liked stores ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _showCircularProgress(bool loading) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }




  Widget product(String name, String price,id,img){
    var screenWidth= MediaQuery.of(context).size.width;
    var screenHeight= MediaQuery.of(context).size.height;

    return  Stack(
      children: <Widget>[
        InkWell(
          child: Container(
            margin: EdgeInsets.fromLTRB(screenWidth*0.1, screenHeight*0.01, screenWidth*0.05, screenHeight*0.01),
            height:screenHeight*0.25 ,
            width: double.infinity,
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
                    child: Text(
                      price,
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
          onLongPress: (){
            showAlertDialog2(context, id);
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


  showAlertDialog2(BuildContext context,id) {

    // set up the buttons
    Widget remindButton = FlatButton(
      child: Text("Remove"),
      onPressed:  () async{
        curdObject.delete_pro(id).then((result){
          curdObject.get_products().then((results){
            setState(() {
              all_products = results;
              Navigator.of(context).pop();
            });
          });
        });
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Decrease qnt."),
      onPressed:  () async{
        curdObject.decrease_quantity(id).then((result){
          curdObject.get_products().then((results){
            setState(() {
              all_products = results;
              Navigator.of(context).pop();
            });
          });
        });
      },
    );
    Widget launchButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Delete product or decrease qnt. ?"),
      actions: [
        remindButton,
        cancelButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}


