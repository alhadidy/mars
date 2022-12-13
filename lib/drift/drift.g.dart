// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift.dart';

// ignore_for_file: type=lint
class LocalOrder extends DataClass implements Insertable<LocalOrder> {
  final int? id;
  final String fid;
  final String name;
  final String imgurl;
  final int quantity;
  final int price;
  final int discount;
  const LocalOrder(
      {this.id,
      required this.fid,
      required this.name,
      required this.imgurl,
      required this.quantity,
      required this.price,
      required this.discount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['fid'] = Variable<String>(fid);
    map['name'] = Variable<String>(name);
    map['imgurl'] = Variable<String>(imgurl);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<int>(price);
    map['discount'] = Variable<int>(discount);
    return map;
  }

  LocalOrdersCompanion toCompanion(bool nullToAbsent) {
    return LocalOrdersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      fid: Value(fid),
      name: Value(name),
      imgurl: Value(imgurl),
      quantity: Value(quantity),
      price: Value(price),
      discount: Value(discount),
    );
  }

  factory LocalOrder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalOrder(
      id: serializer.fromJson<int?>(json['id']),
      fid: serializer.fromJson<String>(json['fid']),
      name: serializer.fromJson<String>(json['name']),
      imgurl: serializer.fromJson<String>(json['imgurl']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<int>(json['price']),
      discount: serializer.fromJson<int>(json['discount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'fid': serializer.toJson<String>(fid),
      'name': serializer.toJson<String>(name),
      'imgurl': serializer.toJson<String>(imgurl),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<int>(price),
      'discount': serializer.toJson<int>(discount),
    };
  }

  LocalOrder copyWith(
          {Value<int?> id = const Value.absent(),
          String? fid,
          String? name,
          String? imgurl,
          int? quantity,
          int? price,
          int? discount}) =>
      LocalOrder(
        id: id.present ? id.value : this.id,
        fid: fid ?? this.fid,
        name: name ?? this.name,
        imgurl: imgurl ?? this.imgurl,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        discount: discount ?? this.discount,
      );
  @override
  String toString() {
    return (StringBuffer('LocalOrder(')
          ..write('id: $id, ')
          ..write('fid: $fid, ')
          ..write('name: $name, ')
          ..write('imgurl: $imgurl, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('discount: $discount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fid, name, imgurl, quantity, price, discount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalOrder &&
          other.id == this.id &&
          other.fid == this.fid &&
          other.name == this.name &&
          other.imgurl == this.imgurl &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.discount == this.discount);
}

class LocalOrdersCompanion extends UpdateCompanion<LocalOrder> {
  final Value<int?> id;
  final Value<String> fid;
  final Value<String> name;
  final Value<String> imgurl;
  final Value<int> quantity;
  final Value<int> price;
  final Value<int> discount;
  const LocalOrdersCompanion({
    this.id = const Value.absent(),
    this.fid = const Value.absent(),
    this.name = const Value.absent(),
    this.imgurl = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.discount = const Value.absent(),
  });
  LocalOrdersCompanion.insert({
    this.id = const Value.absent(),
    required String fid,
    required String name,
    required String imgurl,
    required int quantity,
    required int price,
    required int discount,
  })  : fid = Value(fid),
        name = Value(name),
        imgurl = Value(imgurl),
        quantity = Value(quantity),
        price = Value(price),
        discount = Value(discount);
  static Insertable<LocalOrder> custom({
    Expression<int>? id,
    Expression<String>? fid,
    Expression<String>? name,
    Expression<String>? imgurl,
    Expression<int>? quantity,
    Expression<int>? price,
    Expression<int>? discount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fid != null) 'fid': fid,
      if (name != null) 'name': name,
      if (imgurl != null) 'imgurl': imgurl,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (discount != null) 'discount': discount,
    });
  }

  LocalOrdersCompanion copyWith(
      {Value<int?>? id,
      Value<String>? fid,
      Value<String>? name,
      Value<String>? imgurl,
      Value<int>? quantity,
      Value<int>? price,
      Value<int>? discount}) {
    return LocalOrdersCompanion(
      id: id ?? this.id,
      fid: fid ?? this.fid,
      name: name ?? this.name,
      imgurl: imgurl ?? this.imgurl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discount: discount ?? this.discount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fid.present) {
      map['fid'] = Variable<String>(fid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imgurl.present) {
      map['imgurl'] = Variable<String>(imgurl.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalOrdersCompanion(')
          ..write('id: $id, ')
          ..write('fid: $fid, ')
          ..write('name: $name, ')
          ..write('imgurl: $imgurl, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('discount: $discount')
          ..write(')'))
        .toString();
  }
}

class $LocalOrdersTable extends LocalOrders
    with TableInfo<$LocalOrdersTable, LocalOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fidMeta = const VerificationMeta('fid');
  @override
  late final GeneratedColumn<String> fid = GeneratedColumn<String>(
      'fid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imgurlMeta = const VerificationMeta('imgurl');
  @override
  late final GeneratedColumn<String> imgurl = GeneratedColumn<String>(
      'imgurl', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
      'price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
      'discount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fid, name, imgurl, quantity, price, discount];
  @override
  String get aliasedName => _alias ?? 'local_orders';
  @override
  String get actualTableName => 'local_orders';
  @override
  VerificationContext validateIntegrity(Insertable<LocalOrder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fid')) {
      context.handle(
          _fidMeta, fid.isAcceptableOrUnknown(data['fid']!, _fidMeta));
    } else if (isInserting) {
      context.missing(_fidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('imgurl')) {
      context.handle(_imgurlMeta,
          imgurl.isAcceptableOrUnknown(data['imgurl']!, _imgurlMeta));
    } else if (isInserting) {
      context.missing(_imgurlMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    } else if (isInserting) {
      context.missing(_discountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalOrder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      fid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imgurl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}imgurl'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount'])!,
    );
  }

  @override
  $LocalOrdersTable createAlias(String alias) {
    return $LocalOrdersTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $LocalOrdersTable localOrders = $LocalOrdersTable(this);
  late final LocalOrdersDao localOrdersDao =
      LocalOrdersDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [localOrders];
}

mixin _$LocalOrdersDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalOrdersTable get localOrders => attachedDatabase.localOrders;
}
