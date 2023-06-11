import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;


part 'model.g.dart';

const tableUsers = SqfEntityTable(
    tableName: 'Users',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    fields: [
      SqfEntityField('login', DbType.text),
      SqfEntityField('name', DbType.text),
      SqfEntityField('mail', DbType.text),
      SqfEntityField('password', DbType.text)
    ]);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(usersModel)
const usersModel = SqfEntityModel(
  modelName: 'UsersDbModel',
  databaseName: 'UsersDbORM.db',
  sequences: [seqIdentity],
  databaseTables: [tableUsers],
);


