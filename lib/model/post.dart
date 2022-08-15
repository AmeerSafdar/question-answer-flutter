
import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
 String description;
 String  uid;
final String  username;
final String postid; 
final  datepublished;
final String posturl;
final String profimage;
final likes;

Post({
  this.description,
 this.uid,
 this.username,
 this.postid,
 this.datepublished,
 this.posturl,
 this.profimage,
 this.likes
});
  Map<String , dynamic> toJson()=>{
            "username":username,
             "uid":uid,
             "description":description,
             "postid":postid,
             "date":datepublished,
             "posturl":posturl,
             "profimage":profimage,
             "likes":likes,
  };

   static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String , dynamic>;
    return Post(
      username: snapshot['username'],
       uid: snapshot['uid'], 
       description:snapshot['description'],
       postid:snapshot['postid'], 
       datepublished: snapshot['datepublished'], 
       posturl: snapshot['posturl'], 
       profimage: snapshot['profimage'],
      likes: snapshot['likes']
       );

  }
}