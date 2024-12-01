import 'login_dao.dart';

Map<String, String> hiHeader() {
  return {
    "auth-token": "ZmEtMjAyMS0wNC0xMaiAyMToyddMjoyMC1mYQ==ft",
    "course-flag": 'ft',
    "boarding-pass": LoginDao.getBoardingPass() ?? ""
  };
}
