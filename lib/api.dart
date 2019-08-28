import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_favoritos/models/video.dart';

const API_KEY = "AIzaSyDgdwFn6BaUNfHpE5cZIPqogyG6tI9g4J4";

class Api {

  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async{

    _search = search; //passa o q foi pesquisado para _search

    http.Response response = await http.get(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    );

    return decode(response);
  }

  //trás a proxima pagina com a pesquisa
  Future<List<Video>> nextPage() async{

    //requisição para a proxima pagina passando o token
    http.Response response = await http.get(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&PageToken=$_nextToken"
    );

    return decode(response);

  }

  List<Video> decode(http.Response response){

    if(response.statusCode == 200){

      var decoded = json.decode(response.body); // pegando o json da requisição 

      _nextToken = decoded["nextPageToken"]; // aramazena o token para a proxima pagina

      //pegando os videos que tem no items e retorna em uma lista
      List<Video> videos = decoded["items"].map<Video>(
        (map){
          return Video.fromJson(map);
        }
      ).toList();

    
      return videos;
    }else {
      //caso dê erro
      throw Exception("Failed to load videos");
    }
  }
}