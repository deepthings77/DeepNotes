// import 'dart:async';


// import 'package:deepnotes/extentions/list/filter.dart';
// import 'package:deepnotes/services/crud/crud_exceptions.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class NotesService {
//   Database? _db;

//   DatabaseUser? _user;

//   List<DatabaseNotes> _notes = [];

//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNotes>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NotesService() => _shared;

//   late final StreamController<List<DatabaseNotes>> _notesStreamController;

//   Stream<List<DatabaseNotes>> get allNotes =>
//       _notesStreamController.stream.filter((notes) {
//         final currentUser = _user;
//         if (currentUser != null) {
//          return notes.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });

//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNote();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   Future<DatabaseNotes> updateNotes(
//       {required DatabaseNotes notes, required String text}) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     //make sure note exist
//     await getNote(id: notes.id);
// //update DB
//     final updateCount = await db.update(
//       noteTable,
//       {
//         textColumn: text,
//         isSyncedWithCloudColumn: 0,
//       },
//       where: 'id = ?',
//       whereArgs: [notes.id],
//     );
//     if (updateCount == 0) {
//       throw CouldNotUpdateNotes();
//     } else {
//       final updateNote = await getNote(id: notes.id);
//       _notes.removeWhere((note) => note.id == updateNote.id);
//       _notes.add(updateNote);
//       _notesStreamController.add(_notes);
//       return updateNote;
//     }
//   }

//   Future<Iterable<DatabaseNotes>> getAllNote() async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//     );

//     return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
//   }

//   Future<DatabaseNotes> getNote({required int id}) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     final notes =
//         await db.query(noteTable, limit: 1, where: 'id =?', whereArgs: [id]);

//     if (notes.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final note = DatabaseNotes.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);

//       return note;
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     final numberOfDeletions = db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDeletions;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     final deletedCount =
//         await db.delete(noteTable, where: 'id = ? ', whereArgs: [id]);
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<DatabaseNotes> createNote({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();

//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }
//     const text = '';
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });
//     final note = DatabaseNotes(
//         id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true);

//     _notes.add(note);
//     _notesStreamController.add(_notes);

//     return note;
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     final results = await db.query(userTable,
//         limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);

//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     final results = await db.query(userTable,
//         limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);

//     if (results.isNotEmpty) {
//       throw UserAlreadyExist();
//     }
//     final userId =
//         await db.insert(userTable, {emailColumn: email.toLowerCase()});
//     return DatabaseUser(id: userId, email: email);
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(userTable,
//         where: 'email = ? ', whereArgs: [email.toLowerCase()]);
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenedException {}
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenedException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;

//       await db.execute(createUserTable);

//       await db.execute(createNoteTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentDirectory();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Persone , ID = $id, email = $email';
//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNotes {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   DatabaseNotes(
//       {required this.id,
//       required this.userId,
//       required this.text,
//       required this.isSyncedWithCloud});

//   DatabaseNotes.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Note , ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const noteTable = 'notes';
// const userTable = 'user';
// const dbName = 'notes.db';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const createUserTable = '''
// CREATE TABLE IF NOT EXISTS  "user" (
// 	"id"	INTEGER NOT NULL,
// 	"email"	TEXT NOT NULL UNIQUE,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );
// );

// ''';
// const createNoteTable = '''
// CREATE TABLE IF NOT EXISTS "notes" (
// 	"id"	INTEGER NOT NULL,
// 	"user_id"	INTEGER NOT NULL,
// 	"text"	TEXT,
// 	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
// 	FOREIGN KEY("user_id") REFERENCES "user"("id"),
// 	PRIMARY KEY("id" AUTOINCREMENT)

// );

// ''';
