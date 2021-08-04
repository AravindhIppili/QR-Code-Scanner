class ScannedData {
  String text, time;
  ScannedData({required this.text, required this.time});
  @override
  String toString() {
    return text + time;
  }
}

List<ScannedData> scannedData = [];
