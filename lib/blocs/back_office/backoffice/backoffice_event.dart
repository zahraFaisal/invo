abstract class BackOfficePageEvent {}

class BackToPos implements BackOfficePageEvent {
  BackToPos();
}

class ResetDatabase implements BackOfficePageEvent {
  ResetDatabase();
}
