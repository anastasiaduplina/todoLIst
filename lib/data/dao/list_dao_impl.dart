import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/data/dao/list_dao.dart';
import 'package:todo_list_app/data/dto/action_dto.dart';
import 'package:todo_list_app/data/dto/element_dto.dart';
import 'package:todo_list_app/utils/constant.dart';
import 'package:todo_list_app/utils/exceptions/not_exist_action_exception.dart';
import 'package:todo_list_app/utils/exceptions/not_valid_auth_exception.dart';
import 'package:todo_list_app/utils/exceptions/not_valid_revision_exception.dart';
import 'package:todo_list_app/utils/exceptions/server_error_exception.dart';
import 'package:todo_list_app/utils/logger.dart';

import '../dto/list_dto.dart';

class ListDaoImpl implements ListDao {
  // final Client http;
  ListDaoImpl();

  static Future<bool> setRevisionToSharedPreferences(int revision) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt('revision', revision);
  }

  static Future<int> getRevisionFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('revision') ?? 0;
  }

  void checkResponse(Response response, int revision, {String id = "0"}) {
    AppLogger.d(response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
        {
          return;
        }
      case 400:
        {
          AppLogger.e(response.body.toString());
          throw NotValidRevisionException(revision.toString());
        }
      case 401:
        {
          AppLogger.e(response.body.toString());
          throw const NotValidAuthException("");
        }
      case 404:
        {
          AppLogger.e(response.body.toString());
          throw NotExistActionException(id);
        }
      case 500:
        {
          AppLogger.e("Server error: ${response.body.toString()}");
          throw ServerErrorException(response.body.toString());
        }
      default:
        {
          AppLogger.i("Unexpected status code:${response.statusCode}");
          if (response.statusCode >= 300) {
            throw Exception();
          }
        }
    }
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
    checkResponse(response, revision);

    setRevisionToSharedPreferences(jsonDecode(response.body)["revision"]);
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
    checkResponse(response, revision);
    setRevisionToSharedPreferences(jsonDecode(response.body)["revision"]);
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
    checkResponse(response, revision);
    setRevisionToSharedPreferences(jsonDecode(response.body)["revision"]);
  }

  @override
  Future<ActionDto> getActionById(String id) async {
    final url = Uri.parse('${Constants.baseUrlList}/$id');
    int revision = await getRevisionFromSharedPreferences();
    final response = await http.get(
      url,
      headers: {
        Constants.headerRevision: revision.toString(),
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    checkResponse(response, revision);
    ActionDto actionDto =
        ActionDto.fromJson(jsonDecode(response.body)["element"]);
    setRevisionToSharedPreferences(jsonDecode(response.body)["revision"]);
    return actionDto;
  }

  @override
  Future<List<ActionDto>> getList() async {
    final url = Uri.parse(Constants.baseUrlList);
    int revision = await getRevisionFromSharedPreferences();
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    checkResponse(response, revision);
    ListDto listDto = ListDto.fromJson(jsonDecode(response.body));
    setRevisionToSharedPreferences(listDto.revision);
    return listDto.list;
  }

  Future<int> getRevision() async {
    final url = Uri.parse(Constants.baseUrlList);
    int revision = await getRevisionFromSharedPreferences();
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${Constants.token}",
      },
    );
    checkResponse(response, revision);
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
    checkResponse(response, revision);
    ListDto listDto = ListDto.fromJson(jsonDecode(response.body));
    setRevisionToSharedPreferences(listDto.revision);
    return listDto.list;
  }
}
