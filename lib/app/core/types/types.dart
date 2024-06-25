import 'package:either_dart/either.dart';

import '../errors/base_exception.dart';

typedef Output<T> = Either<BaseException, T>;
