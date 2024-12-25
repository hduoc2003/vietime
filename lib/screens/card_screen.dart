import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

import '../custom_widgets/card_popup_menu.dart';
import '../entity/card.dart';
import '../helpers/validate.dart';

class CardScreen extends StatelessWidget {
  final Flashcard flashcard;

  CardScreen({required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thẻ #${flashcard.index}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: UserCardPopupMenu(
              card: flashcard,
              icon: const Iconify(
                Ri.more_2_fill,
                color: Colors.grey,
                size: 30,
              ),
              isPopSecond: true,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Câu hỏi:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                flashcard.question,
                style: TextStyle(fontSize: 19),
              ),
              SizedBox(height: 15),
              validateURL(flashcard.questionImgURL)
                  ? Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.91,
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            errorWidget: (context, _, __) => const Image(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/image_loading.jpg'),
                            ),
                            imageUrl: flashcard.questionImgURL,
                            placeholder: (context, url) => const Image(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/image_loading.jpg'),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          flashcard.questionImgLabel,
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 15),
              Text(
                'Câu trả lời đúng:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 19),
                child: Text(
                  '●  ${flashcard.correctAnswer}',
                  style: TextStyle(fontSize: 19),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Câu trả lời sai:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: flashcard.wrongAnswers.map((wrongAnswer) {
                  return Padding(
                    padding: EdgeInsets.only(left: 19),
                    child: Text(
                      '●  $wrongAnswer',
                      style: TextStyle(fontSize: 19),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
