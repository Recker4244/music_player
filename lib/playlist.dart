import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'dart:io';
import 'package:musicplayer/music_player.dart';

class Playlist extends StatefulWidget {
  @override
  _playlistState createState() => _playlistState();
 
}

class _playlistState extends State<Playlist> {
  
   final FlutterAudioQuery audioQuery=FlutterAudioQuery();
   List<PlaylistInfo> playlists;
   
   void initState()  {
    super.initState();
    getPlaylist();
  }
  void getPlaylist () async{
    playlists = await audioQuery.getPlaylists();
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Playlists',style: TextStyle(color: Colors.black,fontSize: 28.0),),
        leading: IconButton(icon:Icon(Icons.playlist_add_rounded),onPressed: (){},color: Colors.black,),
      ),
      bottomNavigationBar: 

        BottomNavigationBar(
          selectedItemColor: Colors.deepPurple,
          onTap: (int ind){
            if(ind==1)
             Navigator.of(context).pushNamed('/second');
             else
             if(ind==0)
             Navigator.of(context).pop();
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
        itemCount: playlists==null?0:playlists.length,
        itemBuilder: (context,index)=>ListTile(title: Text(playlists[index].name),
        )
      ),
      
      
    );
      
    
  }
}