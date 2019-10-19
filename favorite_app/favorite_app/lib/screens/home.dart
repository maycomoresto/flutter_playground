import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favorite_app/blocs/favorite_bloc.dart';
import 'package:favorite_app/blocs/videos_bloc.dart';
import 'package:favorite_app/delegates/data_search.dart';
import 'package:favorite_app/models/video.dart';
import 'package:favorite_app/widgets/video_title.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

    @override
    Widget build(BuildContext context) {

        final bloc = BlocProvider.of<VideosBloc>(context);
        final blocFavorite = BlocProvider.of<FavoriteBloc>(context);

        return Scaffold(
            appBar: AppBar(
                title: Container(
                    height: 25,
                    child: Image.asset('images/yt_logo_rgb_dark.png'),
                ),
                elevation: 0,
                backgroundColor: Colors.black87,
                actions: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: StreamBuilder<Map<String, Video>>(
                            stream: blocFavorite.outFavorites,
                            initialData: {},
                            builder: (context, snapshot) {
                                if (snapshot.hasData) return Text('${snapshot.data.length}');
                                else Text('0');
                            },
                        ),
                    ),
                    IconButton(
                        icon: Icon(Icons.star),
                        onPressed: () {},
                    ),
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                            String result = await showSearch(context: context, delegate: DataSearch());
                            if (result != null) {
                                BlocProvider.of<VideosBloc>(context).searchIn.add(result);
                            }
                        },
                    )
                ],
            ),
            backgroundColor: Colors.black87,
            body: StreamBuilder(
                stream: bloc.outVideos,
                initialData: [],
                builder: (context, snapshot) {
                    if (snapshot.hasData) {
                        return ListView.builder(
                            itemBuilder: (context, index) {
                                if (index < snapshot.data.length) {
                                    return VideoTitle(snapshot.data[index]);
                                } else if (index > 1){
                                    bloc.searchIn.add(null);
                                    return Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),

                                        ),
                                    );
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

