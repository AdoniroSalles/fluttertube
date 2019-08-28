import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//classe para pesquisa/ tela de pesquisa 
class DataSearch extends SearchDelegate<String>{

  @override
  List<Widget> buildActions(BuildContext context) {
    //botao de pesquisa 
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          //limpar pesquisa, deleta o que estava sendo pesquisado 
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //fica no canto esquerdo
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        //sair da tela
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //resulado da pesquisa
    //aqui foi colocado um delayed para poder fechar a janela e voltar para a tela inicial com os resultados
    Future.delayed(Duration.zero).then(
      (_) => close(context, query)
    );
    return Container();
  }

 
  @override
  Widget buildSuggestions(BuildContext context) {
    //sugestões de pesquisa
    if(query.isEmpty)
      return Container();
    else
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return ListView.builder(
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(snapshot.data[index]),
                  leading: Icon(Icons.play_arrow),
                  onTap: (){
                    close(context, snapshot.data[index]);
                  },
                );
              },  
              itemCount: snapshot.data.length,
            );
          }
        },
      );
  }

  Future<List> suggestions(String search) async{

    http.Response response = await http.get(
      "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"
    );

    //se der tudo certo
    if(response.statusCode == 200){

      return json.decode(response.body)[1].map(
        (v){
          return v[0];
        }
      ).toList();

    }else{
      throw Exception("Failed to load suggestions");
    }
  }

}