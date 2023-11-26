import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNameProvider = StateProvider<String?>((ref) => 'Loading..');

final firstNameProvider = StateProvider<String?>((ref) => 'Loading..');

final phoneNumberProvider = StateProvider<String?>((ref) => 'Loading..');

final emailProvider = StateProvider<String?>((ref) => 'Loading..');

final profilePicProvider = StateProvider<String?>((ref) => '');

final scheduledTimeProvider = StateProvider<String?>((ref) => '');

final scheduledDateProvider = StateProvider<String?>((ref) => '');
