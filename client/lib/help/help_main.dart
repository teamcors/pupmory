import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/help/answer_help_request.dart';
import 'package:client/help/received_help.dart';
import 'package:client/help/write_help_request.dart';
import 'package:client/style.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String selectedProfile = "";
int hid = 0;

class HelpMainPage extends StatefulWidget {
  @override
  State<HelpMainPage> createState() => _HelpMainPageState();
}

class _HelpMainPageState extends State<HelpMainPage> {

  // 화면에 보이는 UI 설정 bool
  bool askHelp = true;
  bool sendHelp = false;

  int askHelpCount = 5;
  int sendHelpCount = 5;

  /// 도움 요청하기
  bool receivedHelp = false; // 요청한 도움을 받았는지
  bool checkAskHelp = false; // 요청받은 도움을 확인했는지

  /// 도움 보내기
  bool checkSendHelp = false; // 도움을 잘 보냈는지

  List<String> parsedResponse = [
    'https://images.unsplash.com/photo-1615751072497-5f5169febe17?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80',
    'https://images.unsplash.com/photo-1588943211346-0908a1fb0b01?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80',
    'https://images.unsplash.com/photo-1596492784531-6e6eb5ea9993?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80',
    'https://images.unsplash.com/photo-1544568100-847a948585b9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
    'https://images.unsplash.com/photo-1546447147-3fc2b8181a74?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80',
    'https://images.unsplash.com/photo-1636910825807-171715240043?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1992&q=80',
    'https://images.unsplash.com/photo-1579807351146-e6dd49462635?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80',
    'https://images.unsplash.com/photo-1634635880938-d81e973bcd6c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80',
    'https://images.unsplash.com/photo-1534176043700-789edb4e2f91?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
  ];

  late List<dynamic> parsedResponseHR; // 도움 요청 내역
  late List<dynamic> parsedResponseHA; // 도움 답변 내역
  bool isLastest = false;

  // 내가 보낸 "도움 요청" 내역 불러오기(GET)
  void callHelpRequest() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/community/help/all?type=req'; // 실제 API 엔드포인트로 변경하세요

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

      parsedResponseHR = json.decode(jsonResponse);

      setState(() {});

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 내가 보낸 "도움" 내역 불러오기(GET)
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
    callHelpRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Padding(padding: EdgeInsets.only(right: 60),
              child: Text('도움 내역', style: textStyle.bk20bold,),
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
        color: Color(0xffDDE7FD),
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 15,),

