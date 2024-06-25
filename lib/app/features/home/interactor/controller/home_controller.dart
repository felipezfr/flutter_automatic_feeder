import '../../../../core/controllers/controllers.dart';
import '../../../../core/states/base_state.dart';
import '../repositories/i_home_repository.dart';

class HomeController extends BaseController {
  final IHomeRepository repository;
  HomeController(
    this.repository,
  ) : super(InitialState());

  Future<void> getWordList() async {
    update(LoadingState());

    // final response = await repository.get();

    // response.fold(
    //   (left) => update(ErrorState(exception: left)),
    //   (right) => update(SuccessState(data: right)),
    // );
  }
}
