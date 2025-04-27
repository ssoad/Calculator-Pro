import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_calculator/bloc/calculator_bloc/calculator_bloc.dart';
import 'package:neumorphic_calculator/bloc/page_cubit/page_cubit.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/utils/result_model.dart';
import 'package:neumorphic_calculator/widgets/confirm_dialog.dart';

import 'bloc/history_bloc/history_bloc.dart';
import 'service/preference_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ScrollController _scrollController;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 56, end: 0).animate(_controller);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService.instance;
    final showTip = prefs.settingsModel.showHistoryTip;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Theme.of(context).colorScheme.primary;
    final backgroundColor =
        isDark ? const Color(0xFF252525) : const Color(0xFFEEEEEE);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            final resultNotEmpty =
                state is HistoryLoaded && state.results.isNotEmpty;

            return Scaffold(
                backgroundColor: backgroundColor,
                appBar: AppBar(
                  systemOverlayStyle: Theme.of(context)
                      .appBarTheme
                      .systemOverlayStyle
                      ?.copyWith(
                        systemNavigationBarColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      ),
                  title: Row(
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //     color: accentColor.withOpacity(0.2),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Icon(
                      //     Icons.history,
                      //     color: accentColor,
                      //     size: 22,
                      //   ),
                      // ),
                      // const SizedBox(width: 12),
                      const Text(
                        'History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  elevation: 0,
                  backgroundColor: backgroundColor,
                  bottom: showTip && resultNotEmpty
                      ? PreferredSize(
                          preferredSize: Size.fromHeight(_animation.value),
                          child: SizedBox(
                            height: _animation.value,
                            child: ClipRect(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.info_outline,
                                    color: accentColor,
                                  ),
                                  title: const Text(
                                    'Press and hold to copy result',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _controller.forward();
                                      prefs.updateSettings(prefs.settingsModel
                                          .copyWith(showHistoryTip: false));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ))
                      : null,
                  actions: [
                    if (resultNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              ConfirmDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Clear History'),
                                      Lottie.asset(
                                        !isDark
                                            ? AppConst.deleteDark
                                            : AppConst.deleteLight,
                                        height: 50,
                                        width: 50,
                                        repeat: false,
                                      ),
                                    ],
                                  ),
                                  content:
                                      'Are you sure you want to clear the history?',
                                  confirmText: 'Clear',
                                  onConfirm: () {
                                    context
                                        .read<HistoryBloc>()
                                        .add(const ClearHistory());
                                  }).show(context);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                body: switch (state) {
                  HistoryInitial() => _buildEmptyState(isDark, accentColor),
                  HistoryLoading() => Center(
                      child: CircularProgressIndicator(color: accentColor),
                    ),
                  HistoryEmpty() => _buildEmptyState(isDark, accentColor),
                  HistoryLoaded() => _buildHistoryList(
                      state.results,
                      isDark,
                      accentColor,
                      context,
                    ),
                  HistoryFailure() => _buildErrorState(state.error, isDark),
                });
          },
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark, Color accentColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie.asset(
          //   isDark ? AppConst.emptyHistoryDark : AppConst.emptyHistoryLight,
          //   height: 160,
          //   width: 160,
          // ),
          const SizedBox(height: 20),
          Text(
            'No History Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your calculation history will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 70,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 20),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(
    List<ResultModel> results,
    bool isDark,
    Color accentColor,
    BuildContext context,
  ) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        final isLastItem = index == results.length - 1;

        // Group items by date
        final bool showDateHeader = index == 0 ||
            !_isSameDay(results[index].dateTime, results[index - 1].dateTime);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader)
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 8,
                  left: 8,
                ),
                child: Text(
                  _formatDate(result.dateTime),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
            _buildHistoryCard(result, isDark, accentColor, context, isLastItem),
          ],
        );
      },
    );
  }

  Widget _buildHistoryCard(
    ResultModel result,
    bool isDark,
    Color accentColor,
    BuildContext context,
    bool isLastItem,
  ) {
    final shadowDark =
        isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade300;
    final shadowLight = isDark ? Colors.grey.shade800 : Colors.white;

    return Container(
      margin: EdgeInsets.only(bottom: isLastItem ? 80 : 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowDark,
            offset: const Offset(3, 3),
            blurRadius: 5,
          ),
          BoxShadow(
            color: shadowLight,
            offset: const Offset(-3, -3),
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.read<CalculatorBloc>().add(LoadCalculation(result));
            context.read<PageCubit>().updateIndex(1);
          },
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: result.output));
            HapticFeedback.heavyImpact();

            // Show snackbar to confirm copying
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Result copied to clipboard'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: accentColor,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expression section
                Text(
                  result.expression,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // Result section
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '= ${result.output}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        result.dateTime.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();

    if (_isSameDay(date, now)) {
      return 'Today';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      // Format date
      final List<String> months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }
}
