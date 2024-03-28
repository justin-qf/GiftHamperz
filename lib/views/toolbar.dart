import 'package:flutter/material.dart';
import 'package:gifthamperz/configs/assets_constant.dart';

class ToolbarScreen extends StatefulWidget {
  const ToolbarScreen({super.key});

  @override
  State<ToolbarScreen> createState() => _ToolbarScreenState();
}

class _ToolbarScreenState extends State<ToolbarScreen> {
  ScrollController? _scrollController;
  double imageSize = 0;
  double initSize = 236;
  double containerHeight = 465;
  double containerInitialHeight = 465;
  double imageOpacity = 1;
  bool showTopBar = false;
  final bool _isInPlay = false;
  @override
  void initState() {
    imageSize = initSize;

    _scrollController = ScrollController()
      ..addListener(() {
        imageSize = initSize - _scrollController!.offset;
        if (imageSize < 0) {
          imageSize = 0;
        }
        containerHeight = containerInitialHeight - _scrollController!.offset;
        if (containerHeight < 0) {
          containerHeight = 0;
        }
        imageOpacity = imageSize / initSize;
        if (_scrollController!.offset > 224) {
          showTopBar = true;
        } else {
          showTopBar = false;
        }
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.red,
                    height: containerHeight,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Opacity(
                            opacity: imageOpacity.clamp(0, 1.0),
                            child: Container(
                              height: imageSize,
                              width: imageSize,
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent,
                                    offset: Offset(0, 10),
                                    spreadRadius: -10,
                                    blurRadius: 15,
                                  ),
                                  BoxShadow(
                                    color: Colors.indigo,
                                    offset: Offset(0, -10),
                                    spreadRadius: -10,
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                Asset.itemOne,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0),
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(1),
                              ],
                            ),
                            border: Border.all(
                              width: 0,
                              color: Colors.amber,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: initSize + 45,
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 25),
                                    child: Text(
                                      'TEsttttttttt',
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // height: 1000,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              width: 0,
                              color: Colors.black,
                            ),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text("Title-1")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 90,
                      color: showTopBar ? Colors.red : Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                Positioned(
                                  left: 15,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 60),
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: showTopBar ? 1 : 0,
                                    child: const Text(
                                      "Ninjaaa",
                                      style: TextStyle(
                                        fontFamily: "AM",
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 25,
                                    bottom: 85 -
                                        containerHeight.clamp(
                                            125.0, double.infinity),
                                    child: (!_isInPlay)
                                        ? const Icon(
                                            Icons.play_arrow,
                                            size: 56,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.play_arrow,
                                            size: 10,
                                            color: Colors.green,
                                          )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
             
            ],
          ),
        ));
  }
}
