import 'dart:isolate';

import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:mars/services/methods.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'drift.g.dart';

@DataClassName('LocalOrder')
class LocalOrders extends Table {
  IntColumn get id => integer().autoIncrement().nullable()();
  TextColumn get fid => text()();
  TextColumn get name => text()();
  TextColumn get imgurl => text()();
  TextColumn get details => text().nullable()();
  IntColumn get quantity => integer()();
  IntColumn get price => integer()();
  IntColumn get discount => integer()();
}

@DriftDatabase(tables: [
  LocalOrders
], daos: [
  LocalOrdersDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        Isolate.spawn((message) {}, 'message');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          m.addColumn(
            localOrders,
            GeneratedColumn('details', 'localOrders', true,
                type: DriftSqlType.string),
          );
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file, logStatements: true);
  });
}

@DriftAccessor(
  tables: [LocalOrders],
)
class LocalOrdersDao extends DatabaseAccessor<AppDatabase>
    with _$LocalOrdersDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  LocalOrdersDao(this.db) : super(db);

  Stream<int> getOrderSize() {
    Stream<List<LocalOrder>> order = select(localOrders).watch();

    //returns the count of all items in the order

    return order.map((event) {
      int count = 0;
      for (var element in event) {
        count = count + element.quantity;
      }
      return count;
    });
  }

  Stream<int> getOrderTotal() {
    Stream<List<LocalOrder>> order = select(localOrders).watch();

    return order.map((event) {
      int total = 0;
      for (var element in event) {
        total = total +
            element.quantity *
                Methods.roundPriceWithDiscountIQD(
                    price: element.price, discount: element.discount);
      }
      return total;
    });
  }

  Future<int> getOrderTotalFuture() async {
    List<LocalOrder> order = await select(localOrders).get();

    int total = 0;
    for (var element in order) {
      total = total +
          element.quantity *
              Methods.roundPriceWithDiscountIQD(
                  price: element.price, discount: element.discount);
    }
    return total;
  }

  Stream<int> watchOrderTotalFuture() {
    Stream<List<LocalOrder>> order = select(localOrders).watch();

    return order.map((event) {
      int total = 0;
      for (var element in event) {
        total = total +
            element.quantity *
                Methods.roundPriceWithDiscountIQD(
                    price: element.price, discount: element.discount);
      }
      return total;
    });
  }

  Stream<LocalOrder> searchInOrder(String name) {
    return (select(localOrders)
          ..where((tbl) {
            return tbl.name.equals(name);
          }))
        .watchSingle();
  }

  Future<LocalOrder?> searchInOrderFuture(String name) {
    return (select(localOrders)
          ..where((tbl) {
            return tbl.name.equals(name);
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<LocalOrder>> getTheOrder() {
    return select(localOrders).get();
  }

  Stream<List<LocalOrder>> watchTheOrder() {
    return select(localOrders).watch();
  }

  Future insertInTheOrder(LocalOrder order) => into(localOrders).insert(order);

  // Future increaseQuantity(LocalOrder oldOrder) {
  //   LocalOrder order = LocalOrder(
  //       id: oldOrder.id,
  //       fid: oldOrder.fid,
  //       name: oldOrder.name,
  //       imgurl: oldOrder.imgurl,
  //       price: oldOrder.price,
  //       discount: oldOrder.discount,
  //       quantity: oldOrder.quantity + 1);
  //   return update(localOrders).replace(order);
  // }

  // Future decreaseQuantity(LocalOrder oldOrder) {
  //   if (oldOrder.quantity == 1) {
  //     return delete(localOrders).delete(oldOrder);
  //   }
  //   LocalOrder order = LocalOrder(
  //       id: oldOrder.id,
  //       fid: oldOrder.fid,
  //       name: oldOrder.name,
  //       imgurl: oldOrder.imgurl,
  //       price: oldOrder.price,
  //       discount: oldOrder.discount,
  //       quantity: oldOrder.quantity - 1);
  //   return update(localOrders).replace(order);
  // }

  Future deleteFromTheOrder(LocalOrder order) {
    return (delete(localOrders)..where((tbl) => tbl.id.equals(order.id!))).go();
  }

  Future clearTheOrder() => delete(localOrders).go();
}
