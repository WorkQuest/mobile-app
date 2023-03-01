import 'package:app/model/profile_response/portfolio.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/create_portfolio/store/create_portfolio_store.dart';
import 'package:app/ui/widgets/default_app_bar.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/media_upload/media_upload_widget.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

final _spacer = const SizedBox(
  height: 10.0,
);

class CreatePortfolioPage extends StatefulWidget {
  final PortfolioModel? portfolio;

  CreatePortfolioPage({
    required this.portfolio,
  });

  static const String routeName = "/addPortfolioPage";

  @override
  State<CreatePortfolioPage> createState() => _CreatePortfolioPageState();
}

class _CreatePortfolioPageState extends State<CreatePortfolioPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late final CreatePortfolioStore store;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isEdit => widget.portfolio != null;

  @override
  void initState() {
    store = context.read<CreatePortfolioStore>();
    _titleController = TextEditingController(text: isEdit ? widget.portfolio!.title : null);
    _descriptionController = TextEditingController(text: isEdit ? widget.portfolio!.description : null);
    if (isEdit) {
      store.setImages(widget.portfolio!.medias);
      store.setDescription(widget.portfolio!.description);
      store.setTitle(widget.portfolio!.title);
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<CreatePortfolioStore>(
      onSuccess: () async {
        await AlertDialogUtils.showSuccessDialog(context);
        Navigator.pop(context, store.successData);
      },
      onFailure: () => false,
      child: Scaffold(
        appBar: DefaultAppBar(
          title: isEdit ? "profiler.editPortfolio".tr() : "profiler.addPortfolio".tr(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: DismissKeyboard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "modals.title".tr(),
                      ),
                      _spacer,
                      DefaultTextField(
                        controller: _titleController,
                        onChanged: store.setTitle,
                        hint: 'modals.title'.tr(),
                        inputFormatters: [],
                        validator: Validators.emptyValidator,
                        enableDispose: false,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "modals.description".tr(),
                      ),
                      _spacer,
                      SizedBox(
                        height: 200,
                        child: DefaultTextField(
                          controller: _descriptionController,
                          onChanged: store.setDescription,
                          keyboardType: TextInputType.multiline,
                          hint: 'quests.aboutPortfolio'.tr(),
                          expands: true,
                          inputFormatters: [],
                          validator: Validators.emptyValidator,
                          enableDispose: false,
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "uploader.files".tr(),
                      ),
                      _spacer,
                      MediaUploadWithProgress(
                        store: store,
                        type: MediaType.images,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 20.0,
          ),
          child: Observer(
            builder: (_) => LoginButton(
              enabled: store.isLoading,
              onTap: store.canSubmit ? _onPressedCreatePortfolio : null,
              title: "meta.save".tr(),
            ),
          ),
        ),
      ),
    );
  }

  _onPressedCreatePortfolio() {
    if (_formKey.currentState?.validate() ?? false) {
      if (isEdit) {
        store.editPortfolio(portfolioId: widget.portfolio!.id);
      } else {
        store.createPortfolio();
      }
    }
  }
}
