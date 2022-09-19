import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/product_page.dart';
import 'package:horizonuser/db/crud.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:progress_indicators/progress_indicators.dart';


class WishList extends StatefulWidget {
  final internet_status;

  const WishList({Key key, this.internet_status}) : super(key: key);
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {

  Methods curdObject=new Methods();
  bool internet=true;
  var favourites;
  @override
  void initState() {

    curdObject.get_favs().then((results){
      setState(() {
        internet=widget.internet_status==null?true:widget.internet_status;
        favourites = results;
      });

    });


    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading:IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
          ),
          onPressed: (){
            Navigator.of(context).pop();

          },        ) ,
        title: Text(
          getTranslated(context,"My WishList"),
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
            child:main_fav()
        ),

      ),
    );
  }

Widget main_fav(){
  ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
  ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));

  if(favourites!=null){
      if(favourites.isNotEmpty){
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  for(var i in favourites) product("${i['brand']} ${i['model_id']} ${i['Type']} - ${i['processor']}, ${i['ram']} GB RAM, ${i['hard_disk_hdd']} HDD ${i['hard_disk_ssd']} SSD", "${i['price']}","${i['id']}","${i['img1url']}","${i['new_price']}"),


                ],
              ),
            ),
          ],
        );
      }else{
        return Center(child: Text(getTranslated(context,"Empty")),);
      }
    }else{
      return Center(child: JumpingDotsProgressIndicator(fontSize: 20.0,));
    }

}
Widget product(String name, String price,id,img, String new_price){
  return  Stack(
      children: <Widget>[
        InkWell(
          child: Container(
            margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
            height: 200.0,
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
                              Text("${new_price!="0"?"${(100-(int.parse(new_price)/int.parse(price))*100).round()}%${getTranslated(context," OFF")}":""}",
                              style: TextStyle(
                              color: Colors.red
                              ),
                              ),

                      ],
                      ),

                      /*Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            width: 90.0,
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Add to Cart",
                            ),
                          ),
                          onTap: (){},
                        ),
                      ),*/

                ],
              ),
            ),
          ),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
              return ProductPage(id: id,);
            }
            ),
            );
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
