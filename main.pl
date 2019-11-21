:- include('nouns.pl').
:- include('verbs.pl').
:- dynamic girilencumle/5.

undo :- retract(girilencumle(_, _, _, _, _)), fail.
undo :- open('X.txt', write, Stream), close(Stream).

cumle(A, B, C, D, E) :- undo, asserta(girilencumle(A, B, C, D, E)), cikarim(A, B, C, D, E).

cikarim(A, B, C, D, E) :- open('X.txt', append, Stream),
	write('~~~~~ 1 ADIMLI CIKARIMLAR ~~~~~'), nl,
	write(Stream, '~~~~~ 1 ADIMLI CIKARIMLAR ~~~~~'), nl(Stream), close(Stream),
	cikarim1(A, B, C, D, E),
	open('X.txt', append, Stream1),
	write('~~~~~ 2 ADIMLI CIKARIMLAR ~~~~~'), nl,
	write(Stream1, '~~~~~ 2 ADIMLI CIKARIMLAR ~~~~~'), nl(Stream1), close(Stream1), 
	cikarim2(A, B, C, D, E),
	open('X.txt', append, Stream2), nl(Stream2),
	nl, write('~~~~~ 3 ADIMLI CIKARIMLAR ~~~~~'), nl,
	write(Stream2, '~~~~~ 3 ADIMLI CIKARIMLAR ~~~~~'), nl(Stream2), close(Stream2),  
	cikarim3(A, B, C, D, E).

cikarim1(A, _, _, _, _) :-
	bulunmak1(A, _, _, Yer, _), open('X.txt', append, Stream),
	write(A), write(' '), write(Yer), write('(da) bulundu.'), nl, 
	write(Stream, A), write(Stream, ' '), write(Stream, Yer), write(Stream, '(da) bulundu.'), nl(Stream), 
	close(Stream), fail.
cikarim1(A, _, _, _, _) :-
	olmak1(A, Ne, _, _, _), open('X.txt', append, Stream),
	write(A), write(' '), write(Ne), write('(dir).'), nl, 
	write(Stream, A), write(Stream, ' '), write(Stream, Ne), write(Stream, '(dir).'), nl(Stream), 
	close(Stream), fail.
cikarim1(_, _, _, _, _).


cikarim2(A, _, _, _, _) :-
	yapmak2(A, _, _, _, Ne), open('X.txt', append, Stream),
	write(A), write(' '), write(Ne), write(' yapar.'), nl,
	write(Stream, A), write(Stream, ' '), write(Stream, Ne), write(Stream, ' yapar.'), nl(Stream),
	close(Stream), fail.
cikarim2(A, _, _, _, _) :-
	olmak2(A, Ne, _, _, _), open('X.txt', append, Stream),
	write(A), write(' '), write(Ne), write('(dir).'), nl, 
	write(Stream, A), write(Stream, ' '), write(Stream, Ne), write(Stream, '(dir).'), nl(Stream), 
	close(Stream), fail.
cikarim2(_, _, _, _, _).


cikarim3(A, _, _, _, _) :-
	sahip3(A, Nesne, _, _, _), open('X.txt', append, Stream),
	write(A), write(' '), write(Nesne), write('(ye) sahiptir.'), nl, 
	write(Stream, A), write(Stream, ' '), write(Stream, Nesne), write(Stream, '(ye) sahiptir.'), nl(Stream), 
	close(Stream), fail.
cikarim3(_, _, _, _, _).




/* 1 ADIMLI ÇIKARIM İLİŞKİLERİ */
/* Biri bir yerde bir sey yaptiysa, o kisi orada bulunmustur. */
bulunmak1(A, _, _, Yer, _) :- girilencumle(A, _, _, Yer, _), not(var(A)), not(var(Yer)).
/* Biri bir is yaparsa, o is bir yerde yapiliyorsa, o kisi o yerde bulunmustur. */
bulunmak1(A, _, _, Yer, _) :- yapmak1(A, _, _, _, Z), iliski(Z, 'nerede yapilir?', Yer),
	open('X.txt', append, Stream),
	write('('), write(Z), write(' '), write(Yer), write('(da) yapilir.) -> '),
	write(Stream, '('), write(Stream, Z), write(Stream, ' '), write(Stream, Yer), write(Stream, '(da) yapilir.) -> '),
	close(Stream).

