import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPhotos extends StatefulWidget {
  final String heroTitle;
  final imageIndex;
  final List<dynamic> imageList;
  final Color textColor;
  ViewPhotos(
      {this.imageIndex,
      this.imageList,
      this.heroTitle = "img",
      this.textColor = Colors.grey});

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  PageController pageController;
  int currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              pageController: pageController,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.imageList[index]),
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: "photo${widget.imageIndex}"),
                );
              },
              onPageChanged: onPageChanged,
              itemCount: widget.imageList.length,
              loadingBuilder: (context, progress) => Center(
                child: Container(
                  child: (progress == null ||
                          progress.cumulativeBytesLoaded == null ||
                          progress.expectedTotalBytes == null)
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(widget.textColor),
                        )
                      : CircularProgressIndicator(
                          value: progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(widget.textColor),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.black,
        height: 30,
        alignment: Alignment.topRight,
        width: MediaQuery.of(context).size.width,
        child: Text(
          "${currentIndex + 1} / ${widget.imageList.length}",
          style: TextStyle(
              color: widget.textColor,
              fontSize: 12,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
