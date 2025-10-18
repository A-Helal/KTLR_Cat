extension ImageUrlX on String {
  String toImageUrl() {
    return 'https://cdn2.thecatapi.com/images/$this.jpg';
  }
}
