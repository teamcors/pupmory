import 'package:flutter_svg/svg.dart';
import 'package:client/sign/sign_up2.dart';
import 'package:client/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:http/http.dart';
//import 'package:petlose/sign/logintest2.dart';
import 'package:client/sign/google_log_in.dart';
//import 'package:petlose/start/start1.dart';
import 'package:client/firebase_options.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../screen.dart';

String uuid = "axNNnzcfJaSiTPI6kW23G2Vns9o1";
class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorString = ''; //login error 보려고 만든 String state

  static final storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key:'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      Navigator.pushNamed(context, '/main');
    } else {
      print('로그인이 필요합니다');
    }
  }

  //flutter_secure_storage 사용을 위한 초기화 작업


  // 로그인 버튼 누르면 실행
  // loginAction(accountName, password) async {
  //   try {
  //     var dio = Dio();
  //     var param = {'account_name': '$accountName', 'password': '$password'};
  //
  //     Response response = await dio.post('로그인 API URL', data: param);
  //
  //     if (response.statusCode == 200) {
  //       final jsonBody = json.decode(response.data['user_id'].toString());
  //       // 직렬화를 이용하여 데이터를 입출력하기 위해 model.dart에 Login 정의 참고
  //       var val = jsonEncode(Login('$accountName', '$password', '$jsonBody'));
  //
  //       await storage.write(
  //         key: 'login',
  //         value: val,
  //       );
  //       print('접속 성공!');
  //       return true;
  //     } else {
  //       print('error');
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  /// 토큰 뽑아오기1
  // Future<Details> getDetails() async {
  //   String bearer = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   print("Bearer: " + bearer.toString());
  //   String token = "Bearer ${bearer}";
  //   var apiUrl = Uri.parse('Your url here');
  //
  //   final response = await http.get(apiUrl, headers: {
  //     'Authorization' : '${token}'
  //   });
  //
  //   final responseJson = jsonDecode(response.body);
  //
  //   return Details.fromJson(responseJson);
  // }

  // /// 토큰 뽑아오기2
  // var token = FirebaseAuth.instance.currentUser?.getIdToken();
  // //var response = httpClient.get(url,headers: {'Authorization':"Bearer $token"});
  //
  //
  //
  // /// 회원가입, 로그인시 사용자 영속
  // void authPersistence() async{
  //   await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  // }



  /// 로그인
  // Future<void> signIn(String email, String pw) async{
  //   try {
  //     UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: email,
  //         password: pw
  //     );
  //     if (credential.user != null) {
  //       print("테스트 한번만..ㅠ");
  //       print(credential);
  //       print(credential.user!.uid);
  //     }
  //     // final userCredential = await FirebaseAuth.instance
  //     //     .signInWithEmailAndPassword(
  //     //     email: email,
  //     //     password: pw) //아이디와 비밀번호로 로그인 시도
  //     //     .then((value) {
  //     //   print(value);
  //     //   print("테스트확인좀^^");
  //     //   value.user!.emailVerified == true //이메일 인증 여부
  //     //       ? Navigator.push(context,
  //     //       MaterialPageRoute(builder: (_) => logintest2Page(title: 'test',)))
  //     //       : print('이메일 확인 안댐');
  //     //   return value;
  //     // });
  //   } on FirebaseAuthException catch (e) {
  //     //로그인 예외처리
  //     if (e.code == 'user-not-found') {
  //       print('등록되지 않은 이메일입니다');
  //     } else if (e.code == 'wrong-password') {
  //       print('비밀번호가 틀렸습니다');
  //     } else {
  //       print(e.code);
  //     }
  //
  //   }
  //
  //   //print(credential);
  //   // try {
  //   //   final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //   //       email: email,
  //   //       password: pw
  //   //   );
  //   // } on FirebaseAuthException catch (e) {
  //   //   if (e.code == 'user-not-found') {
  //   //     print('No user found for that email.');
  //   //   } else if (e.code == 'wrong-password') {
  //   //     print('Wrong password provided for that user.');
  //   //   }
  //   // } catch (e) {
  //   //   print(e);
  //   //   return false;
  //   // }
  //   authPersistence(); // 인증 영속
  //
  //   User user = await FirebaseAuth.instance.currentUser!;
  //   String idToken;
  //   try {
  //     ///String tokenResult = await user.getIdToken();
  //     // Send token to your backend via HTTPS
  //     /// 이건 규리 언니가 해준 부분
  //     print("토큰 결과:");
  //     ///print(tokenResult); // 이거를 서버로 전달하세요
  //
  //   } catch (e) {
  //     // Handle error
  //     print('Error: $e');
  //   }
  //   // return true;
  // }



  // Future<void> signIn(String email, String password) async {
  //   if (_form.currentState!.validate()) {
  //     print(email);
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password)
  //         .then((uid) => {
  //       //Fluttertoast.showToast(msg: "Login Successfully"),
  //       // Navigator.of(context)
  //       //     .pushReplacementNamed(UploadScreen.routeName),
  //     }).onError((e, s) {
  //       print("");
  //       // Fluttertoast.showToast(msg: 'Incorrect Email or Password.',
  //       //     toastLength: Toast.LENGTH_LONG
  //       // );
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return Container(
      color: Color(0xffDDE7FD),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 120,),
              Container(
                width: screenSize.width,
                height: 64,
                child: SvgPicture.asset(
                  'assets/images/logo/pupmory_logo3.svg',
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: idController,
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
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
              // SizedBox( // SizedBox 대신 Container를 사용 가능
              //   width: 240,
              //   height: 32,
              //   child: FilledButton(
              //     onPressed: () {},
              //     child: Text('로그인'),
              //     style: ButtonStyle(
              //       //backgroundColor: Color(0x5A9679)
              //     ),
              //   ),
              // ),

              SizedBox(height: 35,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 328,
                    child: ElevatedButton(onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyScreenPage(title: '스크린 페이지',)));
                    },
                        style: buttonChart().signInbtn,
                        child: Text("로그인", style: textStyle.white16normal,)
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 100,),
                      TextButton(
                        onPressed: (){
                        },
                        child: Text("아이디 찾기", style: textStyle.bk14normal),),
                      SizedBox(width: 10,),
                      Container(width: 2, height: 14, color: Colors.black12,),
                      SizedBox(width: 10,),
                      TextButton(
                        onPressed: (){
                        },
                        child: Text("비밀번호 찾기", style: textStyle.bk14normal),),

                    ],
                  ),
                ],
              ),

              SizedBox(height: 105,),
              Container(width: 328,
                child: ElevatedButton(onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInDemo()));
                },
                    style: buttonChart().whitebtn,
                    child: Row(
                      children: [
                        SizedBox(width: 65,),
                        Image.asset('assets/images/logo/google_logo.png'),
                        SizedBox(width: 15,),
                        Text("Google 계정으로 로그인", style: textStyle.bk16normal,)
                      ],
                    )
                ),
              ),
              SizedBox(height: 15,),
              Container(width: 328,
                child: ElevatedButton(onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpPage()));
                },
                    style: buttonChart().bluebtn,
                    child: Text("이메일로 회원가입", style: textStyle.bk16normal,)
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child:
              //   ElevatedButton(onPressed: (){
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (_) => logintest2Page(title: 'test',)));
              //   },
              //       child: Text("회원가입")),
              // ),
              //
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: ElevatedButton(onPressed: (){
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (_) => const SignInDemo()));
              //   },
              //       child: Text("구글 계정으로 로그인")),
              // ),
            ],
          ),
        ),
      ),
    );
  }

}