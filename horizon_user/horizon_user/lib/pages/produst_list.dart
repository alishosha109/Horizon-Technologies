import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/product_page.dart';
import 'package:horizonuser/db/crud.dart';
import 'category.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'package:fluttertoast/fluttertoast.dart';


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
  var brands_org;
  List<DropdownMenuItem<String>> brands=[];
  var colors_org;
  List<DropdownMenuItem<String>> colors=[];
  var hdd_org;
  List<DropdownMenuItem<String>> hdd=[];
  var ssd_org;
  List<DropdownMenuItem<String>> ssd=[];
  var screens_org;
  List<DropdownMenuItem<String>> screens=[];
  var proc_org;
  List<DropdownMenuItem<String>> proc=[];
  var rams_org;
  List<DropdownMenuItem<String>> rams=[];
  var gcards_org;
  List<DropdownMenuItem<String>> gcards=[];
  var open = false;

  var chosed_brand;
  var chosed_color;
  var chosed_hdd;
  var chosed_ssd;
  var chosed_screen;
  var chosed_proc;
  var chosed_ram;
  var chosed_gcards;
  bool internet=true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    curdObject.uploadfavs();
    curdObject.get_products().then((results){
      setState(() {
        all_products = results;
      });
    });
    curdObject.get_colors().then((r1){
      curdObject.get_rams().then((r2){
        curdObject.get_hdds().then((r3){
          curdObject.get_ssds().then((r4){
            curdObject.get_gcards().then((r5){
              curdObject.get_ssizes().then((r6){
                curdObject.get_brands().then((r7){
                  curdObject.get_proc().then((r8){

                      setState(() {
                        internet=widget.internet_status==null?true:widget.internet_status;
                        colors_org=r1;
                        rams_org=r2;
                        hdd_org = r3;
                        ssd_org = r4;
                        gcards_org = r5;
                        screens_org = r6;
                        brands_org = r7;
                        proc_org = r8;
                        load_info();
                        if(open){
                          _scaffoldKey.currentState.openEndDrawer();

                        }
                      });


                  });
                });
              });
            });
          });
        });
      });
    });



    super.initState();
  }

  load_info(){
    colors=[];
    rams=[];
    hdd=[];
    ssd=[];
    gcards=[];
    screens=[];
    brands=[];
    proc=[];

    setState(() {
      brands_org.forEach((item){
        brands.add(new DropdownMenuItem(
          child: new Text("${item['name']}"),
          value: "${item['name']}",
        ));
      });
      colors_org.forEach((item){
        colors.add(new DropdownMenuItem(
          child: new Text("${item['name']}"),
          value: "${item['name']}",
        ));
      });

      rams_org.forEach((item){
        rams.add(new DropdownMenuItem(
          child: new Text("${item['name']}"),
          value: "${item['name']}",
        ));
      });

      hdd_org.forEach((item){
        hdd.add(new DropdownMenuItem(
          child: new Text("${item['name']}"),
          value: "${item['name']}",
        ));
      });

      ssd_org.forEach((item){
        ssd.add(new DropdownMenuItem(
          child: new Text("${item['name']}"),
          value: "${item['name']}",
        ));
      });

      gcards_org.forEach((item){
        gcards.add(new DropdownMenuItem(
          child: new Text("${item['name']}"),
          value: "${item['name']}",
        ));
      });

      screens_org.forEach((item){
        screens.add(new DropdownMenuItem(
          child: new Text("${item['name']}"),
          value: "${item['name']}",
        ));
      });



      proc_org.forEach((item){
        proc.add(new DropdownMenuItem(
          child: new Text("${item['name']}"),
          value: "${item['name']}",
        ));
      });
    });


  }

  @override

  Widget build(BuildContext context) {
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    return Scaffold(

      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(backgroundColor:Colors.blue,child: Icon(Icons.filter_list),onPressed: ()async{

        if(proc_org==null){
          open = true;
        }else{
          await load_info();
          _scaffoldKey.currentState.openEndDrawer();
        }

        },),
      endDrawer: new Drawer(
          child: new ListView(
            children: <Widget>[


              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  color: Colors.black12,
                  child: ListTile(

                    title: Center(child: Text(getTranslated(context, "Filter Products"),style: TextStyle(fontSize: 18.0,color: Colors.black),)),
                  ),
                ),
              ),

              ListTile(
                leading: Text("Brand :",style: TextStyle(fontSize: 18.0),),
                title: brand_filter(),
              ),
              ListTile(
                leading: Text("Color :",style: TextStyle(fontSize: 18.0),),
                title: color_filter(),
              ),ListTile(
                leading: Text("HDD :",style: TextStyle(fontSize: 18.0),),
                title: hdd_filter(),
              ),ListTile(
                leading: Text("SSD :",style: TextStyle(fontSize: 18.0),),
                title: ssd_filter(),
              ),ListTile(
                leading: Text("Screen Size :",style: TextStyle(fontSize: 18.0),),
                title: ssize_filter(),
              ),ListTile(
                leading: Text("Processor :",style: TextStyle(fontSize: 18.0),),
                title: proc_filter(),
              ),ListTile(
                leading: Text("Ram :",style: TextStyle(fontSize: 18.0),),
                title: ram_filter(),
              ),ListTile(
                leading: Text("Graphic Card :",style: TextStyle(fontSize: 18.0),),
                title: gcard_title(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Material(
                    color: Colors.blue,
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () {
                        var search = "${chosed_brand!=null?chosed_brand:""} ${chosed_color!=null?chosed_color:""} ${chosed_hdd!=null?chosed_hdd:""} ${chosed_ssd!=null?chosed_ssd:""} ${chosed_screen!=null?chosed_screen:""} ${chosed_proc!=null?chosed_proc:""} ${chosed_ram!=null?chosed_ram:""} ${chosed_gcards!=null?chosed_gcards:""}";
                        curdObject.get_search(search).then((res){
                          setState(() {
                            all_products=res;
                            Navigator.of(context).pop();
                          });
                        });

                      },
                      minWidth: MediaQuery.of(context).size.width,
                      child: Text(
                        getTranslated(context,"Apply"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    )),
              ),


              // header
            ],
          )),
      backgroundColor: Colors.grey[200],

      appBar: AppBar(

        actions: <Widget>[
          new Container()
        ],
        backgroundColor: Colors.blue[800],
        leading:IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
          ),
          onPressed: (){
            Navigator.of(context).pop();

          },        ) ,
        title: Text(getTranslated(context,"Laptops"),
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
            for(var i in all_products) product("${i['brand']} ${i['model_id']} ${i['Type']} - ${i['processor']}, ${i['ram']} GB RAM, ${i['hard_disk_hdd']} HDD ${i['hard_disk_ssd']} SSD", "${i['price']}","${i['id']}","${i['img1url']}","${i['new_price']}"),

          ],)
        ],)
      );
    }else{
      return Center(child: Text(getTranslated(context,"No Products")));
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
                        Text(getTranslated(context,"Please Wait...."),style: TextStyle(color: Colors.blueAccent),)
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
      child: Text(getTranslated(context,"Cancel")),
      onPressed:  () {
        Navigator.of(context).pop();

      },
    );
    Widget continueButton = FlatButton(
      child: Text(getTranslated(context,"Continue")),
      onPressed:  () {
        curdObject.get_products().then((result){
          Navigator.of(context).pop();
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> new ProductList(internet_status: internet,)));
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(getTranslated(context,"Clear liked stores")),
      content: Text(getTranslated(context,"Are you sure you want to clear liked stores ?")),
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

  Widget brand_filter(){
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: new Text("Brand"),
          items: brands,
          onChanged: (value){
            setState(() {
              chosed_brand=value;
            });

          },
          value: chosed_brand,
        )
    );
  }

  Widget color_filter(){
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: new Text("Color"),
          items: colors,
          onChanged: (value){
            setState(() {
              chosed_color=value;
            });

          },
          value: chosed_color,
        )
    );
  }

  Widget hdd_filter(){
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: new Text("HDD Hard Drive"),
          items: hdd,
          onChanged: (value){
            setState(() {
              chosed_hdd=value;
            });

          },
          value:chosed_hdd
        )
    );
  }

  Widget ssd_filter(){
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: new Text("SSD Hard Drive"),
          items: ssd,
          onChanged: (value){
              setState(() {
                chosed_ssd=value;
              });

          },
          value: chosed_ssd,
        )
    );
  }

  Widget ssize_filter(){
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: new Text("Screen Size"),
          items: screens,
          onChanged: (value){
            setState(() {
              chosed_screen=value;
            });

          },
          value: chosed_screen,
        )
    );
  }

  Widget proc_filter(){
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: new Text("Proccesor"),
          items: proc,
          onChanged: (value){
              setState(() {
                chosed_proc=value;
              });

          },
          value: chosed_proc,
        )
    );
  }
  Widget ram_filter(){
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: new Text("RAM"),
          items: rams,
          onChanged: (value){
              setState(() {
                chosed_ram=value;
              });

          },
          value: chosed_ram,
        )
    );
  }
  Widget gcard_title(){
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: new Text("Graphics Card"),
          items: gcards,
          onChanged: (value){
            setState(() {
              chosed_gcards=value;
            });

          },
          value: chosed_gcards,
        )
    );
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue[800].withOpacity(.4),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            new_price!="0"?Text(
                              "${price}",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ):Container(),
                            Text(
                              "${new_price!="0"?new_price:price} EGP",
                            ),
                          ],
                        ),
                      ),
                      Text("${new_price!="0"?"${(100-(int.parse(new_price)/int.parse(price))*100).round()}% ${getTranslated(context," OFF")}":""}",
                        style: TextStyle(
                            color: Colors.red
                        ),
                      ),

                    ],
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


