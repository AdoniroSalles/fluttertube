class Video {
  final String id;
  final String title;
  final String thumb;
  final String channel;

  Video({this.id, this.title, this.thumb, this.channel});

  //pega o json da requisição do youtube e retorna os dados do json
  factory Video.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("id")) {
      return Video(
        id: json["id"]["videoId"],
        title: json["snippet"]["title"],
        thumb: json["snippet"]["thumbnails"]["high"]["url"],
        channel: json["snippet"]["channelTitle"]
      );
    }else{
      return Video(
        id: json["videoId"],
        title: json["title"],
        thumb: json["thumb"],
        channel: json["channel"]
      );
    }
  }

  //passando a lista para json
  Map<String, dynamic> toJson() {
    return {"videoId": id, "title": title, "thumb": thumb, "channel": channel};
  }
}
