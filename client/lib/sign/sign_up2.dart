import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/style.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:exif/exif.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// 회원가입 페이지(이메일 회원가입)
class SignUpPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpPage(),
      ),
    );
  }

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  //final List<XFile>? images = await _picker.pickMultiImage();

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final certNumController = TextEditingController();

  // 단계를 위한 bool
  bool idCheck = false;
  bool emailCheck = false;
  bool certStartCheck = false;
  bool certCheck = false;
  bool pwCheck = false;
  bool pwReCheck = false;

  // 글 저장하기 (POST)
  void saveMemorial(String content) async {

    // 요청 본문 데이터
    var data = {
      "content" : "test",
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'axNNnzcfJaSiTPI6kW23G2Vns9o1', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    var url = Uri.parse('http://3.38.1.125:8080/memorial'); // 엔드포인트 URL 설정

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
        backgroundColor: Color(0xffF2F4F6),
        appBar: AppBar(
          title: Text("회원가입", style: textStyle.bk20normal),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,

        ),extendBodyBehindAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 85,),
            if(idCheck == false && emailCheck == false && pwCheck == false && pwReCheck == false)...[
              Row(
                children: [
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('아이디를 입력하세요.',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      Text('로그인에 사용할 아이디를 입력하세요.'),
                    ],
                  ),
                ],
              ),

            ] else if(idCheck == true && emailCheck == false && pwCheck == false && pwReCheck == false)...[
              Row(
                children: [
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('이메일 주소를 입력하세요.',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      Text('이메일 인증을 위해 정확한 이메일을 작성해주세요.'),
                    ],
                  ),
                ],
              ),
            ] else if(idCheck == true && emailCheck == true && pwCheck == false && pwReCheck == false && certCheck == true)...[
              Row(
                children: [
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('인증 코드가 확인 되었습니다.\n비밀번호를 설정해주세요.',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      Text('로그인에 사용할 비밀번호를 입력하세요.'),
                    ],
                  ),
                ],
              ),
            ] else if(idCheck == true && emailCheck == true && pwCheck == true && pwReCheck == false)...[
              Row(
                children: [
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('비밀번호를 확인해주세요.',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      Text('비밀번호를 다시 입력해주세요.'),
                    ],
                  ),
                ],
              ),
            ],
            SizedBox(height: 15,),
            if(idCheck == false && emailCheck == false && pwCheck == false && pwReCheck == false)...[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffEEF3FE),
                    labelText: '아이디',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 328,
                    child: ElevatedButton(onPressed: (){
                      idCheck = true;
                      setState(() {});
                    },
                        style: buttonChart().signInbtn,
                        child: Text("다음", style: textStyle.white16normal,)
                    ),
                  ),
                ],
              ),
            ] else if(idCheck == true && emailCheck == false && pwCheck == false && pwReCheck == false)...[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffEEF3FE),
                    labelText: '이메일',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 328,
                    child: ElevatedButton(onPressed: (){
                      certStartCheck = true;
                      setState(() {});
                    },
                        style: buttonChart().signInbtn,
                        child: Text("다음", style: textStyle.white16normal,)
                    ),
                  ),
                ],
              ),
              if(certStartCheck)...[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffEEF3FE),
                      labelText: '인증 번호',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(width: 328,
                      child: ElevatedButton(onPressed: (){
                        emailCheck = true;
                        certCheck = true;
                        setState(() {});
                      },
                          style: buttonChart().signInbtn,
                          child: Text("다음", style: textStyle.white16normal,)
                      ),
                    ),
                  ],
                ),
              ],

            ] else if(idCheck == true && emailCheck == true && pwCheck == false && pwReCheck == false && certCheck == true)...[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  obscureText: true,
                  controller: pwController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffEEF3FE),
                    labelText: '비밀번호',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 328,
                    child: ElevatedButton(onPressed: (){
                      pwCheck = true;
                      setState(() {});
                    },
                        style: buttonChart().signInbtn,
                        child: Text("다음", style: textStyle.white16normal,)
                    ),
                  ),
                ],
              ),
            ] else if(idCheck == true && emailCheck == true && pwCheck == true && pwReCheck == false && certCheck == true)...[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  obscureText: true,
                  controller: pwController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffEEF3FE),
                    labelText: '비밀번호 확인',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 328,
                    child: ElevatedButton(onPressed: (){
                    },
                        style: buttonChart().signInbtn,
                        child: Text("다음", style: textStyle.white16normal,)
                    ),
                  ),
                ],
              ),
            ],


            SizedBox(height: 35,),


          ],
        ),

      );

  }
}
