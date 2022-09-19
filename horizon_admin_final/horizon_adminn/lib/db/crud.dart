import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class Methods{
  var headers = {'Authorization': 'Token e18985d8d5eb1333d7d61adface2abde440f7cce'};
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();




  get_token()async{
    var token = await _firebaseMessaging.getToken();
    print(token);
    return token;

  }

  add_token()async{
    var token = await _firebaseMessaging.getToken();
    var url = "http://horizonstore.pythonanywhere.com/notify_tokens?search=$token";
    var url2 = "http://horizonstore.pythonanywhere.com/notify_tokens/";
    var response = await http.get(url,headers: headers);
    var li = json.decode("${response.body}");
    if(li.isEmpty){
      var headers2 = {"Content-Type": "application/json"};
      var body = jsonEncode({
        "name":token,
      });
      var response = await http.post(url2,body:body,headers: headers2);
      print(response.statusCode);
      print(response.body);
    }else{
        return;
    }
  }

  get_products()async{
    var url = 'http://horizonstore.pythonanywhere.com/product/';
    var response = await http.get(url,headers: headers);
    var li = json.decode("${response.body}");
    print(response.body);
    return li;
  }

  get_one_product(id)async{
    var url = 'http://horizonstore.pythonanywhere.com/product/$id';
    var response = await http.get(url,headers: headers);
    var li = json.decode("${response.body}");
    return li;
  }


  get_orders()async{

    var url = 'http://horizonstore.pythonanywhere.com/order/';
    var response = await http.get(url,headers: headers);
    var li = json.decode("${response.body}");
    return li;
  }

  get_one_order(id)async{
    var url = 'http://horizonstore.pythonanywhere.com/order/$id';
    var response = await http.get(url,headers: headers);
    var li = json.decode("${response.body}");
    return li;
  }

  get_users()async{
    var url = 'http://horizonstore.pythonanywhere.com/user/';
    var response = await http.get(url,headers: headers);
    var li = json.decode("${response.body}");
    return li;
  }

  get_not_completed()async{
    var url = 'http://horizonstore.pythonanywhere.com/not_completed_orders/';
    var response = await http.get(url,headers: headers);
    var li = json.decode("${response.body}");
    return li;
  }

  get_completed()async{
    var url = 'http://horizonstore.pythonanywhere.com/completed_orders/';
    var response = await http.get(url,headers: headers);
    var li = json.decode("${response.body}");
    return li;
  }

  getorderproducts(productids)async{
    var all=[];
    var li;
    if(productids == null){
      return [];
    }
    for(int i =0;i<productids.length;i++){
      var url = 'http://horizonstore.pythonanywhere.com/product/${productids[i]}/';
      var response = await http.get(url,headers: headers);
      response.statusCode==200?li = json.decode("${response.body}"):li=null;
      all.add(li);
    }
    return all;
  }

  get_sp_order(no)async{
    var url = 'http://horizonstore.pythonanywhere.com/order/$no/';
    var response = await http.get(url,headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode(response.body);
    var li2 = utf8.decode(response.bodyBytes);
    print(li2);
    return [li,li2];
  }


  decrease_quantity(id)async{
    var url = 'http://horizonstore.pythonanywhere.com/product/$id/';
    var headers2 = {'Authorization': 'Token 5cce56da08b8dfcc7c026afda6928a63eb2f0aeb',"Content-Type": "application/json"};

    var response = await http.get(url,headers: headers);
    var li = json.decode("${response.body}");
    print(li['quantity']);
    if(li['quantity'] -1 ==0){
      delete_pro(id);
    }else{
      var body = jsonEncode({
        "quantity":li['quantity']-1,
      });
      var response2 = await http.patch(url,body:body,headers: headers2);
      print(response2.body);
    }
  }
    delete_pro(id)async{
      var url = 'http://horizonstore.pythonanywhere.com/product/$id/';
      var response = await http.delete(url,headers: headers);
    }

}