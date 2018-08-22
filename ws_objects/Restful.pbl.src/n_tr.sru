$PBExportHeader$n_tr.sru
forward
global type n_tr from transaction
end type
end forward

global type n_tr from transaction
end type
global n_tr n_tr

type prototypes
function double triple_price(double price ) RPCFUNC 

end prototypes
on n_tr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_tr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

