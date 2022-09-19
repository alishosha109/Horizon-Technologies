import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/home.dart';
import 'package:horizonuser/pages/account.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:horizonuser/pages/product_page.dart';
import 'package:horizonuser/db/crud.dart';



class Search extends StatefulWidget {
  final internet_status;
  const Search({Key key, this.internet_status}): super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool internet=true;
  var pros;
  Methods curdObject=new Methods();

  @override
  void initState() {

    setState(() {
      internet=widget.internet_status==null?true:widget.internet_status;

    });


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],

        title: TextField(
          onChanged: (value){
            if(value==""){
              curdObject.get_search("hamoksha").then((result){
                setState(() {
                  pros = result;
                });
              });
            }else{
              curdObject.get_search(value).then((result){
                setState(() {
                  pros = result;
                  print(pros);
                });
              });
            }

          },
          autofocus: true,
          decoration: InputDecoration(

            hintText:getTranslated(context,"Find a Laptop"),
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 20.0,
          ),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage(internet_status:internet)));

          },
        ),
        centerTitle: true,
      ),      backgroundColor: Colors.grey[200],

      body: ConnectivityWidget(
        offlineCallback: (){
          internet=false;
        },
        onlineCallback: (){
          internet=true;
        },
        builder: (context, isOnline) => Center(
            child:main_se()
        ),

      ),

    );
  }

  Widget main_se(){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));

    return pros ==null?Center(child:
      Text(getTranslated(context,"Search for something")),
    ):  ListView(
      children: <Widget>[
        Column(children: <Widget>[
          for(var i in pros) product("${i['brand']} ${i['model_id']} ${i['Type']} - ${i['processor']}, ${i['ram']} GB RAM, ${i['hard_disk_hdd']} HDD ${i['hard_disk_ssd']} SSD", "${i['price']} EGP","${i['id']}","${i['img1url']}"),

        ],)
      ],
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

