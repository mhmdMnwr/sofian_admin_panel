import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get enter_username;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enter_password;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @banners.
  ///
  /// In en, this message translates to:
  /// **'Banners'**
  String get banners;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brands;

  /// No description provided for @discounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get discounts;

  /// No description provided for @dashboard_overview.
  ///
  /// In en, this message translates to:
  /// **'DashBoard Overview'**
  String get dashboard_overview;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenues'**
  String get revenue;

  /// No description provided for @last_7_days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last_7_days;

  /// No description provided for @this_year.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get this_year;

  /// No description provided for @last_12_months.
  ///
  /// In en, this message translates to:
  /// **'Last 12 months'**
  String get last_12_months;

  /// No description provided for @top_selling_products.
  ///
  /// In en, this message translates to:
  /// **'Top Selling Products'**
  String get top_selling_products;

  /// No description provided for @sales_by_product_category.
  ///
  /// In en, this message translates to:
  /// **'Sales by product category'**
  String get sales_by_product_category;

  /// No description provided for @product_details.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details;

  /// No description provided for @top.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get top;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @recent_orders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recent_orders;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @order_id.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get order_id;

  /// No description provided for @total_price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get total_price;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @active_client.
  ///
  /// In en, this message translates to:
  /// **'Active Clients'**
  String get active_client;

  /// No description provided for @last_month.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get last_month;

  /// No description provided for @life_time.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get life_time;

  /// No description provided for @search_for_categories.
  ///
  /// In en, this message translates to:
  /// **'Search for categories...'**
  String get search_for_categories;

  /// No description provided for @categories_management.
  ///
  /// In en, this message translates to:
  /// **'Categories Management'**
  String get categories_management;

  /// No description provided for @add_category.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get add_category;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get no_data;

  /// No description provided for @add_product.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get add_product;

  /// No description provided for @products_management.
  ///
  /// In en, this message translates to:
  /// **'Products Management'**
  String get products_management;

  /// No description provided for @product_id.
  ///
  /// In en, this message translates to:
  /// **'Product ID'**
  String get product_id;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @categorie.
  ///
  /// In en, this message translates to:
  /// **'Categorie'**
  String get categorie;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @stat.
  ///
  /// In en, this message translates to:
  /// **'Stat'**
  String get stat;

  /// No description provided for @search_for_products.
  ///
  /// In en, this message translates to:
  /// **'Search for products...'**
  String get search_for_products;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @product_name.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get product_name;

  /// No description provided for @product_status.
  ///
  /// In en, this message translates to:
  /// **'Product Status'**
  String get product_status;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @brands_management.
  ///
  /// In en, this message translates to:
  /// **'Brands Management'**
  String get brands_management;

  /// No description provided for @add_brand.
  ///
  /// In en, this message translates to:
  /// **'Add Brand'**
  String get add_brand;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @search_for_brands.
  ///
  /// In en, this message translates to:
  /// **'Search for brands...'**
  String get search_for_brands;

  /// No description provided for @search_for_orders.
  ///
  /// In en, this message translates to:
  /// **'Search for orders...'**
  String get search_for_orders;

  /// No description provided for @add_order.
  ///
  /// In en, this message translates to:
  /// **'Add Order'**
  String get add_order;

  /// No description provided for @order_management.
  ///
  /// In en, this message translates to:
  /// **'Order Management'**
  String get order_management;

  /// No description provided for @client_name.
  ///
  /// In en, this message translates to:
  /// **'Client Name'**
  String get client_name;

  /// No description provided for @contact_info.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contact_info;

  /// No description provided for @join_date.
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get join_date;

  /// No description provided for @total_spent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get total_spent;

  /// No description provided for @orders_count.
  ///
  /// In en, this message translates to:
  /// **'Orders Count'**
  String get orders_count;

  /// No description provided for @last_order_date.
  ///
  /// In en, this message translates to:
  /// **'Last Order Date'**
  String get last_order_date;

  /// No description provided for @search_for_clients.
  ///
  /// In en, this message translates to:
  /// **'Search for clients...'**
  String get search_for_clients;

  /// No description provided for @clients_management.
  ///
  /// In en, this message translates to:
  /// **'Clients Management'**
  String get clients_management;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @edit_product.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get edit_product;

  /// No description provided for @select_category.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get select_category;

  /// No description provided for @select_brand.
  ///
  /// In en, this message translates to:
  /// **'Select Brand'**
  String get select_brand;

  /// No description provided for @select_state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get select_state;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @choose_image.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get choose_image;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @admins.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get admins;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @edit_admin.
  ///
  /// In en, this message translates to:
  /// **'Edit Admin'**
  String get edit_admin;

  /// No description provided for @admins_management.
  ///
  /// In en, this message translates to:
  /// **'Admins Management'**
  String get admins_management;

  /// No description provided for @add_admin.
  ///
  /// In en, this message translates to:
  /// **'Add Admin'**
  String get add_admin;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @delete_order.
  ///
  /// In en, this message translates to:
  /// **'Delete Order'**
  String get delete_order;

  /// No description provided for @are_you_sure_you_want_to_delete_this_order.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this order?'**
  String get are_you_sure_you_want_to_delete_this_order;

  /// No description provided for @create_admin.
  ///
  /// In en, this message translates to:
  /// **'Create Admin'**
  String get create_admin;

  /// No description provided for @select_asigned_permissions.
  ///
  /// In en, this message translates to:
  /// **'Select Asigned Permissions'**
  String get select_asigned_permissions;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit_price.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unit_price;

  /// No description provided for @order_info.
  ///
  /// In en, this message translates to:
  /// **'Order Info'**
  String get order_info;

  /// No description provided for @update_state.
  ///
  /// In en, this message translates to:
  /// **'Update State'**
  String get update_state;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @order_details.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get order_details;

  /// No description provided for @customer_info.
  ///
  /// In en, this message translates to:
  /// **'Customer Info'**
  String get customer_info;

  /// No description provided for @selectAssignedSections.
  ///
  /// In en, this message translates to:
  /// **'Select Assigned Sections'**
  String get selectAssignedSections;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @are_you_sure_you_want_to_add_this_admin.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to add this admin?'**
  String get are_you_sure_you_want_to_add_this_admin;

  /// No description provided for @assigned_sections.
  ///
  /// In en, this message translates to:
  /// **'Assigned sections :'**
  String get assigned_sections;

  /// No description provided for @unit_per_box.
  ///
  /// In en, this message translates to:
  /// **'Unit per box :'**
  String get unit_per_box;

  /// No description provided for @category_name.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get category_name;

  /// No description provided for @edit_category.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get edit_category;

  /// No description provided for @brand_name.
  ///
  /// In en, this message translates to:
  /// **'Brand Name'**
  String get brand_name;

  /// No description provided for @edit_brand.
  ///
  /// In en, this message translates to:
  /// **'Edit Brand'**
  String get edit_brand;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
