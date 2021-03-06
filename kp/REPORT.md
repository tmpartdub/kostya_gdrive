# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Лукашкин К.В.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |  16.12.2017        |  5- (отл)             |
| Левинская М.А.|              |               |

> Предикат поиска родственника находит не все решения за счет ограничения перебора.

## Введение

За время выполнения курсоого проекта я изучил обширный пласт логического программирования, применил многие навыки полученые при выполнении лабораторных работ, например методы поиска и естественно-языковой интерфейс. Также я познакомился с таким форматом как GedCom, по сути, аналогов для представления генеалогических деревьев не существует. Он хорошо развит и документирован.

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com 
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: ...
 3. Реализовать предикат проверки/поиска .... 
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. 

## Получение родословного дерева

Моё родословное дерево получилось не сильно большим, поскольку сколько-нибудь достоверные данные было достать невозможно. Моя семья испокон веков проживала в деревне, а в деревнях строгого учёта населения не проводилось, также документальных свидетельств правдивости инфорации изложенной в дереве касательно далёких предков я предоставить не могу.

## Конвертация родословного дерева

Для конвертации родословного дерева я использовал язык Python, поскольку он удобен для работы с текстом и идеально подходит для подобных задач -- быстро написать программу, который ты больше никогда не воспользуешься. Главным принципом моей программы является построчное считывание файла с запоминание id конкретного человека, затем по этим id создание семей. 
Генерация предиката child:
```
while (line[1] == 'CHIL'):
			if len(wife)>0:
				print("child({0}, {1}).".format(people[line[2]], wife))
			if husbando:
				print("child({0}, {1}).".format(people[line[2]], husbando))
			line = f.readline().split()
```



## Предикат поиска родственника

Предикат поиска родственника, в моём случае шурина, реализован следующим образом:
```
brotherinlaw(X, Y):-
  %Х имеет жену -> он мужчина
  male(X),
  child(Z,X),
  child(Z,M),
  %нашли жену
  female(M),
  %ищем ее родителей
  child(M,A),
  child(M,B),
  female(A),
  male(B),
  %ищем брата
  child(Y,A),
  child(Y,B),
  male(Y).
```
Для поиска применяется обход по всем мужчинам -- это очень простой и очевидный способ, который гарантирует нахождение всех шуринов. При поиске шурина можно сразу предположить что это мужчина, тем самым отсекая всех женщин от дальнейших проверок.
```
?- brother
brother       brotherinlaw
?- brotherinlaw("Евгений Кольчугин",X).
X = "Вячеслав Лукашкин" ;
false.

?- brotherinlaw(Y,X).
Y = "Евгений Кольчугин",
X = "Вячеслав Лукашкин" ;
false.
```

## Определение степени родства


`relative(Родство, X, Y)` Кто Y для X? Определение родства двух конкретных индивидуумов.

При определении произвольной степени родства сперва проверяются тривиальные случаи, например
```
relative(son, X, Y, _):-    child(Y,X), male(Y).
```
когда все они пройдены, необходимо искать более сложные решения для это используется предикат
```
более глубокая взаимосвязь
relative(Surf-Deep, X, Y, N):-                N = 'deep',
  relative(Deep, X, Intermediate, 'deep'),    not(X = Intermediate),
  relative(Surf, Intermediate, Y, 'surface'), not(Y = Intermediate), not(X = Y).

```
Суть его заключается в следующем: определяем для Х человека, который является каким либо родственником ему, и пытаемся определить степень родства этого человека для Y. Чтобы избежать циклов и малочитаемых сложных решений на ранних стадиях поиска, поиск для Y осуществляется поверхностно, без захода в рекурсивную функцию опеределения родства. Полнота вывода от этого не страдает. Бесконечное количество ответов от такого решения оптимизации не уменьшилось. Однако удобочитаемость и простота ответов повысилась, поскольку подобный поиск очень похож на обход графа с итерационным спуском, величина спуска равна 1, таким спуском обусловливается последовательное увеличения количества слов в ответе.

## Естественно-языковый интерфейс

Естественно языковой интерфейс реализован для двух ситуаций: Сколько (тип родственника) имеет человек? и проверки истинности утверждения: Маша сестра пети? и ответа, сообщающего о том, что запрос пользователя не распознан.
Определение смысла происходит с помощью разбора предложения на значащие части, определения по ним типа запроса и последующего его анализа. 

Для определения типа вопроса используется словарь, строки в нём имеют вид
```
  'is':type('approve'),
   'How':'many':type('count'),
    'Have':type('having'),
```
по этим значащим частям программа вычленияет структуру запроса и пытается определить, что является искомым именем, а что типом родственной связи. Поскольку в естесственном языке используется множественное число при вопросах о количестве, то также необходим словарь для определения числа слова:
```
gen_many(F):-
  F=[
  fathers:father,
  mothers:mother,
  ...
```
Проверка на человека:
```
name(X):-
  female(X).
name(X):-
  male(X).
```
Проверка на то, что это родственная связь (Для примера я взял связи глубиной более 10, которые при размерах моего дерева заведомо мало понятны для человека, и вероятнее всего извиваются по дереву, имея абсолютно нечитаемый вид):
```
contacts(S,S1):-
  many(S,S1),
  contacts(S1, 10,_).
  
contacts(S,N,_):-
  N>0,
  N1 is N-1,
  S = father;
  ...
  S = contacts(1)-contacts(N1).
```
Когда структура становиться понятна программе, производится запрос к ранее реализованомму предикату, обработка его ответа и вывод на экран. Подсчёт количества:
```
...
    setof(N,relative(Rel,E,N),L),
    length(L,N1),
    write("There are "), write(N1),
    write(" "),
    write(C),nl,
    write(L), nl, !.
```
и определение истинности:
```
relative(Rel,B,E),
  write("Yes, it is"), nl, !.
  
...
  write("No, this is wrong"), nl,!.
```

Обработка непонятых запросов:
```
a_phrase(_):- write("Can not understand question. Please, be more specific"), nl.
```

Использование:
```
?- a_phrase(['How','many','fathers','does',"Елизавета Лукашкина",'has']).
There are 1 fathers
[Вячеслав Лукашкин]
true.

?- a_phrase(['How','many','brothers','does',"Елизавета Лукашкина",'has']).
There are 1 brothers
[Константин Лукашкин]
true.

?- a_phrase(['Does',"Вячеслав Лукашкин",'has','daugther',"Елизавета Лукашкина"]).
Yes, it is
true.

```

## Выводы

Курсовой проект заставил меня задуматся над серьёзным изучением функциональных языков программирования, в процессе написания реферата, я мельком познакомился с таким языком как Mercury, он показался мне очень интересным в плане концепций и методов решения. При выполнении 5-го задания курсовой и 4-го лабораторной работы я познакомился с анализом естественных языков. До этого момента естественный язык казался мне непостижимо сложным, неопределенным и творческим, таким, каким компьютер не сможет овладеть, хотя сейчас сопоставляя русский язык и абстракции в языках программирования, таких как Haskell (к примеру бесконечные ряды), я подумал, что быть может вполне реально научить машину естественному языку, если она уже владеет такими сложными математическими концепциями и абстракциями.
