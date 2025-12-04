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

  // Fake category list (backend ile uyumlu hale getirilebilir)
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
      appBar: AppBar(
        title: const Text("Harcama Ekle"),
        centerTitle: true,
        elevation: 0,
      ),
      body: notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // TITLE
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Başlık",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Başlık boş olamaz";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // AMOUNT
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

                    // DATE PICKER
                    ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300)),
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
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // CATEGORY DROPDOWN
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
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Kategori seçmelisin";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // SAVE BUTTON
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
                          id: "", // Repo içinde UUID atanıyor
                          title: _titleController.text,
                          amount: double.parse(_amountController.text),
                          date: _selectedDate,
                          category: _selectedType == TransactionType.expense ? _selectedCategory : null,
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
}
