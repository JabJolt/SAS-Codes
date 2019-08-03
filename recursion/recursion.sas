options mprint mlogic symbolgen;

/* Power */

%macro recPower(num, power);
%if &power eq 0 %then
%do; 
1
%return;
%end;
%let power=%sysevalf(&power-1);
%sysevalf(&num*%recPower(&num., &power))
%mend;

%put %recPower(2.4, 3);

/* --- Sum --- */

/* Delete parenthesises */
%macro mDelParenths(mvString);
	%sysfunc( compress(%nrbquote(&mvString.), %str(%(%))) )
%mend;

/* integer */
%macro recSum / parmbuff;
	%let mvPars=%nrbquote(%sysfunc(compress(%nrbquote(&syspbuff), %str(%(%)))));
	%if (%scan(&syspbuff, -1) eq &mvPars) %then 
		%do;
			&mvPars
			%return;
		%end;
	%sysevalf(%scan(&mvPars, 1) + %recSum( %substr(&mvPars, %eval(%index(&mvPars, %str(,))+1))))
/*	%sysfunc(sum(%scan(&mvPars, 1), %recSum( %substr(&mvPars, %eval(%index(&mvPars, %str(,))+1)) ) ))*/
%mend;

%put %recSum(1,2,3,4,5);

/* decimal */
options mprint mlogic symbolgen;
%macro recSum / parmbuff;
	%let mvPars=%nrbquote(%sysfunc(compress(%nrbquote(&syspbuff), %str(%(%)))));
	%if (%scan(%nrbquote(&mvPars), -1, %str(,)) eq &mvPars) %then 
		%do;
			&mvPars
			%return;
		%end;
/*		%sysevalf(%scan(%nrbquote(&mvPars), 1, %str(,)) + %recSum(%substr(&mvPars, %eval(%index(&mvPars, %str(,))+1))))*/
		%sysfunc(sum(%scan(%nrbquote(&mvPars), 1, %str(,)), %recSum(%substr(&mvPars, %eval(%index(&mvPars, %str(,))+1)))))
%mend;

%put %sysevalf(10 + %recSum(10,-5,.,10,.,10));
/**/




%put %scan(%quote(1,2,3,.), -1, %str(,));

%let mv=%quote(%mDelParenths((1,2,3,4,5,6)));
%put &mv;

%put %substr(&mv, %eval(%index(&mv, %str(,))+1)	);
%put %index(&mv, %index(&mv, %str(,)));

*%put %mDelParenths((2)@()();

/* Factorial */