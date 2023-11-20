import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(),
      ),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
  }

  @override
  void dispose() async {
    super.dispose();
  }

  ListTile _tile(String title, String subtitle) => ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Image.network("https://randomuser.me/api/portraits/women/10.jpg")
  );

  Widget _buildList() => ListView(
    children: [
      _tile("안녕하세요", "반가워요"),
    ],
  );

  ClipRRect _userImage(String url) => ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child:Image.network(url)
  );

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background_test.png'), // 배경 이미지
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Image.asset('assets/images/pupmory_logo.png', height: 85, width: 95,),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),extendBodyBehindAppBar: true,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 65, right: 5),
                child: Container(
                    height: 70,
                    width: screenSize.width,
                  child:Column(
                    children: [
                      Text(
                          "나라님이 초코를 기억한지\n1일째 입니다."
                      ),
                    ],
                  )
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation0_1()));
                      },
                      child: Container(
                        width: 208,
                        height: 104,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/con1_button.png')
                            )
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation0_1()));
                      },
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/help_request_button.png')
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                width: 450,
                height: 50,
                child: InkWell(
                  onTap: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation0_1()));
                  },
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("하마님에게 추천하는 게시글",style: TextStyle(fontSize: 16),),
                      Padding(
                        padding: EdgeInsets.only(left: 70),
                        child: Image(image: AssetImage('assets/images/home_right_arrow.png'),
                          width: 4, height: 8,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child:
                SingleChildScrollView(
                  // scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        width: 172,
                        height: 172,
                        child: InkWell(
                          child: Container(
                            width: 172,
                            height: 172,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/proto_recommend1.png')
                                )
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        width: 172,
                        height: 172,
                        child: InkWell(
                          child: Container(
                            width: 172,
                            height: 172,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/proto_recommend1.png')
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
              Container(
                alignment: Alignment.center,
                child:
                Padding(padding: EdgeInsets.only(top: 5,),
                  child: InkWell(
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation0_1()));
                    },
                    child: Container(
                      width: 330,
                      height: 160,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/dog_gallery.png')
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      );

  }
}


class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.child,
    this.color,
    this.disableColor,
    this.elevation,
    this.side = BorderSide.none,
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color? color;
  final Color? disableColor;
  final double? elevation;
  final BorderSide side;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        shape: const StadiumBorder().copyWith(side: side),
        disabledBackgroundColor: disableColor ?? Colors.grey,
        elevation: elevation,
      ),
      onPressed: onTap,
      child: child,
    );
  }
}
