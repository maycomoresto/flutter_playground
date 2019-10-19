import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favorite_app/api.dart';
import 'package:favorite_app/models/video.dart';

class VideosBloc implements BlocBase {

    Api api;
    List<Video> videos;
    final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
    Stream get outVideos => this._videosController.stream;
    final StreamController<String> _searchController = StreamController<String>();
    Sink get searchIn => this._searchController.sink;

    VideosBloc() {
        this.api = Api();
        this._searchController.stream.listen(_search);
    }

    Future<void> _search(String search) async {
        if (search != null) {
            this._videosController.sink.add([]);
            this.videos = await this.api.search(search);
        } else {
            this.videos += await this.api.nextPage();
        }
        this._videosController.sink.add(this.videos);
    }
    @override
    void dispose() {
        this._videosController.close();
        this._searchController.close();
    }

}