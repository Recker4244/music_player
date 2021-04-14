import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/playlist.dart';
import 'dart:typed_data';
import 'search.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:musicplayer/music_player.dart';
class Tracks extends StatefulWidget {
_TracksState createState()=>_TracksState();

}
class _TracksState extends State<Tracks> {
  final FlutterAudioQuery audioQuery=FlutterAudioQuery();
  final GlobalKey<MusicPlayerState> key=GlobalKey<MusicPlayerState>();
  
  List<SongInfo> songs=[];
  int currentIndex=0;
  
  void initState()  {
    super.initState();
    getTracks();
  }

  void getTracks() async  {
    songs=await audioQuery.getSongs();
    setState(() {
      songs=songs;
    });
  } 
  void changeTrack(bool isNext) {
    if(isNext)  {
      if(currentIndex!=songs.length-1)  {
        currentIndex++;
      }
    } else  {
      if(currentIndex!=0) {
        currentIndex--;
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }
  Widget build(context) {
    return Scaffold(
      //backgroundColor: Colors.blue,
      appBar: AppBar(backgroundColor: Colors.white,
      brightness: Brightness.light, 
      leading: ImageIcon(AssetImage('assets/icons/launcher.png'),color:Colors.deepPurple,size: 30.0,),//Icon(CupertinoIcons.music_note_2,color: Colors.black),
      title: Text('Music Player', 
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30.0
          )
        ),
      ),
      bottomNavigationBar: 

        BottomNavigationBar(
          selectedItemColor: Colors.deepPurple,
          onTap: (int ind){
            if(ind==1)
             //Navigator.of(context).push(_createRoute());
             Navigator.push(
    context, CupertinoPageRoute(builder: (context) => Search()));
             else
             if(ind==2)
             Navigator.push(
    context, CupertinoPageRoute(builder: (context) => Playlist()));
          },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Playlists',
          ),
          
        ],
        
      ),
      body: ListView.separated(
        separatorBuilder:(context,index)=>Divider(),
        itemCount: songs.length,
        itemBuilder: (context,index)=>ListTile(title: Text(songs[index].title,style: TextStyle(fontSize: 18.0),),
        subtitle: Text(songs[index].artist),
        onTap: (){currentIndex=index;
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MusicPlayer(changeTrack: changeTrack,songInfo: songs[currentIndex],key: key)));
        },
      leading: (songs[index].albumArtwork == null)
                  ? FutureBuilder<Uint8List>(
                      future: audioQuery.getArtwork(
                          type: ResourceType.SONG,
                          id: songs[index].id,
                          size: Size(100, 100)),
                      builder: (_, snapshot) {
                        if (snapshot.data == null)
                          return CircleAvatar(
                            child: CircularProgressIndicator(),
                          );

                        if (snapshot.data.isEmpty)
                          return CircleAvatar(
                            backgroundImage: AssetImage('assets/images/music_gradient.jpg'),
                          );

                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: MemoryImage(
                            snapshot.data,
                          ),
                        );
                     }):null,
      )
    )
    );

      
  
  }
  Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Search(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
}