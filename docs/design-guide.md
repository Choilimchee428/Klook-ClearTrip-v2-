# Klook ClearTrip v2 — Design Guide

## 문제 정의
현재 Klook은 Booking Summary와 Price Summary 및 관련 경고를 이미 제공하지만, 일부 핵심 정보가 별도 팝업과 스크롤 영역에 나뉘어 있다. 결제 전 중요 정보의 가시성과 일관성을 개선한다.

## 화면 구성

| 번호 | Widget | 비즈니스 명칭 | 원칙 | 표시 기준 |
|---|---|---|---|---|
| A-1 | AppBar | 상품 탐색 제목줄 | P04 | 브랜드 및 탐색 |
| A-2 | Card / InkWell | 상품 선택 카드 | P02/P06 | 상품명, 가격, 선택 표시 |
| A-3 | ChoiceChip | 날짜 및 상품 선택 | P07 | 누른 선택을 명확히 표시 |
| A-4 | ChoiceChip | 날짜·가격 카드 | P05/P06 | 가격은 날짜와 함께 표시 |
| A-5 | IconButton / Row | 인원 선택 | P03/P05 | 1~10명, 유효 범위 제한 |
| A-6 | ConditionRow | 핵심 이용 조건 | P06/P08 | 중요한 규칙 직접 표시 |
| A-7 | InfoPair | 총금액 | P01 | 날짜·수량에 따라 표시 |
| A-8 | FilledButton | 예약 내용 확인 이동 | P03/P05 | A→B Navigator.push |
| B-1 | AppBar | 예약 확인 제목줄 | P03/P04 | 이전 단계 이동 |
| B-2 | Text / Column | 확인 목적 안내 | P02 | 지금 확인할 과업 표시 |
| B-3 | SectionCard / InfoPair | 통합 예약 정보 | P05/P06 | 날짜·인원·가격·상품 한곳에 |
| B-4 | TextButton | 선택 사항 수정 | P03 | A로 돌아가기 |
| B-5 | ConditionRow | 중요 이용 규정 | P05/P08 | 취소 등 고위험 항목 기본 노출 |
| B-6 | BottomSheet / FutureBuilder | 전체 이용 규정 | P10 | GET /policies 로드 |
| B-7 | SectionCard | 연락처 관련 안내 | P05 | 실제 개인정보 입력 없음 |
| B-8 | CheckboxListTile | 내용 확인 체크 | P05 | 유효성 검토가 필요한 설계 가설 |
| B-9 | FilledButton | 모의 예약 결과 이동 | P01/P05 | B→C BottomSheet |
| C-1 | Sheet Header | 결과 제목 | P04 | 명확한 결과 화면 |
| C-2 | Card / Icon / Text | 예약 상태 카드 | P01 | 문구+아이콘+색상 |
| C-3 | Card / InfoPair | 주문 내용 요약 | P04/P06 | 동일한 날짜·수량·가격 유지 |
| C-4 | SegmentedButton | 모의 결과 전환 | P01 | 수업 시연용, 실제 상태 변경 아님 |
| C-5 | Card / Text | 다음 행동 설명 | P09/P10 | 상태에 맞는 안내 |
| C-6 | OutlinedButton | 이전 화면 | P03 | 모달 종료 |

## 상태 지점

| 상태 | 변화 데이터 | 영향 위젯 | 코드 표기 |
|---|---|---|---|
| S1 | 선택 상품 | A-2/A-3/A-7 | // STATE S1 |
| S2 | 선택 날짜 | A-4/A-7/B-3 | // STATE S2 |
| S3 | 인원 | A-5/A-7/B-3 | // STATE S3 |
| S4 | 확인 여부 | B-8/B-9 | // STATE S4 |
| S5 | 모의 결과 | C-2/C-4/C-5 | // STATE S5 |
| S6 | GET 요청 | A 목록, B 전체 정책 | fetchProducts / fetchPolicyDetails |

`setState`는 화면 내부 예시를 표시하는 최소 범위이며 Provider, Bloc, Riverpod이나 영구 저장을 도입하지 않는다.

## 정보 전달 기준
A: 상품→날짜→인원→조건→가격→확인 버튼. B: 상품/날짜/인원/가격→고위험 조건→연락처 주의→결과 버튼. C: 현재 상태→의미→상품 정보→후속 행동.

## 시각 규칙
브랜드 오렌지 강조; 흰 카드와 명확한 여백; 오류와 확인은 색만이 아니라 아이콘/텍스트로 함께 표시. 긴 규정은 기본 화면에 전부 펼치지 않고 확인 경로를 제공한다.
