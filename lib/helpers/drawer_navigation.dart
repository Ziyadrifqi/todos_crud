import 'package:kelompok_crud/screens/home_screen.dart';
import 'package:kelompok_crud/screens/todos_by_category.dart';
import 'package:kelompok_crud/services/category_service.dart';
import 'package:flutter/material.dart';
import '../screens/categories_screen.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoriesList = [];

  CategoryService _categoryService = CategoryService();

  @override
  initState() {
    super.initState();
    _getAllCategories();
  }

  _getAllCategories() async {
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        _categoriesList.add(InkWell(
          onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new TodosByCategory(
                        category: category['name'],
                      ))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://i.pinimg.com/564x/e1/93/26/e19326151dc446c9d4e5c64f0b423cd3.jpg',
                ),
              ),
              accountName: Text('Kelompok 1'),
              accountEmail: Text('admin@kelompok1'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green], // Warna gradasi
                  begin: Alignment.topLeft, // Posisi awal gradasi
                  end: Alignment.bottomRight, // Posisi akhir gradasi
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(),
              )),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CategoriesScreen(),
              )),
            ),
            Divider(),
            Column(
              children: _categoriesList,
            ),
          ],
        ),
      ),
    );
  }
}
