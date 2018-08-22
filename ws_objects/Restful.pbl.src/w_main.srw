$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_rest from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 832
integer height = 1824
boolean titlebar = true
string title = "PB2017 R2 New Features"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_rest cb_rest
end type
global w_main w_main

on w_main.create
this.cb_rest=create cb_rest
this.Control[]={this.cb_rest}
end on

on w_main.destroy
destroy(this.cb_rest)
end on

type cb_rest from commandbutton within w_main
integer x = 178
integer y = 244
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "REST"
end type

event clicked;Open ( w_rest )
end event

