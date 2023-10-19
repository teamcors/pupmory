import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/memorial/write_memorial.dart';
import 'package:client/style.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'memorial_detail.dart';
import 'watch_others.dart';

class MemorialMain0919Page extends StatefulWidget {
  @override
  State<MemorialMain0919Page> createState() => _MemorialMain0919PageState();
}

String selectedImage = "";
int postId = 0;


class Todos {
  String? posts;

  Todos({this.posts});

  Todos.fromJson(Map<String, dynamic> json) {
    posts = json['posts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posts'] = this.posts;
    return data;
  }
}

class _MemorialMain0919PageState extends State<MemorialMain0919Page> {

  // 화면에 보이는 UI 설정 bool
  bool askHelp = true;
  bool sendHelp = false;

  bool checkCN = false;

  List<String> con0Text =[];

  void _callAPI2() async {
    var url = Uri.parse(
      'http://3.38.1.125:8080/memorial/all',
    );
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // url = Uri.parse('https://reqbin.com/sample/post/json');
    // response = await http.post(url, body: {
    //   'key': 'value',
    // });
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
  }


  Future<List<Todos>> fetchTodos() async {
    final response = await http.get(
        Uri.parse('http://3.38.1.125:8080/memorial/all')
    );

    if(response.statusCode == 255){
      return (jsonDecode(response.body) as List)
          .map((e) => Todos.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  void fetchData() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/comment?postId=2'; // 실제 API 엔드포인트로 변경하세요

    // HTTP GET 요청 보내기
    var response = await http.get(Uri.parse(apiUrl));

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      var data = json.decode(response.body);
      var jsonResponse = utf8.decode(response.bodyBytes);

      // 데이터 처리
      print('서버로부터 받은 데이터: $jsonResponse');
    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  late Map<String, dynamic> parsedResponseCN; // 글 내용

  late List<dynamic> postsList; // 포스트 하나 내용

  void fetchWithHeaders() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/all'; // 실제 API 엔드포인트로 변경하세요

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

      // JSON 문자열을 Map<String, dynamic>으로 파싱
      Map<String, dynamic> data = json.decode(jsonResponse);

      // "posts" 배열의 내용을 추출
      //List<dynamic> postsList = data["posts"];
      postsList = data["posts"];

      print(postsList);

      // 추출된 "posts" 배열의 내용 출력
      postsList.forEach((post) {
        print('게시물 ID: ${post["id"]}');
        print('게시물 제목: ${post["title"]}');
        print('게시물 내용: ${post["content"]}');
        // 필요한 다른 정보도 출력하거나 처리할 수 있습니다.
      });

      checkCN = true;
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  void _callAPI() async {

    // 요청 본문 데이터
    var data = {
      "Authorization" : "axNNnzcfJaSiTPI6kW23G2Vns9o1",
    };

    var url = Uri.parse('http://3.38.1.125:8080/memorial/all'); // 엔드포인트 URL 설정

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

        List<String> contentList = [];

        List<dynamic> parsedResponse = json.decode(jsonResponse);

        setState(() {
          for (var item in parsedResponse) {
            if (item['content'] != null) {
              con0Text.add(item['content']);
            }
          }
        });


        print(con0Text);

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

  List<String> parsedResponse = [
    'https://images.unsplash.com/photo-1589965716319-4a041b58fa8a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
    'https://images.unsplash.com/photo-1546975490-a79abdd54533?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80',
    'https://images.unsplash.com/photo-1628344806892-11873eba7974?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80',
    'https://images.unsplash.com/photo-1618901277211-00af8265a94d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
    'https://images.unsplash.com/photo-1561852184-92b9bb821045?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2073&q=80',
    'https://images.unsplash.com/photo-1636910825807-171715240043?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1992&q=80',
    'https://images.unsplash.com/photo-1546975554-31053113e977?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
    'https://images.unsplash.com/photo-1634635880938-d81e973bcd6c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80',
    'https://images.unsplash.com/photo-1534176043700-789edb4e2f91?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
    'https://images.unsplash.com/photo-1549950844-e6a5d47f8324?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
    'https://images.unsplash.com/photo-1636910824730-4eaf1603a3e4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1636910824657-4be41fdf713a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80'
  ];

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  late Future<List<Todos>> futureTodos;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    fetchWithHeaders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/home/home_main_logo.svg',
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffDDE7FD),
        elevation: 0.0,
      ),
      body: Container(
        color: Color(0xffDDE7FD),
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if(checkCN)...[
                Row(
                  children: [
                    SizedBox(width: 15,),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 65,
                      // minRadius: 50,
                      // maxRadius: 55,
                      //backgroundImage: NetworkImage(parsedResponseCN['profileImage']),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(parsedResponseCN['profileImage']),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${parsedResponseCN['nickname']}님의 반려견", style: textStyle.bk20bold,),
                        SizedBox(height: 5,),
                        Text("${parsedResponseCN['puppyName']}(${parsedResponseCN['puppyType']}, ${parsedResponseCN['puppyAge']}살)", style: textStyle.bk16normal,),
                      ],
                    ),
                    SizedBox(width: 20,),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    Container(
                      width: 115,
                      height: 40,
                      child: ElevatedButton(
                        style: buttonChart().bluebtn2,
                        child: Text('프로필 사진'),
                        onPressed: (){

                        },
                      ),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      width: 205,
                      height: 40,
                      child: ElevatedButton(
                        style: buttonChart().whitebtn,
                        child: Row(children: [
                          SizedBox(width: 35,),
                          Text('메모리얼 올리기'),
                          SizedBox(width: 5,),
                          SvgPicture.asset(
                            'assets/images/memorial/upload_icon.svg',
                          ),
                        ],),
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WriteMemorialPage()));
                        },
                      ),
                    ),
                  ],),
                SizedBox(height: 30,),
                Container(
                  color: Color(0xffF2F4F6),
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Container(
                          width: 400,
                          height: 480,
                          color: Color(0xffF2F4F6),
                          child: GridView.builder(
                              itemCount:postsList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                                childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                                mainAxisSpacing: 8, //수평 Padding
                                crossAxisSpacing: 8, //수직 Padding
                              ),
                              itemBuilder: (BuildContext context, int index){
                                return
                                  Container(
                                      width: 120,
                                      height: 120,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              selectedImage = postsList[index]['image'];
                                              postId = postsList[index]['id'];
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => MemorialDetailPage()));
                                            },
                                            child: Container(
                                              width: 120,
                                              height: 120,
                                              child:
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child:  Image.network(postsList[index]['image'], fit: BoxFit.cover,),
                                              ),
                                            ),
                                          ),
                                          if(postsList[index]['private'] == true)...[
                                            Row(children: [
                                              SizedBox(width: 90,),
                                              Padding(padding: EdgeInsets.only(top:10),
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/private.svg',
                                                ),
                                              ),
                                            ],)

                                          ],
                                        ],
                                      )
                                  );

                              })
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 30, 10, 15),
                        width: Get.width,
                        height: 98,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 41,
                                  height: 41,
                                  child: Image.asset('assets/images/memorial/more_memorial.png'),),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("다른 반려인들의 메모리얼을 구경해보세요!",style: TextStyle(color: Color(0xff4B5396),fontSize: 14),),
                                    SizedBox(height:3,),
                                    Text("메모리얼 구경하러 가기",style: TextStyle(color: Color(0xff4B5396),fontSize: 18, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                SizedBox(width: 37,),
                                IconButton(onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WatchOthersPage()));
                                }, icon: Icon(Icons.arrow_forward_ios_rounded), color: Color(0xff627DBB),)
                              ],
                            )
                          ],
                        ),
                      ),

                    ],
                  ),

                ),
              ],
            ],
          ),
        ),
      ),
    );

  }

  bool extended = false;

  FloatingActionButton extendButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WriteMemorialPage()));
      },
      label: const Text(""),
      isExtended: extended,
      icon: const Icon(
        Icons.add,
        size: 30,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),

      /// 텍스트 컬러
      foregroundColor: Color(0xffFCCBCD),
      backgroundColor: Color(0xff83A8FF),
    );
  }
}