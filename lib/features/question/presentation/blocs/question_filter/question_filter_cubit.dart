import 'package:bloc/bloc.dart';
import 'package:codersgym/core/utils/bloc_extension.dart';
import 'package:codersgym/features/question/domain/model/problem_sort_option.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:equatable/equatable.dart';

part 'question_filter_state.dart';

class QuestionFilterCubit extends Cubit<QuestionFilterState> {
  QuestionFilterCubit() : super(const QuestionFilterState());

  void setDifficulty(String? difficulty) {
    if (difficulty == null) {
        safeEmit(
        QuestionFilterState(
          sortOption: state.sortOption,
          topicTags: state.topicTags,
        ),
      );
      return;
    }
    safeEmit(
      state.copyWith(
        difficulty: difficulty,
      ),
    );
  }

  void setTopicTags(Set<TopicTags> tags) {
    safeEmit(
      state.copyWith(
        topicTags: tags,
      ),
    );
  }

  void setSortOption(ProblemSortOption? sortOption) {
    if (sortOption == null) {
      safeEmit(
        QuestionFilterState(
          difficulty: state.difficulty,
          topicTags: state.topicTags,
        ),
      );
      return;
    }
    safeEmit(
      state.copyWith(
        sortOption: sortOption,
      ),
    );
  }

  void reset() {
    safeEmit(
      const QuestionFilterState(),
    );
  }
}
