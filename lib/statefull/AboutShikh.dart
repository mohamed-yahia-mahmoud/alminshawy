import 'package:flutter/material.dart';

class AboutShikh extends StatefulWidget {

 final String about;
 final String bio;

  AboutShikh( {this.about,this.bio});

 @override
 _AboutShikhState createState() => _AboutShikhState();
}

class _AboutShikhState extends State<AboutShikh> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  final formKey = new GlobalKey<FormState>();


  bool savedLocal=false;


  @override
  void initState() {
    // TODO: implement initState

    super.initState();

  }

  @override
  void dispose() {
     super.dispose();
  }




  @override
  Widget build(BuildContext context) {


    Future.delayed(const Duration(milliseconds: 60), () {
      if(mounted){
        setState(() {
          // Here you can write your code for open new view
        });
      }
    });




        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Scaffold(
            key: _drawerKey,
            appBar: AppBar(
              shadowColor: Colors.green,
              backgroundColor: Colors.green,
              centerTitle: true,
              title: Text("القرآن الكريم للشيخ محمد صديق المنشاوى",style: TextStyle(color: Colors.white,fontSize: 15),),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (mounted) {
                      Navigator.pop(context);
                    }

                  }
              ),
              actions: [
                /*   Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.exit_to_app),
            ),*/
              ],
            ),

            body:   Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,

                      child: Column(
                         children: <Widget>[

                           Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .88,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                   Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            'نبذة عن الشيخ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        child: RichText(
                                          text: TextSpan(

                                              children: [
                                                TextSpan( text: "ولد الشيخ محمد بمدينة المنشاة التابعة لمحافظة سوهاج في جمهورية مصر العربية، وأتم حفظ القرآن الكريم وهو في الثامنة من عمره؛ حيث نشأ في أسرة قرآنية عريقة توارثت تلاوة القرآن، فأبوه الشيخ صديق المنشاوي وجده تايب المنشاوي وجد والده كلهم قرّاء للقرآن وفي أسرته الكثير ممن يحفظون القرآن ويجيدون تلاوته منهم شقيقه محمود صديق المنشاوي. تأثر بوالده الذي تعلم منه فن قراءة القرآن الكريم، فأصبحت هذه العائلة رائدة لمدرسة جميلة منفردة بذاتها في تلاوة القرآن، بإمكاننا أن نطلق عليها (المدرسة المنشاوية). رحل إلى القاهرة مع عمه القارئ الشيخ أحمد السيد فحفظ هناك ربع القرآن في عام 1927 ثم عاد إلى بلدته المنشاة وأتم حفظ ودراسة القرآن على مشايخ مثل محمد النمكي ومحمد أبو العلا ورشوان أبو مسلم الذي كان لا يتقاضى أجراً على التعليم.\n للشيخ المنشاوي بصمة خاصة في التلاوة يتميز بصوت خاشع ذي مسحة من الحزن فلُقِّب الشيخ محمد صديق المنشاوي بـ  الصوت الباكى  ابتدأت رحلته مع التلاوة بتجواله مع أبيه وعمه بين السهرات المختلفة، حتى سنحت الفرصة له كي يقرأ منفردًا في ليلة من عام 1952 بمحافظة سوهاج، ومن هنا صار اسمه مترددًا في الأنحاء.\n سجل القرآن الكريم كاملاً في ختمة مرتلة، كما سجل ختمة قرآنية مجودة بـالإذاعة المصرية، وله كذلك قراءة مشتركة برواية الدوري مع القارئين كامل البهتيمي وفؤاد العروسي. وله أيضا العديد من التسجيلات في المسجد الأقصى والكويت وسوريا وليبيا. تلى القرآن في المساجد الرئيسية في العالم الإسلامي كالمسجد الحرام في مكة المكرمة والمسجد النبوي في المدينة المنورة والمسجد الأقصى في القدس. زار عددا من الدول الاسلامية كالعراق واندونيسيا وسوريا والكويت وليبيا وفلسطين والمملكة العربية السعودية. ",
                                                  style: TextStyle(
                                                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),


                                              ]),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    );
                  }),
            ),
          ),
        );




  }
}


