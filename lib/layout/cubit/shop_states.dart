abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeNavBarState extends ShopStates {}

class GetHomeDataLoadingState extends ShopStates {}
class GetHomeDataSuccessState extends ShopStates {}
class GetHomeDataErrorState extends ShopStates {}

class GetCategoriesDataLoadingState extends ShopStates {}
class GetCategoriesDataSuccessState extends ShopStates {}
class GetCategoriesDataErrorState extends ShopStates {}

class ChangeFavoritesState extends ShopStates {}

class GetFavoritesSuccessState extends ShopStates {}
class GetFavoritesErrorState extends ShopStates {}

class GetUserSuccessState extends ShopStates {}
class GetUserErrorState extends ShopStates {}

class UpdateUserLoadingState extends ShopStates {}
class UpdateUserSuccessState extends ShopStates {}
class UpdateUserErrorState extends ShopStates {}