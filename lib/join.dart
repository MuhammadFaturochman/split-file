import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

void main(List<String> arguments) {
  var sampleFilePartsDirPath = p.join(Directory.current.path, 'parts');
  var sampleFilePartsDir = Directory(sampleFilePartsDirPath);
  List<FileSystemEntity> sampleFileParts = sampleFilePartsDir.listSync(recursive: false).toList();

  var sampleFilePartsPath = sampleFileParts.map((entity) => entity.path).toList();
  sampleFilePartsPath.sort(((a, b) {
    var positionA = int.parse(a.split('.').elementAt(2).replaceAll('part', ''));
    var positionB = int.parse(b.split('.').elementAt(2).replaceAll('part', ''));

    return positionA.compareTo(positionB);
  }));

  var resultFilePath = p.join(Directory.current.path, 'file-result.jpg');
  File resultFile = File(resultFilePath);
  List<int> binaryList = [];

  for (var filePath in sampleFilePartsPath) {
    File sampleFilePart = File(filePath);
    Uint8List uint8list = sampleFilePart.readAsBytesSync();

    binaryList.addAll(uint8list);
  }

  Uint8List uint8listAll = Uint8List.fromList(binaryList);

  resultFile.writeAsBytesSync(uint8listAll);
}
