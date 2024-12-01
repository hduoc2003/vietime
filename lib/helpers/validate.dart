bool validateURL(String? input) {
  if (input != null && input != "") {
    return Uri.parse(input).host.isNotEmpty;
  } else {
    return false;
  }
}