# Отчет по лабораторной работе №1
## Работа со списками и реляционным представлением данных
## по курсу "Логическое программирование"

### студент: Лукашкин К.В.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|   22/12/17   |   4          |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Список в Прологе можно представить как двоичное дерево и дать следующее рекурсивное определение: пустой список является списком, список состоит из элемента (головы) и другого списка (хвоста). Такое представление показывает каким образом чаще всего происходит работа со списками, обрабатывается голова и рекурсивно вызывается та же функция для хвоста, пока он не будет пустым. 

От принятых в императивных языках подходов к хранению данных списки Пролога отличаются, в первую очередь, произвольным типом элементов, такое свободное отношение к типам редко в императивных языках. Как было сказано выше списки Пролога очень похожи на бинарные деревья, с тем допущением, что каждый узел имеет лист. В SWI-Prolog, в частности, присутствует большой набор встроенных функций для обработки списков, что наталкивает на мысль о схожести списков и векторов (вектор -- динамический массив): они часто меняют количество содержащися элементов и действия чаще всего производятся с крайними элементами (функции pop и push у вектора).

## Задание 1.1: Предикат обработки списка

`getn(Number, List, Elem)` Получение N-го элемента списка без стандартных предикатов

`getn_std(Number, List, Elem)` Получение N-го элемента списка


Примеры использования:
```?- getn(4,[a,b,c,d,e,f],X).
X = d .
?- getn(Y,[a,b,c,d,e,f],c).
Y = 3 .
?- getn(Y,[1,2,3,a,b,c],f).
false.
?- getn(10,[a,b,c,d,e,f,j,k,l,m,n,o,p,r,s,t],X).
X = m .
?- getn_std(1,[a],X).
X = a.
?- getn_std(Y,[a,b,c,d,e,f],c).
Y = 3 .
```

Реализация:
```getn(1,[H|_],H).
getn(N,[_|T],X):-
  getn(N1,T,X),
  N is N1+1.
```
Рекурсивно обходим список и уменьшаем N пока оно не станет равным единице, голова полученного списка есть искомое.
```
getn_std(N,T,X):-
  my_append(A,[X|_],T),
  my_length(A,L),
  N is L+1.
```
С помощью append отсекаем от исходного списка элемент длиной N-1, первый элемент (голова) оставшейся части есть искомое.

## Задание 1.2: Предикат обработки числового списка
`is_geom(List)` Проверка списка на геометрическую прогрессию

`is_geom(List, Number)` Проверка списка на геометрическую прогрессию и вычисление знаменателя прогрессии


Примеры использования:
```?- is_geom([1,2,4,8],X).
X = 2 .
?- is_geom([27,9,3,1],X).
X = 0.3333333333333333 .
?- is_geom([1,2,4,9]).
false.
?- is_geom([3,3,3,3]).
true .
```
Реализация:
```
is_geom(H):-
  %поиск прогрессии с любым знаменателем  
  is_geom(H,_).
  
is_geom([],_).
is_geom([_],_).
is_geom([A,B|T],N):-
  A =\= 0,
  N is B/A,
  is_geom([B|T],N).
```
Выделяем по два числа из списка и смотрим, равно ли их частное знаменателю прогрессии. При делении происходит проверка на неравенство нулю

## Задание 1.3: Пример совместного использования
`generate(List, List1)` Попытаться переставить элементы в списке, так, чтобы получилась геометрическая прогрессия.

Примеры использования:
```
?- generate([8,1,2,4],L).
L = [8, 4, 2, 1] ;
L = [1, 2, 4, 8] .

?- generate([27,9,3,1],L).
L = [27, 9, 3, 1] ;
L = [1, 3, 9, 27] .
```

Реализация:
```
generate(L,L1):-
  my_permute(L, L1),
  is_geom(L1).
```
Все престановки списка проверяются на геометрическую прогрессию.

## Задание 2: Реляционное представление данных

Термин «реляционный» означает, что теория основана на понятии отношениях (relation) между объектами. Для удовлетворения запроса к таким данным необходимо провести анализ отношений между ними. Таким образом задачей программиста является создание программы, позволяющей осуществлять этот анализ. Самым главным преимуществом такого представления данных является приближенность к реальному миру. Отношения являются логическими и абстрактными, а не физически хранимыми структурами.

Моё представление похоже на ячейки таблицы с подписями столбцов и строк. Оно занимает очень много места: для четырёх небольших групп ученков по 5 проставленных  оценок, оно заняло 202 строки. Но в тоже время, как программисту, с ним очень удобно работать. По небольшому телу запроса получаем лаконичный и краткий ответ. Навигация по всем конретным полям за счёт такого развернутого представления очень удобна и проста.
Большая часть строк содержит в себе фамилии учеников и оценки по предметам, так что для оптиизации по памяти, в первую очередь стоит учитывать именно это. Напрмер, собрать оценки в какой-либо компактный журнал или таблицу.

