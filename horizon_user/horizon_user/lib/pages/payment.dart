import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/COD.dart';
import 'package:horizonuser/db/crud.dart';
class Payment extends StatefulWidget {
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
  const Payment({Key key,this.note,this.ph2, this.total_price,this.fname, this.lname, this.build_no, this.sname, this.reg, this.city, this.phone_number}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var promo;
  var tot_price=0;
  var promo_index;
  bool apply=false;
  Methods curdObject=new Methods();

  @override
  Widget build(BuildContext context) {
    var screenWidth= MediaQuery.of(context).size.width;
    var screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(      backgroundColor: Colors.grey[200],

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
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                //margin: EdgeInsets.only(top: 20),
                height: screenHeight*0.20,
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
                              Text("${tot_price==0?widget.total_price:tot_price}",
                                style: TextStyle(
                                  fontSize:17,
                                ),),Text(getTranslated(context,"EGP"),
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
                              Text("${tot_price==0?(widget.total_price + 0):(tot_price+0)} ",
                                style: TextStyle(
                                  fontSize:19,
                                  fontWeight: FontWeight.bold,
                                ),), Text(getTranslated(context,"EGP"),
                                style: TextStyle(
                                  fontSize:19,
                                  fontWeight: FontWeight.bold,
                                ),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),


              Card(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextFormField(
                    onChanged: (value){
                        promo=value;
                    },
                      decoration: InputDecoration(
                        hintText:"Enter Promo-Code",
                        border: InputBorder.none,
                      ),
                    ),
                ),
              ),

               !apply?RaisedButton(
                 onPressed: ()async{
                   var res =await curdObject.check_promo(promo);
                   print(res);
                   if(!res[0]){

                     Fluttertoast.showToast(msg:"Wrong Promo Code");
                   }else{
                      setState(() {
                        tot_price = (widget.total_price - (widget.total_price*(res[1]/100))).round();
                        apply = true;
                        promo_index=res[2];
                      });
                   }
                 },
                 elevation: 0.5,
                 color: Colors.red,
                 child: Center(
                   child: Text(
                     "Apply",
                   ),
                 ),
                 textColor: Colors.white,
               ):Container(
                 padding: EdgeInsets.all(10),
                 width: double.infinity,
                 color: Colors.green,
                 child: Center(child: Text("Applied",style: TextStyle(fontSize: 16),)),
               ),







              /*Container(
                //margin: EdgeInsets.only(top: 20),
                height: 75,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.credit_card),
                      SizedBox(width: 10,),
                      Text("Credit Or Debit Card",style: TextStyle(
                        fontSize: 17
                      ),),
                      Icon(Icons.arrow_forward_ios,color: Colors.black.withOpacity(0.3,),size: 15,),
                    ],
                  ),
                ),
              ),*/
              SizedBox(height: 10),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                    return Cash(fname:widget.fname,lname:widget.lname,build_no: widget.build_no,sname: widget.sname,reg:widget.reg,city: widget.city,phone_number: widget.phone_number,total_price:tot_price==0?widget.total_price:tot_price,ph2:widget.ph2,note:widget.note,promo_index: promo_index,);
                  }
                  ));
                },
                child: Container(
                  //margin: EdgeInsets.only(top: 20),
                  height: screenHeight*0.1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenHeight*0.032),
                    child:Wrap(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(Icons.attach_money),
                            Text(getTranslated(context,"Cash On Delivery (COD)"),style: TextStyle(
                                fontSize: screenHeight*0.025,
                            ),),
                            Icon(Icons.arrow_forward_ios,color: Colors.black.withOpacity(0.3,),size: screenHeight*0.02,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
