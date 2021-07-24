import 'dart:io';
import 'dart:ui';

import 'package:alminshawy/mobx/QuranMobx.dart';
import 'package:alminshawy/statefull/Player.dart';
import 'package:alminshawy/statless/AlertLogOut.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
 import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'AboutShikh.dart';


const String testDevice ='3ADF6D1F2FF900409FCD7AFFF73CF972';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  QuranMobx con;

  BannerAd _bannerAd;


  //---------------------------------- ad initialization -------------------------------------

/*

  static const MobileAdTargetingInfo targetingInfo=MobileAdTargetingInfo(
      keywords: <String>['quran', 'alafasy'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[testDevice]
  );

*/

  static final AdRequest request = AdRequest(
    keywords: <String>['alminshawy', 'quran'],
    contentUrl: 'https://flutter.io',
    nonPersonalizedAds: true,
  );

  BannerAd _anchoredBanner;
  bool _loadingAnchoredBanner = false;



  final String IOS_AD_UNIT_BANNER="";

  final String ANDROID_AD_UNIT_BANNER="ca-app-pub-8165719959159108/3995703022";

  final String IOS_APP_ID="";

  final String ANDROID_APP_ID="ca-app-pub-8165719959159108~8373931735";


  int myIndex=0;


  String getAppId() {

    print ("get app id ");
    print(Platform.isIOS);
    print(Platform.isAndroid);
    if (Platform.isIOS) {
      return IOS_APP_ID;
    } else if (Platform.isAndroid) {
      return ANDROID_APP_ID;
    }
    return null;
  }

//  BannerAd createBannerAd(){
//    return BannerAd(
//        adUnitId:  getBannerAdUnitId() ,
//        size: AdSize.fullBanner,
//        targetingInfo: targetingInfo,
//        listener: (MobileAdEvent event) {
//          if (event == MobileAdEvent.loaded) {
//            _bannerAd.show(anchorOffset: -10.0, anchorType: AnchorType.bottom,  horizontalCenterOffset: 0.0,);
//
//          }
//        }
//    );
//  }

  String getBannerAdUnitId() {
    print("*******************");
    print("getBannerAdUnitId");
    print(Platform.isAndroid);

    if (Platform.isAndroid) {
      return ANDROID_AD_UNIT_BANNER;
    } else {
      return IOS_AD_UNIT_BANNER;

    }

  }

//------------------------------------------------------------------------------------------------



  @override
  void initState() {

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: /*BannerAd.testAdUnitId*/getBannerAdUnitId(),
      listener:  AdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
      request: request,
    );
    _bannerAd.load();


