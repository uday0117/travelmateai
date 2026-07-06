// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_stats_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTravelStatsIsarModelCollection on Isar {
  IsarCollection<TravelStatsIsarModel> get travelStatsIsarModels =>
      this.collection();
}

const TravelStatsIsarModelSchema = CollectionSchema(
  name: r'TravelStatsIsarModel',
  id: 4528854319638871094,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isDeleted': PropertySchema(
      id: 1,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'statsId': PropertySchema(
      id: 2,
      name: r'statsId',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 3,
      name: r'syncStatus',
      type: IsarType.string,
      enumMap: _TravelStatsIsarModelsyncStatusEnumValueMap,
    ),
    r'totalCountries': PropertySchema(
      id: 4,
      name: r'totalCountries',
      type: IsarType.long,
    ),
    r'totalDaysTraveled': PropertySchema(
      id: 5,
      name: r'totalDaysTraveled',
      type: IsarType.long,
    ),
    r'totalDistanceKm': PropertySchema(
      id: 6,
      name: r'totalDistanceKm',
      type: IsarType.double,
    ),
    r'totalExpenses': PropertySchema(
      id: 7,
      name: r'totalExpenses',
      type: IsarType.double,
    ),
    r'totalTrips': PropertySchema(
      id: 8,
      name: r'totalTrips',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 10,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _travelStatsIsarModelEstimateSize,
  serialize: _travelStatsIsarModelSerialize,
  deserialize: _travelStatsIsarModelDeserialize,
  deserializeProp: _travelStatsIsarModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'statsId': IndexSchema(
      id: -2501059016366061103,
      name: r'statsId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'statsId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _travelStatsIsarModelGetId,
  getLinks: _travelStatsIsarModelGetLinks,
  attach: _travelStatsIsarModelAttach,
  version: '3.1.0+1',
);

int _travelStatsIsarModelEstimateSize(
  TravelStatsIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.statsId.length * 3;
  bytesCount += 3 + object.syncStatus.name.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _travelStatsIsarModelSerialize(
  TravelStatsIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeBool(offsets[1], object.isDeleted);
  writer.writeString(offsets[2], object.statsId);
  writer.writeString(offsets[3], object.syncStatus.name);
  writer.writeLong(offsets[4], object.totalCountries);
  writer.writeLong(offsets[5], object.totalDaysTraveled);
  writer.writeDouble(offsets[6], object.totalDistanceKm);
  writer.writeDouble(offsets[7], object.totalExpenses);
  writer.writeLong(offsets[8], object.totalTrips);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeString(offsets[10], object.userId);
}

TravelStatsIsarModel _travelStatsIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TravelStatsIsarModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isDeleted = reader.readBool(offsets[1]);
  object.statsId = reader.readString(offsets[2]);
  object.syncStatus = _TravelStatsIsarModelsyncStatusValueEnumMap[
          reader.readStringOrNull(offsets[3])] ??
      SyncStatus.synced;
  object.totalCountries = reader.readLong(offsets[4]);
  object.totalDaysTraveled = reader.readLong(offsets[5]);
  object.totalDistanceKm = reader.readDouble(offsets[6]);
  object.totalExpenses = reader.readDouble(offsets[7]);
  object.totalTrips = reader.readLong(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.userId = reader.readString(offsets[10]);
  return object;
}

P _travelStatsIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_TravelStatsIsarModelsyncStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncStatus.synced) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TravelStatsIsarModelsyncStatusEnumValueMap = {
  r'synced': r'synced',
  r'pending': r'pending',
  r'conflict': r'conflict',
  r'failed': r'failed',
};
const _TravelStatsIsarModelsyncStatusValueEnumMap = {
  r'synced': SyncStatus.synced,
  r'pending': SyncStatus.pending,
  r'conflict': SyncStatus.conflict,
  r'failed': SyncStatus.failed,
};

Id _travelStatsIsarModelGetId(TravelStatsIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _travelStatsIsarModelGetLinks(
    TravelStatsIsarModel object) {
  return [];
}

void _travelStatsIsarModelAttach(
    IsarCollection<dynamic> col, Id id, TravelStatsIsarModel object) {
  object.id = id;
}

extension TravelStatsIsarModelByIndex on IsarCollection<TravelStatsIsarModel> {
  Future<TravelStatsIsarModel?> getByStatsId(String statsId) {
    return getByIndex(r'statsId', [statsId]);
  }

  TravelStatsIsarModel? getByStatsIdSync(String statsId) {
    return getByIndexSync(r'statsId', [statsId]);
  }

  Future<bool> deleteByStatsId(String statsId) {
    return deleteByIndex(r'statsId', [statsId]);
  }

  bool deleteByStatsIdSync(String statsId) {
    return deleteByIndexSync(r'statsId', [statsId]);
  }

  Future<List<TravelStatsIsarModel?>> getAllByStatsId(
      List<String> statsIdValues) {
    final values = statsIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'statsId', values);
  }

  List<TravelStatsIsarModel?> getAllByStatsIdSync(List<String> statsIdValues) {
    final values = statsIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'statsId', values);
  }

  Future<int> deleteAllByStatsId(List<String> statsIdValues) {
    final values = statsIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'statsId', values);
  }

  int deleteAllByStatsIdSync(List<String> statsIdValues) {
    final values = statsIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'statsId', values);
  }

  Future<Id> putByStatsId(TravelStatsIsarModel object) {
    return putByIndex(r'statsId', object);
  }

  Id putByStatsIdSync(TravelStatsIsarModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'statsId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByStatsId(List<TravelStatsIsarModel> objects) {
    return putAllByIndex(r'statsId', objects);
  }

  List<Id> putAllByStatsIdSync(List<TravelStatsIsarModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'statsId', objects, saveLinks: saveLinks);
  }
}

