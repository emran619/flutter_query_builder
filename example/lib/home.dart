import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_query_builder/flutter_query_builder.dart';

import 'common/dummy_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              // ~ Initializing data base
              const Center(child: Text('Initializing data base')),
              ButtonsWidget(
                title: 'Initializing data base',
                onTap: () async {
                  await DataBaseManagment.initDatabase(
                      dbName: 'test1', version: 1);
                },
              ),

              // ~ Tables
              const Center(child: Text('Tables')),
              ButtonsWidget(
                title: 'Create Table',
                onTap: () async {
                  await QueryBuilder.createTable(
                    table: collage,
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),
              ButtonsWidget(
                title: 'Get Table Content',
                onTap: () async {
                  await QueryBuilder.getTableContent(
                    tableName: collage.name,
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),
              ButtonsWidget(
                title: 'Rename Table',
                onTap: () async {
                  await QueryBuilder.renameTable(
                    table: student,
                    newName: 'first Table',
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),
              ButtonsWidget(
                title: 'Get Table Names',
                onTap: () async {
                  await QueryBuilder.getTablesNames(
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),
              ButtonsWidget(
                title: 'Drop Table',
                onTap: () async {
                  await QueryBuilder.dropTable(
                    table: student,
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),

              // ~ Columns
              const Center(child: Text('Columns')),

              ButtonsWidget(
                title: 'Add New Column',
                onTap: () async {
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
                },
              ),

              ButtonsWidget(
                title: 'Update Column Value',
                onTap: () async {
                  await QueryBuilder.updateColumnValue(
                    table: student,
                    columnName: 'ID_adress',
                    newColumnValue: 'hi',
                    condition: ConditionModel(
                      key: 'id',
                      condition: ConditionType.equalTo,
                      val: 5,
                    ),
                    whenError: (error) {},
                  );
                },
              ),

              ButtonsWidget(
                title: 'Column Names In Table',
                onTap: () async {
                  await QueryBuilder.getColumnNames(collage.name);
                },
              ),
              ButtonsWidget(
                title: 'Rename Column',
                onTap: () async {
                  await QueryBuilder.renameColumn(
                    table: student,
                    oldName: 'have4324',
                    newName: 'havek',
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),

              // ~ Reords

              const Center(child: Text('Records')),

              ButtonsWidget(
                title: 'Insert Record',
                onTap: () async {
                  await QueryBuilder.insertRecord(
                    table: collage,
                    record: RecordModel(data: [
                      RecordItemModel(
                          columnName: 'name', value: 'Duff Fork Villas'),
                      RecordItemModel(columnName: 'address', value: 'test2'),
                      RecordItemModel(columnName: 'collageId', value: 5),
                    ]),
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),
              ButtonsWidget(
                title: 'Update Record',
                onTap: () async {
                  await QueryBuilder.updateRecord(
                    table: student,
                    newRecord: [
                      RecordItemModel(columnName: 'name', value: 'Erhamny'),
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
                },
              ),
              ButtonsWidget(
                title: 'Delete Record',
                onTap: () async {
                  await QueryBuilder.deleteRecord(
                    table: student,
                    condition: ConditionModel(
                        key: 'haveTV',
                        condition: ConditionType.equalTo,
                        val: 0),
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),

              // ~ Union

              const Center(child: Text('Union')),

              ButtonsWidget(
                title: 'Union',
                onTap: () async {
                  await QueryBuilder.union(
                    type: UnionType.union,
                    firstRowSelect: 'SELECT bio FROM ${student.name}',
                    secondRowSelect: 'SELECT bio FROM ${student.name}',
                    orderByColumn: 'bio',
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),
              ButtonsWidget(
                title: 'Union All',
                onTap: () async {
                  await QueryBuilder.union(
                    type: UnionType.unionAll,
                    firstRowSelect: 'SELECT bio FROM ${student.name}',
                    secondRowSelect: 'SELECT bio FROM ${student.name}',
                    orderByColumn: 'bio',
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),
              // ~ Inner Join
              const Center(child: Text('Join')),
              ButtonsWidget(
                title: 'Inner Join',
                onTap: () async {
                  JoinType.inner;
                  JoinType.left;
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
                },
              ),
              // ~ left Join
              ButtonsWidget(
                title: 'Left Join',
                onTap: () async {
                  await QueryBuilder.join(
                    type: JoinType.left,
                    rowSelect:
                        'SELECT ${collage.name}.address,${student.name}.name FROM ${student.name}',
                    secondTableName: collage.name,
                    firstColumnName: '${collage.name}.collageId',
                    secondColumnName: '${student.name}.collageId',
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),
              // ~ Row Query

              const Center(child: Text('Row Query')),

              ButtonsWidget(
                title: 'Row Query',
                onTap: () async {
                  await QueryBuilder.rawQuery(
                    'query',
                    whenError: (error) {
                      log('Error 👾: $error');
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({
    super.key,
    required this.onTap,
    required this.title,
  });
  final VoidCallback onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(title),
      ),
    );
  }
}
