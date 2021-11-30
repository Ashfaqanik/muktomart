import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mukto_mart/models/details_model.dart';
import 'package:mukto_mart/providers/comment_provider.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mukto_mart/providers/favourite_seller_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/repo/comment_repo.dart';
import 'package:mukto_mart/repo/favourite_seller_repo.dart';
import 'package:mukto_mart/repo/wish_list_repo.dart';
import 'package:mukto_mart/repo/review_repo.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:mukto_mart/components/vendor_products_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mukto_mart/screens/details/all_product_components/all_comments.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription(
      {Key key,
      @required this.productDetails,
      this.pressOnSeeMore,
      this.favourite,
      this.productId})
      : super(key: key);

  final ProductDetails productDetails;
  final GestureTapCallback pressOnSeeMore;
  final bool favourite;
  final int productId;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  bool color = false;
  bool reply=false;
  String token;
  Color star1=Colors.grey;
  Color star2=Colors.grey;
  Color star3=Colors.grey;
  Color star4=Colors.grey;
  Color star5=Colors.grey;
  String userId;
  String reviewText;
  int rating;
  String addReview='false';
  bool _isLoading = false;
  bool isFavourite = false;
  WishListRepo wishListRepo = WishListRepo();
  CommentsRepo commentsRepo = CommentsRepo();
  ReviewRepo reviewRepo = ReviewRepo();
  String commentText;
  final replyTextController = TextEditingController();
  final editCommentController = TextEditingController();
  final editReplyController = TextEditingController();
  final commentTextController = TextEditingController(text: '');
  final reviewTextController = TextEditingController();
  String replyText;
  int _counter=0;
  final _addKey = GlobalKey<FormState>();

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
      userId = preferences.getString('userId');
    });
  }
  Future<void> _fetch(CommentProvider commentProvider)async{
    setState(()=> _counter++);
    setState(() {
      _isLoading=true;
    });
      commentProvider.fetch(widget.productId).then((value){
        setState(() {
          _isLoading=false;
        });
      });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }

  @override
  Widget build(BuildContext context) {
    FavouriteSellerRepo favouriteSellerRepo = FavouriteSellerRepo();
    final CommentProvider commentProvider = Provider.of<CommentProvider>(context,listen: false);
    final size = MediaQuery.of(context).size;
    if(_counter==0) _fetch(commentProvider);
    final WishProvider wishProvider =
        Provider.of<WishProvider>(context, listen: false);
    final DetailsProvider detailsProvider =
        Provider.of<DetailsProvider>(context, listen: false);
    final FavouriteSellerProvider favouriteSellerProvider =
        Provider.of<FavouriteSellerProvider>(context, listen: false);
    if(widget.productDetails!=null){
      if(widget.productDetails.product!=null){
        if (favouriteSellerProvider.Idlist.contains(widget.productDetails.product.userId)) {
          setState(() {
            color = true;
          });
        }
      }
    }
    return widget.productDetails!=null?Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            '${widget.productDetails.product.name??''}',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '${widget.productDetails.rating??''}',
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              if (token == '' || token == null) {
                _showToast('Please log in first..', Colors.redAccent);
              } else {
                setState(() {
                  widget.favourite == false ? isFavourite = true : null;
                });
                isFavourite == true
                    ? wishListRepo
                        .addWishList(token, widget.productId)
                        .then((value) {
                        _showToast(
                            'Product added to your wishlist', kPrimaryColor);
                        wishProvider.fetch(token);
                        wishProvider.fetchId(token);
                      })
                    : null;
              }
            },
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                //color: product.isFavourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SvgPicture.asset(
                "assets/icons/Heart Icon_2.svg",
                color: widget.favourite
                    ? Color(0xFFFF4848)
                    : isFavourite
                        ? Color(0xFFFF4848)
                        : Color(0xFFDBDEE4),
                height: getProportionateScreenWidth(16),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            '${widget.productDetails.product.price??''}',
            maxLines: 3,
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: getProportionateScreenWidth(16),
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: widget.productDetails.product.percent != '0'
              ? Row(
                  children: [
                    Text(
                      '${widget.productDetails.product.previousPrice??''}',
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${widget.productDetails.product.percent??''}',
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  ],
                )
              : Container(),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: widget.productDetails.product.stock == null
              ? Text('')
              : Text(
            'Stock: ${widget.productDetails.product.stock}',
            maxLines: 3,
            style: TextStyle(
                color: Colors.green,
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            'Product SKU: ${widget.productDetails.product.sku??''}',
            maxLines: 3,
            style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(14),
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            'Description',
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: getProportionateScreenWidth(17),
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 5),
        Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(64),
            ),
            child: widget.productDetails.product.details == "<br>"
                ? Text('No Details')
                : Html(
                    data: widget.productDetails.product.details??'',
                  )),
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            'Policy',
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: getProportionateScreenWidth(17),
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 5),
        Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(64),
            ),
            child: widget.productDetails.product.policy == "<br>"
                ? Text('No Details')
                : Html(
                    data: widget.productDetails.product.policy??'',
                  )),
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            'Ratings & Review',
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: getProportionateScreenWidth(17),
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 5),
        // Padding(
        //   padding: EdgeInsets.only(
        //     left: getProportionateScreenWidth(20),
        //     right: getProportionateScreenWidth(64),
        //   ),
        //   child: Text(
        //     '${widget.productDetails.ratings}',
        //     style: TextStyle(color: Colors.grey[600],fontSize: getProportionateScreenWidth(17),fontWeight: FontWeight.w600),
        //   ),
        // ),
        Padding(
        padding: EdgeInsets.only(
        left: getProportionateScreenWidth(20),
        right: getProportionateScreenWidth(64),
      ),
          child: InkWell(
            onTap: (){
              setState(() {
                addReview=='true'?addReview='false':addReview='true';
              });
            },
            child: Container(
              height: 25,width: size.width*.28,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add Review',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                  Icon(Icons.star,size: 20,color: Colors.yellow,),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        addReview=='true'?Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Text('1',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),),
                InkWell(
                  onTap: (){
                    setState(() {
                      star1=Colors.yellow;
                      star2=Colors.grey;
                      star3=Colors.grey;
                      star4=Colors.grey;
                      star5=Colors.grey;
                      rating=1;
                    });
                  },
                    child: Icon(Icons.star,size: 25,color: star1)),
                VerticalDivider(thickness: 2, width: 10, color: Colors.black,),
                Text('2',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),),
                InkWell(
                    onTap: (){
                      setState(() {
                        star2=Colors.yellow;
                        star3=Colors.grey;
                        star4=Colors.grey;
                        star5=Colors.grey;
                        rating=2;
                      });
                      if(star2==Colors.yellow){
                        setState(() {
                          star1=Colors.yellow;
                        });
                      }
                    },
                    child: Icon(Icons.star,size: 25,color: star2)),
                VerticalDivider(thickness: 2, width: 10, color: Colors.black,),
                Text('3',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),),
                InkWell(
                    onTap: (){
                      setState(() {
                        star3=Colors.yellow;
                        star4=Colors.grey;
                        star5=Colors.grey;
                        rating=3;
                      });
                      if(star3==Colors.yellow){
                        setState(() {
                          star1=Colors.yellow;
                          star2=Colors.yellow;
                        });
                      }
                    },
                    child: Icon(Icons.star,size: 25,color: star3)),
                VerticalDivider(thickness: 2, width: 10, color: Colors.black,),
                Text('4',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),),
                InkWell(
                    onTap: (){
                      setState(() {
                        star4=Colors.yellow;
                        star5=Colors.grey;
                        rating=4;
                      });
                      if(star4==Colors.yellow){
                        setState(() {
                          star1=Colors.yellow;
                          star2=Colors.yellow;
                          star3=Colors.yellow;
                        });
                      }
                    },
                    child: Icon(Icons.star,size: 25,color: star4)),
                VerticalDivider(thickness: 2, width: 10, color: Colors.black,),
                Text('5',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),),
                InkWell(
                    onTap: (){
                      setState(() {
                        star5=Colors.yellow;
                        rating=5;
                      });
                      if(star5==Colors.yellow){
                        setState(() {
                          star1=Colors.yellow;
                          star2=Colors.yellow;
                          star3=Colors.yellow;
                          star4=Colors.yellow;
                        });
                      }
                    },
                    child: Icon(Icons.star,size: 25,color: star5)),
              ],
            ),
          ),
        ):Container(),
        SizedBox(height: 10),
        addReview=='true'?Container(
          padding: EdgeInsets.only(left: 15,right: 15),
          height: size.width * .18,
          width: double.infinity,
          color: Colors.white70,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  maxLines: null,minLines: null,
                  expands: true,
                  controller: reviewTextController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: "Write your review...",
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none),
                  onChanged: (value) {
                    reviewText = value;
                  },
                ),
              ),

            ],
          ),
        ):Container(),
        SizedBox(height: 5),
        addReview=='true'?Padding(
        padding: EdgeInsets.only(
        left: getProportionateScreenWidth(20),
        right: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    _isLoading=true;
                  });
                  reviewRepo.addReview(widget.productId, token, reviewText,rating).then((response)async{
                    if(response['status']==true){
                      reviewTextController.clear();
                      setState(() {
                        _isLoading=false;
                      });
                      _showToast('Review submitted',kPrimaryColor);
                    }else{
                      reviewTextController.clear();
                      setState(() {
                        _isLoading=false;
                      });
                      _showToast('Buy this Product first',Colors.redAccent);
                    }
                  //   await commentProvider.fetch(widget.productId).then((value){
                  //     setState(() {
                  //       _isLoading=false;
                  //     });
                  //     _showToast('Comment sent', kPrimaryColor);
                  //   });
                   });
                },
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                  height: getProportionateScreenWidth(45),
                  width: getProportionateScreenWidth(65),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ],
          ),
        ):Container(),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.w600),
              ),
              commentProvider
                  .comments!=null?commentProvider
                  .comments.comdata!=null?commentProvider
                  .comments.comdata.length>2?InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      AllComments(productId: widget.productId,)));
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.w600),
                ),
              ):Container():Container():Container(),
            ],
          ),
        ),
        SizedBox(height: 10),
        _isLoading?Center(child: CircularProgressIndicator()):Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(10),
            ),
            child: commentProvider.comments!= null?
    commentProvider.comments.comdata!= null
                ? commentProvider.comments.comdata.isNotEmpty
                    ? ListView.builder(
                        physics: new ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: commentProvider.comments.comdata.length>2?2:commentProvider.comments.comdata.length,
                        itemBuilder: (BuildContext context, int index) {
                          DateTime time = DateTime.parse(commentProvider
                              .comments.comdata[index].createdAt);
                          return Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: commentProvider.comments
                                                .comdata[index].userphoto ==
                                            'https://muktomart.com/assets/images/users'
                                        ? Icon(Icons.person_outline)
                                        : CachedNetworkImage(
                                      imageUrl: commentProvider.comments.comdata[index].userphoto,
                                      imageBuilder: (context, imageProvider) => Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider, fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) => Icon(Icons.account_circle,color: Colors.grey[700]),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),//Image.network(commentProvider.comments.comdata[index].userphoto),
                                    radius: size.width * .05,
                                  ),
                                  // Text(f.format(time),style: TextStyle(fontSize: size.width*.028)),
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        commentProvider
                                            .comments.comdata[index].username,
                                        style: TextStyle(
                                            fontSize: size.width * .035,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          commentProvider
                                              .comments.comdata[index].text,
                                          style: TextStyle(
                                              fontSize: size.width * .035)),
                                      SizedBox(height: 2),
                                      Text(f.format(time),
                                          style: TextStyle(
                                              fontSize: size.width * .028)),
                                      SizedBox(height: 3),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Icon(Icons.reply,
                                              size: size.width * .06),
                                          InkWell(
                                            child: Text('Reply',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * .033)),
                                            onTap: () {
                                              _showReplyDialog(commentProvider.comments.comdata[index].id,commentProvider);
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          '${commentProvider.comments.comdata[index].userId}' ==
                                                  '$userId'
                                              ? Icon(Icons.edit,
                                                  size: size.width * .06)
                                              : Container(),
                                          '${commentProvider.comments.comdata[index].userId}' ==
                                                  '$userId'
                                              ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                editCommentController.text=commentProvider.comments.comdata[index].text;
                                              });
                                              _showEditDialog(commentProvider.comments.comdata[index].id,commentProvider);
                                            },
                                                child: Text('Edit',
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width * .033)),
                                              )
                                              : Container(),
                                          SizedBox(width: 10),
                                          '${commentProvider.comments.comdata[index].userId}' ==
                                                  '$userId'
                                              ? Icon(Icons.delete,
                                                  size: size.width * .05)
                                              : Container(),
                                          '${commentProvider.comments.comdata[index].userId}' ==
                                                  '$userId'
                                              ? InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      _isLoading=true;
                                                    });
                                                   commentsRepo.deleteComment(token,
                                                       commentProvider.comments.comdata[index].id).then((value)async{
                                                       await commentProvider.fetch(widget.productId).then((value){
                                                         setState(() {
                                                           _isLoading=false;
                                                         });
                                                         _showToast('Comment deleted', kPrimaryColor);
                                                       });
                                                       });},
                                                child: Text('Delete',
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width * .033)),
                                              )
                                              : Container(),
                                        ],
                                      ),

                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ],
                              ),
                              commentProvider.comments.comdata[index].replies
                                      .isNotEmpty
                                  ? Row(
                                      children: [
                                        SizedBox(width: size.width * .2),
                                        Expanded(
                                          child: ListView.builder(
                                              physics:
                                                  new ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: commentProvider
                                                  .comments
                                                  .comdata[index]
                                                  .replies
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int dx) {
                                                    DateTime tm = DateTime.parse(commentProvider
                                                        .comments.comdata[index].replies[dx].createdAt);
                                                var dta = commentProvider
                                                    .comments
                                                    .comdata[index]
                                                    .replies[dx];
                                                return Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey,

                                                      child: dta.userphoto == 'https://muktomart.com/assets/images/users'
                                                          ?Icon(Icons.person_outline)
                                                          : Image.network(dta.userphoto),
                                                      radius: size.width * .05,
                                                    ),
                                                    // Text(f.format(time),style: TextStyle(fontSize: size.width*.028)),
                                                    SizedBox(
                                                      width: 18,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${dta.username}',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.width *
                                                                      .035,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(dta.text,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.width *
                                                                        .035)),
                                                        SizedBox(height: 2),
                                                        Text(
                                                            f.format(
                                                                tm),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.width *
                                                                        .028)),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          children: [
                                                            '${dta.userId}' ==
                                                                '$userId'
                                                                ? Icon(Icons.edit,
                                                                size: size.width * .06)
                                                                : Container(),
                                                            '${dta.userId}' ==
                                                                '$userId'
                                                                ? InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  editReplyController.text=dta.text;
                                                                });
                                                                _showReplyEditDialog(dta.id,commentProvider);
                                                              },
                                                                  child: Text('Edit',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      size.width * .033)),
                                                                )
                                                                : Container(),
                                                            SizedBox(width: 10),
                                                            '${dta.userId}' ==
                                                                '$userId'
                                                                ? Icon(Icons.delete,
                                                                size: size.width * .05)
                                                                : Container(),
                                                            '${dta.userId}' ==
                                                                '$userId'
                                                                ? InkWell(
                                                              onTap: (){
                                                                setState(() {
                                                                  _isLoading=true;
                                                                });
                                                                commentsRepo.deleteReply(token,
                                                                    dta.id).then((value)async{
                                                                  await commentProvider.fetch(widget.productId).then((value){
                                                                    setState(() {
                                                                      _isLoading=false;
                                                                    });
                                                                    _showToast('Reply deleted', kPrimaryColor);
                                                                  });
                                                                });},
                                                                  child: Text('Delete',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      size.width * .033)),
                                                                )
                                                                : Container(),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          );
                        })
                      : Text('No comments')
                    : Text('No comments')
                : Text('No comments')),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 15,right: 15),
          height: size.width * .17,
          width: double.infinity,
          color: Colors.white70,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  maxLines: null,minLines: null,
                  expands: true,
                  controller: commentTextController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: "Write your comment...",
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none),
                  onChanged: (value) {
                    commentText = value;
                  },
                ),
              ),
              SizedBox(width: size.width * .04),
              InkWell(
                onTap: (){
                  if(token==null){
                    _showToast('Please log in first', Colors.redAccent);
                  }else{
                    if(commentTextController.text.isNotEmpty){
                      setState(() {
                        _isLoading=true;
                      });
                      commentsRepo.addComment(widget.productId, token, commentText).then((value)async{
                        await commentProvider.fetch(widget.productId).then((value){
                          commentTextController.clear();
                          setState(() {
                            _isLoading=false;
                          });
                          _showToast('Comment sent', kPrimaryColor);
                        });
                      });
                    }else{
                      _showToast('Write your comment', Colors.redAccent);
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                  height: getProportionateScreenWidth(45),
                  width: getProportionateScreenWidth(65),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seller\'s products',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () {
                  color == false
                      ? favouriteSellerRepo
                          .addFavouriteSeller(
                              token, widget.productDetails.product.userId)
                          .then((value) {
                          _showToast(
                              'Added to your favourite seller', kPrimaryColor);
                          setState(() {
                            color = true;
                          });
                          favouriteSellerProvider.fetch(token);
                          favouriteSellerProvider.fetchSellerId(token);
                        })
                      : null;
                },
                child: Text(
                  'Add to favourite seller',
                  style: TextStyle(
                      color: color ? Colors.grey : kPrimaryColor,
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: new ClampingScrollPhysics(),
          itemCount: detailsProvider.productDetails.vendors.length,
          crossAxisCount: 2,
          itemBuilder: (BuildContext context, int index) {
            // if (demoProducts[index].isPopular)
            return VendorCard(product: detailsProvider.productDetails.vendors[index]);
            // return SizedBox
            //     .shrink(); // here by default width and height is 0
          },
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.fit(1),
          mainAxisSpacing: 6.0,

        ),
        // GridView.builder(
        //   shrinkWrap: true,
        //   physics: new ClampingScrollPhysics(),
        //   itemCount: detailsProvider.productDetails.vendors.length,
        //   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 6
        //   ,childAspectRatio: 6.3/9),
        //   itemBuilder: (BuildContext context, int index) {
        //     // if (demoProducts[index].isPopular)
        //     return VendorCard(product: detailsProvider.productDetails.vendors[index]);
        //     // return SizedBox
        //     //     .shrink(); // here by default width and height is 0
        //   },
        // ),
      ],
    ):Container();
  }

  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _showReplyDialog(int id,CommentProvider commentProvider) {
    String reply;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Write your reply",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Write your reply'),
                      onSaved: (val) {
                        reply = val;
                      },
                      validator: (val) =>
                      val.isEmpty ? 'please write reply' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          color: kPrimaryColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _isLoading=true;
                            });
                            if (_addKey.currentState.validate()) {
                              _addKey.currentState.save();
                              commentsRepo.replyComment(id, token, reply).then((value)async{
                               await commentProvider.fetch(widget.productId).then((value){
                                 setState(() {
                                   _isLoading=false;
                                 });
                                 _showToast('reply sent', kPrimaryColor);
                               });
                               });
                            }

                          },
                          child: Text(
                            "post",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showEditDialog(int id,CommentProvider commentProvider) {
    String editText;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Edit your comment",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      controller: editCommentController,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Edit your comment'),
                      onSaved: (val) {
                        editText = val;
                        //editCommentController.text=editText;
                      },
                        onChanged:(val){
                        setState(() {
                          editText=editCommentController.text;
                        });
                        },
                      validator: (val) =>
                      val.isEmpty ? 'please write comment' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          color: kPrimaryColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _isLoading=true;
                            });
                            if (_addKey.currentState.validate()) {
                              _addKey.currentState.save();
                                commentsRepo.editComment(id, token, editText).then((value)async{
                                  await commentProvider.fetch(widget.productId).then((value){
                                    setState(() {
                                      _isLoading=false;
                                    });
                                    _showToast('comment updated', kPrimaryColor);
                                  });
                                });
                            }

                          },
                          child: Text(
                            "post",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showReplyEditDialog(int id,CommentProvider commentProvider) {
    String replyEditText;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Edit your reply",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      controller: editReplyController,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Edit your reply'),
                      onSaved: (val) {
                        replyEditText = val;
                        //editCommentController.text=editText;
                      },
                      onChanged:(val){
                        setState(() {
                          replyEditText=editReplyController.text;
                        });
                      },
                      validator: (val) =>
                      val.isEmpty ? 'please write reply' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          color: kPrimaryColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _isLoading=true;
                            });
                            if (_addKey.currentState.validate()) {
                              _addKey.currentState.save();
                              commentsRepo.editReply(id, token, replyEditText).then((value)async{
                                await commentProvider.fetch(widget.productId).then((value){
                                  setState(() {
                                    _isLoading=false;
                                  });
                                  _showToast('Reply updated', kPrimaryColor);
                                });
                              });

                            }

                          },
                          child: Text(
                            "post",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
