import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vm/Pages/ExpansetrackerPages/ExpanseAnalysis.dart';
import 'package:vm/Resources/SupportDialogs.dart';
import 'package:provider/provider.dart';
import 'package:vm/Services/expanse_tracker_services.dart';

class PermissionServices with ChangeNotifier{
  BuildContext context;
  PermissionServices(this.context);

  getSmsPermission(){
    Permission.sms.status.then((sta) {
      switch (sta) {
        case PermissionStatus.restricted:
          {
            SupportDialogs().PermisssionPermanentlyDeniedDialog(context);
            break;
          }
        case PermissionStatus.denied:
          {
            grantPermission(Permission.sms);
            break;
          }
        case PermissionStatus.granted:
          {
            updatePage();
            break;
          }
        case PermissionStatus.permanentlyDenied:
          {
            SupportDialogs().PermisssionPermanentlyDeniedDialog(context);
            break;
          }
        case PermissionStatus.undetermined:
          {
            grantPermission(Permission.sms);

            break;
          }
      }
    });
  }

  grantPermission(Permission type) async {
    type.request().then((res) {
      if (res == PermissionStatus.granted) {
        updatePage();
      } else {
        getSmsPermission();
      }
    });
  }

  updatePage(){
    final prov= Provider.of<ExpanseTrackerServices>(context, listen: false);
    prov.updatePageNumber(ExpanseAnalysisState.pageNumber);
  }
}