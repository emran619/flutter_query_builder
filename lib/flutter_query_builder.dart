library flutter_query_builder;

export 'src/flutter_query_builder_base.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';
import 'dart:developer';

///
/// initializing DB
class DataBaseManagment {
  static late Database database;

  static Future<Database> initDatabase({
    required String dbName,
    int? version,
    FutureOr<void> Function(Database)? onOpen,
    FutureOr<void> Function(Database, int)? onCreate,
    FutureOr<void> Function(Database)? onConfigure,
    FutureOr<void> Function(Database, int, int)? onDowngrade,
    FutureOr<void> Function(Database, int, int)? onUpgrade,
    bool? readOnly = false,
    bool? singleInstance = true,
  }) async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/$dbName';
    // open the database
    try {
      database = await openDatabase(
        path,
        version: version,
        onOpen: onOpen,
        onConfigure: onConfigure,
        onDowngrade: onDowngrade,
        onUpgrade: onUpgrade,
        singleInstance: singleInstance,
        readOnly: readOnly,
        onCreate: onCreate,
      );
      print('$dbName  DataBase initialized succeffuly with path $path');
    } catch (e) {
      print(
          'Something went wrong when initializing $dbName  DataBase / error : $e');
    }
    return database;
  }

  Future<void> deleteDataBase(String dbName) async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/$dbName';
    await deleteDatabase(path);
  }
}

///  ~ Query exception handler
/// [whenError] function called when The query failed
class QueryExceptionHandler {
  static Future<void> handler({
    required Future<void> Function() function,
    void Function(String)? whenError,
  }) async {
    try {
      await function.call();
    } catch (e) {
      dynamic exception = e;
      whenError?.call(exception.message);
    }
  }
}

/// ~ main QueryBuilder functionallity

class QueryBuilder {
  // ~
  static final Database _database = DataBaseManagment.database;

  static Future<void> createTable({
    required TableModel table,
    void Function(String)? whenError,
  }) async =>
      await QueryExceptionHandler.handler(
        function: () async {
          await _database.execute(table.create());
          log(table.create());
          log('----------------------------------');
        },
        whenError: (error) {
          whenError?.call(error);
        },
      );

  static Future<List<Map<String, Object?>>> getTablesNames({
    void Function(String)? whenError,
  }) async {
    List<Map<String, Object?>> tables = [];
    await QueryExceptionHandler.handler(
      function: () async {
        tables = await _database.rawQuery(
            "$select name $from $sqlite_master $where type='table' AND name NOT LIKE 'sqlite_%';");
        log(tables.map((row) => row['name'] as String).toList().toString());
        log('----------------------------------');
      },
      whenError: (error) {
        whenError?.call(error);
      },
    );
    return tables;
  }

  static Future<void> addNewColumn({
    required TableModel table,
    required ColumnModel column,
    void Function(String)? whenError,
  }) async =>
      await QueryExceptionHandler.handler(
        function: () async {
          await _database.execute(table.addColumn(column));
          log(table.addColumn(column));
          log('----------------------------------');
        },
        whenError: (error) {
          whenError?.call(error);
        },
      );

  static Future<void> renameColumn({
    required TableModel table,
    required String oldName,
    required String newName,
    void Function(String)? whenError,
  }) async =>
      await QueryExceptionHandler.handler(
        function: () async {
          await _database.execute(table.renameColumn(oldName, newName));
          log(table.renameColumn(oldName, newName));
          log('----------------------------------');
        },
        whenError: (error) {
          whenError?.call(error);
        },
      );

  static Future<void> updateColumnValue({
    required TableModel table,
    required String columnName,
    required dynamic newColumnValue,
    required ConditionModel condition,
    void Function(String)? whenError,
  }) async =>
      await QueryExceptionHandler.handler(
        function: () async {
          await _database.execute(
              table.updateColumn(columnName, newColumnValue, condition));
          log(table.updateColumn(columnName, newColumnValue, condition));
          log('----------------------------------');
        },
        whenError: (error) {
          whenError?.call(error);
        },
      );

  static Future<List<String>> getColumnNames(
    String tableName, {
    void Function(String)? whenError,
  }) async {
    List<String> columns = [];
    await QueryExceptionHandler.handler(
      function: () async {
        final result =
            await _database.rawQuery('$pragma $tableInfo($tableName)');
        columns = result.map((row) => row['name'] as String).toList();

        columns.forEach((element) {
          log(element);
        });
        log('----------------------------------');
      },
      whenError: (error) {
        whenError?.call(error);
      },
    );
    return columns;
  }

