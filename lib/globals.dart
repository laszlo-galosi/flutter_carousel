library flutter_carousel.globals;

List<int> imageNames = [917971, 965986, 900890, 836945, 941223, 952679];

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}