Данные: 1 (one.pl)

Задание: Вариант 3
- Для каждого студента, найти средний балл, и сдал ли он экзамены или нет
- Для каждого предмета, найти количество не сдавших студентов
- Для каждой группы, найти студента (студентов) с максимальным средним баллом

### Задание 2.1: Для каждого студента, найти средний балл, и сдал ли он экзамены или нет

`average_mark(Stud,Mark)` Для каждого студента, найти средний балл

`pass_exams(Stud)` Сдал ли студент экзамены

Примеры использования:
```
?- average_mark('Петров',X).
X = 3.8333333333333335.

?- average_mark(X,4).
X = 'Сидоркин' ;
X = 'Программиро' ;
X = 'Мышин' ;
X = 'Решетников' ;
X = 'Эксель' ;
X = 'Блокчейнис' .

?- average_mark('Эксель',X).
X = 4.
```

Реализация:
```
%1. Для каждого студента, найти средний балл, и сдал ли он экзамены или нет
%(Студент, Средняя оценка)
average_mark(Stud,Mark):-
  student(_,Stud),
  findall(A, grade(Stud,_,A),Marks),
  sum(Marks,S),
  my_length(Marks,C),
  Mark is S / C.

%Cумма всех элементов в списке
%(Список, Сумма)
sum([H|T],N):-
  sum(T,N1),
  N is N1+H.
sum([],0).

%Сдал ли студент экзамены
%Если хотя бы одна двойка, то false
%(Студент)
pass_exams(Stud):-
  findall(A, grade(Stud,_,A),Marks),
  not(my_member(2,Marks)).

```
Для поиска средней оценки находяться все оценки студента, суммируются  и cумма делится на их количество.

Сдал ли студент экзамен? Ищутся все его оценки и проверятся наличие среди них двоек.

### Задание 2.2:  Для каждого предмета, найти количество не сдавших студентов

`count_of_failed(Subj,N)` Для каждого предмета, найти количество не сдавших студентов

Примеры использования:
```
?- count_of_failed('Психология',X).
X = 5.

?- count_of_failed(X,5).
X = 'Психология'.
```

Реализация:
```
%2. Для каждого предмета, найти количество не сдавших студентов
%(Предмет, количество)
count_of_failed(Subj,N):-
  subject(Ss,Subj),
  setof(A,grade(A,Ss,2),L),
  my_length(L, C),
  N is C.
```
Для предмета находится множество (без повторений!) учеников у которых двойка по этому предмету. Длина этого списка-множества искомое.

### Задание 2.3: Для каждой группы, найти студента (студентов) с максимальным средним баллом

`best_student(Group,N)` Для каждой группы, найти студента (студентов) с максимальным средним баллом

Примеры использования:
```
?- best_student(104,L).
L = ['Иванов', 'Фулл'] .

?- best_student(101,L).
L = ['Петровский'] .

?- best_student(102,L).
L = ['Шарпин'] .

?- best_student(103,L).
L = ['Сиплюсплюсов', 'Клавиатурникова'] .
```

Реализация:
```
%3. Для каждой группы, найти студента (студентов) с максимальным средним баллом
%(Группа, Список учеников с максимальным средним баллом)
best_student(Group,N):-
  %собираем список со всеми средними оценками
  findall(Mark, (student(Group,Stud), average_mark(Stud,Mark)),Marks),
  %находим мвксимальную из них
  max(Marks,Max),
  %составляем список из всех студентов имеющих такую оценку
  findall(A,(student(Group,A), average_mark(A,M), M==Max), N).

%Нахождение максимального из положительного числового списка
%(Список, максимум)
max([],0).
max([H|T],N):-
  max(T,B),
  H =< B,
  N is B.
max([H|T],N):-
  max(T,B),
  H >= B,
  N is H.
```
Сперва ищется максимальная средняя оценка по группе: находиться список со всеми оценками и выделяется максимальная. Затем собирается список со всеми учениками, имеющими эту максимальную оценку.
## Выводы

Самоег главное отличие Пролога от привычных мне императивных языков программирования то, что программист описавыет задачу, которую Пролог, по сути, решает сам. Тексты программ на Прологе удивительно просто читать, и в тоже время их написание сложный процесс, который заставляет программиста мыслить глобально, логически, не пошагово.
Примечательно, что иногда Пролог находит нетривиальное решение задачи, которое программист и не представлял увидеть среди ответов, но в то же время удовлетворяющее условиям задачи. 
Во время составления программ я немало времени уделил использованию трассировки, это помогло мне лучше понять логику Пролога, как он думает, и вникнуть в механизм бэктрекинга. 
Пролог, для меня, оказался неожиданно мощным средством решения задач, я продолжу более глубокое изучение его механизмов.



