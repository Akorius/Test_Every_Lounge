import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/modal.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/screen.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/select_payment_method/modal.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/success_add_card_modal.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/success_remove_card_modal.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/try_remove_card_modal.dart';
import 'package:everylounge/presentation/screens/feedback/feedback.dart';
import 'package:everylounge/presentation/screens/feedback/widgets/success_send_feedback_modal.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/screen.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/widget/update_app_screen.dart';
import 'package:everylounge/presentation/screens/login_flow/email_login_flow/enter_code/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/email_login_flow/need_set_email/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/info/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/login_bottom_navigation/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/other_login/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/alfa_id_web_screen.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/tinkoff_id_web_callback/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/tinkoff_id_web_view/tinkoff_id_web_view.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_list/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_details/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_list/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/create_upgrade_order/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/screen.dart';
import 'package:everylounge/presentation/screens/order_create_flow/web_view/tinkoff_acquiring_webview/screen.dart';
import 'package:everylounge/presentation/screens/order_detail/screen.dart';
import 'package:everylounge/presentation/screens/order_detail/upgrade_widget/info_screen.dart';
import 'package:everylounge/presentation/screens/photo_viewer/screen.dart';
import 'package:everylounge/presentation/screens/profile/screen.dart';
import 'package:everylounge/presentation/screens/setting_profile/pdf_view.dart';
import 'package:everylounge/presentation/screens/setting_profile/screen.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/delete/confirmation_screen.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/delete/delete_account_screen.dart';
import 'package:everylounge/presentation/screens/splash/screen.dart';

class AppRoutes {
  static const splash = "/${SplashScreen.path}";

  ///login related
  static const loginBottomNavigation = "/${LoginBottomNavigationScreen.path}";
  static const loginTinkoffWeb = "/${TinkoffIdWebViewScreen.path}";
  static const loginAlfaWeb = "/${AlfaIdWebScreen.path}";
  static const loginOther = "/${OtherLoginScreen.path}";
  static const loginEnterCode = "/${EnterCodeScreen.path}";
  static const loginNeedSetEmail = "/${NeedSetEmailScreen.path}";
  static const tinkoffIdWebCallback = "/${TinkoffIdWebCallbackScreen.path}";
  static const loginInfo = "/${LoginInfoScreen.path}";

  static const homeBottomNavigation = "/${HomeBottomNavigationScreen.path}";
  static const updateAppScreen = "/${UpdateAppScreen.path}";

  ///profile related
  static const profile = "/${ProfileScreen.path}";
  static const settingProfileScreen = "/${SettingProfileScreen.path}";
  static const deleteProfileScreen = "/${DeleteProfileScreen.path}";
  static const confirmationDeleteScreen = "/${ConfirmationDeleteScreen.path}";
  static const pdfViewScreen = "/${PDFView.path}";
  static const successSendFeedbackModal = "/${SuccessSendFeedbackModal.path}";

  ///bank programs related
  static const selectPaymentMethodModal = "/${SelectPaymentMethodModal.path}";

  static const bankProgramDetailed = "/${BankProgramDetailedScreen.path}";
  static const successAddCardModal = "/${SuccessAddCardModal.path}";
  static const successRemoveCardModal = "/${SuccessRemoveCardModal.path}";
  static const tryRemoveCardModal = "/${TryRemoveCardModal.path}";
  static const addByPhoneNumberModal = "/${AddBankByPhoneNumberModal.path}";

  ///business_lounges related
  static const searchAirport = "/${SearchAirportScreen.path}";
  static const businessLoungeList = "/${LoungeListScreen.path}";
  static const premiumServicesList = "/${PremiumServicesListScreen.path}";
  static const premiumServicesDetails = "/${PremiumDetailsScreen.path}";
  static const businessLoungeDetails = "/${LoungeDetailsScreen.path}";
  static const photoViewer = "/${PhotoViewerScreen.path}";

  ///createOrder related
  static const createOrderPremium = "/${CreateOrderPremiumScreen.path}";
  static const acquiringWebViewTinkkoff = "/${TinkoffAcquiringWebView.path}";
  static const orderDetailsModal = "/${OrderDetailsScreen.pathModal}";
  static const orderDetailsScreen = "/${OrderDetailsScreen.pathScreen}";
  static const feedbackContacts = "/${FeedbackContacts.path}";

  ///upgrade flight
  static const upgradeFlight = "/${SearchUpgradeBookingScreen.path}";
  static const flightOrder = "/${CreateUpgradeOrderScreen.path}";
  static const completeUpgradeInfoScreen = "/${CompleteUpgradeInfoScreen.path}";

  //screen for metric
  static const purchasesScreen = "/purchases_screen";
  static const contactScreen = "/contact_screen";
  static const loginInfoScreen = "/login_info_screen";
}
