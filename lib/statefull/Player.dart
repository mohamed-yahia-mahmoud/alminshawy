import 'dart:ui';

 import 'package:alminshawy/mobx/QuranMobx.dart';
import 'package:audioplayers/audio_cache.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

int current = 0;

_backgroundTaskEntrypoint(String sura,String suraName,Duration duration,List suraList) {
  AudioServiceBackground.run(() => AudioPlayerTask(sura,suraName,duration,suraList));
}

class AudioPlayerTask extends BackgroundAudioTask {
  final _audioPlayer = AudioPlayer();

  String sura;
  String suraName;
  Duration duration;
  List suraList;
  AudioPlayerTask(String sura,String suraName,Duration duration,List suraList);

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    AudioServiceBackground.setState(controls: [
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,
      MediaControl.skipToPrevious
    ], systemActions: [
      MediaAction.seekTo
    ], playing: true, processingState: AudioProcessingState.connecting);
    // Connect to the URL
    await _audioPlayer.setUrl(sura);
    AudioServiceBackground.setMediaItem( MediaItem(
        id: sura,
        title: 'القران الكريم للشيخ محمد صديق المنشاوي',
        artUri:  ('assets/img.jpg'),
        album: suraName,
        duration:  duration,
        artist: 'المنشاوي'));
    // Now we're ready to play
    _audioPlayer.play();
    // Broadcast that we're playing, and what controls are available.
    AudioServiceBackground.setState(controls: [
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,
      MediaControl.skipToPrevious
    ], systemActions: [
      MediaAction.seekTo
    ], playing: true, processingState: AudioProcessingState.ready);
  }

  @override
  Future<void> onStop() async {
    AudioServiceBackground.setState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.ready);
    await _audioPlayer.stop();
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    AudioServiceBackground.setState(controls: [
      MediaControl.pause,
      MediaControl.stop,
      MediaControl.skipToNext,
      MediaControl.skipToPrevious
    ], systemActions: [
      MediaAction.seekTo
    ], playing: true, processingState: AudioProcessingState.ready);
    await _audioPlayer.play();
    return super.onPlay();
  }

  @override
  Future<void> onPause() async {
    AudioServiceBackground.setState(controls: [
      MediaControl.play,
      MediaControl.stop,
      MediaControl.skipToNext,
      MediaControl.skipToPrevious
    ], systemActions: [
      MediaAction.seekTo
    ], playing: false, processingState: AudioProcessingState.ready);
    await _audioPlayer.pause();
    return super.onPause();
  }

  @override
  Future<void> onSkipToNext() async {
    if (current < suraList.length - 1)
      current = current + 1;
    else
      current = 0;

      AudioServiceBackground.setMediaItem(MediaItem(
            id: '"https://server11.mp3quran.net/minsh_mjwd/"${suraList[current]}.mp3"',
            title: 'القران الكريم للشيخ محمد صديق المنشاوي',
           artUri:  ('assets/img.jpg'),
            album:  suraName,
             duration:  duration,
           artist: 'المنشاوي'));
           await _audioPlayer.setUrl('"https://server11.mp3quran.net/minsh_mjwd/"${suraList[current]}.mp3"');

    AudioServiceBackground.setState(position: Duration.zero);
    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() async {
    if (current != 0)
      current = current - 1;
    else
      current = suraList.length - 1;

    AudioServiceBackground.setMediaItem(MediaItem(
        id: '"https://server11.mp3quran.net/minsh_mjwd/"${suraList[current]}.mp3"',
        title: 'القران الكريم للشيخ محمد صديق المنشاوي',
        artUri:  ('assets/img.jpg'),
        album:  suraName,
        duration:  duration,
        artist: 'المنشاوي'));
    await _audioPlayer.setUrl('"https://server11.mp3quran.net/minsh_mjwd/"${suraList[current]}.mp3"');
    AudioServiceBackground.setState(position: Duration.zero);
    return super.onSkipToPrevious();
  }

  @override
  Future<void> onSeekTo(Duration position) {
    _audioPlayer.seek(position);
    AudioServiceBackground.setState(position: position);
    return super.onSeekTo(position);
  }
}

class PlayerPage extends StatefulWidget {

  final bool newone;

  const PlayerPage({Key key, this.newone}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}


 

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {

  QuranMobx con;

  AnimationController _animationIconController1;


  void initState() {
    super.initState();
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
      reverseDuration: Duration(milliseconds: 750),
    );


    WidgetsBinding.instance.addPostFrameCallback((_) {

      if(widget.newone){
        con.my_position = con.my_slider;

        con.audioPlayer = new AudioPlayer();
        con.audioCache = new AudioCache(fixedPlayer: con.audioPlayer);
        con.audioPlayer.durationHandler = (d) {
          if(mounted){
            setState(() {
              con.my_duration = d;
            });
          }
        } ;
                                   
        con.audioPlayer.positionHandler = (p) {
          if(mounted){
            setState(() {
              con.my_position = p;
            });
          }
        };
      }else{

        con.audioPlayer.durationHandler = (d) {
          if(mounted){
            setState(() {
              con.my_duration = d;
            });
          }
        } ;

        con.audioPlayer.positionHandler = (p) {
          if(mounted){
            setState(() {
              con.my_position = p;
            });
          }
        };
        _animationIconController1.forward();
      }



    });


  }



