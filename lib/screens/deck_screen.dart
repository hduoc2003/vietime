import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/custom_widgets/long_button.dart';
import 'package:vietime/custom_widgets/love_button.dart';
import 'package:vietime/screens/study_screen.dart';

import '../custom_widgets/animated_progress_bar.dart';
import '../custom_widgets/deck_popup_menu.dart';
import '../custom_widgets/error_dialog.dart';
import '../custom_widgets/snackbar.dart';
import '../entity/deck.dart';
import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../helpers/validate.dart';
import '../services/api_handler.dart';
import '../services/mock_data.dart';

class DeckScreen extends StatefulWidget {
  final DeckWithCards deckData;

  DeckScreen({required this.deckData});

  @override
  _DeckScreenState createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  @override
  Widget build(BuildContext context) {
    String descriptionImgPath = widget.deckData.deck.descriptionImgURL;
    double maxWidth = MediaQuery.of(context).size.width * 0.75;
    double maxHeight = MediaQuery.of(context).size.height * 0.29;
    return Scaffold(
        appBar: AppBar(
          title: Text("Thông tin bộ thẻ"),
          centerTitle: true,
        ),
        body: ValueListenableBuilder(
            valueListenable: widget.deckData.deck.isPublic
                ? GetIt.I<APIHanlder>().publicDecksChanged
                : GetIt.I<APIHanlder>().userDecksChanged,
            builder: (
              BuildContext context,
              bool hidden,
              Widget? child,
            ) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Big image
                  Center(
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        height: maxHeight, // Set your maximum height
                        width: maxWidth, // Set your maximum width
                        child: validateURL(descriptionImgPath)
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                errorWidget: (context, _, __) => const Image(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('assets/deck_placeholder.png'),
                                ),
                                imageUrl: descriptionImgPath,
                                placeholder: (context, url) => const Image(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('assets/deck_placeholder.png'),
                                ),
                              )
                            : const Image(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage('assets/deck_placeholder.png'),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 16, bottom: 4),
                    child: Text(
                      widget.deckData.deck.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Iconify(
                            Mdi.cards_playing,
                            color: Colors.purple,
                            size: 30,
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        LoveDeckButton(
                          deckItem: widget.deckData,
                          size: 30,
                        ),
                        if (!widget.deckData.deck.isPublic)
                          SizedBox(
                            width: 5,
                          ),
                        if (!widget.deckData.deck.isPublic)
                          DeckPopupMenu(
                            deckItem: widget.deckData,
                            icon: const Iconify(
                              Ri.settings_4_fill,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildScheduleTitleRow(),
                          _buildCardTypesRow(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24.0, right: 16, top: 6, bottom: 4),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.only(right: 16),
                              childrenPadding: EdgeInsets.zero,
                              title: const Text(
                                'Thông tin chi tiết',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'Mô tả:  ${widget.deckData.deck.description}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Ngày tạo: 22/11/2023'),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text('Vị trí: Hà Nội'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildNumberOfCardsRow(),
                          if (!widget.deckData.deck.isPublic)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, right: 16, bottom: 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Tiến triển:  ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  (widget.deckData.deck.totalCards == 0)
                                      ? const Text(
                                          'Chưa có thẻ nào',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : const SizedBox(),
                                  (widget.deckData.deck.totalCards > 0)
                                      ? AnimatedProgressBar(
                                          width: 200,
                                          height: 14,
                                          progress: widget.deckData.deck
                                                  .totalLearnedCards /
                                              widget.deckData.deck.totalCards,
                                          backgroundColor:
                                              const Color(0xffD9D9D9),
                                          progressColor:
                                              const Color(0xff40a5e8),
                                          innerProgressColor:
                                              const Color(0xff6db7f4),
                                        )
                                      : const SizedBox(),
                                  (widget.deckData.deck.totalCards > 0)
                                      ? SizedBox(width: 16.0)
                                      : const SizedBox(),
                                  (widget.deckData.deck.totalCards > 0)
                                      ? Text(
                                          '${(widget.deckData.deck.totalLearnedCards / widget.deckData.deck.totalCards * 100).toStringAsFixed(0)}%',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  widget.deckData.deck.isPublic
                      ? LongButton(
                          text: 'LƯU BỘ THẺ',
                          outerBoxColor: Color(0xff1783d1),
                          innerBoxColor: Color(0xff46a4e8),
                          textColor: Colors.white,
                          onTap: () {
                            showLoaderDialog(context);
                            APIHelper.submitCopyDeckRequest(
                                    widget.deckData.deck.id)
                                .then((copyDeckResponse) {
                              if (copyDeckResponse.containsKey("error")) {
                                Navigator.pop(context);
                                ErrorDialog.show(context);
                              } else {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                GetIt.I<APIHanlder>()
                                    .onCopyDeckSuccess(copyDeckResponse);
                                ShowSnackBar().showSnackBar(
                                  context,
                                  "Đã lưu bộ thẻ vào bộ thẻ cá nhân",
                                );
                              }
                            });
                          },
                        )
                      : ((widget.deckData.numBlueCards +
                                  widget.deckData.numRedCards +
                                  widget.deckData.numGreenCards >
                              0)
                          ? LongButton(
                              text: 'BẮT ĐẦU HỌC',
                              outerBoxColor: Color(0xff1783d1),
                              innerBoxColor: Color(0xff46a4e8),
                              textColor: Colors.white,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StudyScreen(
                                        deckID: widget.deckData.deck.id,
                                        questions: GetIt.I<APIHanlder>()
                                            .idToDeckWithReviewCards[
                                                widget.deckData.deck.id]!
                                            .cards),
                                  ),
                                );
                              },
                            )
                          : LongButton(
                              text: 'ĐÃ HỌC XONG HÔM NAY',
                              outerBoxColor: Color(0xffC7C6C6),
                              innerBoxColor: Color(0xfff0f2f0),
                              textColor: Color(0xffC7C6C6),
                              onTap: () {},
                            )),
                  SizedBox(
                    height: 16,
                  )
                ],
              );
            }));
  }

  Widget _buildInfoColumn(String bigNumber, String smallText, Color color) {
    return Column(
      children: [
        Text(
          bigNumber,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          smallText,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumnPublicDeck(
      String bigNumber, Iconify icon, String smallText, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              bigNumber,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Padding(padding: const EdgeInsets.all(8.0), child: icon)
          ],
        ),
        Text(
          smallText,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCardTypesRow() {
    return widget.deckData.deck.isPublic
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumnPublicDeck(
                    widget.deckData.deck.rating.toStringAsFixed(1),
                    Iconify(
                      Ri.star_smile_fill,
                      color: Colors.orange,
                    ),
                    "Đánh giá",
                    Colors.orange),
                _buildInfoColumnPublicDeck(
                    widget.deckData.deck.views.toString(),
                    Iconify(
                      Ion.ios_eye,
                      color: Colors.green,
                    ),
                    "Lượt xem",
                    Colors.green),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(widget.deckData.numBlueCards.toString(),
                    "Thẻ Mới", Colors.blue),
                _buildInfoColumn(widget.deckData.numRedCards.toString(),
                    "Đã Quên", Colors.red),
                _buildInfoColumn(widget.deckData.numGreenCards.toString(),
                    "Ôn Tập", Colors.green),
              ],
            ),
          );
  }

  Widget _buildScheduleTitleRow() {
    return widget.deckData.deck.isPublic
        ? Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Thông số",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    // Show dialog for more information
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Chất lượng đánh giá"),
                          content: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Các đánh giá về các bộ thẻ được xác thực kỹ "
                                      "càng trước khi được tính vào thông số cuối cùng",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          actionsPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          contentPadding: EdgeInsets.only(
                              left: 24, right: 24, top: 10, bottom: 0),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lịch học hôm nay",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    // Show dialog for more information
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Ba loại thẻ khi học"),
                          content: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Màu ",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: "xanh dương",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w900),
                                ),
                                TextSpan(
                                  text:
                                      " nghĩa là những thẻ mới người dùng chưa học bao giờ. "
                                      "\n\nMàu ",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: "đỏ",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w900),
                                ),
                                TextSpan(
                                  text:
                                      " nghĩa là những thẻ người dùng đã quên cần học lại. "
                                      "\n\nMàu ",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: "xanh lá cây",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w900),
                                ),
                                TextSpan(
                                  text:
                                      " nghĩa là những thẻ người dùng cần ôn tập.",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          actionsPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          contentPadding: EdgeInsets.only(
                              left: 24, right: 24, top: 10, bottom: 0),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Widget _buildNumberOfCardsRow() {
    return widget.deckData.deck.isPublic
        ? Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 16, bottom: 18),
            child: Row(
              children: [
                Text(
                  "Số lượng:   ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.deckData.deck.totalCards.toString(),
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, bottom: 2),
                  child: Iconify(
                    Mdi.cards_playing,
                    color: Colors.purple,
                    size: 20.0,
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 16, bottom: 18),
            child: Row(
              children: [
                Text(
                  "Số lượng:   ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.deckData.deck.totalLearnedCards.toString(),
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "/${widget.deckData.deck.totalCards}",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, bottom: 2),
                  child: Iconify(
                    Mdi.cards_playing,
                    color: Colors.purple,
                    size: 20.0,
                  ),
                ),
                Text(
                  "  (đã học / tổng số)",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
  }
}
