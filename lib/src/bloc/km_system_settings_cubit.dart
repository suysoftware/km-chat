import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/models/km_system_settings.dart';

class KmSystemSettingsCubit extends Cubit<KmSystemSettings> {
  KmSystemSettingsCubit() : super(KmSystemSettings());

  void changeSettings(KmSystemSettings kmSystemSettings) {
    emit(kmSystemSettings);
  }
}
