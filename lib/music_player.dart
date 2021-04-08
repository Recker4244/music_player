import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicplayer/tracks.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;
  final GlobalKey<MusicPlayerState> key;
  Function changeTrack;
  MusicPlayer({this.songInfo,this.changeTrack,this.key}):super(key: key);
  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  double min_value=0.0,max_value=0.0,current=0.0;
  String curr='',end='';
  bool isPlaying=false;
  final AudioPlayer player=AudioPlayer();
  void initState()
  {
    super.initState();
    setSong(widget.songInfo);
  }
  void dispose()
  {
    super.dispose();
    player?.dispose();
  }
  void setSong(SongInfo songInfo) async
  {
    widget.songInfo=songInfo;
    await player.setUrl(songInfo.uri);
    current=min_value;
     max_value=player.duration.inMilliseconds.toDouble();
     setState(() {
            curr=getDuration(current);
            end=getDuration(max_value-current);
            
          });
          isPlaying=false;
          changestatus();
          player.positionStream.listen((duration){
            current=duration.inMilliseconds.toDouble();
            if(current>=max_value)   {
   widget.changeTrack(true);
}
            setState(() {
                          curr=getDuration(current);
                          end=getDuration(max_value-current);
                        });
          });
  }
  void changestatus()
{
  setState(() {
      isPlaying=!isPlaying;
    });
    if(isPlaying)
    {
      player.play();

    }
    else
    player.pause();
}
  String getDuration(double value)
  {
    Duration duration=Duration(milliseconds:value.round());
    return [duration.inMinutes, duration.inSeconds].map((element)=>element.remainder(60).toString().padLeft(2, '0')).join(':');
  }
  
  @override
  Widget build(BuildContext context) {
     FlutterAudioQuery audioQuery = FlutterAudioQuery();
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        
        elevation: 0.0,
        backgroundColor: Colors.white,
        
        leading: IconButton(onPressed:(){
          Navigator.of(context).pop();
          //Navigator.of(context).pushNamed('/');
        }, 
        icon:Icon(
          Icons.arrow_back_ios_rounded,color:Colors.black,
        size: 20.0,
        ),
        
        ),
        title: Text('Now Playing',style: TextStyle(color: Colors.black,fontSize: 24.0,fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
        //SizedBox(height: 10.0,),
        Expanded(
          child: Container(
            
            decoration: BoxDecoration(
              
              color: Colors.white,
              
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            
            child: Column(

              
              children:[
                SizedBox(height: 5.0,),
                Container(
                  
                  //width: double.infinity,
                  child: (widget.songInfo.albumArtwork==null)? FutureBuilder<Uint8List>
                  (
                      future: audioQuery.getArtwork(
                          type: ResourceType.SONG,
                          id: widget.songInfo.id,
                          size: Size(600, 600)),
                      builder: (_, snapshot) {
                        
                        if (snapshot.data == null)
                          return CircleAvatar(
                            child: CircularProgressIndicator(),
                          );
                    
                        // if (snapshot.data.isEmpty)
                        //   return CircleAvatar(
                        //     backgroundImage: AssetImage('assets/images/music_gradient.jpg'),
                        //   );

                        if(snapshot.data.isEmpty)
                        return Container(
                           width: 320,
                           margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                           height: 300,
                           child:ClipRRect(
                             
                           borderRadius: BorderRadius.circular(20),
                           child: Image(image:AssetImage('assets/images/music_gradient.jpg')),
                           )
                           );
                        
                         return Material(
                           elevation: 15.0,
                           borderRadius: BorderRadius.circular(20),
                           child: ClipRRect(
                               
                             borderRadius: BorderRadius.circular(20),
                             
                             child:Container(
                             
                             decoration: BoxDecoration(
                               shape: BoxShape.rectangle,
                               //color: Colors.red,
                               borderRadius: BorderRadius.all(Radius.circular(20)),),
                               child:Image.memory(snapshot.data,gaplessPlayback: true,fit: BoxFit.fill,),
                             margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                             height: MediaQuery.of(context).size.height*0.45,
                             //width: MediaQuery.of(context).size.width*0.75,
                             
                             ),
                           )
                         );
              }):null,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.03,),
               Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 10, 0),
                  child:Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    //textDirection: TextDirection.ltr,
                    children: [
                      Text(widget.songInfo.title,style:TextStyle(fontSize: 23.0,fontWeight: FontWeight.w800,fontFamily: 'SFPro'),textAlign: TextAlign.left,)
                      ],
                      )
                  
                ),
                 SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                 Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 10, 0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(children: [
                        Text(widget.songInfo.artist,style:TextStyle(fontSize: 20.0,fontWeight: FontWeight.w400,color: Colors.grey),textAlign: TextAlign.left,)
                      ],)
                      
                      ],
                      )
                  
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.014,),
                
                SliderTheme(
    data: SliderThemeData(
            thumbColor: Colors.deepPurple,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7)),
            
    child: Slider(value: current,
                
                inactiveColor: Colors.black12,
                activeColor: Colors.deepPurple,
                 min: min_value,
                max: max_value,
                 onChanged: (value){
                   
                  current=value;
                  player.seek(Duration(milliseconds: current.round()));

                  } ,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                    Text(curr,style:TextStyle(fontSize: 12.0,color: Colors.grey )),
                    Text("-"+end,style:TextStyle(fontSize: 12.0,color: Colors.grey )),
                    ]
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.03,),

                Container(
                  transform: Matrix4.translationValues(0,-7,0),
                  margin: EdgeInsets.fromLTRB(20,0,20,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
                      
                      GestureDetector(child: Icon(CupertinoIcons.backward_fill,//Icon(Icons.skip_previous_rounded,
                      color: Colors.black,size: 35,)
                      ,behavior: HitTestBehavior.translucent,
                      onTap:(){
                        widget.changeTrack(false); 
                      } ,),
                      GestureDetector(child: Icon(isPlaying?CupertinoIcons.pause_solid:CupertinoIcons.play_fill,
                      color: Colors.black,size: 60,),
                      behavior: HitTestBehavior.translucent,
                      onTap:(){
                        changestatus();
                      } ,),
                      GestureDetector(child: Icon(CupertinoIcons.forward_fill,
                      color: Colors.black,size: 35,),
                      behavior: HitTestBehavior.translucent,
                      onTap:(){
                      widget.changeTrack(true);                    
                      } ,),
                      
                      
                    ],
                    
                  ),
                 
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder<LoopMode>(
                    stream: player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.grey),
                        Icon(Icons.repeat, color: Colors.deepPurple),
                        Icon(Icons.repeat_one, color: Colors.deepPurple),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          player.setLoopMode(cycleModes[
                              (cycleModes.indexOf(loopMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
  
                       StreamBuilder<bool>(
                    stream: player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? Icon(CupertinoIcons.shuffle, color: Colors.deepPurple)
                            : Icon(CupertinoIcons.shuffle, color: Colors.grey),
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          if (enable) {
                            await player.shuffle();
                          }
                          await player.setShuffleModeEnabled(enable);
                        },
                      );
                    },
                  ),
                  ],
              ),
                ),
                ]
            ),
          ),
        ),
        ]
      )
      );
  }
}