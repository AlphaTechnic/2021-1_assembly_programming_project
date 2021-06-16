1. 프로젝트 빌드 종속성 -> masm
2. asm 파일 우클릭 -> 항목 형식 ->  Microsoft Macro Assembler
3. 프로젝트 속성
   1. Microsoft Macro Assembler -> general -> include path C:\Irvine
   2. Microsoft Macro Assembler  -> Listing file -> Assembled code listing file -> $(ProjectName).lst
   3. Linker -> 일반 -> 추가 라이브러리 디렉터리 -> C:\Irvine 입력
   4. Linker -> 입력 -> 추가종속성 -> irvine32.lib;  편집
   5. Linker -> 고급 -> 이미지에 안전한 -> 아니오 설정
   6. Linker -> 디버깅 -> 디버그 정보생성 으로 set

