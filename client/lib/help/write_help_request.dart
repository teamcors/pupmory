import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

/// 도움 요청 작성하기
class WriteHelpRequestPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => WriteHelpRequestPage(),
      ),
    );
  }

  @override
  _WriteHelpRequestPageState createState() => _WriteHelpRequestPageState();
}

class _WriteHelpRequestPageState extends State<WriteHelpRequestPage> {


  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  // 도움 요청 저장하기 (POST)
  void saveHelpRequest(String uid, String title ,String content) async {

    // 요청 본문 데이터
    var data = {
      "toUserUid": uid,
      "title": title,
      "content" : content
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'axNNnzcfJaSiTPI6kW23G2Vns9o1', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    var url = Uri.parse('http://3.38.1.125:8080/community/help'); // 엔드포인트 URL 설정

    try {
      var response = await http.post(
        url,
        body: json.encode(data), // 요청 본문에 데이터를 JSON 형식으로 인코딩하여 전달
        headers: headers, // 헤더 추가
      );

      if (response.statusCode == 200) {
        // 응답 성공 시의 처리

        var jsonResponse = utf8.decode(response.bodyBytes); // 응답 본문을 JSON 형식으로 디코딩
        // JSON 값을 활용한 원하는 동작 수행
        //utf8.decode(jsonResponse);
        print(jsonResponse);

        List<String> contentList = [];

        List<dynamic> parsedResponse = json.decode(jsonResponse);

        setState(() {
        });


        print('API 호출 성공!!: ${response.statusCode}');
      } else {
        // 요청 실패 시의 처리
        print('API 호출 실패!!: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 발생 시의 처리
      print('API 호출 중 예외 발생: $e');
    }
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() async {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Scaffold(
          backgroundColor: Color(0xffF3F3F3),
          appBar: AppBar(
            actions: <Widget>[
              new IconButton(
                icon: Image.asset('assets/images/memorial/memorial_write.png'),
                onPressed: (){
                  saveHelpRequest('q', titleController.text, contentController.text);
                  Navigator.pop(context);
                },
              ),
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Center(
                child: Padding(padding: EdgeInsets.only(right: 0),
                  child: Text('도움 요청하기', style: textStyle.bk20bold,),
                )
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Container(
              width: Get.width,
              height: Get.height,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child:
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        width: Get.width,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                              NetworkImage( 'https://images.unsplash.com/photo-1579807351146-e6dd49462635?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80',
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text('닉네임님에게 도움을 요청합니다.'),
                            SizedBox(width: 50,),
                            // Text('06/16 08:01', style: textStyle.grey12normal,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: Get.width,
                      height: 95,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Padding(padding: EdgeInsets.only(top:16,left: 20, right:20),
                              child: Text("제목",style: TextStyle(fontSize: 14),),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top:8,left: 20, right:20),
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: '제목을 입력하세요 (최대 50자)'),),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: Get.width,
                      //height: 187,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Padding(padding: EdgeInsets.only(top:16,left: 20, right:20),
                              child: Text("내용",style: TextStyle(fontSize: 14),),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top:8,left: 20, right:20),
                            child: SizedBox(
                              width: screenSize.width,
                              //height: 150,
                              child: TextField(
                                controller: contentController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: '도움 받고 싶은 내용을 적어주세요.\n(최대 1000자)',
                                ),
                                maxLines: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          )

      );

  }
}
