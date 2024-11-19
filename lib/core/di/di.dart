import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

final get = GetIt.instance;

@InjectableInit()
FutureOr<GetIt> configureDependencies() async => get.init();
