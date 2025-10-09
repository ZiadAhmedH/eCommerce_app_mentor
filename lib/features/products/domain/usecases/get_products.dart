// import '../../../../core/usecases/usecase.dart';
// import '../entities/product.dart';
// import '../repositories/product_repository.dart';

// class GetProducts implements UseCase<List<Product>, GetProductsParams> {
//   final ProductRepository repository;

//   GetProducts(this.repository);

//   @override
//   Future<Result<List<Product>>> call(GetProductsParams params) async {
//     return await repository.getProducts(page: params.page, limit: params.limit);
//   }
// }

// class GetProductsParams {
//   final int page;
//   final int limit;

//   GetProductsParams({required this.page, required this.limit});
// }
