import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/report_page/store/report_store.dart';
import 'package:app/ui/widgets/default_app_bar.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../widgets/media_upload/media_upload_widget.dart';

enum ReportEntityType {
  user,
  quest,
  discussionComment,
}

class ReportPageArguments {
  final ReportEntityType entityType;
  final String entityId;

  const ReportPageArguments({
    required this.entityType,
    required this.entityId,
  });
}

class ReportPage extends StatefulWidget {
  static const String routeName = '/reportPage';
  final ReportPageArguments arguments;

  const ReportPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late ReportStore _store;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _store = context.read<ReportStore>();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<ReportStore>(
      onSuccess: () async {
        Navigator.pop(context);
        await AlertDialogUtils.showSuccessDialog(context,
            text: 'settings.success'.tr());
        Navigator.pop(context);
      },
      onFailure: () {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          title: 'chat.report'.tr(),
        ),
        body: SingleChildScrollView(
          child: DismissKeyboard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _TextFieldWithTitle(
                      title: 'meta.title'.tr(),
                      child: DefaultTextField(
                        controller: _titleController,
                        hint: 'meta.enterTitle'.tr(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null) {
                            return null;
                          }
                          if (value.isEmpty) {
                            return 'errors.fieldEmpty'.tr();
                          }
                          return null;
                        },
                        inputFormatters: [],
                      ),
                    ),
                    _TextFieldWithTitle(
                      title: 'modals.description'.tr(),
                      child: SizedBox(
                        height: 200,
                        child: DefaultTextField(
                          controller: _descriptionController,
                          hint: 'modals.enterDescription'.tr(),
                          expands: true,
                          textAlign: TextAlign.start,
                          maxLength: 200,
                          keyboardType: TextInputType.multiline,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null) {
                              return null;
                            }
                            if (value.isEmpty) {
                              return 'errors.fieldEmpty'.tr();
                            }
                            if (value.length < 50) {
                              return 'errors.fieldLeastCharacters'.tr();
                            }
                            return null;
                          },
                          inputFormatters: [],
                        ),
                      ),
                    ),
                    MediaUploadWithProgress(
                      store: _store,
                      type: MediaType.any,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            bottom: MediaQuery.of(context).padding.bottom + 10.0,
          ),
          child: Observer(
            builder: (_) => LoginButton(
              enabled: _store.isLoading,
              title: 'crediting.sendReport'.tr(),
              onTap: _onPressedSendReport,
            ),
          ),
        ),
      ),
    );
  }

  _onPressedSendReport() {
    if (_formKey.currentState!.validate()) {
      AlertDialogUtils.showLoadingDialog(context);
      _store.sendReport(
        entityType: widget.arguments.entityType,
        entityId: widget.arguments.entityId,
        title: _titleController.text,
        description: _descriptionController.text,
      );
    }
  }
}

class _TextFieldWithTitle extends StatelessWidget {
  final String title;
  final Widget child;

  const _TextFieldWithTitle({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(
          height: 6,
        ),
        child,
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
