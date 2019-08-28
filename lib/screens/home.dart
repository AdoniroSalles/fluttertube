import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favoritos/blocs/favorite_bloc.dart';
import 'package:youtube_favoritos/blocs/video_bloc.dart';
import 'package:youtube_favoritos/delegates/data_search.dart';
import 'package:youtube_favoritos/models/video.dart';
import 'package:youtube_favoritos/screens/favorite_screen.dart';
import 'package:youtube_favoritos/widgets/video_tile.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("assets/images/yt_logo_rgb_dark.png")
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
              builder: (context, snapshot){
                if (snapshot.hasData) {
                  return Text(
                    "${snapshot.data.length}"
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavoriteScreen()
                )
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async{
              //pega o valor que vem da pesquisa 
              String result = await showSearch(context: context, delegate: DataSearch()); // para poder abrir a tela de pesquisa 

              //mandar resulado para o blc
              if(result != null)
                BlocProvider.getBloc<VideosBloc>().inSearch.add(result); // adicionando dados no inSearch.
            
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      //refaz a tela toda vez que tiver uma alteração na
      body: StreamBuilder(
        stream: BlocProvider.getBloc<VideosBloc>().outVideos, // pega a lista de videos 
        initialData: [],
        builder: (context, snapshot){
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index){
                if(index < snapshot.data.length){
                  return VideoTile(snapshot.data[index]);
                }else if (index > 1 ){
                  BlocProvider.getBloc<VideosBloc>().inSearch.add(null); // para nao pesquisar nada 
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }else {
                  return Container();
                }
              },
              itemCount: snapshot.data.length + 1,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}