/* Biri bir sey gerceklestirdiyse, o kisi onu yapmistir. */
yapmak1(A, _, _, _, Ne) :- girilencumle(A, _, _, _, Ne), not(var(A)), not(var(Ne)).

olmak1(A, Ne, _, _, _) :- girilencumle(A, Ne, _, _, olmak), not(var(A)), not(var(Ne)).
/* Biri bir nesne kullanirsa, o nesneyi belirli kisiler kullaniyorsa, o kisi o belirli kisilerdendir. */
olmak1(A, Kim, _, _, _) :- girilencumle(A, Ne, _, _, _), not(var(A)), not(var(Ne)), 
	iliski(Ne, 'kim kullanir', Kim),
	open('X.txt', append, Stream),
	write('('), write(Ne), write('(leri) '), write(Kim), write('(ler) kullanir.) -> '),
	write(Stream, '('), write(Stream, Ne), write(Stream, '(leri) '), write(Stream, Kim), write(Stream, '(ler) kullanir.) -> '),
	close(Stream).
/* Biri bir is yaparsa, o isi belirli kisiler yaparsa, o kisi o belirli kisilerdendir. */
olmak1(A, Ne, _, _, _) :- yapmak1(A, _, _, _, Y), iliski(Y, 'kim/ne yapar?', Ne),
	open('X.txt', append, Stream),
	write('('), write(Ne), write('(ler) '), write(Y), write(' yapar.) -> '),
	write(Stream, '('), write(Stream, Ne), write(Stream, '(ler) '), write(Stream, Y), write(Stream, ' yapar.) -> '),
	close(Stream).

/* 2 ADIMLI ÇIKARIM İLİŞKİLERİ */
/* Biri birsey ise, o birsey birsey yapiyorsa, o kisi o seyi yapiyordur. */
yapmak2(A, _, _, _, Z) :- olmak1(A, X, _, _, _), iliski(Z, 'kim/ne yapar?', X),
	open('X.txt', append, Stream),
	write('('), write(A), write(' bir '), write(X), write('(dir). '),
	write(X), write('(ler) '), write(Z), write(' yapar.) -> '),
	write(Stream, '('), write(Stream, A), write(Stream, ' bir '), write(Stream, X), write(Stream, '(dir). '),
	write(Stream, X), write(Stream, '(ler) '), write(Stream, Z), write(Stream, ' yapar.) -> '),
	close(Stream).

/* Biri birsey ise, o birsey baska birseyin alt kavramiysa, o kisi o baska birseydir. */
olmak2(A, Ne, _, _, _) :- olmak1(A, Ne1, _, _, _), iliski(Ne1, 'ust kavrami nedir?', Ne),
	open('X.txt', append, Stream),
	write('('), write(A), write(' bir '), write(Ne1), write('(dir). '),
	write(Ne1), write('(ler) '), write(Ne), write('(dir).) -> '),
	write(Stream, '('), write(Stream, A), write(Stream, ' bir '), write(Stream, Ne1), write(Stream, '(dir). '),
	write(Stream, Ne1), write(Stream, '(ler) '), write(Stream, Ne), write(Stream, '(dir).) -> '),
	close(Stream).


/* 3 ADIMLI ÇIKARIM İLİŞKİLERİ */
sahip3(A, Neye, _, _, _) :- yapmak2(A, _, _, _, Ne), iliski(Ne, 'kim/ne ile yapilir?', Neye),
	open('X.txt', append, Stream),
	write('('), write(A), write(' '), write(Ne), write(' yapar. '),
	write(Ne), write(' '), write(Neye), write(' ile yapilir.) -> '),
	write(Stream, '('), write(Stream, A), write(Stream, ' '), write(Stream, Ne), write(Stream, ' yapar. '),
	write(Stream, Ne), write(Stream, ' '), write(Stream, Neye), write(Stream, ' ile yapilir.) -> '),
	close(Stream).

