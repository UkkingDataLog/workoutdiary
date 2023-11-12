//--------------------<<  datalist  >>--------------------
//1. 운동 목록
//운동 부위
enum BodyPart {
  legs('Legs', '하체'),
  shoulders('Shoulders', '어깨'),
  chest('Chest', '가슴'),
  arms('Arms', '팔'),
  back('Back', '등'),
  abs('Abs', '복근');

  // enum의 constructor를 정의해 줍니다.
  const BodyPart(this.englishName, this.koreanName);
  final String englishName;
  final String koreanName;
}

final exerciseList = {
  BodyPart.legs: [
    ' ',
  ],
  BodyPart.shoulders: [
    ' ',
  ],
  BodyPart.chest: [
    ' ',
  ],
  BodyPart.arms: [
    ' ',
  ],
  BodyPart.back: [
    ' ',
  ],
  BodyPart.abs: [
    ' ',
  ],
};

List<String> exerciseItems = exerciseList.values.first;
//2. 운동할때 무게
// 0~250kg(lb)까지 수치를 낼때 0.5를 곱하므로 0~501
var lxweightItems = List<int>.filled(501, 0);
//3. 횟수
var lxnumberItems = List<int>.filled(50, 0);
//4. 세트 수
var lxsetItems = List<int>.filled(20, 0);

enum LegsBabel {
  L_B_Barbell_Glute_Bridge('Barbell Glute Bridge', '바벨 글루트 브릿지'),
  L_B_Sumo_Deadlift('Sumo Deadlift', '스모 데드리프트');

  // enum의 constructor를 정의해 줍니다.
  const LegsBabel(this.en, this.ko);
  final String en;
  final String ko;
}
