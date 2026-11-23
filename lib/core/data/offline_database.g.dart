// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_database.dart';

// ignore_for_file: type=lint
class $HomeSnapshotsTable extends HomeSnapshots
    with TableInfo<$HomeSnapshotsTable, HomeSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomeSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entriesMeta = const VerificationMeta(
    'entries',
  );
  @override
  late final GeneratedColumn<String> entries = GeneratedColumn<String>(
    'entries',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entries, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'home_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<HomeSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entries')) {
      context.handle(
        _entriesMeta,
        entries.isAcceptableOrUnknown(data['entries']!, _entriesMeta),
      );
    } else if (isInserting) {
      context.missing(_entriesMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HomeSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entries: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entries'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HomeSnapshotsTable createAlias(String alias) {
    return $HomeSnapshotsTable(attachedDatabase, alias);
  }
}

class HomeSnapshot extends DataClass implements Insertable<HomeSnapshot> {
  final int id;
  final String entries;
  final DateTime updatedAt;
  const HomeSnapshot({
    required this.id,
    required this.entries,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entries'] = Variable<String>(entries);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HomeSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return HomeSnapshotsCompanion(
      id: Value(id),
      entries: Value(entries),
      updatedAt: Value(updatedAt),
    );
  }

  factory HomeSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeSnapshot(
      id: serializer.fromJson<int>(json['id']),
      entries: serializer.fromJson<String>(json['entries']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entries': serializer.toJson<String>(entries),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HomeSnapshot copyWith({int? id, String? entries, DateTime? updatedAt}) =>
      HomeSnapshot(
        id: id ?? this.id,
        entries: entries ?? this.entries,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HomeSnapshot copyWithCompanion(HomeSnapshotsCompanion data) {
    return HomeSnapshot(
      id: data.id.present ? data.id.value : this.id,
      entries: data.entries.present ? data.entries.value : this.entries,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HomeSnapshot(')
          ..write('id: $id, ')
          ..write('entries: $entries, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entries, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeSnapshot &&
          other.id == this.id &&
          other.entries == this.entries &&
          other.updatedAt == this.updatedAt);
}

class HomeSnapshotsCompanion extends UpdateCompanion<HomeSnapshot> {
  final Value<int> id;
  final Value<String> entries;
  final Value<DateTime> updatedAt;
  const HomeSnapshotsCompanion({
    this.id = const Value.absent(),
    this.entries = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HomeSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String entries,
    required DateTime updatedAt,
  }) : entries = Value(entries),
       updatedAt = Value(updatedAt);
  static Insertable<HomeSnapshot> custom({
    Expression<int>? id,
    Expression<String>? entries,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entries != null) 'entries': entries,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HomeSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<String>? entries,
    Value<DateTime>? updatedAt,
  }) {
    return HomeSnapshotsCompanion(
      id: id ?? this.id,
      entries: entries ?? this.entries,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entries.present) {
      map['entries'] = Variable<String>(entries.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HomeSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('entries: $entries, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StokvelSnapshotsTable extends StokvelSnapshots
    with TableInfo<$StokvelSnapshotsTable, StokvelSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StokvelSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stokvelIdMeta = const VerificationMeta(
    'stokvelId',
  );
  @override
  late final GeneratedColumn<int> stokvelId = GeneratedColumn<int>(
    'stokvel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestedCycleIdMeta = const VerificationMeta(
    'requestedCycleId',
  );
  @override
  late final GeneratedColumn<int> requestedCycleId = GeneratedColumn<int>(
    'requested_cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedCycleIdMeta = const VerificationMeta(
    'cachedCycleId',
  );
  @override
  late final GeneratedColumn<int> cachedCycleId = GeneratedColumn<int>(
    'cached_cycle_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    stokvelId,
    requestedCycleId,
    cachedCycleId,
    detail,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stokvel_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<StokvelSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stokvel_id')) {
      context.handle(
        _stokvelIdMeta,
        stokvelId.isAcceptableOrUnknown(data['stokvel_id']!, _stokvelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stokvelIdMeta);
    }
    if (data.containsKey('requested_cycle_id')) {
      context.handle(
        _requestedCycleIdMeta,
        requestedCycleId.isAcceptableOrUnknown(
          data['requested_cycle_id']!,
          _requestedCycleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestedCycleIdMeta);
    }
    if (data.containsKey('cached_cycle_id')) {
      context.handle(
        _cachedCycleIdMeta,
        cachedCycleId.isAcceptableOrUnknown(
          data['cached_cycle_id']!,
          _cachedCycleIdMeta,
        ),
      );
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    } else if (isInserting) {
      context.missing(_detailMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stokvelId, requestedCycleId};
  @override
  StokvelSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StokvelSnapshot(
      stokvelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stokvel_id'],
      )!,
      requestedCycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}requested_cycle_id'],
      )!,
      cachedCycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cached_cycle_id'],
      ),
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StokvelSnapshotsTable createAlias(String alias) {
    return $StokvelSnapshotsTable(attachedDatabase, alias);
  }
}

class StokvelSnapshot extends DataClass implements Insertable<StokvelSnapshot> {
  final int stokvelId;
  final int requestedCycleId;
  final int? cachedCycleId;
  final String detail;
  final DateTime updatedAt;
  const StokvelSnapshot({
    required this.stokvelId,
    required this.requestedCycleId,
    this.cachedCycleId,
    required this.detail,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stokvel_id'] = Variable<int>(stokvelId);
    map['requested_cycle_id'] = Variable<int>(requestedCycleId);
    if (!nullToAbsent || cachedCycleId != null) {
      map['cached_cycle_id'] = Variable<int>(cachedCycleId);
    }
    map['detail'] = Variable<String>(detail);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StokvelSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return StokvelSnapshotsCompanion(
      stokvelId: Value(stokvelId),
      requestedCycleId: Value(requestedCycleId),
      cachedCycleId: cachedCycleId == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedCycleId),
      detail: Value(detail),
      updatedAt: Value(updatedAt),
    );
  }

  factory StokvelSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StokvelSnapshot(
      stokvelId: serializer.fromJson<int>(json['stokvelId']),
      requestedCycleId: serializer.fromJson<int>(json['requestedCycleId']),
      cachedCycleId: serializer.fromJson<int?>(json['cachedCycleId']),
      detail: serializer.fromJson<String>(json['detail']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stokvelId': serializer.toJson<int>(stokvelId),
      'requestedCycleId': serializer.toJson<int>(requestedCycleId),
      'cachedCycleId': serializer.toJson<int?>(cachedCycleId),
      'detail': serializer.toJson<String>(detail),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StokvelSnapshot copyWith({
    int? stokvelId,
    int? requestedCycleId,
    Value<int?> cachedCycleId = const Value.absent(),
    String? detail,
    DateTime? updatedAt,
  }) => StokvelSnapshot(
    stokvelId: stokvelId ?? this.stokvelId,
    requestedCycleId: requestedCycleId ?? this.requestedCycleId,
    cachedCycleId: cachedCycleId.present
        ? cachedCycleId.value
        : this.cachedCycleId,
    detail: detail ?? this.detail,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StokvelSnapshot copyWithCompanion(StokvelSnapshotsCompanion data) {
    return StokvelSnapshot(
      stokvelId: data.stokvelId.present ? data.stokvelId.value : this.stokvelId,
      requestedCycleId: data.requestedCycleId.present
          ? data.requestedCycleId.value
          : this.requestedCycleId,
      cachedCycleId: data.cachedCycleId.present
          ? data.cachedCycleId.value
          : this.cachedCycleId,
      detail: data.detail.present ? data.detail.value : this.detail,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StokvelSnapshot(')
          ..write('stokvelId: $stokvelId, ')
          ..write('requestedCycleId: $requestedCycleId, ')
          ..write('cachedCycleId: $cachedCycleId, ')
          ..write('detail: $detail, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    stokvelId,
    requestedCycleId,
    cachedCycleId,
    detail,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StokvelSnapshot &&
          other.stokvelId == this.stokvelId &&
          other.requestedCycleId == this.requestedCycleId &&
          other.cachedCycleId == this.cachedCycleId &&
          other.detail == this.detail &&
          other.updatedAt == this.updatedAt);
}

class StokvelSnapshotsCompanion extends UpdateCompanion<StokvelSnapshot> {
  final Value<int> stokvelId;
  final Value<int> requestedCycleId;
  final Value<int?> cachedCycleId;
  final Value<String> detail;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StokvelSnapshotsCompanion({
    this.stokvelId = const Value.absent(),
    this.requestedCycleId = const Value.absent(),
    this.cachedCycleId = const Value.absent(),
    this.detail = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StokvelSnapshotsCompanion.insert({
    required int stokvelId,
    required int requestedCycleId,
    this.cachedCycleId = const Value.absent(),
    required String detail,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : stokvelId = Value(stokvelId),
       requestedCycleId = Value(requestedCycleId),
       detail = Value(detail),
       updatedAt = Value(updatedAt);
  static Insertable<StokvelSnapshot> custom({
    Expression<int>? stokvelId,
    Expression<int>? requestedCycleId,
    Expression<int>? cachedCycleId,
    Expression<String>? detail,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stokvelId != null) 'stokvel_id': stokvelId,
      if (requestedCycleId != null) 'requested_cycle_id': requestedCycleId,
      if (cachedCycleId != null) 'cached_cycle_id': cachedCycleId,
      if (detail != null) 'detail': detail,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StokvelSnapshotsCompanion copyWith({
    Value<int>? stokvelId,
    Value<int>? requestedCycleId,
    Value<int?>? cachedCycleId,
    Value<String>? detail,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StokvelSnapshotsCompanion(
      stokvelId: stokvelId ?? this.stokvelId,
      requestedCycleId: requestedCycleId ?? this.requestedCycleId,
      cachedCycleId: cachedCycleId ?? this.cachedCycleId,
      detail: detail ?? this.detail,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stokvelId.present) {
      map['stokvel_id'] = Variable<int>(stokvelId.value);
    }
    if (requestedCycleId.present) {
      map['requested_cycle_id'] = Variable<int>(requestedCycleId.value);
    }
    if (cachedCycleId.present) {
      map['cached_cycle_id'] = Variable<int>(cachedCycleId.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StokvelSnapshotsCompanion(')
          ..write('stokvelId: $stokvelId, ')
          ..write('requestedCycleId: $requestedCycleId, ')
          ..write('cachedCycleId: $cachedCycleId, ')
          ..write('detail: $detail, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedCyclesTable extends CachedCycles
    with TableInfo<$CachedCyclesTable, CachedCycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetCentsMeta = const VerificationMeta(
    'targetCents',
  );
  @override
  late final GeneratedColumn<int> targetCents = GeneratedColumn<int>(
    'target_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiredCentsMeta = const VerificationMeta(
    'requiredCents',
  );
  @override
  late final GeneratedColumn<int> requiredCents = GeneratedColumn<int>(
    'required_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    number,
    dueDate,
    targetCents,
    requiredCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('target_cents')) {
      context.handle(
        _targetCentsMeta,
        targetCents.isAcceptableOrUnknown(
          data['target_cents']!,
          _targetCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetCentsMeta);
    }
    if (data.containsKey('required_cents')) {
      context.handle(
        _requiredCentsMeta,
        requiredCents.isAcceptableOrUnknown(
          data['required_cents']!,
          _requiredCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requiredCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      targetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_cents'],
      )!,
      requiredCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}required_cents'],
      )!,
    );
  }

  @override
  $CachedCyclesTable createAlias(String alias) {
    return $CachedCyclesTable(attachedDatabase, alias);
  }
}

class CachedCycle extends DataClass implements Insertable<CachedCycle> {
  final int id;
  final String status;
  final int number;
  final DateTime dueDate;
  final int targetCents;
  final int requiredCents;
  const CachedCycle({
    required this.id,
    required this.status,
    required this.number,
    required this.dueDate,
    required this.targetCents,
    required this.requiredCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['status'] = Variable<String>(status);
    map['number'] = Variable<int>(number);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['target_cents'] = Variable<int>(targetCents);
    map['required_cents'] = Variable<int>(requiredCents);
    return map;
  }

  CachedCyclesCompanion toCompanion(bool nullToAbsent) {
    return CachedCyclesCompanion(
      id: Value(id),
      status: Value(status),
      number: Value(number),
      dueDate: Value(dueDate),
      targetCents: Value(targetCents),
      requiredCents: Value(requiredCents),
    );
  }

  factory CachedCycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCycle(
      id: serializer.fromJson<int>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      number: serializer.fromJson<int>(json['number']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      targetCents: serializer.fromJson<int>(json['targetCents']),
      requiredCents: serializer.fromJson<int>(json['requiredCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'status': serializer.toJson<String>(status),
      'number': serializer.toJson<int>(number),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'targetCents': serializer.toJson<int>(targetCents),
      'requiredCents': serializer.toJson<int>(requiredCents),
    };
  }

  CachedCycle copyWith({
    int? id,
    String? status,
    int? number,
    DateTime? dueDate,
    int? targetCents,
    int? requiredCents,
  }) => CachedCycle(
    id: id ?? this.id,
    status: status ?? this.status,
    number: number ?? this.number,
    dueDate: dueDate ?? this.dueDate,
    targetCents: targetCents ?? this.targetCents,
    requiredCents: requiredCents ?? this.requiredCents,
  );
  CachedCycle copyWithCompanion(CachedCyclesCompanion data) {
    return CachedCycle(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      number: data.number.present ? data.number.value : this.number,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      targetCents: data.targetCents.present
          ? data.targetCents.value
          : this.targetCents,
      requiredCents: data.requiredCents.present
          ? data.requiredCents.value
          : this.requiredCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCycle(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('number: $number, ')
          ..write('dueDate: $dueDate, ')
          ..write('targetCents: $targetCents, ')
          ..write('requiredCents: $requiredCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, status, number, dueDate, targetCents, requiredCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCycle &&
          other.id == this.id &&
          other.status == this.status &&
          other.number == this.number &&
          other.dueDate == this.dueDate &&
          other.targetCents == this.targetCents &&
          other.requiredCents == this.requiredCents);
}

class CachedCyclesCompanion extends UpdateCompanion<CachedCycle> {
  final Value<int> id;
  final Value<String> status;
  final Value<int> number;
  final Value<DateTime> dueDate;
  final Value<int> targetCents;
  final Value<int> requiredCents;
  const CachedCyclesCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.number = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.targetCents = const Value.absent(),
    this.requiredCents = const Value.absent(),
  });
  CachedCyclesCompanion.insert({
    this.id = const Value.absent(),
    required String status,
    required int number,
    required DateTime dueDate,
    required int targetCents,
    required int requiredCents,
  }) : status = Value(status),
       number = Value(number),
       dueDate = Value(dueDate),
       targetCents = Value(targetCents),
       requiredCents = Value(requiredCents);
  static Insertable<CachedCycle> custom({
    Expression<int>? id,
    Expression<String>? status,
    Expression<int>? number,
    Expression<DateTime>? dueDate,
    Expression<int>? targetCents,
    Expression<int>? requiredCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (number != null) 'number': number,
      if (dueDate != null) 'due_date': dueDate,
      if (targetCents != null) 'target_cents': targetCents,
      if (requiredCents != null) 'required_cents': requiredCents,
    });
  }

  CachedCyclesCompanion copyWith({
    Value<int>? id,
    Value<String>? status,
    Value<int>? number,
    Value<DateTime>? dueDate,
    Value<int>? targetCents,
    Value<int>? requiredCents,
  }) {
    return CachedCyclesCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      number: number ?? this.number,
      dueDate: dueDate ?? this.dueDate,
      targetCents: targetCents ?? this.targetCents,
      requiredCents: requiredCents ?? this.requiredCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (targetCents.present) {
      map['target_cents'] = Variable<int>(targetCents.value);
    }
    if (requiredCents.present) {
      map['required_cents'] = Variable<int>(requiredCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCyclesCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('number: $number, ')
          ..write('dueDate: $dueDate, ')
          ..write('targetCents: $targetCents, ')
          ..write('requiredCents: $requiredCents')
          ..write(')'))
        .toString();
  }
}

class $PaymentOutboxTable extends PaymentOutbox
    with TableInfo<$PaymentOutboxTable, PaymentOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stokvelIdMeta = const VerificationMeta(
    'stokvelId',
  );
  @override
  late final GeneratedColumn<int> stokvelId = GeneratedColumn<int>(
    'stokvel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<int> cycleId = GeneratedColumn<int>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryAtMeta = const VerificationMeta(
    'retryAt',
  );
  @override
  late final GeneratedColumn<DateTime> retryAt = GeneratedColumn<DateTime>(
    'retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idempotencyKey,
    stokvelId,
    cycleId,
    userId,
    amountCents,
    createdAt,
    retryAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('stokvel_id')) {
      context.handle(
        _stokvelIdMeta,
        stokvelId.isAcceptableOrUnknown(data['stokvel_id']!, _stokvelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stokvelIdMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_at')) {
      context.handle(
        _retryAtMeta,
        retryAt.isAcceptableOrUnknown(data['retry_at']!, _retryAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idempotencyKey};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {stokvelId, cycleId, userId},
  ];
  @override
  PaymentOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentOutboxData(
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      stokvelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stokvel_id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}retry_at'],
      ),
    );
  }

  @override
  $PaymentOutboxTable createAlias(String alias) {
    return $PaymentOutboxTable(attachedDatabase, alias);
  }
}

class PaymentOutboxData extends DataClass
    implements Insertable<PaymentOutboxData> {
  final String idempotencyKey;
  final int stokvelId;
  final int cycleId;
  final int userId;
  final int amountCents;
  final DateTime createdAt;
  final DateTime? retryAt;
  const PaymentOutboxData({
    required this.idempotencyKey,
    required this.stokvelId,
    required this.cycleId,
    required this.userId,
    required this.amountCents,
    required this.createdAt,
    this.retryAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['stokvel_id'] = Variable<int>(stokvelId);
    map['cycle_id'] = Variable<int>(cycleId);
    map['user_id'] = Variable<int>(userId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || retryAt != null) {
      map['retry_at'] = Variable<DateTime>(retryAt);
    }
    return map;
  }

  PaymentOutboxCompanion toCompanion(bool nullToAbsent) {
    return PaymentOutboxCompanion(
      idempotencyKey: Value(idempotencyKey),
      stokvelId: Value(stokvelId),
      cycleId: Value(cycleId),
      userId: Value(userId),
      amountCents: Value(amountCents),
      createdAt: Value(createdAt),
      retryAt: retryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(retryAt),
    );
  }

  factory PaymentOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentOutboxData(
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      stokvelId: serializer.fromJson<int>(json['stokvelId']),
      cycleId: serializer.fromJson<int>(json['cycleId']),
      userId: serializer.fromJson<int>(json['userId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryAt: serializer.fromJson<DateTime?>(json['retryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'stokvelId': serializer.toJson<int>(stokvelId),
      'cycleId': serializer.toJson<int>(cycleId),
      'userId': serializer.toJson<int>(userId),
      'amountCents': serializer.toJson<int>(amountCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryAt': serializer.toJson<DateTime?>(retryAt),
    };
  }

  PaymentOutboxData copyWith({
    String? idempotencyKey,
    int? stokvelId,
    int? cycleId,
    int? userId,
    int? amountCents,
    DateTime? createdAt,
    Value<DateTime?> retryAt = const Value.absent(),
  }) => PaymentOutboxData(
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    stokvelId: stokvelId ?? this.stokvelId,
    cycleId: cycleId ?? this.cycleId,
    userId: userId ?? this.userId,
    amountCents: amountCents ?? this.amountCents,
    createdAt: createdAt ?? this.createdAt,
    retryAt: retryAt.present ? retryAt.value : this.retryAt,
  );
  PaymentOutboxData copyWithCompanion(PaymentOutboxCompanion data) {
    return PaymentOutboxData(
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      stokvelId: data.stokvelId.present ? data.stokvelId.value : this.stokvelId,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      userId: data.userId.present ? data.userId.value : this.userId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryAt: data.retryAt.present ? data.retryAt.value : this.retryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentOutboxData(')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('stokvelId: $stokvelId, ')
          ..write('cycleId: $cycleId, ')
          ..write('userId: $userId, ')
          ..write('amountCents: $amountCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryAt: $retryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idempotencyKey,
    stokvelId,
    cycleId,
    userId,
    amountCents,
    createdAt,
    retryAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentOutboxData &&
          other.idempotencyKey == this.idempotencyKey &&
          other.stokvelId == this.stokvelId &&
          other.cycleId == this.cycleId &&
          other.userId == this.userId &&
          other.amountCents == this.amountCents &&
          other.createdAt == this.createdAt &&
          other.retryAt == this.retryAt);
}

class PaymentOutboxCompanion extends UpdateCompanion<PaymentOutboxData> {
  final Value<String> idempotencyKey;
  final Value<int> stokvelId;
  final Value<int> cycleId;
  final Value<int> userId;
  final Value<int> amountCents;
  final Value<DateTime> createdAt;
  final Value<DateTime?> retryAt;
  final Value<int> rowid;
  const PaymentOutboxCompanion({
    this.idempotencyKey = const Value.absent(),
    this.stokvelId = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.userId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentOutboxCompanion.insert({
    required String idempotencyKey,
    required int stokvelId,
    required int cycleId,
    required int userId,
    required int amountCents,
    required DateTime createdAt,
    this.retryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : idempotencyKey = Value(idempotencyKey),
       stokvelId = Value(stokvelId),
       cycleId = Value(cycleId),
       userId = Value(userId),
       amountCents = Value(amountCents),
       createdAt = Value(createdAt);
  static Insertable<PaymentOutboxData> custom({
    Expression<String>? idempotencyKey,
    Expression<int>? stokvelId,
    Expression<int>? cycleId,
    Expression<int>? userId,
    Expression<int>? amountCents,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? retryAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (stokvelId != null) 'stokvel_id': stokvelId,
      if (cycleId != null) 'cycle_id': cycleId,
      if (userId != null) 'user_id': userId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (createdAt != null) 'created_at': createdAt,
      if (retryAt != null) 'retry_at': retryAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentOutboxCompanion copyWith({
    Value<String>? idempotencyKey,
    Value<int>? stokvelId,
    Value<int>? cycleId,
    Value<int>? userId,
    Value<int>? amountCents,
    Value<DateTime>? createdAt,
    Value<DateTime?>? retryAt,
    Value<int>? rowid,
  }) {
    return PaymentOutboxCompanion(
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      stokvelId: stokvelId ?? this.stokvelId,
      cycleId: cycleId ?? this.cycleId,
      userId: userId ?? this.userId,
      amountCents: amountCents ?? this.amountCents,
      createdAt: createdAt ?? this.createdAt,
      retryAt: retryAt ?? this.retryAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (stokvelId.present) {
      map['stokvel_id'] = Variable<int>(stokvelId.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<int>(cycleId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryAt.present) {
      map['retry_at'] = Variable<DateTime>(retryAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentOutboxCompanion(')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('stokvelId: $stokvelId, ')
          ..write('cycleId: $cycleId, ')
          ..write('userId: $userId, ')
          ..write('amountCents: $amountCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryAt: $retryAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$OfflineDatabase extends GeneratedDatabase {
  _$OfflineDatabase(QueryExecutor e) : super(e);
  $OfflineDatabaseManager get managers => $OfflineDatabaseManager(this);
  late final $HomeSnapshotsTable homeSnapshots = $HomeSnapshotsTable(this);
  late final $StokvelSnapshotsTable stokvelSnapshots = $StokvelSnapshotsTable(
    this,
  );
  late final $CachedCyclesTable cachedCycles = $CachedCyclesTable(this);
  late final $PaymentOutboxTable paymentOutbox = $PaymentOutboxTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    homeSnapshots,
    stokvelSnapshots,
    cachedCycles,
    paymentOutbox,
  ];
}

typedef $$HomeSnapshotsTableCreateCompanionBuilder =
    HomeSnapshotsCompanion Function({
      Value<int> id,
      required String entries,
      required DateTime updatedAt,
    });
typedef $$HomeSnapshotsTableUpdateCompanionBuilder =
    HomeSnapshotsCompanion Function({
      Value<int> id,
      Value<String> entries,
      Value<DateTime> updatedAt,
    });

class $$HomeSnapshotsTableFilterComposer
    extends Composer<_$OfflineDatabase, $HomeSnapshotsTable> {
  $$HomeSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entries => $composableBuilder(
    column: $table.entries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HomeSnapshotsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $HomeSnapshotsTable> {
  $$HomeSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entries => $composableBuilder(
    column: $table.entries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HomeSnapshotsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $HomeSnapshotsTable> {
  $$HomeSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entries =>
      $composableBuilder(column: $table.entries, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HomeSnapshotsTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $HomeSnapshotsTable,
          HomeSnapshot,
          $$HomeSnapshotsTableFilterComposer,
          $$HomeSnapshotsTableOrderingComposer,
          $$HomeSnapshotsTableAnnotationComposer,
          $$HomeSnapshotsTableCreateCompanionBuilder,
          $$HomeSnapshotsTableUpdateCompanionBuilder,
          (
            HomeSnapshot,
            BaseReferences<
              _$OfflineDatabase,
              $HomeSnapshotsTable,
              HomeSnapshot
            >,
          ),
          HomeSnapshot,
          PrefetchHooks Function()
        > {
  $$HomeSnapshotsTableTableManager(
    _$OfflineDatabase db,
    $HomeSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomeSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HomeSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HomeSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entries = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => HomeSnapshotsCompanion(
                id: id,
                entries: entries,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entries,
                required DateTime updatedAt,
              }) => HomeSnapshotsCompanion.insert(
                id: id,
                entries: entries,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HomeSnapshotsTable, HomeSnapshot>(table),
                  BaseReferences<
                    _$OfflineDatabase,
                    $HomeSnapshotsTable,
                    HomeSnapshot
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HomeSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $HomeSnapshotsTable,
      HomeSnapshot,
      $$HomeSnapshotsTableFilterComposer,
      $$HomeSnapshotsTableOrderingComposer,
      $$HomeSnapshotsTableAnnotationComposer,
      $$HomeSnapshotsTableCreateCompanionBuilder,
      $$HomeSnapshotsTableUpdateCompanionBuilder,
      (
        HomeSnapshot,
        BaseReferences<_$OfflineDatabase, $HomeSnapshotsTable, HomeSnapshot>,
      ),
      HomeSnapshot,
      PrefetchHooks Function()
    >;
typedef $$StokvelSnapshotsTableCreateCompanionBuilder =
    StokvelSnapshotsCompanion Function({
      required int stokvelId,
      required int requestedCycleId,
      Value<int?> cachedCycleId,
      required String detail,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StokvelSnapshotsTableUpdateCompanionBuilder =
    StokvelSnapshotsCompanion Function({
      Value<int> stokvelId,
      Value<int> requestedCycleId,
      Value<int?> cachedCycleId,
      Value<String> detail,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$StokvelSnapshotsTableFilterComposer
    extends Composer<_$OfflineDatabase, $StokvelSnapshotsTable> {
  $$StokvelSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get requestedCycleId => $composableBuilder(
    column: $table.requestedCycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cachedCycleId => $composableBuilder(
    column: $table.cachedCycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StokvelSnapshotsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $StokvelSnapshotsTable> {
  $$StokvelSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get requestedCycleId => $composableBuilder(
    column: $table.requestedCycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cachedCycleId => $composableBuilder(
    column: $table.cachedCycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StokvelSnapshotsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $StokvelSnapshotsTable> {
  $$StokvelSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get stokvelId =>
      $composableBuilder(column: $table.stokvelId, builder: (column) => column);

  GeneratedColumn<int> get requestedCycleId => $composableBuilder(
    column: $table.requestedCycleId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cachedCycleId => $composableBuilder(
    column: $table.cachedCycleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StokvelSnapshotsTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $StokvelSnapshotsTable,
          StokvelSnapshot,
          $$StokvelSnapshotsTableFilterComposer,
          $$StokvelSnapshotsTableOrderingComposer,
          $$StokvelSnapshotsTableAnnotationComposer,
          $$StokvelSnapshotsTableCreateCompanionBuilder,
          $$StokvelSnapshotsTableUpdateCompanionBuilder,
          (
            StokvelSnapshot,
            BaseReferences<
              _$OfflineDatabase,
              $StokvelSnapshotsTable,
              StokvelSnapshot
            >,
          ),
          StokvelSnapshot,
          PrefetchHooks Function()
        > {
  $$StokvelSnapshotsTableTableManager(
    _$OfflineDatabase db,
    $StokvelSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StokvelSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StokvelSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StokvelSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> stokvelId = const Value.absent(),
                Value<int> requestedCycleId = const Value.absent(),
                Value<int?> cachedCycleId = const Value.absent(),
                Value<String> detail = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StokvelSnapshotsCompanion(
                stokvelId: stokvelId,
                requestedCycleId: requestedCycleId,
                cachedCycleId: cachedCycleId,
                detail: detail,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int stokvelId,
                required int requestedCycleId,
                Value<int?> cachedCycleId = const Value.absent(),
                required String detail,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StokvelSnapshotsCompanion.insert(
                stokvelId: stokvelId,
                requestedCycleId: requestedCycleId,
                cachedCycleId: cachedCycleId,
                detail: detail,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StokvelSnapshotsTable, StokvelSnapshot>(table),
                  BaseReferences<
                    _$OfflineDatabase,
                    $StokvelSnapshotsTable,
                    StokvelSnapshot
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StokvelSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $StokvelSnapshotsTable,
      StokvelSnapshot,
      $$StokvelSnapshotsTableFilterComposer,
      $$StokvelSnapshotsTableOrderingComposer,
      $$StokvelSnapshotsTableAnnotationComposer,
      $$StokvelSnapshotsTableCreateCompanionBuilder,
      $$StokvelSnapshotsTableUpdateCompanionBuilder,
      (
        StokvelSnapshot,
        BaseReferences<
          _$OfflineDatabase,
          $StokvelSnapshotsTable,
          StokvelSnapshot
        >,
      ),
      StokvelSnapshot,
      PrefetchHooks Function()
    >;
typedef $$CachedCyclesTableCreateCompanionBuilder =
    CachedCyclesCompanion Function({
      Value<int> id,
      required String status,
      required int number,
      required DateTime dueDate,
      required int targetCents,
      required int requiredCents,
    });
typedef $$CachedCyclesTableUpdateCompanionBuilder =
    CachedCyclesCompanion Function({
      Value<int> id,
      Value<String> status,
      Value<int> number,
      Value<DateTime> dueDate,
      Value<int> targetCents,
      Value<int> requiredCents,
    });

class $$CachedCyclesTableFilterComposer
    extends Composer<_$OfflineDatabase, $CachedCyclesTable> {
  $$CachedCyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get requiredCents => $composableBuilder(
    column: $table.requiredCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCyclesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $CachedCyclesTable> {
  $$CachedCyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get requiredCents => $composableBuilder(
    column: $table.requiredCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCyclesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $CachedCyclesTable> {
  $$CachedCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get requiredCents => $composableBuilder(
    column: $table.requiredCents,
    builder: (column) => column,
  );
}

class $$CachedCyclesTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $CachedCyclesTable,
          CachedCycle,
          $$CachedCyclesTableFilterComposer,
          $$CachedCyclesTableOrderingComposer,
          $$CachedCyclesTableAnnotationComposer,
          $$CachedCyclesTableCreateCompanionBuilder,
          $$CachedCyclesTableUpdateCompanionBuilder,
          (
            CachedCycle,
            BaseReferences<_$OfflineDatabase, $CachedCyclesTable, CachedCycle>,
          ),
          CachedCycle,
          PrefetchHooks Function()
        > {
  $$CachedCyclesTableTableManager(
    _$OfflineDatabase db,
    $CachedCyclesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int> targetCents = const Value.absent(),
                Value<int> requiredCents = const Value.absent(),
              }) => CachedCyclesCompanion(
                id: id,
                status: status,
                number: number,
                dueDate: dueDate,
                targetCents: targetCents,
                requiredCents: requiredCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String status,
                required int number,
                required DateTime dueDate,
                required int targetCents,
                required int requiredCents,
              }) => CachedCyclesCompanion.insert(
                id: id,
                status: status,
                number: number,
                dueDate: dueDate,
                targetCents: targetCents,
                requiredCents: requiredCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedCyclesTable, CachedCycle>(table),
                  BaseReferences<
                    _$OfflineDatabase,
                    $CachedCyclesTable,
                    CachedCycle
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $CachedCyclesTable,
      CachedCycle,
      $$CachedCyclesTableFilterComposer,
      $$CachedCyclesTableOrderingComposer,
      $$CachedCyclesTableAnnotationComposer,
      $$CachedCyclesTableCreateCompanionBuilder,
      $$CachedCyclesTableUpdateCompanionBuilder,
      (
        CachedCycle,
        BaseReferences<_$OfflineDatabase, $CachedCyclesTable, CachedCycle>,
      ),
      CachedCycle,
      PrefetchHooks Function()
    >;
typedef $$PaymentOutboxTableCreateCompanionBuilder =
    PaymentOutboxCompanion Function({
      required String idempotencyKey,
      required int stokvelId,
      required int cycleId,
      required int userId,
      required int amountCents,
      required DateTime createdAt,
      Value<DateTime?> retryAt,
      Value<int> rowid,
    });
typedef $$PaymentOutboxTableUpdateCompanionBuilder =
    PaymentOutboxCompanion Function({
      Value<String> idempotencyKey,
      Value<int> stokvelId,
      Value<int> cycleId,
      Value<int> userId,
      Value<int> amountCents,
      Value<DateTime> createdAt,
      Value<DateTime?> retryAt,
      Value<int> rowid,
    });

class $$PaymentOutboxTableFilterComposer
    extends Composer<_$OfflineDatabase, $PaymentOutboxTable> {
  $$PaymentOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get retryAt => $composableBuilder(
    column: $table.retryAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentOutboxTableOrderingComposer
    extends Composer<_$OfflineDatabase, $PaymentOutboxTable> {
  $$PaymentOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get retryAt => $composableBuilder(
    column: $table.retryAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentOutboxTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $PaymentOutboxTable> {
  $$PaymentOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stokvelId =>
      $composableBuilder(column: $table.stokvelId, builder: (column) => column);

  GeneratedColumn<int> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get retryAt =>
      $composableBuilder(column: $table.retryAt, builder: (column) => column);
}

class $$PaymentOutboxTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $PaymentOutboxTable,
          PaymentOutboxData,
          $$PaymentOutboxTableFilterComposer,
          $$PaymentOutboxTableOrderingComposer,
          $$PaymentOutboxTableAnnotationComposer,
          $$PaymentOutboxTableCreateCompanionBuilder,
          $$PaymentOutboxTableUpdateCompanionBuilder,
          (
            PaymentOutboxData,
            BaseReferences<
              _$OfflineDatabase,
              $PaymentOutboxTable,
              PaymentOutboxData
            >,
          ),
          PaymentOutboxData,
          PrefetchHooks Function()
        > {
  $$PaymentOutboxTableTableManager(
    _$OfflineDatabase db,
    $PaymentOutboxTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> idempotencyKey = const Value.absent(),
                Value<int> stokvelId = const Value.absent(),
                Value<int> cycleId = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> retryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentOutboxCompanion(
                idempotencyKey: idempotencyKey,
                stokvelId: stokvelId,
                cycleId: cycleId,
                userId: userId,
                amountCents: amountCents,
                createdAt: createdAt,
                retryAt: retryAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String idempotencyKey,
                required int stokvelId,
                required int cycleId,
                required int userId,
                required int amountCents,
                required DateTime createdAt,
                Value<DateTime?> retryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentOutboxCompanion.insert(
                idempotencyKey: idempotencyKey,
                stokvelId: stokvelId,
                cycleId: cycleId,
                userId: userId,
                amountCents: amountCents,
                createdAt: createdAt,
                retryAt: retryAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentOutboxTable, PaymentOutboxData>(table),
                  BaseReferences<
                    _$OfflineDatabase,
                    $PaymentOutboxTable,
                    PaymentOutboxData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $PaymentOutboxTable,
      PaymentOutboxData,
      $$PaymentOutboxTableFilterComposer,
      $$PaymentOutboxTableOrderingComposer,
      $$PaymentOutboxTableAnnotationComposer,
      $$PaymentOutboxTableCreateCompanionBuilder,
      $$PaymentOutboxTableUpdateCompanionBuilder,
      (
        PaymentOutboxData,
        BaseReferences<
          _$OfflineDatabase,
          $PaymentOutboxTable,
          PaymentOutboxData
        >,
      ),
      PaymentOutboxData,
      PrefetchHooks Function()
    >;

class $OfflineDatabaseManager {
  final _$OfflineDatabase _db;
  $OfflineDatabaseManager(this._db);
  $$HomeSnapshotsTableTableManager get homeSnapshots =>
      $$HomeSnapshotsTableTableManager(_db, _db.homeSnapshots);
  $$StokvelSnapshotsTableTableManager get stokvelSnapshots =>
      $$StokvelSnapshotsTableTableManager(_db, _db.stokvelSnapshots);
  $$CachedCyclesTableTableManager get cachedCycles =>
      $$CachedCyclesTableTableManager(_db, _db.cachedCycles);
  $$PaymentOutboxTableTableManager get paymentOutbox =>
      $$PaymentOutboxTableTableManager(_db, _db.paymentOutbox);
}
