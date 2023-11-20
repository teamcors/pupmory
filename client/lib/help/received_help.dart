import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/style.dart';
import 'package:flutter/services.dart';
import 'help_main.dart'as help ;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// 도움 요청하기
class ReceivedHelpPage extends StatefulWidget {
  @override
  State<ReceivedHelpPage> createState() => _ReceivedHelpPageState();
}

class _ReceivedHelpPageState extends State<ReceivedHelpPage> {

  // 화면에 보이는 UI 설정 bool
  bool check = false;
  bool sent = true;

  // 도움 보내기 수
  int countHelp = 0;

  // 도움을 보낸 시각 (시연용)
  String sentDate = "";

  /// 도움 요청하기
  bool receivedHelp = true; // 요청한 도움을 받았는지
  bool checkAskHelp = false; // 요청받은 도움을 확인했는지

  late Map<String, dynamic> parsedResponseHR; // 도움 요청 내역

  // 내가 보낸 "도움 요청" 내역에서 내가 보낸 요청 세부 내용 불러오기(GET)
  void callHelpRequest(int id) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/community/help?hid=${id}'; // 실제 API 엔드포인트로 변경하세요

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'axNNnzcfJaSiTPI6kW23G2Vns9o1', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터(세부내용): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      check = true;
      parsedResponseHR = json.decode(jsonResponse);

      setState(() {});

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    callHelpRequest(help.hid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Padding(padding: EdgeInsets.only(right: 60),
              child: Text('도움 요청하기', style: textStyle.bk20bold,),
            )
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        //color: Color(0xffF3F3F3),
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if(check)...[
                SizedBox(height: 15,),
                Container(
                  width: Get.width,
                  height: 56,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: receivedHelp? Color(0xffFCCBCD):Color(0xffF3F3F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        minRadius: 15,
                        maxRadius: 15,
                        backgroundImage:
                        NetworkImage(help.selectedProfile,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text('${parsedResponseHR['toUserUid']}님에게 도움을 요청했습니다.', style: textStyle.bk14normal,)
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: Get.width,
                  child:
                  ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                      child:
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5,),
                            Text('제목', style: textStyle.bk14regular,),
                            SizedBox(height: 5,),
                            Text('${parsedResponseHR['title']}', style: textStyle.bk16normal,),
                            SizedBox(height: 5,),
                          ],
                        ),
                      )
                  ),
                  //Image.network(parsedResponseCM[index]['image'], fit: BoxFit.cover,),
                ),
                SizedBox(height: 10,),

                Container(
                  width: Get.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                      child:
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('내용', style: textStyle.bk14regular,),
                            SizedBox(height: 5,),
                            Text('${parsedResponseHR['content']}', style: textStyle.bk16normal,)
                          ],
                        ),
                      )
                  ),
                ),
                SizedBox(height: 15,),
                if(parsedResponseHR['answer'] != null)...[
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xffFEFBAC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              minRadius: 15,
                              maxRadius: 15,
                              backgroundImage:
                              NetworkImage(help.selectedProfile,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text('${parsedResponseHR['toUserUid']}님이 보낸 도움'),
                            SizedBox(width: 110,),
                            Text(sentDate)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Text('${parsedResponseHR['answer']}')
                      ],
                    ),
                  ),
                ],
              ]
            ],
          ),
        ),
      ),
    );
  }
}