import 'package:flutter/material.dart';
import 'package:harcama_app/domain/usecases/generic_usecase.dart';

abstract class BaseNotifier<T> extends ChangeNotifier {
  final CreateUseCase<T> createUseCase;
  final UpdateUseCase<T> updateUseCase;
  final DeleteUseCase<T> deleteUseCase;
  final GetAllUseCase<T> getAllUseCase;

  BaseNotifier({
    required this.createUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
    required this.getAllUseCase,
  }) {
    fetchItems();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<T> _items = [];
  List<T> get items => _items;

  @protected
  set items(List<T> value) => _items = value;

  Future<void> fetchItems() async {
    setLoading(true);
    try {
      _items = await getAllUseCase();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Hata: Veriler yüklenirken sorun oluştu: $e';
    } finally {
      setLoading(false);
    }
  }

  Future<void> addItem(T item) async {
    setLoading(true);
    try {
      await createUseCase(item);
      await fetchItems();
    } catch (e) {
      _errorMessage = 'Hata: Ekleme başarısız: $e';
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateItem(T item) async {
    setLoading(true);
    try {
      await updateUseCase(item);
      await fetchItems();
    } catch (e) {
      _errorMessage = 'Hata: Güncelleme başarısız: $e';
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteItem(String id) async {
    setLoading(true);
    try {
      await deleteUseCase(id);
      await fetchItems();
    } catch (e) {
      _errorMessage = 'Hata: Silme başarısız: $e';
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}