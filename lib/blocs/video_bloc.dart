import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_favoritos/api.dart';
import 'package:youtube_favoritos/models/video.dart';

class VideosBloc extends BlocBase{

  Api api;

  List<Video> videos = [];
  List<Video> newVideos;

  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream; // retorna a saida do Stream, podendo ser acessivel fora do bloc

  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink; // para receber um dado no _searchController 

  VideosBloc(){
    api = Api();

    //  
    _searchController.stream.listen(
      (_search)
    );
  }

  void _search( String search) async {

    if (search != null) {
      _videosController.sink.add([]);
      videos = await api.search(search);
    
    } else {
      videos += await api.nextPage(); // adiciona os proximos videos a lista de videos
    }
    
    _videosController.sink.add(videos); // colocando os videos na lista de videos 
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
    // TODO: implement dispose
  }
}