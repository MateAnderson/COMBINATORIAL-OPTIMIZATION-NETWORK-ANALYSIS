option MINLP = BARON ;
option optcr = 0;
option intvarUp = 0;
option reslim = 1000 ; 

set
* i: # of shares in our dataset
* t: days
* dum: a dummy set which has only "1" as a member
* we use it for defining some parameters with only one value
    i,t,dum;

Parameter
* r: shares Returns
* ir: Index Return
    r(i,t)
    ir(t)
    c(dum)
    upper(i)
    lower(i);

$GDXIN %gdxincname%
$LOAD i, t, dum, r, ir, c, upper, lower
$GDXIN

* defining variables
free variable z;
binary variable delta(i);
positive variable x(i) ;

* defining constraights and objective
equations
const1,
const2,
const3,
const4,
obj;

const1..
         sum((i), delta(i)) =e= c('1');
const2..
         sum((i), x(i)) =e= 1;
const3(i)..
         lower(i)*delta(i) =l= x(i);
const4(i)..
         x(i) =l= upper(i)*delta(i) ;
obj..
    z =e= sum((t),    power( sum(i,r(i,t)*x(i)- ir(t)) ,2) )  ;
* 6) introducing the model
model mod/
const1,
const2,
const3,
const4,
obj/;
*  7) solve command
solve mod using MINLP minimizing z;
Display z.l,x.l,delta.l,i, t, dum, r, ir, c, upper, lower;