              Container(
                width: 328,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xffF2F6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [

                    if(askHelp && sendHelp == false)...[
                      SizedBox(width: 5,),
                      Container(
                          decoration: BoxDecoration(
                            color: Color(0xffC0D2FC),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          width: 156,
                          height: 32,
                          child: Center(child: Text("도움 요청하기", style: TextStyle(color: Color(0xff4B5396),fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600, fontSize: 16),),)
                      ),
                      SizedBox(width: 42,),
                      TextButton(onPressed: (){
                        askHelp = false;
                        sendHelp = true;
                        callHelpAnswer();
                        setState(() {});
                      }, child: Text("도움 보내기", style: textStyle.bk16normal,)),
                      SizedBox(width: 20,),

                    ]else if(askHelp  == false && sendHelp)...[
                      SizedBox(width: 36,),
                      TextButton(onPressed: (){
                        askHelp = true;
                        sendHelp = false;
                        callHelpRequest();
                        setState(() {});
                      }, child: Text("도움 요청하기", style: textStyle.bk16normal,)),
                      SizedBox(width: 36,),
                      Container(
                          decoration: BoxDecoration(
                            color: Color(0xffC0D2FC),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          width: 156,
                          height: 32,
                          child: Center(child: Text("도움 보내기", style: TextStyle(color: Color(0xff4B5396),fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600, fontSize: 16)),)
                      ),
                      //SizedBox(width: 20,),
                    ]
                  ],
                ),
              ),

              SizedBox(height: 5,),

              if(askHelp)...[
                if(parsedResponseHR.length == 0)...[
                  Container(
                    width: Get.width,
                    height: 120,
                    color: Color(0xffDDE7FD),
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        SvgPicture.asset(
                          'assets/images/help/no_help.svg',
                        ),
                        SizedBox(width: 55,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 45,),
                            Text('도움을 요청하고 받은 내역이 없습니다.', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(height: 5,),
                            Text('               어려움을 겪고 있다면 언제든지\n다른 반려인들에게 도움을 요청해보세요!', style: textStyle.bk14normal)
                          ],)
                      ],
                    ),
                  ),
                ]else...[
                  Container(
                    width: Get.width,
                    height: 120,
                    color: Color(0xffDDE7FD),
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        SvgPicture.asset(
                          'assets/images/help/ask_help.svg',
                        ),
                        SizedBox(width: 45,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 45,),
                            Text('총 ${parsedResponseHR.length}번의 소중한 도움을 받았습니다.', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(height: 5,),
                            Text('               어려움을 겪고 있다면 언제든지\n다른 반려인들에게 도움을 요청해보세요!', style: textStyle.bk14normal)
                          ],)
                      ],
                    ),
                  ),
                ]

              ] else if(sendHelp)...[
                if(parsedResponseHA.length ==0)...[
                  Container(
                    width: Get.width,
                    height: 120,
                    color: Color(0xffDDE7FD),
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        SvgPicture.asset(
                          'assets/images/help/no_help.svg',
                        ),
                        SizedBox(width: 55,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 45,),
                            Text('도움을 요청받고 보낸 내역이 없습니다.', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(height: 5,),
                            Text('             다른 반려인이 도움을 요청하면 \n따뜻한 마음을 담아 도움을 보내주세요!', style: textStyle.bk14normal,)
                          ],)
                      ],
                    ),
                  ),
                ]else...[
                  Container(
                    width: Get.width,
                    height: 120,
                    color: Color(0xffDDE7FD),
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        SvgPicture.asset(
                          'assets/images/help/send_help.svg',
                        ),
                        SizedBox(width: 63,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 45,),
                            Text('총 ${parsedResponseHA.length}번의 소중한 도움을 보냈습니다.', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600, fontSize: 16)),
                            SizedBox(height: 5,),
                            Text('             다른 반려인이 도움을 요청하면 \n따뜻한 마음을 담아 도움을 보내주세요!', style: textStyle.bk14normal)
                          ],)
                      ],
                    ),
                  ),
                ]
              ],

              Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  width: Get.width,
                  //height: Get.height-30,
                  color: Color(0xffF2F4F6),
                  child:
                  Column(
                    children: [
                      if(askHelp)...[
                        if(parsedResponseHR.length == 0)...[
                          SizedBox(height: 180,),
                          Container(
                            height: 600,
                            child: Center(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/memorial/no_result.svg',
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('도움을 요청한 내역이 없습니다.', style: textStyle.bk14normal),
                                ],
                              ),
                            ),
                          )

                        ]else...[
                          Container(
                              height: Get.height - 300,
                              child: ListView.builder(
                                  padding: const EdgeInsets.all(5),
                                  itemCount: parsedResponseHR.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return
                                      Padding(padding: EdgeInsets.only(bottom: 15),
                                        child: InkWell(
                                          onTap: (){
                                            hid = parsedResponseHR[index]['id'];
                                            setState(() {

                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ReceivedHelpPage()));
                                          },
                                          child: Container(
                                            width: Get.width,
                                            height: 88,
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  minRadius: 30,
                                                  maxRadius: 35,
                                                  backgroundImage:
                                                  NetworkImage(parsedResponse[index],
                                                  ),
                                                ),
                                                SizedBox(width: 15,),
                                                Container(width: 165,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 15,),
                                                      Row(
                                                        children: [
                                                          Text('${parsedResponseHR[index]['toUserUid']}', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold),),
                                                          Text('님에게', style: textStyle.bk14normal),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      if(parsedResponseHR[index]['isFromUserReadAnswer'] == 0)...[
                                                        Text('도움을 받았습니다.', style: textStyle.bk14normal),
                                                      ] else if(parsedResponseHR[index]['isFromUserReadAnswer'] == 1)...[
                                                        Text('받은 도움을 확인해보세요!', style: textStyle.bk14normal),
                                                      ] else if(parsedResponseHR[index]['isFromUserReadAnswer'] == 2)...[
                                                        Text('도움을 요청했습니다.', style: textStyle.bk14normal),
                                                      ],
                                                      //Text('도움을 요청했습니다', style: TextStyle(color: Color(0xff99A8CB), fontSize: 14),),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(width: 15,),
                                                Column(children: [
                                                  // DateFormat("MM/dd hh:mm").format(parsedResponseHR[index]['createdAt'])
                                                  // DateFormat('dd/MM HH:mm').parse(parsedResponseHR[index]['createdAt'])
                                                  // DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))
                                                  Text('${DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))}', style: TextStyle(color: Color(0xff99A8CB), fontSize: 10),),
                                                  SizedBox(height: 25,),
                                                  if(parsedResponseHR[index]['answeredAt'] == null)...[
                                                    Container(
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffFCCBCD),
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        width: 49,
                                                        height: 18,
                                                        child: Center(child: Text('요청중', style: TextStyle(fontSize: 12,color: Colors.white),),)
                                                    )
                                                  ],

                                                ],)

                                              ],
                                            ),
                                          ),
                                        ),);
                                  })
                          )
                        ]
                      ] else if(sendHelp)...[
                        if(parsedResponseHA.length == 0)...[
                          SizedBox(height: 180,),
                          Container(
                            height: 600,
                            child: Center(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/help/no_send_help.svg',
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('도움을 요청 받은 내역이 없습니다.'),
                                ],
                              ),
                            ),
                          )
                        ]else...[
                          Container(
                              height: Get.height - 300,
                              child: ListView.builder(
                                  padding: const EdgeInsets.all(5),
                                  itemCount: parsedResponseHA.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return
                                      Padding(padding: EdgeInsets.only(bottom: 15),
                                        child: InkWell(
                                          onTap: (){
                                            hid = parsedResponseHA[index]['id'];
                                            setState(() {

                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AnswerHelpRequestPage()));
                                          },
                                          child: Container(
                                            width: Get.width,
                                            height: 88,
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  minRadius: 30,
                                                  maxRadius: 35,
                                                  backgroundImage:
                                                  NetworkImage(parsedResponse[index],
                                                  ),
                                                ),
                                                SizedBox(width: 15,),
                                                Container(width: 165,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 15,),
                                                      Row(
                                                        children: [
                                                          Text('${parsedResponseHA[index]['fromUserUid']}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                                          Text('님이', style: textStyle.bk14normal),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text('도움을 요청했습니다.', style: textStyle.bk14normal),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(width: 15,),
                                                Column(children: [
                                                  Text('${DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHA[index]['createdAt']))}', style: TextStyle(color: Color(0xff99A8CB),fontSize: 10),),
                                                  SizedBox(height: 25,),
                                                  if(parsedResponseHA[index]['answeredAt'] == null)...[
                                                    Row(children: [
                                                      SizedBox(width: 10,),
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: Color(0xffFCCBCD),
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          width: 35,
                                                          height: 18,
                                                          child: Center(child: Text('요청', style: TextStyle(fontSize: 12,color: Colors.white),),)
                                                      )
                                                    ],),

                                                  ]else...[
                                                    Row(children: [
                                                      SizedBox(width: 10,),
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: Color(0xffC0D2FC),
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          width: 35,
                                                          height: 18,
                                                          child: Center(child: Text('완료', style: TextStyle(fontSize: 12,color: Colors.white),),)
                                                      )
                                                    ],)

                                                  ]
                                                ],)
                                              ],
                                            ),
                                          ),
                                        ),);
                                  })
                          )
                        ]
                      ]
                    ],
                  )
              ),


            ],
          ),
        ),
      ),
    );
  }
}