//    FirebaseAdMob.instance.initialize(appId: getAppId());
//    _bannerAd=createBannerAd()..load()..show(
//      anchorOffset: 0.0,
//      anchorType: AnchorType.bottom,
//      horizontalCenterOffset: 0.0,
//    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      con.getMySuraId();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }



  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertLogOut(onNoPressed: (){
        Navigator.of(context).pop(false);
      },onYesPressed: (){
        if(con.audioPlayer!=null&&con.isSuraPlaying!=null&&con.isSuraPlaying){
          con.isSuraPlaying=false;
          con.audioPlayer.stop();
          con.audioPlayer.dispose();
        }
        Navigator.of(context).pop(true);
      },)
    )) ?? false;
  }


  @override
  Widget build(BuildContext context) {
  con=Provider.of<QuranMobx>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _drawerKey, // assign key to Scaffold

        drawer:   Drawer(
          child: ListView(
            children: [

              Container(
                height: MediaQuery.of(context).size.height*.288,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Container(

                      width:    120,
                      height:    120,
                      child: new CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: const Color(0xff7c94b6),
                            borderRadius: new BorderRadius.all(new Radius.circular(90.0)),
                            border: new Border.all(
                              color: Colors.white,
                              width: 4.0,
                            ),
                          ),

                          child:  ClipOval(
                            child: Image(
                              image: AssetImage("assets/affasy.jpg"),
                              width:  (MediaQuery.of(context).size.width) -  200,
                              height:  (MediaQuery.of(context).size.width) -  200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      ),
                    ),

                    SizedBox(height: 5),

                    Center(child: Text("الشيخ مشارى بن راشد العفاسى",style: TextStyle(color: Colors.white,fontSize: 22),),),

                    //  widget.loadingText
                  ],
                ),
              ),


              ListTile(
                title: Center(child: Text("قيم التطبيق",style: TextStyle(color: Colors.green,fontSize: 18),)),
                onTap: (){},
              ),

              //         ====================== Divider =======================
              Padding(
                padding:  EdgeInsets.only(top:0.0,left: 5,right: 5,bottom: 0),
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 10, top: 6),
                  child: Divider(
                    height: 1,
                    thickness: 1.3,
                  ),
                ),
              ),

              ListTile(
                title: Center(child: Text("تطبيقات أخرى",style: TextStyle(color: Colors.green,fontSize: 18,),)),
                onTap: (){
                  Toast.show("حاليا لا توجد تطبيقات اخري ولكن سيتم اضافتها قريبا", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);

                },
              ),

              //         ====================== Divider =======================
              Padding(
                padding:  EdgeInsets.only(top:0.0,left: 5,right: 5,bottom: 0),
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 10, top: 6),
                  child: Divider(
                    height: 1,
                    thickness: 1.3,
                  ),
                ),
              ),

              ListTile(
                title: Center(child: Text("نبذة عن الشيخ",style: TextStyle(color: Colors.green,fontSize: 18),)),
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) =>
                      AboutShikh(about: "نبذة عن الشيخ",bio: "ولد الشيخ محمد بمدينة المنشاة التابعة لمحافظة سوهاج في جمهورية مصر العربية، وأتم حفظ القرآن الكريم وهو في الثامنة من عمره؛ حيث نشأ في أسرة قرآنية عريقة توارثت تلاوة القرآن، فأبوه الشيخ صديق المنشاوي وجده تايب المنشاوي وجد والده كلهم قرّاء للقرآن وفي أسرته الكثير ممن يحفظون القرآن ويجيدون تلاوته منهم شقيقه محمود صديق المنشاوي. تأثر بوالده الذي تعلم منه فن قراءة القرآن الكريم، فأصبحت هذه العائلة رائدة لمدرسة جميلة منفردة بذاتها في تلاوة القرآن، بإمكاننا أن نطلق عليها (المدرسة المنشاوية). رحل إلى القاهرة مع عمه القارئ الشيخ أحمد السيد فحفظ هناك ربع القرآن في عام 1927 ثم عاد إلى بلدته المنشاة وأتم حفظ ودراسة القرآن على مشايخ مثل محمد النمكي ومحمد أبو العلا ورشوان أبو مسلم الذي كان لا يتقاضى أجراً على التعليم.\n للشيخ المنشاوي بصمة خاصة في التلاوة يتميز بصوت خاشع ذي مسحة من الحزن فلُقِّب الشيخ محمد صديق المنشاوي بـ  الصوت الباكى  ابتدأت رحلته مع التلاوة بتجواله مع أبيه وعمه بين السهرات المختلفة، حتى سنحت الفرصة له كي يقرأ منفردًا في ليلة من عام 1952 بمحافظة سوهاج، ومن هنا صار اسمه مترددًا في الأنحاء.\n سجل القرآن الكريم كاملاً في ختمة مرتلة، كما سجل ختمة قرآنية مجودة بـالإذاعة المصرية، وله كذلك قراءة مشتركة برواية الدوري مع القارئين كامل البهتيمي وفؤاد العروسي. وله أيضا العديد من التسجيلات في المسجد الأقصى والكويت وسوريا وليبيا. تلى القرآن في المساجد الرئيسية في العالم الإسلامي كالمسجد الحرام في مكة المكرمة والمسجد النبوي في المدينة المنورة والمسجد الأقصى في القدس. زار عددا من الدول الاسلامية كالعراق واندونيسيا وسوريا والكويت وليبيا وفلسطين والمملكة العربية السعودية. " ,)));
                },
              ),

              //         ====================== Divider =======================
              Padding(
                padding:  EdgeInsets.only(top:0.0,left: 5,right: 5,bottom: 0),
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 10, top: 6),
                  child: Divider(
                    height: 1,
                    thickness: 1.3,
                  ),
                ),
              ),




            ],
          ),
        ),
        appBar: AppBar(
          shadowColor: Colors.green,
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text("القرآن الكريم للشيخ محمد صديق المنشاوى",style: TextStyle(color: Colors.white,fontSize: 15),),

          actions: [

          ],
        ),

        body: Observer(
          builder: (_) {
            return Stack(
              children: [
                Container(
                  child: Container(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        height: (MediaQuery.of(context).size.height*.78),
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: con.suarsNames.length ,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
                                child: InkWell(
                                  onTap: (){
                                    if(mounted){
                                      setState(() {
                                        print("my suras${con.surasId}");

                                        if(con.audioPlayer!=null&&con.isSuraPlaying!=null&&con.isSuraPlaying&& con.currentIndex==index){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PlayerPage(newone: false,)));
                                          print('first called');
                                        }else if(con.audioPlayer!=null&&con.isSuraPlaying!=null&&con.isSuraPlaying){
                                          con.isSuraPlaying=false;
                                          con.audioPlayer.stop();
                                          con.audioPlayer.dispose();
                                          con.currentIndex=index;
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PlayerPage(newone: true,)));
                                          print('second called');
                                        }else{
                                          con.currentIndex=index;
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PlayerPage(newone: true,)));
                                          print('third called');
                                        }

                                      });

                                    }



                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    height: 50,
                                  //  color: Colors.grey,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [


                                       // index==con.currentIndex
                                        Observer(
                                          builder: (_) {
                                          return
                                                 Visibility(
                                                  visible: index==con.currentIndex,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right:20.0),
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      size: 25,
                                                      color: Colors.green[800],
                                                    ),
                                                  ),
                                                );
                                              }
                                        ),
                                        Observer(
                                        builder: (_) {
                                          return Visibility(
                                            visible: index != con.currentIndex,
                                            child: SizedBox(
                                              width: 0,
                                            ),
                                          );
                                        }
                                        ),
                                        Center(child: Text( con.suarsNames[index] ,style: TextStyle(fontSize: 22,color:Colors.green[800],),)),

                                        Observer(
                                            builder: (_) {
                                              return SizedBox(
                                                width: index != con.currentIndex?50:70,
                                              );
                                            }
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                    ),
                  ),
                ),

//                Container(
//                  width: 468,
//                  height: 60,
//                  padding: EdgeInsets.only(bottom: 10.0),
//                  alignment: Alignment.bottomCenter,
//                  child: AdWidget(ad: _bannerAd),
//                ),
              ],
            );

          },
        ),

      ),
    );
  }
}