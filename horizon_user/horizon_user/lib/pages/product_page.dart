import 'package:flutter/material.dart';
import 'package:horizonuser/db/crud.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:carousel_pro/carousel_pro.dart';

// import 'package:flutter_advanced_networkimage/provider.dart';
// import 'package:flutter_advanced_networkimage/transition.dart';
// import 'package:flutter_advanced_networkimage/zoomable.dart';
class ProductPage extends StatefulWidget {
  final id;
  final internet_status;

  const ProductPage({Key key, this.id, this.internet_status}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Methods curdObject = new Methods();
  bool internet = true;
  var product;
  bool liked = false;
  bool carted = false;
  bool _isloading = true;
  @override
  void initState() {
    curdObject.get_one_product(widget.id).then((results) {
      curdObject.checkfavlist(widget.id).then((results2) {
        curdObject.check_cart(widget.id).then((results3) {
          setState(() {
            internet =
                widget.internet_status == null ? true : widget.internet_status;
            product = results;
            print(product);
            liked = results2;
            carted = results3;
          });
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ConnectivityWidget(
        offlineCallback: () {
          internet = false;
        },
        onlineCallback: () {
          internet = true;
        },
        builder: (context, isOnline) => Center(child: main_pro()),
      ),
    );
  }

  Widget main_pro() {
    ConnectivityUtils.instance.setServerToPing(
        "https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance
        .setCallback((response) => response.contains("This is a test!"));

    var screenWidth = MediaQuery.of(context).size.width;

    if (product != null && liked != null) {
      return Stack(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                image_carousel(context, product['img1url'], product['img2url'],
                    product['img3url'], product['img4url']),
                Positioned(
                  top: 17,
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 20.0,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 300),
            child: Material(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(90.0)),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: 30.0, top: 10.0, right: 10.0, bottom: 30.0),
                child: ListView(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(
                              "${product['brand']} ${product['model_id']}",
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: <Widget>[
                            //Icon(Icons.attach_money, color: Colors.white,),
                            Text(
                              "${product['new_price'] != 0 ? product['price'] : ""}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.black,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              " ${product['new_price'] != 0 ? product['new_price'] : product['price']} ${getTranslated(context, "EGP")} ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.3),
                            product['new_price'] != 0
                                ? Container(
                                    padding: EdgeInsets.all(4),
                                    color: Colors.blue[800].withOpacity(0.5),
                                    child: Text(
                                      "${"${(100 - (product['new_price'] / product['price']) * 100).round()}% ${getTranslated(context, " OFF")}"}",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                  onTap: () async {
                                    showLoadingDialog(context, true);

                                    !carted
                                        ? curdObject
                                            .add_to_cart(product['id'])
                                            .then((result) {
                                            setState(() {
                                              carted = !carted;
                                              Navigator.of(context).pop();
                                            });
                                          })
                                        : curdObject
                                            .remove_from_cart(product['id'])
                                            .then((result) {
                                            setState(() {
                                              carted = !carted;
                                              Navigator.of(context).pop();
                                            });
                                          });
                                  },
                                  child: !carted
                                      ? Icon(Icons.add_shopping_cart,
                                          color: Colors.blue[800])
                                      : Icon(
                                          Icons.shopping_cart,
                                          color: Colors.blue[800],
                                        )),
                              InkWell(
                                  onTap: () async {
                                    showLoadingDialog(context, _isloading);
                                    liked
                                        ? await curdObject.workonfavourites([],
                                            0, product['id']).then((result) {
                                            setState(() {
                                              liked = !liked;
                                              Navigator.of(context).pop();
                                            });
                                          })
                                        : await curdObject.workonfavourites(
                                            [product['id']], 1).then((result) {
                                            setState(() {
                                              liked = !liked;
                                              Navigator.of(context).pop();
                                            });
                                          });
                                  },
                                  child: !liked
                                      ? Icon(Icons.bookmark_border,
                                          color: Colors.blue[800])
                                      : Icon(
                                          Icons.bookmark,
                                          color: Colors.blue[800],
                                        )),
                            ],
                          ),
                        ),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.assignment, size: 15, color: Colors.black.withOpacity(0.3),),
                                  Text(" Write Review",style: TextStyle(color: Colors.black.withOpacity(0.3)),),

                                ],
                              ),
                              onTap: (){},
                            ),
                            InkWell(child: Text("10 Reviews", style:TextStyle(color: Colors.black.withOpacity(0.3)),),
                              onTap: (){},
                            ),
                          ],
                        ),*/
                        //SizedBox(height: 10,),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),

                        Text(
                          getTranslated(context, "Description"),
                          style: TextStyle(
                            color: Colors.black.withOpacity(.8),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              getTranslated(context, "Upgrade Availability"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${product['upgrade'] == true ? getTranslated(context, "This product is available for increasing SSD, HDD and ram") : getTranslated(context, "This product is not available for increasing SSD, HDD and ram")}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Text(
                              "Brand ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - ${product['brand']} ${product['model_id']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Platform ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - Platform: ${product['platform']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Color ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - Color: ${product['color']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Operating System ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - Operating System: ${product['operation_system']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            // Text(" - Hard Disk Interface: SSA and SSD",style: TextStyle(fontSize: 15),),
                            // SizedBox(height: 10),

                            Text(
                              "Hard Disk ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - HDD: ${product['hard_disk_hdd']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              " - SSD: ${product['hard_disk_ssd']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            //Text(" - Type: DDR4",style: TextStyle(fontSize: 15),),
                            //SizedBox(height: 10),

                            Text(
                              "Screen ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " -  Screen Size: ${product['screen_size']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Processor ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " -  Processor: ${product['processor']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              " -  Number of processor cores: ${product['number_processor_core']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              " -  Processor speed: ${product['processor_speed']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "USB ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - USB: ${product['usb']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Memory Card Reader",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - Memory Card Reader:  ${product['memory_card_reader'] == true ? "Yes" : "No"}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "RAM",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - RAM:  ${product['ram']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              " - RAM info:  ${product['ram_extra_info']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Graphics Card 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - Graphics Card Type:  ${product['graphic_card_type'] == null ? "No" : product['graphic_card_type']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              " - Capacity:  ${product['graphic_card_capacity'] == null ? "No" : product['graphic_card_capacity']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Graphics Card 2",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - Graphics Card Type:  ${product['graphic_card_2_type'] == null ? "No" : product['graphic_card_2_type']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              " - Capacity:  ${product['graphic_card_2_capacity'] == null ? "No" : product['graphic_card_2_capacity']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Touch Screen",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - Touch Screen:  ${product['touch_screen'] == true ? "Yes" : "No"}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Quantity",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - Quantity:  ${product['quantity']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "X360",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - X360:  ${product['x360'] == true ? "Yes" : "No"}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Light Keyboard",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              " - Light Keyboard:  ${product['light_keyboard'] == true ? "Yes" : "No"}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Extra Info.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${product['laptop_extra_info']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),

                            //Icon(Icons.question_answer,color: Colors.purple,),
                          ],
                        ),
                        /*Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text("Add to cart",
                                    style: TextStyle(
                                      color: Colors.white,

                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                    ),
                                    color: Colors.blue[800],
                                  ),
                                  alignment: Alignment.center,
                                ),
                                onTap: (){},
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10.0),
                                  child: Text("Add to wishlist",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                    ),
                                    color: Colors.blue[800].withOpacity(.4),
                                  ),
                                ),
                                onTap: (){},
                              ),
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return JumpingDotsProgressIndicator(
        fontSize: 20.0,
      );
    }
  }

  showLoadingDialog(BuildContext context, isloading) async {
    if (isloading) {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new WillPopScope(
                onWillPop: () async => false,
                child: SimpleDialog(
                    backgroundColor: Colors.black54,
                    children: <Widget>[
                      Center(
                        child: Column(children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            getTranslated(context, "Please Wait...."),
                            style: TextStyle(color: Colors.blueAccent),
                          )
                        ]),
                      )
                    ]));
          });
    } else {
      return "";
    }
  }

  Widget image_carousel(
      context, product_pic1, product_pic2, product_pic3, product_pic4) {
    return new Container(
      height: 300,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          InkWell(
            child: Image.network(
              product_pic1,
              fit: BoxFit.cover,
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) {
              //   // return DetailScreen(img1: product_pic1,);
              // }));
            },
          ),
          InkWell(
            child: Image.network(
              product_pic2,
              fit: BoxFit.cover,
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) {
              //   // return DetailScreen(img1: product_pic2,);
              // }));
            },
          ),
          InkWell(
            child: Image.network(
              product_pic3,
              fit: BoxFit.cover,
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) {
              //   // return DetailScreen(img1: product_pic3,);
              // }));
            },
          ),
          InkWell(
            child: Image.network(
              product_pic4,
              fit: BoxFit.cover,
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) {
              //   // return DetailScreen(img1: product_pic4,);
              // }));
            },
          )
        ],
        autoplay: false,
        dotSize: 3.0,
        dotSpacing: 15.0,
        dotColor: Colors.black,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.black.withOpacity(0.5),
        borderRadius: true,
        dotPosition: DotPosition.bottomRight,
        noRadiusForIndicator: true,
      ),
    );
  }
}

// class DetailScreen extends StatelessWidget {
//   final img1;
//   const DetailScreen({Key key, this.img1}): super(key: key);

//   @override
//   Widget build(BuildContext context,) {
//     return Scaffold(
//       body: GestureDetector(
//         child: Center(
//             child: ZoomableWidget(
//               minScale: 0.3,
//               maxScale: 2.0,
//               // default factor is 1.0, use 0.0 to disable boundary
//               panLimit: 0.8,
//               child: Container(
//                 child: TransitionToImage(
//                   image: AdvancedNetworkImage(img1, timeoutDuration: Duration(minutes: 1)),
//                   // This is the default placeholder widget at loading status,
//                   // you can write your own widget with CustomPainter.
//                   placeholder: CircularProgressIndicator(),
//                   // This is default duration
//                   duration: Duration(milliseconds: 300),
//                 ),
//               ),
//             )
//         ),
//         onTap: () {
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }
// }
