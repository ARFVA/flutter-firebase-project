import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyquest/core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<User> registerWithEmailPassword({
    required String email,
    required String password,
  });

  Future<User> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendPasswordResetEmail(String email);

  Stream<User?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<User> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getAuthErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<User> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getAuthErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getAuthErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return firebaseAuth.authStateChanges();
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'Email already in use.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
