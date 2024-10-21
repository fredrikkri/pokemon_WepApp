//   "categories": [],
//   "created_at": "2020-01-05 13:42:24.40636",
//   "icon_url": "https://api.chucknorris.io/img/avatar/chuck-norris.png",
//   "id": "LAE8HOeKRUGLHyBwrOvJEA",
//   "updated_at": "2020-01-05 13:42:24.40636",
//   "url": "https://api.chucknorris.io/jokes/LAE8HOeKRUGLHyBwrOvJEA",
//   "value": "IF Chuck Norris EVENTUALLY dies, he will get ALL the virgins in the world."

class JokeData {
  final List categories;
  final String createdAt;
  final String iconUrl;
  final int id;
  final String updatedAt;
  final String url;
  final String value;

  const JokeData({
    required this.categories,
    required this.createdAt,
    required this.iconUrl,
    required this.id,
    required this.updatedAt,
    required this.url,
    required this.value,
  });

  factory JokeData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'categories': List categories,
        'createdAt': String createdAt,
        'iconUrl': String iconUrl,
        'id': int id,
        'updatedAt': String updatedAt,
        'url': String url,
        'value': String value,
      } =>
        JokeData(
          categories: categories,
          createdAt: createdAt,
          iconUrl: iconUrl,
          id: id,
          updatedAt: updatedAt,
          url: url,
          value: value,
        ),
      _ => throw const FormatException('Failed to load pokemon.'),
    };
  }
}
