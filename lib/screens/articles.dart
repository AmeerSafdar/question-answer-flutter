import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/controller/upload_query_controller.dart';
import 'package:instaclone/screens/add_articles.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key key}) : super(key: key);

  @override
  State<ArticlesPage> createState() => _ArticlesState();
}

class _ArticlesState extends State<ArticlesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ArticlesPage'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddArticles());
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            //Text('Hey'),
            // ListView.builder(
            //     physics: NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: 18,
            //     itemBuilder: (context, index) {
            //       return Text('Some text');
            //     }),
            GetX<UploadQuryController>(
                init: Get.put(UploadQuryController()),
                builder: (uploadQuryController) {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: uploadQuryController.getarticelList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryColor)),
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   uploadQuryController
                                  //       .getarticelList[index].description,
                                  //   style: TextStyle(color: Colors.white),
                                  // ),
                                  ReadMoreText(
                                      uploadQuryController.getarticelList[index].description,
                                      trimLines: 2,
                                      colorClickableText: Colors.pink,
                                      trimMode: TrimMode.Line,
                                      trimLength: 20,
                                      trimCollapsedText: 'Show more',
                                      trimExpandedText: 'Show less',
                                      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: blueColor),
                                      lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: blueColor),
                                    
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.history,
                                        color: blueColor,
                                      ),
                                      // Text(snapshot.data.docs[index].data()['date'].toString())
                                      Text(uploadQuryController
                                          .getarticelList[index].datepublished),
                                      Icon(
                                        Icons.person,
                                        color: blueColor,
                                      ),
                                      // Text(snapshot.data.docs[index].data()['date'].toString())
                                      Text(uploadQuryController
                                          .getarticelList[index].username)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                })
          ],
        ),
      ),
      // body: SafeArea(
      //   child: StreamBuilder(
      //       stream: FirebaseFirestore.instance
      //           .collection('articles')
      //           .orderBy('date', descending: true)
      //           .snapshots(),
      //       builder: (context,
      //           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //         // return 0;
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         }
      //         return ListView.builder(
      //             itemCount: snapshot.data.docs.length,
      //             itemBuilder: (context, index) {
      //               return Padding(
      //                 padding: const EdgeInsets.only(top: 8.0),
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                       border: Border.all(color: primaryColor)),
      //                   margin: EdgeInsets.symmetric(
      //                     horizontal: 10,
      //                     vertical: 8,
      //                   ),
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(8.0),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text(snapshot.data.docs[index]
      //                             .data()['description']),
      //                         SizedBox(
      //                           height: 3,
      //                         ),
      //                         Row(
      //                           children: [
      //                             Icon(
      //                               Icons.history,
      //                               color: blueColor,
      //                             ),
      //                             // Text(snapshot.data.docs[index].data()['date'].toString())
      //                             Text(DateFormat.yMMMd().format(snapshot
      //                                 .data.docs[index]
      //                                 .data()['date']
      //                                 .toDate())),
      //                             Icon(
      //                               Icons.person,
      //                               color: blueColor,
      //                             ),
      //                             // Text(snapshot.data.docs[index].data()['date'].toString())
      //                             Text(snapshot.data.docs[index]
      //                                 .data()['username'])
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               );
      //               // return PostCard(
      //               //   snap:snapshot.data.docs[index].data(),
      //               // );
      //             });
      //       }),
      // ),
    );
  }
}
