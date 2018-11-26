%ЗАДАНИЕ №8

%абсолютная позиция
bottom(D,[_,_,_,D]).
medium(C,[_,_,C,_]).
medium(B,[_,B,_,_]).
top(A,[A,_,_,_]).

% X раньше (старше/быстрее/чаще посещает театр/играет в шахматы лучше) Y
before(X,Y,[X|T]):-
    member(Y,T).
before(X,Y,[_|T]):-
    before(X,Y,T).


solve(Mans):-
  ['Борисов','Кириллов','Данин','Савин']=[X, Y, Z, K],
  permutation(['Строитель','Aвтомеханик','Химик','Радиотехник'],
    [Xprof, Yprof, Zprof, Kprof]),
  Mans = [man(X, Xprof), man(Y, Yprof), man(Z, Zprof),  man(K, Kprof)],

  %успехи в шахматах
  permutation(Mans,Chess),

  %Борисов обыгрывает в шахматы Данина
  before( man('Борисов', _),man('Данин', _), Chess),
  %но проигрывает Савину
  before(man('Савин', _),man('Борисов', _),  Chess),

  %Строитель проигрывает в шахматных сражениях автомеханику
  before(man(_, 'Aвтомеханик'), man(_, 'Строитель'),  Chess),

  %возраст
  permutation(Mans,Age),

  %Самый пожилой из инженеров лучше всех играет в шахматы
  top(Grandpa,Age),
  top(Grandpa,Chess),


  %Химик не является ни самым молодым, ни самым старшим
  medium(man(_,'Химик'),Age),


  %скорость на лыжах
  permutation(Mans, Ski),

  %самый молодой лучше всех ходит на лыжах
  bottom(Whelp, Age),
  top(Whelp, Ski),

  %Строитель на лыжах бегает хуже, чем радиотехник
  before(man(_, 'Радиотехник'), man(_, 'Строитель'), Ski),

  %Борисов бегает на лыжах лучше того инженера, который моложе его
  member(Somebody1, Mans),
  before(man('Борисов', _), Somebody1, Ski),
  before(man('Борисов', _), Somebody1, Age),

  %посещение театра
  permutation(Mans,Theater),

  %Самый пожилой из инженеров чаще всех бывает в театре
  top(Grandpa,Theater),

  %Борисов ходит в театр чаще, чем тот инженер, который старше Кириллова.
  member(Somebody2, Mans),
  before(man('Борисов', _), Somebody2,  Theater),
  before(Somebody2, man('Кириллов', _), Age),

  %Химик посещает театр чаще, чем автомеханик, но реже, чем строитель
  before(man(_, 'Химик'), man(_, 'Aвтомеханик'),  Theater),
  before(man(_, 'Строитель'),  man(_, 'Химик'), Theater).
