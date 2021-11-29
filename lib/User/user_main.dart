import 'package:flutter/material.dart';
import 'package:yorizori_app/User/models/recipe_thumb.dart';
import 'package:yorizori_app/User/profile.dart';
import 'package:yorizori_app/User/user_setting/setting_main.dart';

import 'models/user.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var user;
  List<RecipeThumb> sub_recipe_list = [];
  List<RecipeThumb> user_bookmark_list = [];
  List<RecipeThumb> user_upload_list = [];

  int length_sub_recipe_list = 0;

  int menuSelected = 0;
  final items = List.generate(5, (index) => "list $index");

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    List<Widget> bookmark = [
      Icon(
        Icons.favorite,
        size: width * 0.06,
        color: Theme.of(context).primaryColor,
      ),
      Icon(
        Icons.favorite_outline,
        size: width * 0.06,
        color: Theme.of(context).primaryColor,
      )
    ];

    List<Widget> wrote = [
      Icon(
        Icons.folder_outlined,
        size: width * 0.06,
        color: Theme.of(context).primaryColor,
      ),
      Icon(
        Icons.folder,
        size: width * 0.06,
        color: Theme.of(context).primaryColor,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              },
              icon: Icon(Icons.grid_view_rounded))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
          future: getUser(context, 3), //TODO user id!!!
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            var data = snapshot.data;
            user = data[0];
            sub_recipe_list = user_bookmark_list = data[1];
            length_sub_recipe_list = sub_recipe_list.length;
            user_upload_list = data[2];

            return Column(
              children: [
                SizedBox(
                  width: width,
                  height: height * 0.42,
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            height: height * 0.18,
                            child: profileRow(context, user)),
                        Container(
                          height: height * 0.03,
                          margin:
                              EdgeInsets.only(left: width * 0.06, bottom: 5),
                          //color: Colors.grey,
                          child: Row(
                            children: [
                              Text(
                                '👀',
                                style: TextStyle(fontSize: width * 0.05),
                              )
                            ],
                          ),
                        ),
                        ScrollConfiguration(
                          behavior: NoGlow(),
                          child: Container(
                              margin: EdgeInsets.only(bottom: height * 0.03),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              height: 90,
                              //color: Colors.grey,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        width: 90,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  "https://cdn.ppomppu.co.kr/zboard/data3/2018/0509/m_1525850138_3126_1516635001428.jpg"),
                                            ),
                                            Text(items[index])
                                          ],
                                        ));
                                  })),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: width * 0.07,
                      left: width * 0.07,
                      top: height * 0.03),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: bookmark[menuSelected],
                            onPressed: () {
                              setState(() {
                                sub_recipe_list = user_bookmark_list;
                                length_sub_recipe_list = sub_recipe_list.length;
                                menuSelected = 0;
                              });
                            },
                          ),
                          IconButton(
                            icon: wrote[menuSelected],
                            onPressed: () {
                              setState(() {
                                sub_recipe_list = user_upload_list;
                                length_sub_recipe_list = sub_recipe_list.length;
                                menuSelected = 1;
                              });
                            },
                          )
                        ],
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: NoGlow(),
                    child: ValueListenableBuilder(
                      valueListenable: ValueNotifier(length_sub_recipe_list),
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            padding: EdgeInsets.only(
                                top: 0,
                                left: width * 0.06,
                                right: width * 0.06),
                            itemCount: sub_recipe_list.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                key: Key(sub_recipe_list[index].title),
                                onDismissed: (direction) {
                                  setState(() {
                                    sub_recipe_list.removeAt(index);
                                    //TODO 삭제 request
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 4,
                                            offset: Offset(2, 4))
                                      ],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text(sub_recipe_list[index].title,
                                        overflow: TextOverflow.ellipsis),
                                    subtitle: Text(sub_recipe_list[index]
                                            .views
                                            .toString() +
                                        " views"),
                                    leading: CircleAvatar(
                                      radius: width * 0.08,
                                      backgroundImage: NetworkImage(
                                          sub_recipe_list[index].thumb),
                                    ),
                                  ),
                                ),
                                background: Container(
                                  // decoration: BoxDecoration(
                                  //     color: Colors.grey.shade200,
                                  //     borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(20),
                                  alignment: Alignment.centerRight,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      )), //Text("delete")
                                  /*decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle)*/
                                ),
                              );
                            });
                      },
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UserDetail(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}

class NoGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
