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

class AnswerHelpRequestPage extends StatefulWidget {
  @override
  State<AnswerHelpRequestPage> createState() => _AnswerHelpRequestPageState();
}

class _AnswerHelpRequestPageState extends State<AnswerHelpRequestPage> {

  late List<dynamic> parsedResponseHA; // 도움 답변 내역

  bool answered = false; // 답변한 적이 있는지 확인
  int answerid = 0; // 답변한 적이 있다면 해당 내용들 가져오기 위한 정수

  // 내가 보낸 "도움" 내역 불러오기(GET) 및 상대방이 보낸 도움 내역 가져오기
  void callHelpAnswer() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/community/help/all?type=ans'; // 실제 API 엔드포인트로 변경하세요

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
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseHA = json.decode(jsonResponse);

      // 사용자의 답변 수 찾아가기
      for(int i =0; i < parsedResponseHA.length; i++){
        if(parsedResponseHA[i]['answer'] != null){
          countHelp++;
        }
      }

      countHelp %= 3;

      // 현재 답변 내용 찾아가기
      for(int i =0; i < parsedResponseHA.length; i++){
        if(parsedResponseHA[i]['id'] == help.hid && parsedResponseHA[i]['answer'] != null){
          answered = true;
          answerid = i;
        }
      }


      setState(() {});

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 도움 답변 저장하기 (POST)
  void saveHelpAnswer(int id, String content) async {

    // 요청 본문 데이터
    var data = {
      "helpId" : id,
      "content" : content,
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'axNNnzcfJaSiTPI6kW23G2Vns9o1', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    var url = Uri.parse('http://3.38.1.125:8080/community/answer'); // 엔드포인트 URL 설정

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


  // 화면에 보이는 UI 설정 bool
  bool askHelp = true;
  bool sendHelp = false;
  bool popup = true;
  bool sent = false;

  // 도움 보내기 수
  int countHelp = 0;

  // 도움을 보낸 시각 (시연용)
  String sentDate = "";
  String helpContents = "";


  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    callHelpAnswer();
  }

  void FlutterDialog2() {

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(30.0))),
          content: Builder(
            builder: (context) {

              return Container(
                  height: 296,
                  width: 316,
                  child:
                  Padding(padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          width: 125,
                          height: 117,
                          child: SvgPicture.asset(
                            'assets/images/help/attention.svg',
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text("닉네임님에게 도움을 보내시겠어요?",style: textStyle.bk16bold,),
                        SizedBox(height: 10,),
                        Text("한 번 보낸 도움은 회수할 수 없어요!", style: textStyle.bk14normal,),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Container(width: 120,
                              child: ElevatedButton(
                                child: new Text("취소"),
                                style: buttonChart().purplebtn2,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(width: 124,
                              child: ElevatedButton(
                                child: new Text("도움 보내기", style: TextStyle(color: Colors.white),),
                                style: buttonChart().purplebtn,
                                onPressed: () {
                                  var now = DateTime.now();
                                  sentDate = DateFormat('yy/mm/dd h:mm').format(now);
                                  sent = true;
                                  helpContents = myController.text;
                                  countHelp ++;

                                  // 서버에 전송
                                  saveHelpAnswer(help.hid, myController.text);

                                  // !!화면 갱신!!
                                  callHelpAnswer();

                                  setState(() {});
                                  myController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),)
              );
            },
          ),
        )
    );
  }

  void FlutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Container(
                  width: 180,
                  height: 80,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/help/help_pop_up.png')
                      )
                  ),
                  child: SvgPicture.asset(
                    'assets/images/help/attention.svg',
                  ),
                ),
                new Text("닉네임님에게 도움을 보내시겠어요?"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "한 번 보낸 도움은 회수할 수 없어요!",
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: new Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: new Text("도움 보내기"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Padding(padding: EdgeInsets.only(right: 60),
                child: Text('도움 보내기', style: textStyle.bk20bold,),
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
                SizedBox(height: 15,),
                Container(
                  width: Get.width,
                  height: 56,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xffF3F3F3),
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
                      Text('${parsedResponseHA[answerid]['fromUserUid']}님이 요청한 도움입니다.', style: textStyle.bk14normal,)
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: Get.width,
                  child:
                  ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                      child:
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5,),
                            Text('제목', style: answered? textStyle.grey14regular : textStyle.bk14regular,),
                            SizedBox(height: 5,),
                            Text('${parsedResponseHA[answerid]['title']}', style: answered? textStyle.grey16normal :textStyle.bk16normal,),
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
                            Text('내용', style: answered? textStyle.grey14regular : textStyle.bk14regular,),
                            SizedBox(height: 5,),
                            Text('${parsedResponseHA[answerid]['content']}', style:answered? textStyle.grey16normal : textStyle.bk16normal,)
                          ],
                        ),
                      )
                  ),
                ),
                SizedBox(height: 10,),
                if(answered)...[
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
                            Container(width: 200,
                              child: Text('${parsedResponseHA[answerid]['fromUserUid']}님이 보낸 도움', style: textStyle.bk14regular,),),
                            SizedBox(width: 25,),
                            Text(DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHA[answerid]['answeredAt'])), style: TextStyle(fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xff4B5396)),)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Text(parsedResponseHA[answerid]['answer'], style: textStyle.bk16normal,)
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 15,),
                if(popup)...[
                  Container(
                    height: 210,
                    width: Get.width,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 300,),
                            IconButton(onPressed: (){
                              popup = false;
                              setState(() {
                              });

                            }, icon: SvgPicture.asset(
                              'assets/images/cancel_icon.svg',
                            ),),
                          ],
                        ),
                        if(countHelp == 0)...[
                          Row(
                            children: [
                              SizedBox(width: 45,),
                              SvgPicture.asset(
                                'assets/images/help/help_count_n.svg',
                              ),
                              SvgPicture.asset(
                                'assets/images/help/help_count_n.svg',
                              ),
                              SvgPicture.asset(
                                'assets/images/help/help_count_n.svg',
                              ),
                            ],
                          ),
                        ] else if(countHelp == 1)...[
                          Row(
                            children: [
                              SizedBox(width: 45,),
                              SvgPicture.asset(
                                'assets/images/help/help_count_y.svg',
                              ),
                              SvgPicture.asset(
                                'assets/images/help/help_count_n.svg',
                              ),
                              SvgPicture.asset(
                                'assets/images/help/help_count_n.svg',
                              ),
                            ],
                          ),
                        ]
                        else if(countHelp == 2)...[
                            Row(
                              children: [
                                SizedBox(width: 45,),
                                SvgPicture.asset(
                                  'assets/images/help/help_count_y.svg',
                                ),
                                SvgPicture.asset(
                                  'assets/images/help/help_count_y.svg',
                                ),
                                SvgPicture.asset(
                                  'assets/images/help/help_count_n.svg',
                                ),
                              ],
                            ),
                          ] else if(countHelp == 3)...[
                            Row(
                              children: [
                                SizedBox(width: 45,),
                                SvgPicture.asset(
                                  'assets/images/help/help_count_y.svg',
                                ),
                                SvgPicture.asset(
                                  'assets/images/help/help_count_y.svg',
                                ),
                                SvgPicture.asset(
                                  'assets/images/help/help_count_y.svg',
                                ),
                              ],
                            ),
                          ],
                        SizedBox(height: 5,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 115,),
                                Text('도움 보내기 3번', style: TextStyle(fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700, fontSize: 14),),
                                Text('달성 시,', style: TextStyle(fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400, fontSize: 14),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                SizedBox(width: 85,),
                                Text('1번의 도움 요청하기', style: TextStyle(fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700, fontSize: 14),),
                                Text('가 가능합니다.', style: TextStyle(fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400, fontSize: 14),)
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text('현재 3번중 ${countHelp}번 달성', style: TextStyle(fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700, fontSize: 10, color: Color(0xffAAAAAA)),),
                          ],
                        ),

                      ],
                    ),
                  ),
                ]
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child:
                //   Row(
                //     children: [
                //       for(int i= 0; i < 5; i++)...[
                //         Padding(padding:EdgeInsets.all(15),
                //           child: Column(
                //             children: [
                //               Container(
                //                 width: 350,
                //                 height: 350,
                //                 color: Colors.white,
                //                 child:
                //                     Padding(
                //                       padding: EdgeInsets.all(20),
                //                       child: Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                //                           Row(
                //                             children: [
                //                               CircleAvatar(
                //                                 backgroundImage:
                //                                 NetworkImage( 'https://images.unsplash.com/photo-1519098901909-b1553a1190af?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
                //                                 ),
                //                               ),
                //                               SizedBox(width: 20,),
                //                               Text('닉네임'),
                //                               SizedBox(width: 190,),
                //                               Text('날짜')
                //                             ],
                //                           ),
                //                           SizedBox(height: 15,),
                //                           Column(
                //                             crossAxisAlignment: CrossAxisAlignment.start,
                //                             children: [
                //                               Text('도움 요청 제목',style: textStyle.bk16bold,),
                //                               Container(width: 300,
                //                                 height: 200,
                //                               child: Text('도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 도움을 요청하는 내용 '),)
                //                             ],
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //
                //               )
                //             ],
                //           ),)
                //       ]
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.01),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:[
              if(answered == false)...[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: Get.width,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(colorChart.blue)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 30,
                        bottom: 1,
                        top: 1,
                        child: TextField(
                          controller: myController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: '도움을 보내려면 여기를 탭하세요.'),
                          onChanged: (s) {
                            //text = s;
                          },
                          onTap: (){

                          },
                        ),
                      ),
                      Positioned(
                        left: Get.width - 78,
                        //right: 30,
                        bottom: 3,
                        top: 3,
                        child: ElevatedButton(
                            onPressed: () {
                              FlutterDialog2();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(colorChart.blue),
                              fixedSize: const Size(23, 23),
                              shape: const CircleBorder(),
                            ),
                            child:Icon(Icons.arrow_upward, color: Colors.white,)
                        ),
                      ),
                    ],
                  ),
                ),
              ],

            ],
          ),
        )
    );
  }
}