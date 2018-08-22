$PBExportHeader$w_rest.srw
forward
global type w_rest from window
end type
type cb_delete from commandbutton within w_rest
end type
type cb_insert from commandbutton within w_rest
end type
type cb_update from commandbutton within w_rest
end type
type cb_1 from commandbutton within w_rest
end type
type dw_1 from datawindow within w_rest
end type
type cb_restclient from commandbutton within w_rest
end type
end forward

global type w_rest from window
integer width = 3863
integer height = 1800
boolean titlebar = true
string title = "REST Client"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_delete cb_delete
cb_insert cb_insert
cb_update cb_update
cb_1 cb_1
dw_1 dw_1
cb_restclient cb_restclient
end type
global w_rest w_rest

on w_rest.create
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_update=create cb_update
this.cb_1=create cb_1
this.dw_1=create dw_1
this.cb_restclient=create cb_restclient
this.Control[]={this.cb_delete,&
this.cb_insert,&
this.cb_update,&
this.cb_1,&
this.dw_1,&
this.cb_restclient}
end on

on w_rest.destroy
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_update)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.cb_restclient)
end on

type cb_delete from commandbutton within w_rest
integer x = 3383
integer y = 548
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;long	ll_row

ll_row = dw_1.GetRow()
IF ll_row > 0 THEN
	dw_1.DeleteRow(ll_row)
END IF
end event

type cb_insert from commandbutton within w_rest
integer x = 3383
integer y = 416
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Insert"
end type

event clicked;long	ll_row

ll_row = dw_1.InsertRow(0)
dw_1.ScrollToRow(ll_row)
end event

type cb_update from commandbutton within w_rest
integer x = 3383
integer y = 772
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update"
end type

event clicked;integer   li_rc, li_rsc
long       ll_index, ll_count, ll_id, ll_root
constant integer OK = 200
constant integer CREATED = 201
String	    ls_json, ls_result
dwItemStatus   status
HttpClient         hc
JSONGenerator jg
JSONParser      jp

hc = create HttpClient
jg = create JSONGenerator
jp = create JSONParser

dw_1.AcceptText()

ll_count = dw_1.Rowcount( )
FOR ll_index = 1 TO ll_count
	status = dw_1.GetItemStatus ( ll_index, 0, Primary! )
	CHOOSE CASE status
		CASE NewModified!, DataModified!
			//Inserted or Modified Rows
			ll_root = jg.createjsonobject( )
			jg.AddItemNumber(ll_root, "userid", dw_1.GetItemNumber(ll_index, 'userid'))
			jg.AddItemString(ll_root,'title',dw_1.GetItemString(ll_index,'title'))
			jg.AddItemString(ll_root,'body',dw_1.GetItemString(ll_index,'body'))
			IF status = NewModified! THEN
				//Inserted
				ls_json = jg.getjsonstring( )
				li_rc = hc.sendrequest( 'POST', 'https://jsonplaceholder.typicode.com/posts', ls_json)
				li_rsc = hc.GetResponseStatusCode()
				IF li_rsc = CREATED THEN
					//Get the response, which contains the ID value assigned to the new row
					hc.GetResponseBody(ls_json)
					ls_result = jp.loadstring( ls_json )
					ll_root = jp.getrootitem( )
					ll_id = jp.getitemnumber( ll_root, "id" )
					//Set it back into the inserted row
					dw_1.SetItem ( ll_index, 'id', ll_id )
				ELSE
					MessageBox ( parent.title, "Insert Failed" )
				END IF
			ELSE
				//Updated
				ll_id = dw_1.GetItemNumber ( ll_index, 'id' )
				jg.AddItemNumber(ll_root,"id", ll_id)
				ls_json = jg.getjsonstring( )
				li_rc = hc.sendrequest( 'PUT', 'https://jsonplaceholder.typicode.com/posts/' + String ( ll_id ), ls_json)
				li_rsc = hc.GetResponseStatusCode()
				IF li_rsc <> OK THEN
					MessageBox ( parent.title, "Update Failed" )
				END IF
			END IF
		CASE ELSE
			//skip this row
			CONTINUE 
	END CHOOSE
NEXT

//Deleted Rows
ll_count = dw_1.Deletedcount( )
FOR ll_index = 1 TO ll_count
	ll_id = dw_1.GetItemNumber(ll_index, 'id', Delete!, true)
	li_rc = hc.sendrequest( 'DELETE', 'https://jsonplaceholder.typicode.com/posts/' + String ( ll_id ))
	li_rsc = hc.GetResponseStatusCode()
	IF li_rsc <> OK THEN
		MessageBox ( parent.title, "Delete Failed" )
	END IF
NEXT

dw_1.ResetUpdate( )
end event

type cb_1 from commandbutton within w_rest
integer x = 3383
integer y = 196
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "HTTP Client"
end type

event clicked;integer    li_rc
long        ll_id, ll_userid,ll_row,ll_root,ll_index,ll_child,ll_count
string      ls_string,ls_result,ls_body,ls_title
httpclient http

http = create httpclient
li_rc = http.sendrequest( 'GET', 'https://jsonplaceholder.typicode.com/posts')
if li_rc = 1 and http.GetResponseStatusCode() = 200 then
	http.GetResponseBody(ls_string)
end if

JSONParser json
json = create JSONParser
ls_result = json.loadstring( ls_string )

ll_root = json.getrootitem( )
ll_count = json.getchildcount( ll_root )

dw_1.Reset()

for ll_index = 1 to ll_count
	ll_row = dw_1.InsertRow(0)
	ll_child = json.getchilditem( ll_root, ll_index )
	ll_id = json.getitemnumber( ll_child, "id" )
	dw_1.setItem(ll_row, "id", ll_id)
	ll_userid = json.getitemnumber( ll_child, "userid" )
	dw_1.setItem(ll_row, "userid", ll_userid)
	ls_title = json.getitemstring( ll_child, "title")
	dw_1.setItem(ll_row, "title", ls_title)
	ls_body = json.getitemstring( ll_child, "body")
	dw_1.setItem(ll_row, "body", ls_body)
next

end event

type dw_1 from datawindow within w_rest
integer x = 46
integer y = 52
integer width = 3250
integer height = 1540
integer taborder = 20
string title = "none"
string dataobject = "d_rest_call"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_restclient from commandbutton within w_rest
integer x = 3383
integer y = 64
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "REST Client"
end type

event clicked;RESTClient rest

rest = create RESTClient

rest.Retrieve( dw_1, "https://jsonplaceholder.typicode.com/posts")




end event

