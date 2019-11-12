import 'dart:io';
import 'dart:mirrors';

class PackageManager {
  Directory _directory;

  PackageManager(String packageDirectory) {
    _directory = Directory(packageDirectory);
  }

  factory PackageManager.fromUri(Uri uri) {
    String packagePath = PackageManager.getPackagePath(uri);
    return PackageManager(packagePath);
  }

  Future<List<File>> listPackageClasses() async {
    List<File> packageClasses = [];
    await _directory
        .list(recursive: true)
        .forEach((FileSystemEntity entity) async {
      if (entity is File) {
        packageClasses.add(entity);
      }
    });
    return packageClasses;
  }

  Future<List<ClassMirror>> getPackageClasses(IsolateMirror isolate) async {
    List<File> files = await this.listPackageClasses();
    List<ClassMirror> classes = [];
    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      LibraryMirror libraryMirror = await this._loadLibraryClass(isolate, file);
      classes.addAll(this._fileDeclarations(libraryMirror));
    }
    return classes;
  }

  Future<LibraryMirror> _loadLibraryClass(
      IsolateMirror isolateMirror, File file) {
    return isolateMirror.loadUri(Uri.file(file.path));
  }

  List<ClassMirror> _fileDeclarations(LibraryMirror libraryMirror) {
    List<ClassMirror> classes = [];
    libraryMirror.declarations
        .forEach((Symbol name, DeclarationMirror declarationMirror) {
      if (declarationMirror is ClassMirror) {
        classes.add(declarationMirror);
      }
    });
    return classes;
  }

  static String getPackagePath(Uri packageUri) {
    List<String> splittedPath = packageUri.path.split('/');
    if (splittedPath[splittedPath.length - 1].endsWith('.dart')) {
      splittedPath.removeLast();
    }
    return splittedPath.join('/');
  }
}
