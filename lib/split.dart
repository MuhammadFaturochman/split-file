import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

void main(List<String> arguments) {
  File file = File(p.join(Directory.current.path, 'file.jpg'));

  const maxChunkSize = 1 * 1024 * 1024;
  var totalfileSize = file.lengthSync();
  var chunkSizeLeft = totalfileSize % maxChunkSize;
  var totalChunkFile = (totalfileSize - chunkSizeLeft) ~/ maxChunkSize;

  var chunks = List<int>.generate((totalChunkFile), (index) => maxChunkSize);
  chunks.add(chunkSizeLeft);

  RandomAccessFile raf = file.openSync(mode: FileMode.read);

  var currentChunkByte = 0;

  for (var position = 0; position < chunks.length; position++) {
    var chunk = chunks.elementAt(position);
    var chunkByte = currentChunkByte + chunk;
    raf.setPositionSync(currentChunkByte);
    Uint8List uint8list = raf.readSync(chunkByte);

    var nomorFile = position + 1;
    File chunkFile = File(p.join(Directory.current.path, 'parts', 'file.jpg.part$nomorFile'));
    chunkFile.writeAsBytesSync(uint8list);

    currentChunkByte = chunkByte;
  }
}
