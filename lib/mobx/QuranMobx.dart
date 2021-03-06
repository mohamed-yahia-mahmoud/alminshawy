import 'dart:collection';
import 'dart:convert';
import 'dart:io';



import 'package:alminshawy/network/model/MySura.dart';
import 'package:alminshawy/network/request/QuranReq.dart';
import 'package:alminshawy/network/response/QuranResponse.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
 import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:mobx/mobx.dart';

part 'QuranMobx.g.dart';

class QuranController = QuranMobx with _$QuranController;

abstract class QuranMobx with Store {
   final url =  "https://server11.mp3quran.net/minsh_mjwd/";
  final client = http.Client();
  final encoder = JsonEncoder.withIndent("  ");

  //------------------------------------------------- Guarantor survey --------------------------------------------------------------

  ObservableList<MySura> suras = ObservableList<MySura>();


  QuranResponse quranResponse;

  @observable
  var myIcon=Icon(Icons.play_arrow,color: Colors.white,size: 35,);

  @observable
  String d1;


  @observable
  AudioCache audioCache;
  @observable
  AudioPlayer audioPlayer;


  @observable
  Duration my_duration = new Duration();

  ZoomDrawerController drawerController=new ZoomDrawerController();


  @observable
  Duration my_position = new Duration();
  @observable
  Duration my_slider = new Duration(seconds: 0);
  @observable
  bool isSuraPlaying = false;
  @observable
  bool isSuraLooping = false;
  @observable
  bool seekDone;

  @observable
  int currentIndex;

  @observable
  List surasId=new List();

  @action
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

     audioPlayer.seek(newDuration);
  }




  @action
  void myInit(){
     my_position = my_slider;
     audioPlayer = new AudioPlayer();
     audioCache = new AudioCache(fixedPlayer: audioPlayer);
     audioPlayer.durationHandler = (d) => my_duration = d;

     audioPlayer.positionHandler = (p) => my_position = p ;

     audioPlayer.seekCompleteHandler = (finished) =>(){
       seekDone = finished;
       myIcon=Icon(Icons.play_arrow,color: Colors.white,size: 35,);};




}

  @observable
  List<String> suarsNames = <String>[" ???????? ??????????????"," ???????? ????????????"," ???????? ???? ??????????"," ???????? ????????????"," ???????? ??????????????"," ???????? ??????????????",
    " ???????? ??????????????"," ???????? ??????????????"," ???????? ????????????"," ???????? ????????"," ???????? ??????"," ???????? ????????"," ???????? ??????????"," ???????? ??????????????",
    " ???????? ??????????"," ???????? ??????????"," ???????? ??????????????"," ???????? ??????????"," ???????? ????????"," ???????? ????"," ???????? ????????????????"," ???????? ????????",
    " ???????? ????????????????"," ???????? ??????????"," ???????? ??????????????"," ???????? ??????????????"," ???????? ??????????"," ???????? ??????????"," ???????? ????????????????"," ???????? ??????????",
    " ???????? ??????????"," ???????? ????????????"," ???????? ??????????????"," ???????? ??????"," ???????? ????????"," ???????? ????"," ???????? ??????????????"," ???????? ???????? ??",
    " ???????? ??????????"," ???????? ????????"," ???????? ????????"," ???????? ????????????"," ???????? ????????????"," ???????? ????????????"," ???????? ??????????????"," ???????? ??????????????",
    " ???????? ????????"," ???????? ??????????"," ???????? ??????????????"," ???????? ??"," ???????? ????????????????"," ???????? ??????????"," ???????? ??????????"," ???????? ??????????",
    " ???????? ????????????"," ???????? ??????????????"," ???????? ????????????"," ???????? ????????????????"," ???????? ??????????"," ???????? ????????????????"," ???????? ????????"," ???????? ????????????",
    " ???????? ??????????????????"," ???????? ??????????????"," ???????? ????????????"," ???????? ??????????????"," ???????? ??????????"," ???????? ??????????"," ???????? ????????????"," ???????? ??????????????",
    " ???????? ??????"," ???????? ????????"," ???????? ????????????"," ???????? ????????????"," ???????? ??????????????"," ???????? ??????????????"," ???????? ????????????????"," ???????? ??????????",
    " ???????? ????????????????"," ???????? ??????"," ???????? ??????????????"," ???????? ????????????????"," ???????? ????????????????"," ???????? ????????????????","???????? ????????????"," ???????? ????????????",
    " ???????? ????????????"," ???????? ??????????????"," ???????? ??????????"," ???????? ??????????"," ???????? ??????????"," ???????? ??????????"," ???????? ??????????"," ???????? ??????????",
    " ???????? ??????????"," ???????? ??????????"," ???????? ??????????"," ???????? ????????????"," ???????? ??????????????"," ???????? ????????????????"," ???????? ??????????????"," ???????? ??????????????",
    " ???????? ??????????"," ???????? ????????????"," ???????? ??????????"," ???????? ????????"," ???????? ??????????????"," ???????? ????????????"," ???????? ????????????????"," ???????? ??????????",
    " ???????? ??????????"," ???????? ??????????????"," ???????? ??????????"," ???????? ??????????"];





  @action
  List getMySuraId(){
    for(int i=0;i<114;i++){
      if(i<9){
        surasId.add("00${i+1}");
      }else if(i<99){
        surasId.add("0${i+1}");
      }else{surasId.add("${i+1}");}
    }
    return surasId;
  }



  String format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @action
  String getCurrentPositionTime(Duration d){
    return format(d);
  }


  @action
  Future<QuranResponse> getQuranMethod(
      {QuranReq request,BuildContext context ,void doAfterSuccess()}) {

    final body = encoder.convert(request);
    debugPrintSynchronously("POST " + url + "\n" + body);
    return client.post(
      url,
      body: json.encode(request),
      headers: {

        'Content-Type': 'application/x-www-form-urlencoded',
//        'Content-Type': 'application/json',
        'Accept-Type': 'application/json',
      },
    ).then((http.Response response) {
      final data = json.decode(response.body);
       quranResponse = QuranResponse.fromJson(data);
      final int statusCode = data["status"];
      if (statusCode == 200 || statusCode == 204 || statusCode == 412) {
        suras.clear();
        suras.addAll(quranResponse.data);
        if (doAfterSuccess != null) doAfterSuccess();
      }
      if (context != null) Navigator.pop(context);
      debugPrintSynchronously(encoder.convert(data));
      return quranResponse;
    });
  }




}
