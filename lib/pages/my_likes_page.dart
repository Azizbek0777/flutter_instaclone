import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_instaclone/model/post_model.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/utils_service.dart';

class MyLikesPage extends StatefulWidget {
  @override
  _MyLikesPageState createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  bool isLoading = false;
  List<Post> items = new List();

  void _apiLoadLikes() {
    setState(() {
      isLoading = true;
    });
    DataService.loadLikes().then((value) => {
      _resLoadLikes(value),
    });
  }

  void _resLoadLikes(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiPostUnLike(Post post) {
    setState(() {
      isLoading = true;
      post.liked = false;
    });
    DataService.likePost(post, false).then((value) => {
      _apiLoadLikes(),
    });
  }

  _actionRemovePost(Post post) async{
    var result = await Utils.dialogCommon(context, "Insta Clone", "Do you want to remove this post?", false);
    if(result != null && result){
      setState(() {
        isLoading = true;
      });
      DataService.removePost(post).then((value) => {
        _apiLoadLikes(),
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Likes",
          style: TextStyle(
              color: Colors.black, fontFamily: 'Billabong', fontSize: 30),
        ),
      ),
      body: Stack(
        children: [

          items.length > 0?
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index){
              return _itemOfPost(items[index]);
            },
          ): Center(
            child: Text("No liked posts"),
          ),

          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemOfPost(Post post){
    return Container(
      color: Colors.white,
      child: Column(
        children: [

          Divider(),
          //userinfo
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: (post.img_user == null || post.img_user.isEmpty)? Image(
                        image: AssetImage("assets/images/ic_person.png"),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ):Image.network(
                        post.img_user,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.fullname,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          post.date,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
                post.mine ?
                IconButton(
                  icon: Icon(SimpleLineIcons.options),
                  onPressed: () {
                    _actionRemovePost(post);
                  },
                ): SizedBox.shrink(),
              ],
            ),
          ),
          //#image
          //Image.network(post.postImage, fit: BoxFit.cover),

          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            imageUrl: post.img_post,
            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),

          //#likeshare
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      if (post.liked) {
                        _apiPostUnLike(post);
                      }
                    },
                    icon: post.liked
                        ? Icon(
                      FontAwesome.heart,
                      color: Colors.red,
                    )
                        : Icon(FontAwesome.heart_o),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.share_outlined),
                  ),
                ],
              ),
            ],
          ),
          // #caption
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: " ${post.caption}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

}
