import 'package:flutter/material.dart';
import 'package:client/home.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';


void main() => runApp(const MyApp());

enum ThemeStyle {
  BlurEffect,
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  int _selectedIndex = 0;
  int _currentIndex = 0;

  ThemeStyle _currentStyle = ThemeStyle.BlurEffect;

  List<int> _badgeCounts = List<int>.generate(4, (index) => index);

  List<bool> _badgeShows = List<bool>.generate(4, (index) => true);

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text(
      'Index 1: Gallery',
      style: optionStyle,
    ),
    Text(
      'Index 2: Comunity',
      style: optionStyle,
    ),
    Text(
      'Index 3: Mypage',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 메인 위젯
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;

    return Scaffold(
      // extendBody for floating bar get better perfomance
      extendBody: true,
      backgroundColor: Colors.white,
      body: Container(
        width: screenSize.width,
        //padding: EdgeInsets.only(bottom: 20),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _buildBlurEffect(),
    );
  }


  Widget _buildBottomNavigationBar() {
    switch (_currentStyle) {
      case ThemeStyle.BlurEffect:
        return _buildBlurEffect();
      default:
        return _buildBlurEffect();
    }
  }

  Widget _buildTitle() {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Color(0xff040307),
      strokeColor: Color(0x30040307),
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text("Cart"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline),
          title: Text("Explore"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text("Search"),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text("Me"),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  // Widget _buildBlurEffect() {
  //   print("notification");
  //   return CustomNavigationBar(
  //     iconSize: 30.0,
  //     selectedColor: Color(0xff040307),
  //     strokeColor: Color(0x30040307),
  //     unSelectedColor: Color(0xffacacac),
  //     backgroundColor: Colors.white,
  //     items: [
  //       CustomNavigationBarItem(
  //         icon: Icon(Icons.home),
  //         badgeCount: _badgeCounts[0],
  //         showBadge: _badgeShows[0],
  //       ),
  //       CustomNavigationBarItem(
  //         icon: Icon(Icons.shopping_bag),
  //         badgeCount: _badgeCounts[1],
  //         showBadge: _badgeShows[1],
  //       ),
  //       CustomNavigationBarItem(
  //         icon: Icon(Icons.lightbulb_outline),
  //         badgeCount: _badgeCounts[2],
  //         showBadge: _badgeShows[2],
  //       ),
  //       CustomNavigationBarItem(
  //         icon: Icon(Icons.search),
  //         badgeCount: _badgeCounts[3],
  //         showBadge: _badgeShows[3],
  //       ),
  //       CustomNavigationBarItem(
  //         icon: Icon(Icons.account_circle),
  //         badgeCount: _badgeCounts[4],
  //         showBadge: _badgeShows[4],
  //       ),
  //     ],
  //     currentIndex: _currentIndex,
  //     onTap: (index) {
  //       setState(() {
  //         _currentIndex = index;
  //         _badgeShows[index] = false;
  //       });
  //     },
  //   );
  // }

  Widget _buildBlurEffect() {
    return CustomNavigationBar(
      iconSize: 20.0,
      selectedColor: Colors.deepPurpleAccent,
      strokeColor: Colors.white,
      unSelectedColor: Colors.grey[600],
      backgroundColor: Colors.white,
      borderRadius: Radius.circular(30.0),
      blurEffect: true,
      opacity: 0.7,
      items: [
        CustomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
        ),
        CustomNavigationBarItem(
          icon: Icon(
            Icons.image,
          ),
        ),
        CustomNavigationBarItem(
          icon: Icon(
            Icons.connect_without_contact_rounded,
          ),
        ),
        CustomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      isFloating: true,
    );
  }
}


