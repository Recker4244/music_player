import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'dart:io';
import 'package:musicplayer/music_player.dart';
import 'package:musicplayer/tracks.dart';
import 'package:musicplayer/playlist.dart';
class Search extends StatefulWidget {
_SearchState createState()=>_SearchState();

}
class _SearchState extends State<Search> {
  final FlutterAudioQuery audioQuery=FlutterAudioQuery();
  final GlobalKey<MusicPlayerState> key=GlobalKey<MusicPlayerState>();
  
  List<SongInfo> songs=[];
  int currentIndex=0;
  
  void initState()  {
    super.initState();
    //getTracks();
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
      appBar: AppBar(
        //titleSpacing: 3.0,
        
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.search,color: Colors.black,size: 30.0,),
        ),
        leadingWidth: 30.0,
        
       title:CupertinoTextField( 
         
      //TextField(
              
          // decoration: InputDecoration(
          //   hintText: "Search for songs"
          // ),
          onSubmitted: (String val) async{
            songs=await audioQuery.searchSongs(query: "$val");
            setState(() {
                          songs=songs;
                        });
          },
          ),
      
       ),
      
      bottomNavigationBar: 

        BottomNavigationBar(
          
          selectedItemColor: Colors.deepPurple,
          onTap: (int ind){
            if(ind==0)
             Navigator.of(context).pop();
             else
             if(ind==2)
            Navigator.push(
    context, CupertinoPageRoute(builder: (context) => Playlist()));
             setState(() {
                            currentIndex=ind;
                          });
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
        itemBuilder: (context,index)=>ListTile(title: Text(songs[index].title),
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
}