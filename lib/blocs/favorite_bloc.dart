import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_favoritos/models/video.dart';

class FavoriteBloc extends BlocBase{

  //mapa com os videos favoritos 
  Map<String, Video> _favorites = {}; 

  // final StreamController _favController = StreamController<Map<String, Video>>.broadcast();
  final _favController = BehaviorSubject<Map<String, Video>>.seeded({}); //monitora o ultimo dado 

  Stream<Map<String, Video>> get outFav => _favController.stream; // pegar os dados de saida

  FavoriteBloc(){

    //para poder armazenar algum dado
    SharedPreferences.getInstance().then((prefs){
      if(prefs.getKeys().contains("favorites")){
        //decode json da lista de favoritos armazenada 
        _favorites = json.decode(prefs.getString("favorites")).map(
          //mapear um json
          (key, value){
            return MapEntry(key, Video.fromJson(value));
          }
        ).cast<String, Video>();
        _favController.add(_favorites);
      }
    });

  }
  void toggleFavorite(Video video){
    if(_favorites.containsKey(video.id))
      _favorites.remove(video.id);
    else 
      _favorites[video.id] = video;

    _favController.sink.add(_favorites);

    //salva favoritos 
    _saveFav();
  }

  void _saveFav(){

    //transformar em json
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("favorites", json.encode(_favorites));
    });
  }
  @override
  void dispose() {
  
    _favController.close();
    
  }
}