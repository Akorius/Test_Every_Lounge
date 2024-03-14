import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/screens/home/widget/add_card_modal.dart';
import 'package:everylounge/presentation/screens/home/widget/authorize_modal.dart';

Map<String, String> routes = {
  AppRoutes.loginBottomNavigation: 'Экран авторизации',
  AppRoutes.splash: "Сплеш",

  AppRoutes.loginTinkoffWeb: "Экран авторизации Тинькофф",
  AppRoutes.loginAlfaWeb: "Экран авторизации Альфа",
  AppRoutes.loginOther: "Экран авторизации по почте",
  AppRoutes.loginEnterCode: "Экран ввода кода",
  AppRoutes.loginNeedSetEmail: "Экран ввода email",
  AppRoutes.tinkoffIdWebCallback: "Веб вью авторизации Тинькофф",

  AppRoutes.homeBottomNavigation: "Экран главный",
  AppRoutes.updateAppScreen: "Экран обновления приложения",

  ///profile related
  AppRoutes.profile: "Экран профиля",
  AppRoutes.settingProfileScreen: "Экран настройки профиля",
  AppRoutes.deleteProfileScreen: "Экран удаления профиля",
  AppRoutes.confirmationDeleteScreen: "Экран подтвержедния удаления профиля",

  ///bank programs related
  AppRoutes.selectPaymentMethodModal: "Окно выбора банковской карты",

  AppRoutes.bankProgramDetailed: "Экран детальной информации о банковской карте",
  AppRoutes.successAddCardModal: "Окно об успешном добавлении карты",
  AppRoutes.successRemoveCardModal: "Окно об успешном удалении карты",
  AppRoutes.tryRemoveCardModal: "Окно о попытке удалении карты",
  AppRoutes.addByPhoneNumberModal: "Окно об успешном добавлении карты по номеру телефона",

  ///business_lounges related
  AppRoutes.searchAirport: "Экран поиска аэропорта",
  AppRoutes.businessLoungeList: "Экран со списком бизнес-залов",
  AppRoutes.premiumServicesList: "Экран со списком премиум услуг",
  AppRoutes.premiumServicesDetails: "Экран с подробной информацией о премиум услуге",
  AppRoutes.businessLoungeDetails: "Экран с подробной информацией об бизнес-зала",
  AppRoutes.photoViewer: "Экран просмотра изображений",

  ///createOrder related
  AppRoutes.createOrderPremium: "Создание заказа премиум услуг",
  AppRoutes.acquiringWebViewTinkkoff: "Веб вью Тинькофф",
  AppRoutes.orderDetailsModal: "Окно подробной информации заказа",
  AppRoutes.orderDetailsScreen: "Экран подробной информации заказа",
  AppRoutes.feedbackContacts: "Экран обратной связи",

  ///upgrade flight
  AppRoutes.upgradeFlight: "Экран ввода данных для повышения класса перелёта",
  AppRoutes.flightOrder: "Экран заказа повышения билета",
  AppRoutes.completeUpgradeInfoScreen: "Экран информации об обновлении",

  AppRoutes.purchasesScreen: "Экран покупок",
  AppRoutes.contactScreen: "Экран контактов",
  AppRoutes.loginInfoScreen: "Экран информации",
};

Map<String, String> modalSheetNames = {
  showAuthorizeModalPath: 'Модальное окно авторизации',
  showAddCardModalPath: 'Модальное окно добавления способа оплаты'
};
