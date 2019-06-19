import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quna/dao/home_dao.dart';
import 'package:flutter_quna/model/common_model.dart';
import 'package:flutter_quna/model/home_model.dart';
import 'package:flutter_quna/widget/local_nav.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_quna/widget/grid_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  List _imageUrls = [
    'https://imgsa.baidu.com/news/q%3D100/sign=ebefe45e5782b2b7a19f3dc401accb0a/8cb1cb134954092397ff1f249c58d109b2de49d1.jpg',
    'https://imgsa.baidu.com/news/q%3D100/sign=fefabe4d6cd0f703e0b291dc38fb5148/3bf33a87e950352ab2b5cd525d43fbf2b3118b90.jpg',
    'https://imgsa.baidu.com/news/q%3D100/sign=e7057f8606fa513d57aa68de0d6c554c/c75c10385343fbf2c49b4c79be7eca8065388f31.jpg'
  ];
  double appBarAlpha = 0;
  List<CommonModel> localNavList = [];

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if(alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                  _onScroll(scrollNotification.metrics.pixels);
                }
              },
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 160,
                    child: Swiper(
                      itemCount: _imageUrls.length,
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          _imageUrls[index],
                          fit: BoxFit.fill,
                        );
                      },
                      pagination: SwiperPagination(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                    child: LocalNav(localNavList: localNavList),
                  ),
                  Container(
                    height: 800,
                    child: ListTile(title: Text('ddd'),),
                  )
                ],
              ),
            )
          ),
          Opacity(
            opacity: appBarAlpha,
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Padding(padding: EdgeInsets.only(top: 20), 
                  child: Text('首页'),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}