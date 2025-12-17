import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<void> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // 1. Create user via Firebase Auth
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCred.user!.uid;

      // 2. Update display name (optional)
      if (displayName != null && displayName.isNotEmpty) {
        await userCred.user!.updateDisplayName(displayName);
      }

      // 3. Simpan data user ke Firestore
      await _firestore.collection("users").doc(uid).set({
        "uid": uid,
        "name": displayName ?? "",
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Terjadi kesalahan");
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<UserCredential> logInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Failed to send reset email: ${e.toString()}');
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    await _updateUserProfile(() async {
      await _requireUser().updateDisplayName(displayName.trim());
    }, 'display name');
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _requireUser().updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Failed to update password: ${e.toString()}');
    }
  }

  Future<void> reauthenticateWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );
      await _requireUser().reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Re-authentication failed: ${e.toString()}');
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  User _requireUser() {
    final user = currentUser;
    if (user == null) {
      throw AuthException('No user is currently signed in');
    }
    return user;
  }

  Future<String?> getUserIdFromFirestore(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.data()?["uid"];
  }

  Future<String?> getUserNameFromFirestore(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.data()?["name"];
  }

  Future<String?> getUserEmailFromFirestore(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.data()?["email"];
  }

  Future<void> _updateUserProfile(
    Future<void> Function() updateFn,
    String fieldName,
  ) async {
    try {
      await updateFn();
      await _requireUser().reload();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Failed to update $fieldName: ${e.toString()}');
    }
  }

  Future<void> _deleteSubCollection({
    required String uid,
    required String collectionName,
  }) async {
    final collectionRef = _firestore
        .collection('users')
        .doc(uid)
        .collection(collectionName);

    final snapshot = await collectionRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final user = _requireUser();

      // 1️⃣ Re-authenticate
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      final uid = user.uid;

      // 2️⃣ Hapus seluruh subcollection user
      await _deleteSubCollection(uid: uid, collectionName: 'diagnoses');
      await _deleteSubCollection(uid: uid, collectionName: 'messages');
      await _deleteSubCollection(uid: uid, collectionName: 'saved_medicines');

      // 👉 Jika ada subcollection lain, tinggal tambah di sini

      // 3️⃣ Hapus dokumen user
      await _firestore.collection('users').doc(uid).delete();

      // 4️⃣ Hapus akun FirebaseAuth
      await user.delete();

      return true;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Failed to delete account: ${e.toString()}');
    }
  }

  AuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      // Sign Up Errors
      case 'weak-password':
        return AuthException('Password terlalu lemah. Minimal 6 karakter.');
      case 'email-already-in-use':
        return AuthException(
          'Email sudah terdaftar. Silakan login atau gunakan email lain.',
        );

      // Sign In Errors
      case 'user-not-found':
        return AuthException(
          'Email tidak terdaftar. Silakan daftar terlebih dahulu.',
        );
      case 'wrong-password':
        return AuthException('Password salah. Silakan coba lagi.');
      case 'invalid-credential':
        return AuthException('Email atau password salah.');
      case 'user-disabled':
        return AuthException(
          'Akun ini telah dinonaktifkan. Hubungi administrator.',
        );

      // Email Errors
      case 'invalid-email':
        return AuthException('Format email tidak valid.');

      // Rate Limiting
      case 'too-many-requests':
        return AuthException(
          'Terlalu banyak percobaan. Silakan coba lagi nanti.',
        );

      // Requires Recent Login
      case 'requires-recent-login':
        return AuthException(
          'Operasi sensitif. Silakan logout dan login kembali.',
        );

      // Network Errors
      case 'network-request-failed':
        return AuthException(
          'Tidak ada koneksi internet. Periksa koneksi Anda.',
        );

      // Operation Not Allowed
      case 'operation-not-allowed':
        return AuthException('Operasi tidak diizinkan. Hubungi administrator.');

      // Default
      default:
        return AuthException('Error: ${e.message ?? e.code}');
    }
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}