  static Future<void> renameTable({
    required TableModel table,
    required String newName,
    void Function(String)? whenError,
  }) async =>
      await QueryExceptionHandler.handler(
        function: () async {
          await _database.execute(table.rename(newName));
          log(table.rename(newName));
          log('----------------------------------');
        },
        whenError: (error) {
          whenError?.call(error);
        },
      );

  static Future<void> dropTable({
    required TableModel table,
    void Function(String)? whenError,
  }) async =>
      await QueryExceptionHandler.handler(
        function: () async {
          await _database.execute(table.delete());
          log(table.delete());
          log('----------------------------------');
        },
        whenError: (error) {
          whenError?.call(error);
        },
      );

  static Future<List<Map<String, Object?>>> rawQuery(
    String query, {
    void Function(String)? whenError,
  }) async {
    List<Map<String, Object?>> list = [];

    await QueryExceptionHandler.handler(
      function: () async {
        list = await _database.rawQuery(query);
        log(query);
        log('----------------------------------');
      },
      whenError: (error) {
        whenError?.call(error);
      },
    );

    return list;
  }

  static Future<List<Map<String, Object?>>> getTableContent({
    required String tableName,
    List<String>? columns,
    ConditionModel? condition,
    void Function(String)? whenError,
  }) async {
    List<Map<String, Object?>> list = [];

    await QueryExceptionHandler.handler(
      function: () async {
        list = await _database.rawQuery(
            '$select ${columns ?? '*'} $from ${tableName.withoutSpaces} ${condition == null ? '' : '{$where ${condition.equalToString}}'}');
        if (list.isNotEmpty) {
          for (var element in list) {
            log(element.toString());
          }
          log('----------------------------------');
        } else {
          log('Table Empty');
        }
      },
      whenError: (error) {
        whenError?.call(error);
      },
    );
    return list;
  }

  static Future<void> insertRecord({
    required TableModel table,
    required RecordModel record,
    void Function(String)? whenError,
  }) async =>
      await QueryExceptionHandler.handler(
        function: () async {
          await _database.insert(table.name, record.toJson());
          log(record.toJson().toString());
        },
        whenError: (error) {
          whenError?.call(error);
        },
      );

  static Future<void> updateRecord({
    required TableModel table,
    required List<RecordItemModel> newRecord,
    required ConditionModel condition,
    void Function(String)? whenError,
  }) async =>
      await QueryExceptionHandler.handler(
        function: () async {
          await _database.execute(table.updateRecord(newRecord, condition));
          log(table.updateRecord(newRecord, condition));
          log('----------------------------------');
        },
        whenError: (error) {
          whenError?.call(error);
        },
      );

  static Future<void> deleteRecord({
    required TableModel table,
    required ConditionModel condition,
    void Function(String)? whenError,
  }) async =>
      await QueryExceptionHandler.handler(
        function: () async {
          await _database.execute(table.deleteRecord(condition));
          await _resetAutoIncrement(tableName: table.name);
          log(table.deleteRecord(condition));
          log('----------------------------------');
        },
        whenError: (error) {
          whenError?.call(error);
        },
      );

  static Future<void> _resetAutoIncrement({
    required String tableName,
    void Function(String)? whenError,
  }) async {
    var list = await getTableContent(tableName: tableName);

    await QueryExceptionHandler.handler(
      function: () async {
        if (list.isEmpty) {
          await _database.execute(
              '$deleteFrom $sqliteSequence $where name="${tableName.withoutSpaces}"');
        }
      },
      whenError: (error) {
        whenError?.call(error);
      },
    );
  }
  // ~ join

  static Future<void> join({
    required JoinType type,
    required String rowSelect,
    required String secondTableName,
    required String firstColumnName,
    required String secondColumnName,
    void Function(String)? whenError,
  }) async {
    List<Map<String, Object?>> list = [];
    await QueryExceptionHandler.handler(
      function: () async {
        list = await _database.rawQuery(
            '$rowSelect ${joinMapper[type]} ${secondTableName.withoutSpaces} $on ${firstColumnName.withoutSpaces}=${secondColumnName.withoutSpaces} ');
        log('$rowSelect ${joinMapper[type]} $secondTableName $on $firstColumnName=$secondColumnName ');
        list.forEach((element) {
          log(element.toString());
        });
        log('----------------------------------');
      },
      whenError: (error) {
        whenError?.call(error);
      },
    );
  }

