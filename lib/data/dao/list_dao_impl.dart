import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/data/dao/list_dao.dart';
import 'package:todo_list_app/data/dto/action_dto.dart';
import 'package:todo_list_app/data/dto/element_dto.dart';
import 'package:todo_list_app/utils/constant.dart';
import 'package:todo_list_app/utils/exceptions/not_valid_revision_exception.dart';
import 'package:todo_list_app/utils/logger.dart';

import '../dto/list_dto.dart';

class ListDaoImpl implements ListDao {
  ListDaoImpl();

  static Future<bool> setRevisionFromSharedPreferences(int revision) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt('revision', revision);
  }

  static Future<int> getRevisionFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('revision') ?? 0;
  }

  @override
  Future<void> addAction(ActionDto actionDto) async {
    final url = Uri.parse(Constants.baseUrlList);
    int revision = await getRevisionFromSharedPreferences();
    ElementDto elementDto = ElementDto(actionDto);
    final response = await http.post(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
      body: json.encode(elementDto.toJson()),
    );
    if (response.statusCode != 200) {
      AppLogger.e(response.statusCode.toString());
      if (response.statusCode == 400) {
        throw NotValidRevisionException(revision.toString());
      }
    }
    setRevisionFromSharedPreferences(jsonDecode(response.body)["revision"]);
  }

  @override
  Future<void> deleteAction(ActionDto actionDto) async {
    final url = Uri.parse('${Constants.baseUrlList}/${actionDto.id}');
    int revision = await getRevisionFromSharedPreferences();
    final response = await http.delete(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    if (response.statusCode != 200) {
      AppLogger.e(response.statusCode.toString());
      if (response.statusCode == 400) {
        throw NotValidRevisionException(revision.toString());
      }
    }
    setRevisionFromSharedPreferences(jsonDecode(response.body)["revision"]);
  }

  @override
  Future<void> editAction(ActionDto actionDto) async {
    final url = Uri.parse('${Constants.baseUrlList}/${actionDto.id}');
    int revision = await getRevisionFromSharedPreferences();
    ElementDto elementDto = ElementDto(actionDto);
    final response = await http.put(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
      body: json.encode(elementDto.toJson()),
    );
    if (response.statusCode != 200) {
      AppLogger.e(response.statusCode.toString());
      if (response.statusCode == 400) {
        throw NotValidRevisionException(revision.toString());
      }
    }
    setRevisionFromSharedPreferences(jsonDecode(response.body)["revision"]);
  }

  @override
  Future<List<ActionDto>> getList() async {
    final url = Uri.parse(Constants.baseUrlList);
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    if (response.statusCode != 200) {
      AppLogger.e(response.statusCode.toString());
    }
    ListDto listDto = ListDto.fromJson(jsonDecode(response.body));
    setRevisionFromSharedPreferences(listDto.revision);
    return listDto.list;
  }

  Future<int> getRevision() async {
    final url = Uri.parse(Constants.baseUrlList);
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    if (response.statusCode != 200) {
      AppLogger.e(response.statusCode.toString());
    }
    ListDto listDto = ListDto.fromJson(jsonDecode(response.body));
    return listDto.revision;
  }

  @override
  Future<List<ActionDto>> updateList(List<ActionDto> list) async {
    final url = Uri.parse(Constants.baseUrlList);
    int revision = await getRevisionFromSharedPreferences();
    final response = await http.patch(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
      body: '{"list":${json.encode(list.map((e) => e.toJson()).toList())}}',
    );
    if (response.statusCode != 200) {
      AppLogger.e(response.statusCode.toString());
      if (response.statusCode == 400) {
        throw NotValidRevisionException(revision.toString());
      }
    }
    ListDto listDto = ListDto.fromJson(jsonDecode(response.body));
    setRevisionFromSharedPreferences(listDto.revision);
    return listDto.list;
  }
}
