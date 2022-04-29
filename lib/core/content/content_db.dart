class ContentDb {
  bool foreignKeys = false;
  Map schema = {};

  ContentDb(String path) {
    // Db({"db_name": "ContentDb", "tables": {}}, path);
    foreignKeys = true;
  }

  getSchema() {
    Map scehma = {};
    scehma['db_name'] = 'ContentDb';
    schema["version"] = 3;
    schema["tables"] = {};
  }
}

Map contentDb = {};

getContentDb({String? path}) {
  if (path == null) {
    path = "../content.db";
  }

  var result = contentDb.keys.where((element) => path == element).toList();

  if (result.isEmpty) {
    contentDb[path] = ContentDb(path);
    contentDb[path].init();
    return contentDb[path];
  }
}
