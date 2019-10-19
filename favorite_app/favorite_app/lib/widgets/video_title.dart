import 'package:favorite_app/models/video.dart';
import 'package:flutter/material.dart';

class VideoTitle extends StatelessWidget {

    final Video video;

    VideoTitle(this.video);

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    AspectRatio(
                        aspectRatio: 16.0/9.0,
                        child: Image.network(video.thumb, fit: BoxFit.cover,),
                    ),
                    Row(
                        children: <Widget>[
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                                video.title,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16
                                                ),
                                                maxLines: 2,
                                            ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                                video.channel,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            IconButton(
                                icon: Icon(Icons.star_border),
                                iconSize: 30,
                                color: Colors.white,
                                onPressed: () {
                                },
                            )
                        ],
                    )
                ],
            ),
        );
    }

}