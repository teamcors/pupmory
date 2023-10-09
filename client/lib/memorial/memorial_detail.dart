import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hama/help/help_detail.dart';
import 'package:hama/style.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'memorial_main0919.dart' as main;
import 'package:http/http.dart' as http;

class MemorialDetailPage extends StatefulWidget {
  @override
  State<MemorialDetailPage> createState() => _MemorialDetailPageState();
}

class _MemorialDetailPageState extends State<MemorialDetailPage> {

  // 화면에 보이는 UI 설정 bool
  bool askHelp = true;
  bool sendHelp = false;

  bool isComment = false;

  // 코멘트 수와 좋아요 수
  int comments = 0;
  int hearts = 0;

  late Map<String, dynamic> parsedResponseCN; // 글 내용
  late List<dynamic> parsedResponseCM; // 댓글
  late bool myHeart; // 내가 좋아요 눌렀는지

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final myController = TextEditingController();

  // 글내용 가져오기
  void fetchWithHeaders() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial?postId=${main.postId.toString()}'; // 실제 API 엔드포인트로 변경하세요

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

      parsedResponseCN = json.decode(jsonResponse);

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }



  void fetchData() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial?postId=${main.postId.toString()}'; /// postId=1 추후에 바꿔주기

    // HTTP GET 요청 보내기
    var response = await http.get(Uri.parse(apiUrl));

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      var data = json.decode(response.body);
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCN = json.decode(jsonResponse);

      // 데이터 처리
      print('서버로부터 받은 내용 데이터: $jsonResponse');

      isComment = true;
      setState(() {

      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 댓글 가져오기
  void fetchDataComment() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/comment?postId=${main.postId.toString()}'; /// postId=1 추후에 바꿔주기

    // HTTP GET 요청 보내기
    var response = await http.get(Uri.parse(apiUrl));

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      var data = json.decode(response.body);
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCM = json.decode(jsonResponse);

      // 데이터 처리
      print('서버로부터 받은 데이터~: $jsonResponse');

      isComment = true;
      comments = parsedResponseCM.length;
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 댓글 저장하기 (POST)
  void saveComment(String content) async {

    // 요청 본문 데이터
    var data = {
      "content" : content,
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'axNNnzcfJaSiTPI6kW23G2Vns9o1', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    var url = Uri.parse('http://3.38.1.125:8080/memorial/comment?postId=${main.postId.toString()}'); // 엔드포인트 URL 설정

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

  // 좋아요 누르기(POST)
  void sendPostRequest() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/like?postId=${main.postId.toString()}'; // 실제 API 엔드포인트로 변경하세요

    // POST 요청 보내기e
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'axNNnzcfJaSiTPI6kW23G2Vns9o1', // 예: 인증 토큰을 추가하는 방법
        'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
        //'Content-Type': 'application/json',
      }, // 요청 헤더에 Content-Type 설정
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      setState(() {});
      // print('서버로부터 받은 데이터: ${response.body}');
    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }


  // 좋아요 가져오기- 클릭여부 확인(GET)
  void fetchDataLike() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/like?postId=${main.postId.toString()}'; /// postId=1 추후에 바꿔주기

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

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      var data = json.decode(response.body);
      var jsonResponse = utf8.decode(response.bodyBytes);

      myHeart = json.decode(jsonResponse);

      // 데이터 처리
      print('좋아요~: $myHeart');
      if(myHeart == true){
        hearts = 1;
      } else{
        hearts = 0;
      }

      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  /// 의문: 좋아요 수는 어떻게 가져오지??

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    print("test" + main.postId.toString());
    //fetchData();
    fetchWithHeaders();
    fetchDataComment();
    fetchDataLike();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(onPressed: (){
              print("refresh~");
              fetchDataComment();
              fetchDataLike();
              setState(() {
              });
            }, icon: Icon(Icons.menu))
          ],
        ),
        body: Container(
          color: Color(0xffF3F3F3),
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: Get.width,
                  height: 575,
                  color: Colors.white,
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              height: Get.width,
                              child:  ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child:  Image.network(main.selectedImage, fit: BoxFit.cover,),
                              ),
                            ),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Container(
                                  width: 120,
                                  height: 30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${parsedResponseCN['date']}의 기억", style: textStyle.grey12normal,),
                                      SizedBox(height: 3,),
                                      Text(parsedResponseCN['place'], style: textStyle.grey12normal)
                                    ],
                                  ),
                                ),
                                SizedBox(width: 165,),
                                Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child: InkWell(
                                        onTap: (){},
                                        child: SvgPicture.asset(
                                          'assets/images/memorial/comments.svg',
                                        ),
                                      ),),
                                    SizedBox( width: 3,),
                                    Text('${comments}'),
                                    SizedBox( width: 10,),
                                    if(hearts >= 1)...[
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: InkWell(
                                          onTap: (){
                                            // 좋아요 누르기
                                            sendPostRequest();
                                            fetchDataLike();
                                            //hearts= 0;
                                            setState(() {
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/memorial/heart-fill.svg',
                                          ),
                                        ),),
                                    ] else...[
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: InkWell(
                                          onTap: (){
                                            // 좋아요 누르기
                                            sendPostRequest();
                                            fetchDataLike();
                                            setState(() {
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/memorial/heart-empty.svg',
                                          ),
                                        ),
                                      ),
                                    ],
                                    SizedBox( width: 3,),
                                    Text('${hearts}'),
                                  ],
                                )


                              ],
                            ),
                            SizedBox(height: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(parsedResponseCN['title'],style: textStyle.bk16bold,),
                                SizedBox(height: 5,),
                                Container(width: Get.width,
                                  height: 50,
                                  child: Text(parsedResponseCN['content']),
                                ),
                                Container(width: Get.width,
                                  height: 10,
                                  child: Text('#${parsedResponseCN['hashtag']}', style: textStyle.grey12normal),
                                ),
                              ],
                            ),
                          ],
                        ),),

                    ],
                  ),

                ),
                SizedBox(height: 15,),
                Container(
                  height: 200,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          if(isComment)...[
                            for(int i=0; i<parsedResponseCM.length; i++)...[
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                height: 80,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(parsedResponseCM[i]['userUid']),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Text(parsedResponseCM[i]['content']),
                                    SizedBox(height: 5,),
                                    Text(DateFormat('MM/dd  HH:mm').format(DateTime.parse(parsedResponseCM[i]['createdAt'])).toString(), style: TextStyle(fontSize: 9),)

                                    //DateFormat('yy/MM/dd - HH:mm:ss').format(parsedResponse[0]['createdAt'])
                                  ],
                                ),
                              ),
                              SizedBox(height: 15,),
                            ]
                          ],

                          SizedBox(height: 15,),

                        ],
                      )
                  ),
                )
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
                            border: InputBorder.none, hintText: '댓글을 입력하려면 여기를 탭하세요.'),
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
                            saveComment(myController.text);
                            setState(() {
                            });
                            myController.clear();
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
          ),
        )
    );
  }
}