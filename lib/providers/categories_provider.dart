import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/categories_model.dart';
import 'package:mukto_mart/models/home_categories_mode.dart';
import 'package:mukto_mart/models/sub_categories_model.dart';
import 'package:mukto_mart/models/sub_sub_categories_model.dart';
import 'package:mukto_mart/repo/categories_repo.dart';
import 'package:mukto_mart/repo/sub_categories_repo.dart';
import 'package:mukto_mart/repo/sub_sub_category_repo.dart';

class CategoriesProvider extends ChangeNotifier{
  int _selectedIndex=0;

  get selectedIndex => _selectedIndex;

  set selectedIndex(int val) {
    _selectedIndex = val;
    notifyListeners();
  }
  CategoryRepo _categoryRepo=CategoryRepo();
  List<Categories> _categories=[];
  List<HomeCategories> _homeCategories=[];

  SubCategoryRepo _subCategoryRepo=SubCategoryRepo();
  List<SubCategories> _subCategories=[];
  List<SubCategories> _firstSubCategories=[];

  SubSubCategoryRepo _subSubCategoryRepo=SubSubCategoryRepo();
  List<SubSubCategories> _subSubCategories=[];
  List<SubSubCategories> _subSubCategoriesId=[];

  get categoryRepo => _categoryRepo;
  List<Categories> get categories => _categories;
  List<HomeCategories> get homeCategories => _homeCategories;

  get subCategoryRepo => _subCategoryRepo;
  List<SubCategories> get subCategories => _subCategories;

  get subSubCategoryRepo => _subSubCategoryRepo;
  List<SubSubCategories> get subSubCategories => _subSubCategories;
  List<SubSubCategories> get subSubCategoriesId => _subSubCategoriesId;

  Future<void> fetchCategory()async {
    _categories!=null?_categories.clear():null;
    var result = await _categoryRepo.getCategories();
    _categories = result;
    notifyListeners();
  }
  Future<void> fetchHomeCategory()async {
    _homeCategories!=null?_homeCategories.clear():null;
    var result = await _categoryRepo.getHomeCategories();
    _homeCategories = result;
    notifyListeners();
  }
  Future<void> fetchSubCategories(int categoryId)async {
    _subCategories!=null?_subCategories.clear():null;
    var result = await _subCategoryRepo.getSubCategories(categoryId);
    _subCategories = result;
    notifyListeners();
  }
  Future<void> fetchFirstSubCategories()async {
    _subCategories!=null?_subCategories.clear():null;
    var result = await _subCategoryRepo.getFirstSubCategories();
    _subCategories = result;
    notifyListeners();
  }
  Future<void> fetch()async {
    var result = await _subSubCategoryRepo.getSubSubCategories();
    _subSubCategories = result;
    notifyListeners();
  }

  Future<void> fetchSubSubCatId(int id)async {
    _subSubCategoriesId.clear();
    var result = await _subSubCategoryRepo.getSubSubCategoriesId(id);
    _subSubCategoriesId = result;
    notifyListeners();
  }
}