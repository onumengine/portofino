import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:port/bloc/submit/event.dart';
import 'package:port/bloc/submit/state.dart';
import 'package:port/repository/api_client.dart';
import 'package:port/utility/constants.dart';

class SubmitBloc extends Bloc<SubmitScreenEvent, SubmitScreenState> {
  ApiClient _apiClient = ApiClient();

  @override
  SubmitScreenState get initialState => DefaultState();

  @override
  Stream<SubmitScreenState> mapEventToState(SubmitScreenEvent event) async* {
    if (event is SubmissionEvent) {
      try {
        await _postSchedule(note: event.note);
      } catch (e) {
        print(e.toString());
      }
    } else if (event is PurposesFetchEvent) {
      _fetchAppointmentReasons();
    }
    yield SuccessfulSubmissionState();
  }

  _postSchedule({String note}) async {
    await _apiClient.postForm(
      SCHEDULE_POST_PATH,
      {
        "note": note,
      },
    );
  }

  _fetchAppointmentReasons() async {
    var purposes = await _apiClient.get(PURPOSES_FETCH_PATH);
    print("THE PURPOSES THAT HAVE BEEN FETCHED ARE: $purposes");
  }
}
