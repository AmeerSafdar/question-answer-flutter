
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/model/post.dart';
import 'package:instaclone/screens/comment_screen.dart';
import 'package:instaclone/screens/profile_screen.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key key }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController=new TextEditingController();
  bool isShowUser=false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller:searchController ,
              decoration: InputDecoration(
                labelText: "Search your query"
              ),
              onFieldSubmitted: (String _){
                print(_);
                print("controller text is "+searchController.text);
                setState(() {
                  isShowUser=true;
                });
              },
            ),
          ),
        ),
        body:isShowUser? FutureBuilder(
          future: FirebaseFirestore.instance.collection('posts').where('description',
                                                     isGreaterThanOrEqualTo: searchController.text).get(),
          // FirebaseFirestore.instance.collection('users').where('username',isGreaterThanOrEqualTo: searchController.text).get(),
          builder: (context, snapshot){
            if (snapshot.connectionState==ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
              
            }
            return ListView.builder(
              itemCount: (snapshot.data as dynamic).docs.length,
              itemBuilder: (context,index) {
                var snap=(snapshot.data as dynamic).docs[index];
                //  Map<String, dynamic> snap= FirebaseFirestore.instance.collection('posts').where('description',
                //                                      isGreaterThanOrEqualTo: searchController.text).get() as  Map<String, dynamic>;
                // Map<String, dynamic> data = snapshot.data.data();
                // var data=Post.fromSnap(snap);
                // var snap= FirebaseFirestore.instance.collection('posts');
                // var data=Post.fromSnap(data);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        print(snap['description']);
                        Get.to(
                          CommentScreen(
                            imagepath: snap['posturl'],
                            snap: snap,
                            description: snap['description'],
                          )
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                         vertical: 3.0,
                          horizontal: 8
                          ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                         snap['posturl'] !=null?  Container(
                              width: double.infinity,
                              height: SizeConfig.heightMultiplier*20,
                              child:Image.network(
                                snap['posturl'],
                                fit: BoxFit.cover,
                                ),
                            )
                            :
                            SizedBox(
                              height: 0,
                            )
                            ,
                            Container(
                              padding: EdgeInsets.only(
                                top: 15
                              ),
                              child:  Text(
                            snap['description'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            ),
                            ),
                          ],
                        ),
                      )
                      // ListTile(
                      //   // leading: 
                      //   // CircleAvatar(
                      //   //   backgroundImage: NetworkImage((snapshot.data as dynamic).docs[index]['photourl']),
                      //   // ),
                      //   title: Text(
                      //     snap['description'],
                      //     overflow: TextOverflow.ellipsis,
                      //     maxLines: 2,
                      //     ),
                      // ),
                    ),
                    // InkWell(
                    //   onTap: (){
                    //     Get.to(
                    //       ProfileScreen(
                    //       uid:(snapshot.data as dynamic).docs[index]['uid']));
                          
                    //   },
                    //   child: ListTile(
                    //     leading: CircleAvatar(
                    //       backgroundImage: NetworkImage((snapshot.data as dynamic).docs[index]['photourl']),
                    //     ),
                    //     title: Text((snapshot.data as dynamic).docs[index]['username']),
                    //   ),
                    // ),
                  ],
                );
            });
          },
          )
          :
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').orderBy('date',descending: true).get(),
            builder: (context, snapshot){
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(),);
              }
              return StaggeredGridView.countBuilder(
              crossAxisCount: 3,
              crossAxisSpacing:5,
              mainAxisSpacing: 10,
              
              itemCount: (snapshot.data as dynamic).docs.length,
              itemBuilder: (context, index){
                var snp=(snapshot.data as dynamic).docs[index];
                return  snp['posturl'] !=null ? GestureDetector(
                onTap: (){
                  Get.to(
                    CommentScreen(
                    description:snp['description'] ,
                    imagepath: snp['posturl'],
                    snap: snp,
                  ),
                  transition: Transition.native
                  );
                },
                child: Image.network(
                  (snapshot.data as dynamic).docs[index]['posturl'],
                  fit: BoxFit.cover,
                  ),
              )
              :
              SizedBox(
                height: 0,
              )
              ;
              } ,
                staggeredTileBuilder: (index)=> StaggeredTile.count(
                  // (index%7==0)? 2:1,
                  // (index%7==0)? 2:1,
                  1,
                  1
                  ),
     );
            }
            )
      ),
    );
  }
}