import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:fpdart/fpdart.dart';



typedef EitherModel<T> = Future<Either<FailureModel, T>>;
