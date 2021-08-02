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

Map content_db = {};

getContentDb({String path}) {
  if (path == null) {
    path = "../content.db";
  }

  var result = content_db.keys.where((element) => path == element).toList();

  if (result.isEmpty) {
    content_db[path] = ContentDb(path);
    content_db[path].init();
    return content_db[path];
  }
}
