import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favorite_app/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase {

    Map<String, Video> _favorites = {};

    final _favoriteController = BehaviorSubject<Map<String, Video>>(seedValue: {});
    Stream<Map<String, Video>> get outFavorites => this._favoriteController.stream;
    
    FavoriteBloc() {
        SharedPreferences.getInstance().then((prefs) {
            prefs.clear();
            if (prefs.getKeys().contains('favorites')) {
                this._favorites = json.decode(prefs.getString('favorites')).map((k, v) {
                    return MapEntry(k, Video.fromJson(v));
                }).cast<String, Video>();
                this._favoriteController.add(this._favorites);
            }
        });
    }

    void toggleFavorite(Video video) {
        if (this._favorites.containsKey(video.id)) this._favorites.remove(video.id);
        else this._favorites[video.id] = video;

        this._favoriteController.sink.add(this._favorites);
        this._save();
    }
    
    void _save() {
        SharedPreferences.getInstance().then((prefs) {
            prefs.setString('favorites', json.encode(this._favorites));
        });
    }

    @override
    void dispose() {
        this._favoriteController.close();
    }

}