import 'dart:convert';
import 'dart:convert';
import 'package:favorite_app/models/video.dart';
import 'package:http/http.dart' as Http;

const API_KEY = 'AIzaSyCLTe7ACu_oQlpMGIxfdhegr8TUG91WpDU';
//https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&order=viewCount&q=flutter&type=video&key=AIzaSyCLTe7ACu_oQlpMGIxfdhegr8TUG91WpDU

class Api {

    String _search;
    String _nextToken;

    String _qtd = '10';

    Future<List<Video>> search(String search) async {
        this._search = search;
        Http.Response response =  await Http.get(
            'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=$_qtd&order=viewCount&q=$search&type=video&key=$API_KEY'
        );
        return decode(response);
    }

    Future<List<Video>> nextPage() async {
        Http.Response response =  await Http.get(
                'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=$_qtd&order=viewCount&q=$_search&type=video&key=$API_KEY&pageToken=$_nextToken'
        );
        return decode(response);
    }

    List<Video> decode(Http.Response response) {

        if (response.statusCode == 200) {
            var decoded = json.decode(response.body);
            this._nextToken = decoded['nextPageToken'];
            List<Video> videos = decoded['items'].map<Video>(
                (map) { return  Video.fromJson(map); }
            ).toList();

            return videos;
        } else {
            throw Exception('Failed to load videos');
        }
    }

    Future<List> suggestions(String search) async {
        Http.Response response = await Http.get('http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json');
        if (response.statusCode == 200) {
            return json.decode(response.body)[1].map((v) { return v[0]; }).toList();
        } else {
            throw Exception('Faled to load suggestions');
        }
    }
}