  @override
  Widget build(BuildContext context) {

    con = Provider.of<QuranMobx>(context);



    return Scaffold(
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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(0.55),
          image: DecorationImage(
            image: AssetImage("assets/img.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: (MediaQuery.of(context).size.width),
              height: (MediaQuery.of(context).size.height),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 5,),
                    ClipOval(
                      child: Image(
                        image: AssetImage("assets/minshawy.jpg"),
                        width: (MediaQuery.of(context).size.width) - 200,
                        height: (MediaQuery.of(context).size.width) - 200,
                        fit: BoxFit.fill,
                      ),
                    ),

                    Column(
                      children: [
                        Slider(
                          activeColor: Colors.green[300],
                          inactiveColor: Colors.white,
                          value: con.my_position.inSeconds.toDouble(),
                          max: con.my_duration.inSeconds.toDouble() ,
                          onChanged: (double v) {
                            if (this.mounted) {
                              setState(() {
                                con.seekToSecond(v.toInt());
                              });
                            }

                          },


                        ),
                        SizedBox(height: 0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right:20.0),
                                child: Container(
                                  child: Text(
                                    con.suarsNames[con.currentIndex],style: TextStyle(color: Colors.white,fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left:20.0),
                                child: Container(
                                  child: Text(
                                    "${con.getCurrentPositionTime(con.my_position)}",style: TextStyle(color: Colors.white,fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                     SizedBox(height: 20,),


                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                // the previous sura
                                InkWell(
                                  onTap: () {
                                    if(mounted) {
                                      setState(() {
                                        con.isSuraPlaying = true;
                                         _animationIconController1.forward();
                                        con.currentIndex = con.currentIndex - 1;
                                        con.audioPlayer.play(
                                            "${con.url}${con.surasId[con
                                                .currentIndex]}.mp3");
                                      });
                                    }
                                                                    },
                                  child: Icon(
                                    Icons.fast_forward,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ),

                                //backward 10 seconds
                                InkWell(
                                  onTap: () {
                                    con.audioPlayer.seek(
                                      Duration(
                                        milliseconds: con.my_position.inMilliseconds - 10000,
                                      ),
                                    );
                                  },
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: Icon(Icons.replay, size: 35, color: Colors.white,),
                                  ),
                                ),

                                //play pause button
                                StreamBuilder<PlaybackState>(
                                     stream: AudioService.playbackStateStream,
                                                      builder: (context, snapshot) {
                                                        final playing = snapshot.data?.playing ?? false;
                                                        if (playing)
                                                          return ElevatedButton(
                                                              child: Text("Pause"),
                                                              onPressed: () {
                                                                AudioService.pause();
                                                              });
                                                        else
                                                             return
                                                          GestureDetector(

                                                               onTap: () {                                                                                      
                                                                 if(mounted){
                                                                 setState(() {
                                                                               if (!con.isSuraPlaying) {
                                                                                 print('my url :  ${con.url}${con.surasId[con.currentIndex]}.mp3');
                                                                                 con.audioPlayer.play("${con.url}${con.surasId[con.currentIndex]}.mp3");
                                                                                  _animationIconController1.forward();

                                                                                 con.audioPlayer.onPlayerCompletion.listen((event) {

                                                                                      setState(() {
                                                                                        _animationIconController1.reverse();
                                                                                        if(con.currentIndex<113){
                                                                                          con.isSuraPlaying=true;
                                                                                          _animationIconController1.forward();
                                                                                          con.currentIndex=con.currentIndex+1;
                                                                                          con.audioPlayer.play("${con.url}${con.surasId[con.currentIndex]}.mp3")

                                                                                        }
                                                                                         });


                                                                                  });

                                                                               } else {
                                                                                 con.audioPlayer.pause();
                                                                               _animationIconController1.reverse();
                                                                                }
                                                                                con.isSuraPlaying = !con.isSuraPlaying;
                                                                              },
                                                                 );
                                                                 }
                                                               },
                                                               child: ClipOval(
                                                                 child: Container(
                                                                   color: Colors.green[400],
                                                                   child: Padding(
                                                                     padding: const EdgeInsets.all(8.0),
                                                                     child:  AnimatedIcon(
                                                                       icon: AnimatedIcons.play_pause,
                                                                       size: 35,
                                                                       progress: _animationIconController1,
                                                                       color: Colors.white,
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                                                                  );



                                                          // return ElevatedButton(
                                                          //     child: Text("Play"),
                                                          //     onPressed: () {
                                                          //       if (AudioService.running) {
                                                          //         AudioService.play();
                                                          //       } else {
                                                          //         AudioService.start(
                                                          //           backgroundTaskEntrypoint:
                                                          //               _backgroundTaskEntrypoint,
                                                          //         );
                                                          //       }
                                                          //     });
                                                      }




                                ),
                                //forward 10 seconds
                                InkWell(
                                  onTap: () {
                                    con.audioPlayer.seek(
                                      Duration(
                                        milliseconds: con.my_position.inMilliseconds + 10000,
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.replay,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ),
                                //next sura
                                InkWell(
                                  onTap: () {
                                    if(mounted){
                                      setState(() {
                                        con.isSuraPlaying=true;
                                        _animationIconController1.forward();
                                        con.currentIndex=con.currentIndex+1;
                                        con.audioPlayer.play("${con.url}${con.surasId[con.currentIndex]}.mp3");
                                      });
                                    }


                                    },
                                  child: Icon(
                                    Icons.fast_rewind,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),



                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



