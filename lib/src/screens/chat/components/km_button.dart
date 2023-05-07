import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/bloc/km_system_settings_cubit.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/screens/options/options_dialog.dart';
import 'package:one_km/src/widgets/app_logo.dart';
import 'package:sizer/sizer.dart';

class KmButton extends StatelessWidget {
  const KmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      //if hardware keyboard is open it should be unvisible
      visible: MediaQuery.of(context).viewInsets.bottom == 0,

      child: Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return OptionsDialog(
                    kmUser: context.read<KmUserCubit>().state,
                  );
                });
          },
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: appLogo(1, context.read<KmSystemSettingsCubit>().state, context.read<KmUserCubit>().state.userCoordinates),
          ),
        ),
      ),
    );
  }
}
