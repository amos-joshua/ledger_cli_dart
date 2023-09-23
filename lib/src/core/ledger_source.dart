import 'dart:io';
import 'dart:async';

enum LedgerSourceType {
  file, stringData
}

class LedgerSource {
  final LedgerSourceType sourceType;
  final String data;
  final DateTime lastModified;

  const LedgerSource({required this.sourceType, required this.data, required this.lastModified});

  static LedgerSource forFile(String path) {
    final lastModified = File(path).lastModifiedSync();
    return LedgerSource(sourceType: LedgerSourceType.file, data: path, lastModified: lastModified);
  }

  static LedgerSource forData(String data) {
    return LedgerSource(sourceType: LedgerSourceType.stringData, data: data, lastModified: DateTime.now());
  }

  @override
  bool operator ==(Object other) => (other is LedgerSource) && (other.sourceType == sourceType) && (other.data == data) && (other.lastModified == lastModified);

  @override
  int get hashCode => Object.hashAll([sourceType, data, lastModified]);

  @override
  String toString() => "LedgerSource($sourceType, lastModified: $lastModified, data: ${data.length > 100 ? data.substring(0, 100) : data})";
}

class LedgerSourceWatcher {
  StreamSubscription? ledgerFileEventSubscription;
  LedgerSource? currentSource;
  void Function(LedgerSource) onSourceChanged;

  LedgerSourceWatcher({required this.onSourceChanged});

  void watch(LedgerSource source) {
    ledgerFileEventSubscription?.cancel();
    ledgerFileEventSubscription = null;
    if (source.sourceType == LedgerSourceType.file) {
      ledgerFileEventSubscription = File(source.data).parent.watch().listen(onFileSystemEvent);
      currentSource = source;
    }
  }

  void onFileSystemEvent(FileSystemEvent event) async {
    final sourcePath = currentSource?.data;
    if (sourcePath != null) {
      onSourceChanged(LedgerSource.forFile(sourcePath));
    }
  }
}