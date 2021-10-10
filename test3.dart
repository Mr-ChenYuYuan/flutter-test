import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';


class test3 extends StatefulWidget {

  @override
  _test3State createState() => _test3State();
}

class _test3State extends State<test3> {

  var listData = [];

  var _dropValue = '1'; // 选择框默认为 1

  late Future future;
  

  Future getInfo()async{
    var url = Uri.parse('http://47.107.41.68:5001/getchargelog');
    var res = await http.get(url);
    List list = [];
    List data = json.decode(res.body)['data'];

    if(res.statusCode == 200){
      for(var i = 1; i <= 8; i++){
          list.add({
            "num":"${i}", // 序号
            "time":data[i]['time'], // 时间
            "who":data[i]['who'], // 用户
            "amount":data[i]['amount'], // 金额
            "carno":data[i]['carno'], // 车牌号
          });
      }

      return list;
    }
  }


  @override
  void initState() {
    super.initState();

    future = getInfo().then((value){
      this.listData = value;
      setState(() {  });
    });
  }


  

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var width=size.width;
    
    List<TableRow> item = [];
    item.add(
      TableRow(children: [
        TableCell(child: Center(child: Text('序号'))),
        TableCell(child: Center(child: Text('充值时间'))),
        TableCell(child: Center(child: Text('用户'))),
        TableCell(child: Center(child: Text('充值金额'))),
        TableCell(child: Center(child: Text('充值车号'))),
      ]
    ));
    
    getItem(){
      for(int i = 0; i < listData.length; i++){
        item.add(
          TableRow(children: [
              TableCell(child: Center(child: Text(listData[i]['num'].toString()))),
              TableCell(child: Center(child: Text(listData[i]['time'].toString()))),
              TableCell(child: Center(child: Text(listData[i]['who']))),
              TableCell(child: Center(child: Text(listData[i]['amount'].toString()))),
              TableCell(child: Center(child: Text(listData[i]['carno']))),
            ]
          )
        );
      }
      return item;
    }






    return Scaffold(
      appBar: AppBar(
        title: const Text('充值记录'),
      ),
      body:  Container(
              padding: EdgeInsets.all(20),
              child: Scrollbar(  // 添加滚动条 让页面不在溢出时报错
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      
                      // title
                      Container(
                        alignment: Alignment.topLeft,
                        child:Text('充值记录管理',style:TextStyle(fontWeight:FontWeight.w700,fontSize:18)),
                      ),
                      

                      // 排序
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          children: [
                            // 排序
                            Expanded(
                              child:Container(child:Text('排序：',
                                style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18)),
                              padding:EdgeInsets.only(right:15))
                            ),
                            
                            // 选择
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: width/2,
                                child: DropdownButton(
                                  value: _dropValue,
                                  items: [
                                    DropdownMenuItem(child: Text('时间升序'),value: '1'),
                                    DropdownMenuItem(child: Text('时间降序'),value: '2'),
                                  ],
                                  onChanged: (value){
                                    setState(() {
                                      _dropValue = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ),
                            // 查询
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left:30),
                                child: ElevatedButton(
                                  child: Text('查询'),
                                  onPressed: (){
                                    setState(() {
                                      print('查询');
                                      if(int.parse(this._dropValue)==2){
                                        this.listData.sort( (x, y){
                                          return int.parse(y['num'].toString())-int.parse(x['num'].toString());
                                        });
                                      }else{
                                        this.listData.sort( (x, y){
                                          return int.parse(x['num'].toString())-int.parse(y['num'].toString());
                                        });
                                      }
                                      getItem();
                                    });
                                  },
                                ),
                              )
                            ),
                            
                          ],
                        ),
                      ),
                      
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Table(
                          children: getItem(),
                          border: TableBorder(
                              top: BorderSide(color: Colors.red),
                              left: BorderSide(color: Colors.red),
                              right: BorderSide(color: Colors.red),
                              bottom: BorderSide(color: Colors.red),
                              horizontalInside: BorderSide(color: Colors.red),
                              verticalInside: BorderSide(color: Colors.green),
                          )
                        ),
                      ),

                        



                    ],
                  ),
                ),
              ),
              
            ),
             
    );
  }
}