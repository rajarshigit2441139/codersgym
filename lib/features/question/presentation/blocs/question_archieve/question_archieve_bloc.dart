import 'package:bloc/bloc.dart';
import 'package:dailycoder/features/question/domain/model/question.dart';
import 'package:dailycoder/features/question/domain/repository/question_repository.dart';
import 'package:equatable/equatable.dart';

part 'question_archieve_event.dart';
part 'question_archieve_state.dart';

class QuestionArchieveBloc
    extends Bloc<QuestionArchieveEvent, QuestionArchieveState> {
  final QuestionRepository _questionRepository;
  final defaultCategorySlug = "all-code-essentials";
  int currentSkip = 0;
  int currentLimit = 10;
  late String currentCategorySlug = defaultCategorySlug;

  QuestionArchieveBloc(this._questionRepository)
      : super(QuestionArchieveState.initial()) {
    on<QuestionArchieveEvent>((event, emit) async {
      switch (event) {
        case FetchQuestionsListEvent():
          await _onFetchQuestionList(event, emit);
          break;
        default:
          break;
      }
    });
  }

  Future<void> _onFetchQuestionList(
    FetchQuestionsListEvent event,
    Emitter<QuestionArchieveState> emit,
  ) async {
    // Set values to input if provided
    currentLimit = event.limit ?? currentLimit;
    currentSkip = event.skip ?? currentSkip;
    if (state.isLoading) {
      return; // Prevent mutliple call resulting in duplicate items
    }
    emit(state.copyWith(isLoading: true));
    final result = await _questionRepository.getProblemQuestion(
      ProblemQuestionQueryInput(
        skip: currentSkip,
        limit: currentLimit,
        categorySlug: currentCategorySlug,
      ),
    );

    result.when(
      onSuccess: (newQuestionList) {
        final updatedList = List<Question>.from(state.questions)
          ..addAll(
            newQuestionList.$1,
          );
        final moreQuestionAvailable = updatedList.length < newQuestionList.$2;
        // Update currentSkip
        currentSkip = updatedList.length;

        emit(
          state.copyWith(
            questions: updatedList,
            moreQuestionAvailable: moreQuestionAvailable,
          ),
        );
      },
      onFailure: (exception) {
        emit(state.copyWith(error: exception));
      },
    );

    emit(state.copyWith(isLoading: false));
    // result
  }
}
