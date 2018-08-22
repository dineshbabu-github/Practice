$PBExportHeader$pbbeta.sra
$PBExportComments$Generated Application Object
forward
global type pbbeta from application
end type
global n_tr sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type pbbeta from application
string appname = "pbbeta"
end type
global pbbeta pbbeta

on pbbeta.create
appname="pbbeta"
message=create message
sqlca=create n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pbbeta.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open ( w_main )
end event

