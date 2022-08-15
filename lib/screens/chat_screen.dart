import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/chat_controller.dart';
import 'package:instaclone/controller/user_controller.dart';

class ChatScreen extends StatefulWidget {
  String sellerid;
  String postUploaderName;
  String postUploaderImage;

  // SellerShopModel sellerShopModel;

  ChatScreen(
      {Key key, this.sellerid, this.postUploaderImage, this.postUploaderName})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserController athenticationController = Get.put(UserController());

  final ScrollController scrollController = ScrollController();
  int i;

  ChatController chatController = Get.put(ChatController());
  @override
  void initState() {
    chatController.chatStream(widget.sellerid);
    // Future.delayed(const Duration(milliseconds: 300));
    // SchedulerBinding.instance?.addPostFrameCallback((_) {
    //   scrollController.animateTo(scrollController.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 1),
    //       curve: Curves.fastOutSlowIn);
    // });
    i = chatController.getAllchat.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('Selle name is ${widget.sellerShopModel?.shopeName}');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.postUploaderImage),
          ),
          title: Text(widget.postUploaderName,
              style: Theme.of(context).textTheme.bodyText1),
        ),
        //resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
                height: 100 * SizeConfig.heightMultiplier,
                //  color: Colors.amber,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          height: 83 * SizeConfig.heightMultiplier,
                          child: GetX<ChatController>(
                              init: Get.put(ChatController()),
                              builder: (chatController) {
                                return ListView.builder(
                                    reverse: true,
                                    controller: scrollController,
                                    itemCount: chatController.getAllchat.length,
                                    itemBuilder: (context, index) {
                                      if (chatController.getAllchat.length >
                                          1) {
                                        // Future.delayed(
                                        //     const Duration(milliseconds: 300));
                                        // SchedulerBinding.instance
                                        //     ?.addPostFrameCallback((_) {
                                        //   scrollController.animateTo(
                                        //       scrollController
                                        //           .position.maxScrollExtent,
                                        //       duration:
                                        //           const Duration(milliseconds: 1),
                                        //       curve: Curves.fastOutSlowIn);
                                        // });
                                      }
                                      return Column(
                                        crossAxisAlignment:
                                            athenticationController.auth
                                                        .currentUser?.uid ==
                                                    chatController
                                                        .getAllchat[index]
                                                        .senderId
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            // height: 8 * SizeConfig.heightMultiplier,
                                            constraints: BoxConstraints(
                                              maxWidth: 80 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                      blurRadius: 5,
                                                      color: Colors.black12),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                chatController
                                                    .getAllchat[index].message,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height:
                                          //       1 * SizeConfig.heightMultiplier,
                                          // ),
                                        ],
                                      );
                                    });
                              }),
                        ),
                        // SizedBox(
                        //   height: 2 * SizeConfig.heightMultiplier,
                        // ),
                        Container(
                          height: 6 * SizeConfig.heightMultiplier,
                          width: 90 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 10, color: Colors.black12),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: TextField(
                            controller: chatController.chattextController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Enter message',
                              hintStyle: TextStyle(color: Colors.black),
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              suffixIcon: GestureDetector(
                                  onTap: () async {
                                    print(widget.sellerid);
                                    if (chatController
                                        .chattextController.text.isNotEmpty) {
                                      chatController.sendMessage(
                                        sellerId: widget.sellerid,
                                        txtMessage: chatController
                                            .chattextController.text,
                                        postUploaderImage:
                                            widget.postUploaderImage,
                                        postUploaderName:
                                            widget.postUploaderName,
                                      );
                                       chatController
                                            .chattextController.text='';
                                      // await Future.delayed(
                                      //     const Duration(milliseconds: 300));
                                      // SchedulerBinding.instance
                                      //     ?.addPostFrameCallback((_) {
                                      //   scrollController.animateTo(
                                      //       scrollController
                                      //           .position.maxScrollExtent,
                                      //       duration:
                                      //           const Duration(milliseconds: 400),
                                      //       curve: Curves.fastOutSlowIn);
                                      //});
                                    }
                                  },
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.blue,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            // Positioned(
            //   bottom: 2 * SizeConfig.heightMultiplier,
            //   left: 5 * SizeConfig.widthMultiplier,
            //   child: Center(
            //     child:
            //   ),
            // ),
            //Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
          ],
        ),
      ),
    );
  }
}
