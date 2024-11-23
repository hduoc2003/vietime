class Category {
  String title;
  int totalCard;
  int studiedCard;
  String imgPath;
  double rating;

  Category({
    this.title = '',
    this.totalCard = 1,
    this.studiedCard = 0,
    this.imgPath = '',
    this.rating = 0,
  });

  static List<Category> studyingList = <Category>[
    Category(
      title: 'Concept 1',
      totalCard: 30,
      studiedCard: 15,
      imgPath: 'assets/home/lessons/lesson1.png',
      rating: 4.0,
    ),
    Category(
      title: 'Concept 2',
      totalCard: 45,
      studiedCard: 15,
      imgPath: 'assets/home/lessons/lesson2.png',
      rating: 4.3,
    ),
    Category(
      title: 'Concept 3',
      totalCard: 20,
      studiedCard: 5,
      imgPath: 'assets/home/lessons/lesson3.png',
      rating: 4.8,
    ),
    Category(
      title: 'Concept 4',
      totalCard: 30,
      studiedCard: 30,
      imgPath: 'assets/home/lessons/lesson4.png',
      rating: 4.5,
    ),
    Category(
      title: 'Concept 5',
      totalCard: 42,
      studiedCard: 42,
      imgPath: 'assets/home/lessons/lesson5.png',
      rating: 4.1,
    ),
  ];

  static List<Category> popularList = <Category>[
    Category(
        title: 'Concept 1',
        totalCard: 30,
        studiedCard: 15,
        imgPath: 'assets/home/lessons/lesson1.png',
        rating: 4.0,
    ),
    Category(
        title: 'Concept 2',
        totalCard: 45,
        studiedCard: 15,
        imgPath: 'assets/home/lessons/lesson2.png',
        rating: 4.3,
    ),
    Category(
        title: 'Concept 3',
        totalCard: 20,
        studiedCard: 5,
        imgPath: 'assets/home/lessons/lesson3.png',
        rating: 4.8,
    ),
    Category(
        title: 'Concept 4',
        totalCard: 30,
        studiedCard: 30,
        imgPath: 'assets/home/lessons/lesson4.png',
        rating: 4.5,
    ),
    Category(
        title: 'Concept 5',
        totalCard: 42,
        studiedCard: 42,
        imgPath: 'assets/home/lessons/lesson5.png',
        rating: 4.1,
    ),
  ];
}