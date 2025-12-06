import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Category? _selectedCategory;
  TransactionType _selectedType = TransactionType.expense;

  final List<Category> categories = const [
    Category(id: "1", title: "Yemek", icon: "🍔"),
    Category(id: "2", title: "Eğitim", icon: "📚"),
    Category(id: "3", title: "Fatura", icon: "💡"),
    Category(id: "4", title: "Ulaşım", icon: "🚗"),
  ];

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<TransactionNotifier>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Harcama Ekle",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Harcama Detayları",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildCard(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: "Harcamaya bir isim ver...",
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Başlık boş olamaz";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "İşlem Türü",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        _buildTypeChip("Gider", TransactionType.expense,
                            Icons.arrow_downward, Colors.red),
                        const SizedBox(width: 8),
                        _buildTypeChip("Gelir", TransactionType.income,
                            Icons.arrow_upward, Colors.green),
                        const SizedBox(width: 8),
                        _buildTypeChip("Transfer", TransactionType.transfer,
                            Icons.swap_horiz, Colors.blue),
                      ],
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Tutar",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Tutar boş olamaz";
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return "Geçerli bir tutar girin";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      title: Text(
                        "Tarih: ${_selectedDate.toLocal().toString().split(" ")[0]}",
                      ),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    if (_selectedType == TransactionType.expense)
                      DropdownButtonFormField<Category>(
                        decoration: const InputDecoration(
                          labelText: "Kategori",
                          border: OutlineInputBorder(),
                        ),
                        items: categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text("${cat.icon}  ${cat.title}"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                        validator: (value) {
                          if (_selectedType == TransactionType.expense &&
                              value == null) {
                            return "Kategori seçmelisin";
                          }
                          return null;
                        },
                      ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final newTransaction = Transaction(
                          id: "",
                          title: _titleController.text,
                          amount: double.parse(_amountController.text),
                          date: _selectedDate,
                          entryDate: DateTime.now(),
                          category:
                              _selectedType == TransactionType.expense
                                  ? _selectedCategory
                                  : null,
                          type: _selectedType,
                        );

                        await notifier.addNewTransaction(newTransaction);

                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text(
                        "Kaydet",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCard({required Widget child, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildTypeChip(
      String label, TransactionType type, IconData icon, Color color) {
    final isSelected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
            if (type != TransactionType.expense) {
              _selectedCategory = null;
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: 1.4,
            ), 
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? color : Colors.grey, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
