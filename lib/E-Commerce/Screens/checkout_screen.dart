import 'package:dx/E-Commerce/Screens/add_card_screen.dart';
import 'package:dx/E-Commerce/Screens/edit_card_info.dart';
import 'package:dx/E-Commerce/Screens/track_order_screen.dart';
import 'package:dx/Widgets/card_payment_ui.dart';
import 'package:dx/core/navigation/navigation_service.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/core/validators/text_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatefulWidget {
  final bool? data;
  const CheckoutScreen({super.key, this.data});
  @override
  State<CheckoutScreen> createState() {
    return _CheckoutScreenState();
  }
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  //FormKey for ShippingAddress
  late GlobalKey<FormState> _dataShipining;
  late GlobalKey<FormState> _dataContactInformation;
  late final GlobalKey<ScaffoldState> _editShippingAddress;

  // Controlls
  late TextEditingController _address;
  late TextEditingController _postCode;
  late TextEditingController _email;
  late TextEditingController _phone;
  //bool
  bool _isShippingAddressEdited = false;
  bool _isContactInformationEdited = false;
  bool get _isThereAcard => widget.data ?? false;
  //Strings
  String? shippingOption;

  @override
  void initState() {
    _dataShipining = GlobalKey();
    _dataContactInformation = GlobalKey();
    _editShippingAddress = GlobalKey();
    _address = TextEditingController();
    _postCode = TextEditingController();
    _email = TextEditingController();
    _phone = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _address.dispose();
    _postCode.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _editShippingAddress,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: false, //default AppBar (disappear when scroll down)
            floating: true, //appear when scroll up
            snap: true, //It appears immediately, not gradually
            expandedHeight: 50.h,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title:
                  Text("checkout.title".tr(), style: AppStyles.mainTitleStyle),
              titlePadding:
                  EdgeInsetsDirectional.only(bottom: 10.h, start: 80.w),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
          ),

          // Shipping Address information
          SliverPadding(
            padding: EdgeInsetsDirectional.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Card(
                color: Color(0XFFE8E8E8),
                child: ListTile(
                  title: Text(
                    "checkout.shipping_address".tr(),
                    style: AppStyles.subTitleStyle,
                  ),
                  // Editing Info
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _isShippingAddressEdited = !_isShippingAddressEdited;
                      });
                      if (!_isShippingAddressEdited) {
                        NavigationService.navigatorKey.currentState?.pop();
                      } else if (_isShippingAddressEdited) {
                        _editShippingAddress.currentState!.showBottomSheet(
                          backgroundColor: Color(0XFFE8E8E8),
                          (context) => Container(
                            margin: EdgeInsetsDirectional.all(12.dg),
                            height: MediaQuery.of(context).size.height * 0.5.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.vertical(
                                top: Radius.circular(30.r),
                              ),
                            ),
                            child: Column(
                              spacing: 12.h,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "checkout.shipping_address".tr(),
                                  style: AppStyles.subTitleStyle,
                                ),
                                Text("checkout.country".tr(),
                                    style: AppStyles.subTitleStyle),
                                Text("checkout.egypt".tr(),
                                    style: AppStyles.labelTextStyle),
                                Form(
                                  key: _dataShipining,
                                  child: Column(
                                    spacing: 12.h,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.all(18.dg),
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          controller: _address,
                                          decoration: InputDecoration(
                                            label: Text(
                                              "checkout.address".tr(),
                                              style: AppStyles.labelTextStyle,
                                            ),
                                            enabledBorder: AppStyles
                                                .outlineInputBorderstyle,
                                            focusedBorder: AppStyles
                                                .foucasedoutlineInputBorder,
                                            focusedErrorBorder:
                                                AppStyles.errorBorder,
                                            errorBorder: AppStyles.errorBorder,
                                          ),
                                          validator: (value) =>
                                              TextValidation.textValidation(
                                            value!,
                                          ),
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.all(18.dg),
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          controller: _postCode,
                                          decoration: InputDecoration(
                                            label: Text(
                                              "checkout.postcode".tr(),
                                              style: AppStyles.labelTextStyle,
                                            ),
                                            enabledBorder: AppStyles
                                                .outlineInputBorderstyle,
                                            focusedBorder: AppStyles
                                                .foucasedoutlineInputBorder,
                                            focusedErrorBorder:
                                                AppStyles.errorBorder,
                                            errorBorder: AppStyles.errorBorder,
                                          ),
                                          validator: (value) =>
                                              TextValidation.textValidation(
                                            value!,
                                          ),
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: AppStyles.elevatedButtonStyle,
                                        onPressed: () {
                                          if (_dataShipining.currentState!
                                              .validate()) {
                                            _isShippingAddressEdited = false;
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          }
                                        },
                                        child: Text(
                                          "checkout.save_changes".tr(),
                                          style: AppStyles.whiteTextButtonStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: _isShippingAddressEdited
                          ? Color(0XFF32DBE6)
                          : Colors.black,
                    ),
                  ),
                  // info that appeared
                  subtitle: _address.text.isEmpty
                      ? Text("", style: AppStyles.normalTextStyle)
                      : Text(_address.text, style: AppStyles.normalTextStyle),
                  isThreeLine: true,
                ),
              ),
            ),
          ),
          // contact information
          SliverPadding(
            padding: EdgeInsetsDirectional.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Card(
                color: Color(0XFFE8E8E8),
                child: ListTile(
                  title: Text(
                    "checkout.contact_info".tr(),
                    style: AppStyles.subTitleStyle,
                  ),
                  // Editing Info
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _isContactInformationEdited =
                            !_isContactInformationEdited;
                      });
                      if (!_isContactInformationEdited) {
                        NavigationService.navigatorKey.currentState?.pop();
                      } else if (_isContactInformationEdited) {
                        _editShippingAddress.currentState!.showBottomSheet(
                          backgroundColor: Color(0XFFE8E8E8),
                          (context) => Container(
                            margin: EdgeInsetsDirectional.all(12.dg),
                            height: MediaQuery.of(context).size.height * 0.5.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.vertical(
                                top: Radius.circular(30.r),
                              ),
                            ),
                            child: Column(
                              spacing: 12.h,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "checkout.contact_info".tr(),
                                  style: AppStyles.subTitleStyle,
                                ),
                                Text("checkout.country".tr(),
                                    style: AppStyles.subTitleStyle),
                                Text("checkout.egypt".tr(),
                                    style: AppStyles.labelTextStyle),
                                Form(
                                  key: _dataContactInformation,
                                  child: Column(
                                    spacing: 12.h,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.all(18.dg),
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          controller: _email,
                                          decoration: InputDecoration(
                                            label: Text(
                                              "checkout.email_address".tr(),
                                              style: AppStyles.labelTextStyle,
                                            ),
                                            enabledBorder: AppStyles
                                                .outlineInputBorderstyle,
                                            focusedBorder: AppStyles
                                                .foucasedoutlineInputBorder,
                                            focusedErrorBorder:
                                                AppStyles.errorBorder,
                                            errorBorder: AppStyles.errorBorder,
                                          ),
                                          validator: (value) =>
                                              TextValidation.textValidation(
                                            value!,
                                          ),
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.all(18.dg),
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          controller: _phone,
                                          decoration: InputDecoration(
                                            label: Text(
                                              "checkout.phone_number".tr(),
                                              style: AppStyles.labelTextStyle,
                                            ),
                                            enabledBorder: AppStyles
                                                .outlineInputBorderstyle,
                                            focusedBorder: AppStyles
                                                .foucasedoutlineInputBorder,
                                            focusedErrorBorder:
                                                AppStyles.errorBorder,
                                            errorBorder: AppStyles.errorBorder,
                                          ),
                                          validator: (value) =>
                                              TextValidation.textValidation(
                                            value!,
                                          ),
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: AppStyles.elevatedButtonStyle,
                                        onPressed: () {
                                          if (_dataContactInformation
                                              .currentState!
                                              .validate()) {
                                            _isContactInformationEdited = false;
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          }
                                        },
                                        child: Text(
                                          "checkout.save_changes".tr(),
                                          style: AppStyles.whiteTextButtonStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: _isContactInformationEdited
                          ? Color(0XFF32DBE6)
                          : Colors.black,
                    ),
                  ),
                  // info that appeared
                  subtitle: _email.text.isEmpty
                      ? Text("", style: AppStyles.normalTextStyle)
                      : Text(_email.text, style: AppStyles.normalTextStyle),
                  isThreeLine: true,
                ),
              ),
            ),
          ),

          // Items that will shipping
          SliverPadding(
            padding: EdgeInsetsDirectional.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 18.h,
                children: [
                  // number of items
                  Row(
                    spacing: 10.w,
                    children: [
                      Text("checkout.items".tr(),
                          style: AppStyles.subTitleStyle),
                      ClipRRect(
                        child: Container(
                          height: 45.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: Color(0XFFE5EBFC),
                          ),
                          child: Center(
                            child: Text("3", style: AppStyles.subTitleStyle),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // first item
                  SizedBox(
                    child: Row(
                      spacing: 12.w,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 45,
                              child: Padding(
                                padding: EdgeInsets.all(6.dg),
                                child: Image.asset("images/greySweater.png"),
                              ),
                            ),
                            PositionedDirectional(
                              end: 0,
                              top: 0,
                              child: Container(
                                height: 25.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[200],
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "1",
                                  style: AppStyles.normalTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            "Grey Sweeter",
                            style: AppStyles.normalTextStyle,
                          ),
                        ),
                        Text("\$1200", style: AppStyles.normalTextStyle),
                      ],
                    ),
                  ),
                  // secound item
                  SizedBox(
                    child: Row(
                      spacing: 12.w,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 45,
                              child: Padding(
                                padding: EdgeInsets.all(6.dg),
                                child: Image.asset("images/greySweater.png"),
                              ),
                            ),
                            PositionedDirectional(
                              end: 0,
                              top: 0,
                              child: Container(
                                height: 25.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[200],
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "1",
                                  style: AppStyles.normalTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            "Grey Sweeter",
                            style: AppStyles.normalTextStyle,
                          ),
                        ),
                        Text("\$1200", style: AppStyles.normalTextStyle),
                      ],
                    ),
                  ),
                  // third item
                  SizedBox(
                    child: Row(
                      spacing: 12.w,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 45,
                              child: Padding(
                                padding: EdgeInsets.all(6.dg),
                                child: Image.asset("images/greySweater.png"),
                              ),
                            ),
                            PositionedDirectional(
                              end: 0,
                              top: 0,
                              child: Container(
                                height: 25.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[200],
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "1",
                                  style: AppStyles.normalTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            "Grey Sweeter",
                            style: AppStyles.normalTextStyle,
                          ),
                        ),
                        Text("\$1200", style: AppStyles.normalTextStyle),
                      ],
                    ),
                  ),

                  // Shipping Options
                  RadioGroup(
                    groupValue: shippingOption,
                    onChanged: (String? val) {
                      setState(() {
                        shippingOption = val;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "checkout.shipping_options".tr(),
                          style: AppStyles.subTitleStyle,
                        ),
                        ListTile(
                          isThreeLine: true,
                          leading: Radio(
                            value: "Standard",
                            activeColor: Color(0XFF32DBE6),
                          ),
                          title: Text(
                            "checkout.standard".tr(),
                            style: AppStyles.normalTextStyle,
                          ),
                          subtitle: Text(
                            "checkout.standard_subtitle".tr(),
                            style: AppStyles.normalTextStyle,
                          ),
                          trailing: Text(
                            "checkout.free".tr(),
                            style: AppStyles.normalTextStyle,
                          ),
                          onTap: () {
                            setState(() {
                              shippingOption = "Standard";
                            });
                          },
                        ),
                        ListTile(
                          isThreeLine: true,
                          leading: Radio(
                            value: "Express",
                            activeColor: Color(0XFF32DBE6),
                          ),
                          title: Text(
                            "checkout.express".tr(),
                            style: AppStyles.normalTextStyle,
                          ),
                          subtitle: Text(
                            "checkout.express_subtitle".tr(),
                            style: AppStyles.normalTextStyle,
                          ),
                          trailing: Text(
                            "\$12.00",
                            style: AppStyles.normalTextStyle,
                          ),
                          onTap: () {
                            setState(() {
                              shippingOption = "Express";
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // payment Editing
          SliverPadding(
            padding: EdgeInsetsDirectional.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Card(
                color: Color(0XFFE8E8E8),
                child: ListTile(
                  title: Text("checkout.payment_method".tr(),
                      style: AppStyles.subTitleStyle),
                  // Editing Card Info
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditCardInfoScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit_outlined, color: Colors.black),
                  ),

                  // view card , ADD card
                  subtitle: Row(
                    spacing: 20.w,
                    children: [
                      // view Card
                      Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(
                            color: Colors.black,
                            width: 0.8,
                            style: BorderStyle.solid,
                          ),
                          color: Color(0XFFE8E8E8),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: MaterialButton(
                          textColor: Color(0XFF32DBE6),
                          child: Text(
                            "checkout.card".tr(),
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            _editShippingAddress.currentState!.showBottomSheet(
                              (context) => !_isThereAcard
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Color(0XFF32DBE6),
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      height: 120.h,
                                      width: double.infinity,
                                      child: SizedBox(
                                        height: 50.h,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddCardScreen(),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.add_box,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: buildCard(),
                                    ),
                            );
                          },
                        ),
                      ),

                      // adding new card
                      Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          color: Color(0XFFE8E8E8),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.add_box,
                            size: 30,
                            color: Color(0XFF32DBE6),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddCardScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // info that appeared
                  isThreeLine: true,
                ),
              ),
            ),
          ),

          // Button PAY
          SliverPadding(
            padding: EdgeInsetsDirectional.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsetsDirectional.only(start: 12.w),
                color: Color(0XFFE8E8E8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${"checkout.total".tr()} \$3000",
                        style: AppStyles.normalTextStyle),
                    SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.6,
                            46.h,
                          ),
                          backgroundColor: Color(0XFF32DBE6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.horizontal(
                              start: Radius.circular(20.r),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrackOrderScreen(),
                            ),
                          );
                        },
                        child: Text("checkout.pay".tr(),
                            style: AppStyles.normalTextStyle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
