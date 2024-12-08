enum ResultType {
  userDeckResult,
  publicDeckResult,
  cardResult,
}

class SearchResult {
  final ResultType type;
  final dynamic data;

  SearchResult(this.type, this.data);
}