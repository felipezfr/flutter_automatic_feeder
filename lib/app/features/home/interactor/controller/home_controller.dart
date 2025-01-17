import '../../../../core/controllers/controllers.dart';
import '../../../../core/states/base_state.dart';
import '../repositories/i_home_repository.dart';

class HomeController extends BaseController {
  final IHomeRepository repository;
  HomeController(
    this.repository,
  ) : super(InitialState());

  Future<void> getProducts() async {
    update(LoadingState());

    repository.getProducts('terneiros').listen(
      (event) {
        event.fold(
          (left) => update(ErrorState(exception: left)),
          (right) => update(SuccessState(data: right)),
        );
      },
    );
  }

  Future<void> updateProduct(
    String productId,
    String name,
    int quantity,
    int timeInMinutes,
  ) async {
    await repository.updateProduct(
      productId,
      'terneiros',
      name,
      quantity,
      timeInMinutes,
    );
  }
}
