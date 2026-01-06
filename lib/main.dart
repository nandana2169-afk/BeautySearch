import 'package:beautyproduct/detailpage.dart';
import 'package:beautyproduct/provider/beautyprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BeautyProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode _searchFocus = FocusNode();
  bool _isSearching = false;
  int selectedCategoryIndex = 0;
  final List<String> categories = ["All", "Beauty", "Furniture", "Grocery"];

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      setState(() {
        _isSearching = _searchFocus.hasFocus;
      });
    });
    Future.microtask(
      () => context.read<BeautyProvider>().fetchBeautyProducts(),
    );
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BeautyProvider>();

    return Scaffold(
      backgroundColor: _isSearching ? Colors.white : const Color(0xfff6f6f6),
      appBar: _isSearching
          ? null
          : AppBar(
              leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
              title: const Text(
                "Store",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(onPressed: (){}, icon: IconButton(onPressed: (){}, icon: Icon(Icons.shopping_bag))),
                ),
              ],
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                focusNode: _searchFocus,
                onChanged: (val) => provider.updateSearch(val),
                decoration: InputDecoration(
                  prefixIcon: _isSearching
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => _searchFocus.unfocus(),
                        )
                      : const Icon(Icons.search),
                  hintText: "Search products...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (!_isSearching) ...[
                const Text(
                  "Categories",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(categories[index]),
                          selected: selectedCategoryIndex == index,
                          selectedColor: Colors.pink,
                          labelStyle: TextStyle(
                            color: selectedCategoryIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setState(() => selectedCategoryIndex = index);
                              provider.updateCategory(categories[index]);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // This is just a normal text label showing count
                    Text(
                      "${provider.filteredProducts.length} Items",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    
                    Row(
                      children: [
                        /// 🔄 NORMAL SORT TEXT (NO POPUP)
                        Row(
                          children: const [
                            Icon(Icons.sort, size: 20, color: Colors.black),
                            SizedBox(width: 4),
                            Text("Sort", style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        
                        const SizedBox(width: 20),

                        /// ⚙️ NORMAL FILTER TEXT (NO FUNCTION)
                        Row(
                          children: const [
                            Icon(Icons.filter_list, size: 20, color: Colors.black),
                            SizedBox(width: 4),
                            Text("Filter", style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // --------------------------------------------------------
              ],

              SizedBox(height: 16,),

              Expanded(
                child: provider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.pink),
                      )
                    : provider.filteredProducts.isEmpty
                    ? const Center(child: Text("No items found"))
                    : GridView.builder(
                        itemCount: provider.filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          final product = provider.filteredProducts[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(product: product),
                              ),
                            ),
                            child: productCard(product),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productCard(BeautyCategory item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Center(child: Image.network(item.thumbnail))),
          Text(
            item.brand.toUpperCase(),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.star, size: 14, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                "${item.rating}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              // Show how many people reviewed/bought it
              Text(
                "(${item.reviews.length} reviews)",
                style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
              ),
              Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${item.price}",
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.add_circle, color: Colors.pink),
            ],
          ),
        ],
      ),
    );
  }
}
