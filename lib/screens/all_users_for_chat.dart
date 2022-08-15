import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/chat_controller.dart';

import 'chat_screen.dart';

// ignore: must_be_immutable
class AllUserforChat extends StatelessWidget {
  AllUserforChat({Key key}) : super(key: key);
  ChatController chatController = Get.put(ChatController());
  //SellerShopModel sellerShopModel = SellerShopModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All User'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 2 * SizeConfig.heightMultiplier,
                ),
                GetX<ChatController>(
                    init: Get.put(ChatController()),
                    builder: (chatController) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: chatController.getAlluserForchat.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 10 * SizeConfig.heightMultiplier,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => ChatScreen(
                                        postUploaderImage: chatController
                                            .getAlluserForchat[index].imageUrl,
                                        postUploaderName: chatController
                                            .getAlluserForchat[index]
                                            .sellerName,
                                        sellerid: chatController
                                            .getAlluserForchat[index].id,
                                      ));
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              chatController
                                                  .getAlluserForchat[index]
                                                  .imageUrl),
                                        ),
                                        SizedBox(
                                          width: 5 * SizeConfig.widthMultiplier,
                                        ),
                                        Text(
                                            chatController
                                                .getAlluserForchat[index]
                                                .sellerName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
