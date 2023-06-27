import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:client/progressbar/animation_progressbar.dart';
import '../main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


/// 두번째 대화 내용 (Chat GPT 활용 예정)
class Con1_1Page extends StatefulWidget {


  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => Con1_1Page(),
      ),
    );
  }

  @override
  _Con1_1PageState createState() => _Con1_1PageState();
}

class _Con1_1PageState extends State<Con1_1Page> {

  void showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT
    );
  }

  String getToday() {
    DateTime now = DateTime.now();

    String year = DateFormat('yyyy').format(now);
    String month = DateFormat('M').format(now);
    String day = DateFormat('d').format(now);
    String hour_ = DateFormat('h').format(now);

    strToday='$year년 $month월 $day일';
    hour = '$hour_시';

    return strToday;
  }

  FocusNode _focusNode = FocusNode();

  String strToday = "";
  String hour = "";

  @override
  void initState() {
    super.initState();
    _callAPI();
    getToday();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // 키보드 올리기
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  void dispose() async {
    super.dispose();
  }

  ClipRRect _userImage(String url) => ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child:Image.network(url)
  );

  int nextQuestion = 0;

  bool heart = false;
  bool pickTime = false;

  String assetImage = "assets/images/con0_10.png";


  /// 텍스트 필드에 추가하고 버튼 누를 때마다 값 증가 및 리스트에 넣고 데이터테이블에 값넣기
  int answerNumber = 0;
  List<String> answer_ = ["","",""]; /// 사용자 이름, 반려견의 존재 의미, 반려견 이름
  /// // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final weatherScrollController_ = TextEditingController();
  final placeScrollController_ = TextEditingController();
  final playScrollController_ = TextEditingController();
  final memoryScrollController_ = TextEditingController();
  final heartScrollController_ = TextEditingController();


  bool userName = false;
  String userNameText = "";
  bool dogName = false;
  String dogNameText = "";
  bool meaning = false;
  String meamimgText = "";
  bool seeNext = false;

  bool answer = false;

  List<int> numbers = [1,2,3];

  List<dynamic> questions1_1 =[
    // "하마님! 기다리고 있었어요.\n대화를 시작해볼까요?",
    // "오늘은 어떤 주제로\n이야기해볼까요?",
    // "좋아요, 하마님.",
    // "초코와 하마님의\n행복한 모습을 떠올리니\n하마님의 마음은 어떤것 같나요?",
    // "하마님,\n초코와의 기억을 떠올려보니",
    // "마냥 슬프기만 하지는 않다는 것을\n느끼셨나요?",
    // "하마님의 마음이 잠시동안은\n행복했길 바라요.",
    // "하지만, 하마님...",
    // "초코를 생각하다보면\n분명 슬픈 감정이 생겨날 수 있어요.",
    // "그럴땐 도와줄개에서\n도움을 요청하거나,",
    // "함께할개에서 더 많은 사람들과\n이야기를 나눠보는 걸 추천드릴게요.",
    // "커뮤니티에서도\n하마님에게 맞는 도움을 받아보세요!", //11
    // "이제 우리가 다시 만나게 될\n시간을 알려주세요.",
    // "좋아요! 그때 봐요",
  ];

  void _callAPI() async {

    // 요청 본문 데이터
    var data = {
      "uuid" : "axNNnzcfJaSiTPI6kW23G2Vns9o1",
      "stage" : "1",
      "set" : "1",
      "lineId" : "0",
      "userAnswer" : "그 날은 바람이 선선하던 날씨였어요.\n저는 초코와 집 앞 공원에 있었어요.\n신나게 뛰놀던 초코의 모습을 떠올리면 그래도 함께한 시간은 즐겁게 보냈구나 싶어요."
    };

    var url = Uri.parse('http://3.38.1.125:8080/conversation/answer'); // 엔드포인트 URL 설정

    try {
      var response = await http.post(
        url,
        body: json.encode(data), // 요청 본문에 데이터를 JSON 형식으로 인코딩하여 전달
        headers: {'Content-Type': 'application/json',}, // 요청 헤더에 Content-Type 설정
      );

      if (response.statusCode == 200) {
        // 응답 성공 시의 처리

        var jsonResponse = utf8.decode(response.bodyBytes); // 응답 본문을 JSON 형식으로 디코딩
        // JSON 값을 활용한 원하는 동작 수행
        //utf8.decode(jsonResponse);
        print(jsonResponse);

        var parsedResponse = json.decode(jsonResponse);

        if (parsedResponse['answer'] != null) {
          setState(() {
            questions1_1.add(parsedResponse['answer'].toString());
          });
        }

        print(questions1_1);


        print('API 호출 성공: ${response.statusCode}');
      } else {
        // 요청 실패 시의 처리
        print('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 발생 시의 처리
      print('API 호출 중 예외 발생: $e');
    }
  }






  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
          color: Color(0xffF3F3F3),
          child: GestureDetector(
            onTap: (){
              nextQuestion++;
              setState(() {
              });
              // 추후 데이터베이스 연결으로 변경하기
              if(nextQuestion ==1){
                assetImage = "assets/images/con1_2.png";
                answer = false;
              }
              if(nextQuestion ==2){
                assetImage = "assets/images/con0_1.png";
                answer = false;
              }
              if(nextQuestion ==3){
                assetImage = "assets/images/con0_3.png";
                heart = true;
                answer = true;}
              // 여기서부터 재작업 시작
              if(nextQuestion ==4){
                assetImage = "assets/images/con0_2.png";
                heart = false;
                answer=false;}
              if(nextQuestion ==5){
                assetImage = "assets/images/con0_1.png";}
              if(nextQuestion ==6){
                assetImage = "assets/images/con0_4.png";}
              if(nextQuestion ==7){
                assetImage = "assets/images/con0_2.png";}
              if(nextQuestion ==8){
                assetImage = "assets/images/con0_1.png";}
              if(nextQuestion ==9){
                assetImage = "assets/images/con0_2.png";}
              if(nextQuestion ==10){
                assetImage = "assets/images/con0_4.png";}
              if(nextQuestion ==11){
                assetImage = "assets/images/con0_10.png";}
              if(nextQuestion ==12){
                assetImage = "assets/images/con0_9.png";
                pickTime = true;
                answer=true;}
              if(nextQuestion ==13){
                assetImage = "assets/images/con0_10.png";
                pickTime = false;}

              // if(nextQuestion ==15){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Con1_2Page()));}
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text("기억할개", style: TextStyle(fontSize:16, color: Colors.black ),),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                iconTheme: IconThemeData(color: Colors.black),
                centerTitle: true,
              ),extendBodyBehindAppBar: true,
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 105, left:16, right: 16),
                    child: Center(
                        child: FAProgressBar(
                          currentValue: 15,
                          size: 5,
                          backgroundColor: Colors.white,
                        )
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  Container(
                    width: screenSize.width,
                    height: 105,
                    child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(0xccffffff),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12, ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(
                                questions1_1[nextQuestion],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff222222),
                                  fontSize: 16,
                                ),
                              ),

                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          width: 48,
                          height: 16,
                          padding: EdgeInsets.only(bottom: 5.5),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/q_tail.png')
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Image.asset(assetImage,
                        // width: 260,
                        // height: 100,
                        fit:BoxFit.contain),
                  ),

                  if(answer == false)
                    Padding(padding: EdgeInsets.only(top:178),
                      child: Center(
                          child:Container(
                            width: screenSize.width,
                            child: Image.asset("assets/images/hand.png",
                                fit:BoxFit.contain
                            ),
                          )

                      ),
                    ),
                  if(nextQuestion == 13)
                    Center(
                      child:
                      Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 325),
                            child: SizedBox(width: 280,height: 40,
                                child: SizedBox( // SizedBox 대신 Container를 사용 가능
                                  width: 280,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(),));
                                    },
                                    child: Text('네, 다시 만나요.',style: TextStyle(color: Colors.white, fontSize: 16),),
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xff8d7af5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          side: BorderSide(color: Colors.black, width: 1),
                                        )
                                    ),
                                  ),
                                )
                            ),)

                        ],
                      ),
                    )
                  //SizedBox(height: 91.75),
                ],
              ),
              bottomSheet: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.01),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:[
                    if(heart == true)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: screenSize.width,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(0xff8d7af5)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              right: 30,
                              bottom: 4,
                              top: 2,
                              child: TextField(
                                controller: heartScrollController_,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: '우리는...'),
                                onChanged: (s) {
                                  //text = s;
                                },
                                onTap: (){

                                },
                              ),
                            ),
                            Positioned(
                              left: screenSize.width-76,
                              //right: 30,
                              bottom: 2,
                              top: 3,
                              child: ElevatedButton(
                                onPressed: () {
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff8d7af5),
                                  fixedSize: const Size(24, 24),
                                  shape: const CircleBorder(),
                                ),
                                child: const Text(
                                  '+',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if(pickTime == true)
                      Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top:35, bottom:16, right: 205),
                            child: Text(strToday, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                          Padding(padding: EdgeInsets.only(bottom:16, right: 285),
                            child: Text(hour, style: TextStyle(color: Colors.black, fontSize: 16),),
                          ),
                          Center(
                            child:
                            Padding(padding: EdgeInsets.only(bottom:35),
                              child: Row(
                                children: [
                                  Container(width: 115,),
                                  ElevatedButton(onPressed: (){},
                                    child: Text("3시간 후", style: TextStyle(color: Colors.black),),
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xffF7DE87)
                                    ),),
                                  Container(width: 32,),
                                  ElevatedButton(onPressed: (){},
                                    child: Text("정각",style: TextStyle(color: Colors.black),),
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xffF7DE87)
                                    ),),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child:
                            Column(
                              children: [
                                SizedBox(width: 280,height: 40,
                                  child: SizedBox( // SizedBox 대신 Container를 사용 가능
                                    width: 280,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        pickTime = false;
                                        nextQuestion ++;
                                        assetImage = "assets/images/con0_10.png";
                                        setState(() {
                                        });
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => WriteMemorialPage(),));
                                      },
                                      child: Text('이때 어때요?',style: TextStyle(color: Colors.white, fontSize: 16),),
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xff8d7af5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            side: BorderSide(color: Colors.black, width: 1),
                                          )
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          SizedBox(height: 40)
                        ],
                      )
                  ],
                ),
              ),
            ),

          )

      );

  }
}



