
abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> add(T entity);
  Future<void> delete(String id);
  Future<void> update(T entity);
}