  // ~ union
  static Future<void> union({
    required UnionType type,
    required String firstRowSelect,
    required String secondRowSelect,
    String? orderByColumn,
    void Function(String)? whenError,
  }) async {
    List<Map<String, Object?>> query = [];
    await QueryExceptionHandler.handler(
      function: () async {
        query = await _database.rawQuery(
            '$firstRowSelect ${unionMapper[type]} $secondRowSelect $orderBy $orderByColumn');
        log('$firstRowSelect ${unionMapper[type]} $secondRowSelect');
        query.forEach((element) {
          log(element.toString());
        });
        log('----------------------------------');
      },
      whenError: (error) {
        whenError?.call(error);
      },
    );
  }
}

/// ~ models
///
/// ~ Table Model
///
class TableModel {
  TableModel({
    required this.name,
    required this.columns,
    this.foreignKeys,
  });
  final String name;
  List<ColumnModel> columns;
  final List<ForeignKeyModel>? foreignKeys;

  // ~ about table

  String create() =>
      '$createTable ${name.withoutSpaces} (${ColumnModel.columnsToString(
        columns: columns,
        foreignKeys: foreignKeys,
      )})';

  String rename(
    String newName,
  ) =>
      '$alterTable $name $renameKey $to ${newName.withoutSpaces}';

  String delete() => '$dropTable $name';

  // ~ about columns

  String addColumn(ColumnModel columnModel) =>
      '$alterTable $name $add ${columnModel.foreignKey == null ? columnModel.columnToString().substring(0, columnModel.columnToString().length - 2) : columnModel.columnToString()}';

  String renameColumn(
    String oldName,
    String newName,
  ) =>
      '$alterTable $name $renameKey $column ${oldName.withoutSpaces} $to ${newName.withoutSpaces}';

  String updateColumn(String columnName, dynamic newColumnValue,
          ConditionModel condition) =>
      '$update $name $setSql $columnName = \'$newColumnValue\' $where ${condition.equalToString}';

  String removeColumn(String columnName) =>
      '$alterTable \'$name\' $drop $column $columnName';

  // ~ about records

  String updateRecord(
    List<RecordItemModel> newRecord,
    ConditionModel condition,
  ) =>
      '$update $name $setSql ${RecordModel.recordList(newRecord)} $where ${condition.equalToString}';

  String deleteRecord(ConditionModel condition) =>
      '$deleteFrom $name $where ${condition.equalToString}';
}

///
/// ~ Record Models
///
class RecordModel {
  List<RecordItemModel> data;
  RecordModel({
    required this.data,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    for (RecordItemModel item in data) {
      map.addAll(item.toJson());
    }
    return map;
  }

  static String recordList(List<RecordItemModel> recordList) {
    String stringRecordList = '';
    for (RecordItemModel item in recordList) {
      stringRecordList += '${item.equalToString} ,';
    }
    return stringRecordList.substring(0, stringRecordList.length - 2);
  }
}

class RecordItemModel {
  RecordItemModel({
    required this.columnName,
    required this.value,
  });
  String columnName;
  dynamic value;

  // ~ getters
  Map<String, dynamic> toJson() => {columnName.withoutSpaces: value};

  String get equalToString => '${columnName.withoutSpaces}=\'$value\'';
}

///
/// ~ fk Models
///
class ForeignKeyModel {
  ForeignKeyModel({
    required this.fkColumnName,
    required this.pkColumnName,
    required this.pkTableName,
  });
  String fkColumnName;
  String pkColumnName;
  String pkTableName;
  String get foreignKeyToString =>
      '$foreignKey (${fkColumnName.withoutSpaces}) $references ${pkTableName.withoutSpaces}(${pkColumnName.withoutSpaces})  ';

  static String foreignKeysToString(List<ForeignKeyModel> keys) {
    String keysString = '';
    for (ForeignKeyModel k in keys) {
      keysString += '${k.foreignKeyToString} ,';
    }
    return keysString.substring(0, keysString.length - 2);
  }
}

///
/// ~ condition Models
///

class ConditionModel {
  String key;
  ConditionType condition;
  dynamic val;
  ConditionModel({
    required this.key,
    required this.condition,
    required this.val,
  });

  // ~ getters

