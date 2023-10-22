set path=%path% C:\Program Files\Java\jdk1.8.0_241\bin
cd..
set PRAC_SRC=.\src
set PRAC_DOCS=.\docs
set PRAC_BIN=.\bin
javac -sourcepath %PRAC_SRC% -cp %PRAC_BIN% -d %PRAC_BIN% %PRAC_SRC%\Main.java

java -cp %PRAC_BIN% Main
pause