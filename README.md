# flutter_query_builder

⬛️ - Whether you're a beginner or an experienced developer, flutter_query_builder simplifies database interactions, allowing you to create, retrieve, update, and delete records with ease. Say goodbye to manual SQL queries and embrace the simplicity and power of flutter_query_builder for all your database operations .

⬛️ - flutter_query_builder empowers Flutter developers to work with SQL databases more efficiently, reducing development time and effort.  developers can focus on building robust applications without getting lost in intricate SQL syntax .

⬛️ - It should be noted that this package is based on the sqflite package 😁 . 
## Get started

### Add dependency

```yaml
dependencies:
  flutter_query_builder: ^1.0.0
```

⬛️ - import sqflite and start initializing your own database.

```dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';

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
}

void main() async {
  await DataBaseManagment.initDatabase(dbName: 'test', version: 1);
  runApp(const MyApp());
}

```
### first thing first ... we assume that we have this dummy data to explain main functionallity

```dart
TableModel student = TableModel(
  name: 'Student',
  columns: [
    ColumnModel(
      name: 'studentId',
      isAutoincrement: true,
      isPrimaryKey: true,
      isNotNull: true,
      isInteger: true,
    ),
    ColumnModel(name: 'name', isText: true),
    ColumnModel(name: 'collageId', isInteger: true),
  ],
);

TableModel collage = TableModel(
  name: 'Collage',
  columns: [
    ColumnModel(
      name: 'collageId',
      isAutoincrement: true,
      isPrimaryKey: true,
      isNotNull: true,
      isInteger: true,
    ),
    ColumnModel(name: 'name', isVarchar: true,varcharCharCount: 50),
    ColumnModel(name: 'address', isText: true),
  ],
);
                         
```

### Super easy to use

⬜️ - creating a table :

```dart

await QueryBuilder.createTable(
        table: collage,
        whenError: (error) {
            log('Error 👾: $error');
        },
    );
                              
```

⬜️ - get table content :

```dart


await QueryBuilder.getTableContent(
        tableName: collage.name,
        whenError: (error) {
            log('Error 👾: $error');
        },
);
                
                              
```

⬜️ - rename a table :

```dart

await QueryBuilder.renameTable(
        table: student,
        newName: 'first Table',
        whenError: (error) {
            log('Error 👾: $error');
        },
);              
                              
```

⬜️ - get tables Names :

```dart


await QueryBuilder.getTablesNames(
        whenError: (error) {
            log('Error 👾: $error');
        },
);
                
                              
```

⬜️ - delete a table :

```dart

await QueryBuilder.dropTable(
        table: student,
        whenError: (error) {
            log('Error 👾: $error');
        },
);
                          
                              
```

⬜️ - add new column :

```dart


await QueryBuilder.addNewColumn(
        table: student,
        column: ColumnModel(
            name: 'bio',
            isReal: true,
        ),
        whenError: (error) {
                log('Error 👾: $error');
        },
);
                
                              
```

⬜️ - update column value :

```dart

await QueryBuilder.updateColumnValue(
        table: student,
        columnName: 'ID_adress',
        newColumnValue: 'NewName',
        condition: ConditionModel(
                key: 'id',
                condition: ConditionType.equalTo,
                val: 5,
        ),
        whenError: (error) {},
);
                
```

⬜️ - get all names of table columns :

```dart         

await QueryBuilder.getColumnNames(student.name);

```

⬜️ - rename a column :

```dart


await QueryBuilder.renameColumn(
        table: student,
        oldName: 'name',
        newName: 'newName',
        whenError: (error) {
            log('Error 👾: $error');
        },
);
                

```

⬜️ - insert a record :

```dart

await QueryBuilder.insertRecord(
        table: collage,
        record: RecordModel(
                    data: [
                      RecordItemModel(columnName: 'name', value: 'Emran Maher Al-daqaq'),
                      RecordItemModel(columnName: 'address', 'Duff Fork Villas'),
                      RecordItemModel(columnName: 'collageId', value: 5),
                    ]),
        whenError: (error) {
            log('Error 👾: $error');
        },
);
                                       
```

⬜️ - update a record :

```dart

                  await QueryBuilder.updateRecord(
                    table: student,
                    newRecord: [
                      RecordItemModel(columnName: 'name', value: 'new name'),
                      RecordItemModel(columnName: 'age', value: '10'),
                      RecordItemModel(columnName: 'ID_adress', value: 65),
                      RecordItemModel(columnName: 'have', value: false),
                      RecordItemModel(columnName: 'haveCat', value: 0),
                    ],
                    condition: ConditionModel(
                        key: 'id', condition: ConditionType.notEqualTo, val: 6),
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                                              
```

⬜️ - delete a record :

```dart


await QueryBuilder.deleteRecord(
        table: student,
        condition: ConditionModel(
                        key: 'haveTV',
                        condition: ConditionType.equalTo,
                        val: 0,
                    ),
        whenError: (error) {
            log('Error 👾: $error');
        },
);
                                
                              
```

🔲 - Union & UnionAll Queries :

```dart

await QueryBuilder.union(
        type: UnionType.union, // ~ or you can use UnionType.unionAll
        firstRowSelect: 'SELECT bio FROM ${student.name}',
        secondRowSelect: 'SELECT bio FROM ${student.name}',
        orderByColumn: 'bio',
        whenError: (error) {
            log('Error 👾: $error');
        },
);
                            
                              
```

🔲 - join Queries :

```dart
/*
join types: 
JoinType.inner;
JoinType.left;
 ~~ RIGHT and FULL OUTER JOINs are not currently supported
*/
await QueryBuilder.join(
        type: JoinType.inner,
        rowSelect:
                    'SELECT ${collage.name}.address,${student.name}.name FROM ${student.name}',
        secondTableName: collage.name,
        firstColumnName: '${collage.name}.collageId',
        secondColumnName: '${student.name}.collageId',
        whenError: (error) {
            log('Error 👾: $error');
        },
);
                           
                              
```

⬜️ - Row Query :

```dart

await QueryBuilder.rawQuery(
        'query',
        whenError: (error) {
            log('Error 👾: $error');
        },
);                         
                              
```

⬜️ - deleta the data base :

```dart

await deleteDataBase(String dbName);                     
                              
```

### super easy ... wasn't it?

## ❤️ Found this project useful?

If you found this useful, then please consider giving it a ⭐ on Github and sharing it with your friends via social media.

## ❤️ Contact Info
## 🔲  LinkedIn : https://www.linkedin.com/in/emran-al-daqaq
## 🔲  Facebook : https://www.facebook.com/emran.aldakak?mibextid=ZbWKwL