  String get equalToString =>
      '${key.withoutSpaces}${conditionMapper[condition]}\'$val\'';
}

///
/// ~ Column Model
///
class ColumnModel {
  ColumnModel({
    required this.name,
    this.isPrimaryKey = false,
    this.isNotNull = false,
    this.isAutoincrement = false,
    this.isText = false,
    this.isInteger = false,
    this.isBoolean = false,
    this.isReal = false,
    this.isVarchar = false,
    this.isUnique = false,
    this.foreignKey,
    this.varcharCharCount = 0,
    this.defaultColumnValue,
  });
  final String name;
  bool isPrimaryKey;
  bool isNotNull;
  bool isAutoincrement;
  bool isText;
  bool isInteger;
  bool isBoolean;
  bool isReal;
  bool isVarchar;
  bool isUnique;
  ForeignKeyModel? foreignKey;
  int varcharCharCount;
  dynamic defaultColumnValue;

  // ~ getters

  String get _dataTypes =>
      '${isInteger.then(integer)} ${isText.then(text)} ${isReal.then(real)} ${isBoolean.then(boolean)} ${isVarchar ? '$varchar($varcharCharCount)' : ''}';

  String get _constraints =>
      '${isPrimaryKey.then(primaryKey)} ${isAutoincrement.then(autoincrement)} ${isNotNull.then(notNull)} ${isUnique.then(unique)} ${defaultColumnValue != null ? '$defaultName $defaultColumnValue ' : ''},';

  String columnToString() => foreignKey != null
      ? foreignKey!.foreignKeyToString
      : '${name.withoutSpaces} $_dataTypes $_constraints';

  static String columnsToString({
    required List<ColumnModel> columns,
    List<ForeignKeyModel>? foreignKeys,
    String? condition,
  }) {
    String columnsString = '';
    for (ColumnModel column in columns) {
      columnsString += column.columnToString();
      // ~ fk
      if (foreignKeys != null) {
        columnsString += ',${ForeignKeyModel.foreignKeysToString(foreignKeys)}';
      }
      // ~ condition
      if (condition != null) {
        columnsString += ',$check ($condition)';
      }
    }
    columnsString = columnsString.substring(0, columnsString.length - 1);

    return columnsString;
  }
}

///
/// ~ some of helper extenstions
///

extension CustomBool on bool {
  String then(String word) => this ? word : '';
}

extension CustomString on String {
  String get withoutSpaces => replaceAll(' ', '');
}

///
/// ~ some of helper constants
///
const String createTable = 'CREATE TABLE';
const String alterTable = 'ALTER TABLE';
const String dropTable = 'DROP TABLE';

const String text = 'TEXT';
const String integer = 'INTEGER';
const String boolean = 'BOOLEAN';
const String real = 'REAL';
const String timestamp = 'TIMESTAMP';
const String varchar = 'VARCHAR';
const String references = 'REFERENCES';

// ~ SQL Constrains
const String primaryKey = 'PRIMARY KEY';
const String foreignKey = 'FOREIGN KEY';
const String notNull = 'NOT NULL';
const String unique = 'UNIQUE';
const String autoincrement = 'autoincrement';
const String check = 'CHECK';
const String defaultName = 'DEFAULT';
const String orderBy = 'ORDER BY';

const String add = 'ADD';
const String drop = 'DROP';
const String column = 'COLUMN';
const String renameKey = 'RENAME';
const String update = 'UPDATE';
const String setSql = 'SET';
const String where = 'WHERE';
const String to = 'to';
const String deleteFrom = 'DELETE FROM';
const String select = 'SELECT';
const String from = 'FROM';
const String on = 'ON';
const String sqliteSequence = 'sqlite_sequence';
const String sqlite_master = 'sqlite_master';
const String pragma = 'PRAGMA';
const String tableInfo = 'table_info';

// ~ join
const String innerJoin = 'INNER JOIN';
const String leftJoin = 'LEFT JOIN';
const String rightJoin = 'RIGHT JOIN';
const String fullOuterJoin = 'FULL OUTER JOIN';

enum JoinType {
  inner,
  left,
}

Map<JoinType, String> joinMapper = {
  JoinType.inner: innerJoin,
  JoinType.left: leftJoin,
};

// ~ union
const String union = 'UNION';
const String unionAll = 'UNION ALL';

enum UnionType {
  union,
  unionAll,
}

Map<UnionType, String> unionMapper = {
  UnionType.union: union,
  UnionType.unionAll: unionAll,
};

// ~ condition
enum ConditionType {
  equalTo,
  notEqualTo,
  lessThan,
  lessThanOrEqual,
  upperThan,
  upperThanOrEqual,
}

Map<ConditionType, String> conditionMapper = {
  ConditionType.equalTo: "=",
  ConditionType.notEqualTo: "!=",
  ConditionType.lessThan: "<",
  ConditionType.lessThanOrEqual: "<=",
  ConditionType.upperThan: ">",
  ConditionType.upperThanOrEqual: ">=",
};