extension TravelStatsIsarModelQueryWhereSort
    on QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QWhere> {
  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TravelStatsIsarModelQueryWhere
    on QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QWhereClause> {
  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterWhereClause>
      statsIdEqualTo(String statsId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'statsId',
        value: [statsId],
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterWhereClause>
      statsIdNotEqualTo(String statsId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statsId',
              lower: [],
              upper: [statsId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statsId',
              lower: [statsId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statsId',
              lower: [statsId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statsId',
              lower: [],
              upper: [statsId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TravelStatsIsarModelQueryFilter on QueryBuilder<TravelStatsIsarModel,
    TravelStatsIsarModel, QFilterCondition> {
  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> statsIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statsId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> statsIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statsId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> statsIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statsId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> statsIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statsId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> statsIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statsId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> statsIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statsId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
          QAfterFilterCondition>
      statsIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statsId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
          QAfterFilterCondition>
      statsIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statsId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> statsIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statsId',
        value: '',
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> statsIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statsId',
        value: '',
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> syncStatusEqualTo(
    SyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
          QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
          QAfterFilterCondition>
      syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalCountriesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCountries',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalCountriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCountries',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalCountriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCountries',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalCountriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCountries',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalDaysTraveledEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDaysTraveled',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalDaysTraveledGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDaysTraveled',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalDaysTraveledLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDaysTraveled',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalDaysTraveledBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDaysTraveled',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalDistanceKmEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDistanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalDistanceKmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDistanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalDistanceKmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDistanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalDistanceKmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDistanceKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalExpensesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalExpenses',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalExpensesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalExpenses',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalExpensesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalExpenses',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalExpensesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalExpenses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalTripsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalTrips',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalTripsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalTrips',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalTripsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalTrips',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> totalTripsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalTrips',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
          QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
          QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension TravelStatsIsarModelQueryObject on QueryBuilder<TravelStatsIsarModel,
    TravelStatsIsarModel, QFilterCondition> {}

extension TravelStatsIsarModelQueryLinks on QueryBuilder<TravelStatsIsarModel,
    TravelStatsIsarModel, QFilterCondition> {}

extension TravelStatsIsarModelQuerySortBy
    on QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QSortBy> {
  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByStatsId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statsId', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByStatsIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statsId', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalCountries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCountries', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalCountriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCountries', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalDaysTraveled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDaysTraveled', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalDaysTraveledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDaysTraveled', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceKm', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalDistanceKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceKm', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalExpenses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExpenses', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalExpensesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExpenses', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalTrips() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTrips', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByTotalTripsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTrips', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension TravelStatsIsarModelQuerySortThenBy
    on QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QSortThenBy> {
  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByStatsId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statsId', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByStatsIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statsId', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalCountries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCountries', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalCountriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCountries', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalDaysTraveled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDaysTraveled', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalDaysTraveledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDaysTraveled', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceKm', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalDistanceKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceKm', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalExpenses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExpenses', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalExpensesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExpenses', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalTrips() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTrips', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByTotalTripsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTrips', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension TravelStatsIsarModelQueryWhereDistinct
    on QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct> {
  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByStatsId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statsId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctBySyncStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByTotalCountries() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCountries');
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByTotalDaysTraveled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDaysTraveled');
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByTotalDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDistanceKm');
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByTotalExpenses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalExpenses');
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByTotalTrips() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalTrips');
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<TravelStatsIsarModel, TravelStatsIsarModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension TravelStatsIsarModelQueryProperty on QueryBuilder<
    TravelStatsIsarModel, TravelStatsIsarModel, QQueryProperty> {
  QueryBuilder<TravelStatsIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TravelStatsIsarModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TravelStatsIsarModel, bool, QQueryOperations>
      isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<TravelStatsIsarModel, String, QQueryOperations>
      statsIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statsId');
    });
  }

  QueryBuilder<TravelStatsIsarModel, SyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<TravelStatsIsarModel, int, QQueryOperations>
      totalCountriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCountries');
    });
  }

  QueryBuilder<TravelStatsIsarModel, int, QQueryOperations>
      totalDaysTraveledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDaysTraveled');
    });
  }

  QueryBuilder<TravelStatsIsarModel, double, QQueryOperations>
      totalDistanceKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDistanceKm');
    });
  }

  QueryBuilder<TravelStatsIsarModel, double, QQueryOperations>
      totalExpensesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalExpenses');
    });
  }

  QueryBuilder<TravelStatsIsarModel, int, QQueryOperations>
      totalTripsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalTrips');
    });
  }

  QueryBuilder<TravelStatsIsarModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<TravelStatsIsarModel, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
