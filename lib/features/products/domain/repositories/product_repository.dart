import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({int page = 1, int limit = 20});
  Future<Result<Product>> getProductById(int id);
  Future<Result<List<Product>>> searchProducts(String query);
  Future<Result<List<Product>>> getProductsByCategory(String category);
}
