import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/sign/sign_in.dart';
import 'package:client/style.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final rePWController = TextEditingController();

  // 텍스트 필드 저장
  String userEmail ="";
  String userPassword ="";
  String userPasswordCheck ="";

  // 단계를 위한 bool
  bool emailCheck = false;
  bool pwCheck = false;
  bool pwReCheck = false;
  bool sentEmail = false;

  // 텍스트 필드에 입력을 했는지 확인
  bool setEmail = false;
  bool setPassword = false;
  bool setPasswordCheck = false;


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() async {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),

        ),extendBodyBehindAppBar: true,
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 86,),
              /// 텍스트
              if(emailCheck == false && pwCheck == false && pwReCheck == false)...[
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('이메일 주소를 입력하세요.',style: textStyle.bk20semibold),
                        SizedBox(height: 16,),
                        Text('이메일 인증을 위해 정확한 이메일을 작성해주세요.',style: textStyle.bk13light),
                      ],
                    ),
                  ],
                ),

              ] else if(emailCheck == true && pwCheck == false && pwReCheck == false )...[
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('비밀번호를 설정해주세요.',style: textStyle.bk20semibold),
                        SizedBox(height: 16,),
                        Text('로그인에 사용할 비밀번호를 입력하세요.',style: textStyle.bk13light),
                      ],
                    ),
                  ],
                ),
              ] else if(emailCheck == true && pwCheck == true && pwReCheck == false)...[
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('비밀번호를 확인해주세요.',style: textStyle.bk20semibold),
                        SizedBox(height: 16,),
                        Text('비밀번호를 다시 입력해주세요.',style: textStyle.bk13light),
                      ],
                    ),
                  ],
                ),
              ]else if((emailCheck == true && pwCheck == true && pwReCheck == true))...[
                Row(
                  children: [
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('본인 인증 이메일을 전송했어요.',style: textStyle.bk20semibold),
                        SizedBox(height: 16,),
                        Text('본인 인증을 통해 회원가입을 완료해보세요.\n이메일이 오지 않았다면, 스팸메일함을 확인해보세요.',style: textStyle.bk13light),
                      ],
                    ),
                  ],
                ),
              ],

              SizedBox(height: 20,),

              /// 텍스트 필드
              if(emailCheck == false && pwCheck == false && pwReCheck == false)...[
                Form(
                  key: _formKey,
                  child:
                  Container(
                    width: screenSize.width,
                    height: 44,
                    child: TextFormField(
                      style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                          fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
                      controller: emailController,
                      onChanged: (text){
                        setEmail = true;
                        setState(() {
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xffF9F9F9),
                        hintText: '이메일 주소',
                        hintStyle: textStyle.grey16normal,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onSaved: (value) {
                        print('Name field onSaved:$value');
                      },
                      validator: (value) {
                        if(!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(value!)){
                          return '잘못된 이메일 형식입니다.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        print('submitted:$value');
                      },
                    ),
                  ),

                ),

              ]else if((emailCheck == true && pwCheck == false && pwReCheck == false))...[
                Form(
                  key: _formKey,
                  child:

                  Container(
                    width: screenSize.width,
                    height: 44,
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                          fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
                      controller: pwController,
                      onChanged: (text){
                        setPassword = true;
                        setState(() {
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xffF9F9F9),
                        hintText: '비밀번호',
                        hintStyle: textStyle.grey16normal,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onSaved: (value) {
                        print('Name field onSaved:$value');
                      },
                      validator: (value) {
                        if(value!.length < 8){
                          return '8자 이상의 영문, 숫자, 특수문자를 조합하여 설정해주세요.';
                        }
                        // if(!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value!)){
                        //   return '8자 이상의 영문, 숫자, 특수문자를 조합하여 설정해주세요.';
                        // } else if(!RegExp(r'[a-zA-Z]').hasMatch(value!)){
                        //   return '8자 이상의 영문, 숫자, 특수문자를 조합하여 설정해주세요.';
                        // }else if(value!.length < 8){
                        //   return '8자 이상의 영문, 숫자, 특수문자를 조합하여 설정해주세요.';
                        // }
                      },
                      onFieldSubmitted: (value) {
                        print('submitted:$value');
                      },
                    ),
                  ),
                ),



              ] else if((emailCheck == true && pwCheck == true && pwReCheck == false))...[
                Form(
                  key: _formKey,
                  child:
                  Container(
                    width: screenSize.width,
                    height: 44,
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                          fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
                      controller: rePWController,
                      onChanged: (text){
                        setPasswordCheck = true;
                        setState(() {
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xffF9F9F9),
                        hintText: '비밀번호 확인',
                        hintStyle: textStyle.grey16normal,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onSaved: (value) {
                        print('Name field onSaved:$value');
                      },
                      validator: (value) {
                        if(!(value == userPassword)){
                          return '비밀번호가 일치하지 않습니다.';
                        }
                      },
                      onFieldSubmitted: (value) {
                        print('submitted:$value');
                      },
                    ),
                  ),


                ),

              ] else if((emailCheck == true && pwCheck == true && pwReCheck == true))...[

                Container(
                  width: screenSize.width,
                  height: 44,
                  child: TextField(
                    style: TextStyle(decorationThickness: 0, fontFamily: 'Pretendard',
                        fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.black)),
                    readOnly: true, // 읽기 전용
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color(0xffEAEAEA),
                      hintText: userEmail,
                      hintStyle: textStyle.grey16normal,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                )
              ],

              SizedBox( height: 16,),
              /// 버튼
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(emailCheck == false && pwCheck == false && pwReCheck == false)...[
                    if(setEmail)...[
                      Container(
                        height: 44,
                        width: screenSize.width,
                        child: ElevatedButton(onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _formKey.currentState!.save();
                              emailCheck = true;
                              userEmail = emailController.text;
                            });
                          }
                          //setState(() {});
                        },
                            style: buttonChart().signInbtn,
                            child: Text("다음", style: textStyle.white16semibold,)
                        ),
                      ),
                    ]else...[
                      Container(
                        height: 44,
                        width: screenSize.width,
                        child: ElevatedButton(onPressed: (){
                          // 아무 반응 없는 것이 맞음
                        },
                            style: buttonChart().purplebtn3,
                            child: Text("다음", style: textStyle.white16semibold,)
                        ),
                      ),
                    ]
                  ]
                  else if(emailCheck == true && pwCheck == false && pwReCheck == false)...[
                    if(setPassword)...[
                      Container(
                        height: 44,
                        width: screenSize.width,
                        child: ElevatedButton(onPressed: (){

                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _formKey.currentState!.save();
                              pwCheck = true;
                              userPassword = pwController.text;
                            });
                          }
                        },
                            style: buttonChart().signInbtn,
                            child: Text("다음", style: textStyle.white16semibold,)
                        ),
                      ),
                    ]else...[
                      Container(
                        height: 44,
                        width: screenSize.width,
                        child: ElevatedButton(onPressed: (){
                          // 아무 반응 없는 것이 맞음
                        },
                            style: buttonChart().purplebtn3,
                            child: Text("다음", style: textStyle.white16semibold,)
                        ),
                      ),
                    ]
                  ]
                  else if(emailCheck == true && pwCheck == true && pwReCheck == false)...[
                      if(setPasswordCheck)...[
                        Container(
                          height: 44,
                          width: screenSize.width,
                          child: ElevatedButton(onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _formKey.currentState!.save();
                                pwReCheck = true;
                                userPasswordCheck = rePWController.text;
                              });

                              try {
                                final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: userEmail, password: userPasswordCheck);
                                if (result.user != null) {
                                  // 인증 메일 발송
                                  result.user!.sendEmailVerification();
                                  // 새로운 계정 생성이 성공하였으므로 기존 계정이 있을 경우 로그아웃 시킴
                                  //signOut();
                                  //return true;
                                }
                              } on Exception catch (e) {
                                // logger.e(e.toString());
                                // List<String> result = e.toString().split(", ");
                                // setLastFBMessage(result[1]);
                                // return false;
                              }

                            }
                          },
                              style: buttonChart().signInbtn,
                              child: Text("다음", style: textStyle.white16semibold,)
                          ),
                        ),
                      ]else...[
                        Container(
                          height: 44,
                          width: screenSize.width,
                          child: ElevatedButton(onPressed: (){
                            // 아무 반응 없는 것이 맞음
                          },
                              style: buttonChart().purplebtn3,
                              child: Text("다음", style: textStyle.white16semibold,)
                          ),
                        ),
                      ]

                    ]
                    else if(emailCheck == true && pwCheck == true && pwReCheck == true)...[
                        Container(
                          height: 44,
                          width: screenSize.width,
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()));
                          },
                              style: buttonChart().signInbtn,
                              child: Text("확인", style: textStyle.white16semibold,)
                          ),
                        ),
                      ],
                ],
              ),


            ],
          ),
        ),

      );

  }
}