import 'package:get_it/get_it.dart';

import '../../features/chat/data/datasources/chat_remote_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/i_chat_repository.dart';
import '../../features/chat/domain/usecases/get_order_chat_thread_usecase.dart';
import '../../features/chat/domain/usecases/send_chat_message_usecase.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../cache/cache_service.dart';
import '../network/i_api_client.dart';

void setupChatDependencies(GetIt getIt) {
  getIt.registerLazySingleton<ChatRemoteSource>(
    () => ChatRemoteSource(getIt<IApiClient>()),
  );
  getIt.registerLazySingleton<IChatRepository>(
    () => ChatRepositoryImpl(
      getIt<ChatRemoteSource>(),
      getIt<CacheService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetOrderChatThreadUseCase(getIt<IChatRepository>()),
  );
  getIt.registerLazySingleton(
    () => SendChatMessageUseCase(getIt<IChatRepository>()),
  );
  getIt.registerFactory(
    () => ChatBloc(
      getIt<GetOrderChatThreadUseCase>(),
      getIt<SendChatMessageUseCase>(),
    ),
  );
}
