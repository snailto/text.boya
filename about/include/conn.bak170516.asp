﻿<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" LCID="2052"%>
<%Response.CodePage="65001":Response.Charset="utf-8":Response.LCID="2052"%>
<!--#include file="../../include/config.asp"-->
<!--#include file="../../include/md5.asp"-->
<!--#include file="../../include/function.asp"-->
<!--#include file="../../include/pager.class.asp"-->
<!--#include file="../../include/mail.class.asp"-->
<% 
JumpRel="../../"
call OpenConn(JumpRel)
%>
<!--#include file="../../global.asp"-->
<%
sub Job
set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Job where ID>0 and Ifpass=1 "
if Server.HTMLEncode(request("id"))<>"" then sql=sql&"and id="&clng(request("id"))&" "
sql=sql&"order by px desc,id desc"
rs.open sql,conn,1,1
rs.pagesize =5
page=clng(request("page"))
if page<=0 then page=1 
if page > rs.pagecount then page=rs.pagecount
if not rs.eof then rs.AbsolutePage=page
if rs.eof and rs.bof then
	response.Write("<a href=#>No Information</a>")
else
for i=1 to rs.pagesize
if rs.eof then exit for
%>
<a name="jlist"></a>
<div class="people_list">
  <div class="people_name">
   <%=rs("Jobname")%>
    <div class="people_btn"><img src="../images/default/ico01.jpg" align="absmiddle" />&nbsp;&nbsp;&nbsp;<a href="apply.asp?id=<%=rs("id")%>">关注此职位</a>	
	</div>
    </div>
	
	 <div class="people_tit">
         <table width="100%">
             <tr>
                <td>
                 <strong>工作地点：</strong><%=rs("province")%> <%=rs("city")%>
                </td>
                <td>
                   <strong>学历：</strong><%
					select case rs("Study")
					case -1:response.Write("不限")
					case 1:response.Write("高中/三校生")
					case 30:response.Write("专科")
					case 50:response.Write("本科")
					case 70:response.Write("硕士")
					case 90:response.Write("博士")
					case 110:response.Write("MBA")
					end select
					%>
                </td>
                 <td>
                    <strong>工作年限：</strong><%
					select case rs("jobyears")
					case -1:response.Write("不限")
					case 3:response.Write("应届毕业生")
					case 5:response.Write("1年以上")
					case 7:response.Write("2年以上")
					case 9:response.Write("3年以上")
					case 11:response.Write("5年以上")
					case 13:response.Write("10年以上")
					end select
					%>
                 </td>
                 <td>
                    <strong>招聘名额：</strong><%if rs("jobnum")=0 then response.Write("不限") else response.Write(rs("jobnum")&"名") end if%>
                  </td>
          </tr>
        </table>
     </div>
	 
	 <div class="people_con">
			<p>
				<strong>职位描述</strong></p>
				<%=rs("JobIntro")%>
			<p>&nbsp;
				</p>
			<p>
				<strong>职位要求</strong></p>
				<%=rs("JobRequire")%>			
		</div>
</div>

<%
rs.movenext
next
%>
 <div id="pgArticle" style=" text-align:right; padding-top:10px;">
<%
pageObj.pageskin=6
pageObj.img_path="../image/"
response.Write pageObj.link(rs.recordcount,rs.pagesize,page,"?page=",qryString)
%>
</div>
<%
end if
rs.close
set rs=nothing
end sub
%>

<%sub hotJob

set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Job where ID>0 and Ifpass=1 order by px desc,id desc"
rs.open sql,conn,1,1
for i=1 to 10 
if rs.eof then exit for
%>

<li><img src="../images/else/point_ico01.jpg" align="absmiddle" />&nbsp;&nbsp; <a href="?id=<%=rs("id")%>#jlist"><%=rs("Jobname")%></a> </li>

<%
rs.movenext
next
rs.close
set rs=nothing
end sub%>


<%
if request("action")="add" then 

	call checkcode(request("checkcode"))

	if request("id")="" then
		alert("非法输入")
		goback()
		response.End()
	else
		if trim(request.Form("sex"))=1 then
		sex=true
		else
		sex=false
		end if
		rs=conn.execute("select * from tb_job where id="&request("id")&" ")
		jobname=rs("jobname")
		set rs=server.CreateObject("adodb.recordset")
		rs.open "select * from tb_jobresume",conn,1,3
		rs.addnew
		rs("jobid")=request("id")
		rs("jobname")=jobname
		rs("truename")=trim(request.Form("Truename"))
		rs("sex")=sex
		rs("Speciality")=trim(request.Form("Speciality"))
		rs("oldaddress")=trim(request.Form("Oldaddress"))
		rs("Standing")=trim(request.Form("Standing"))
		rs("Birthday")=cdate(request.Form("Birthday"))
		rs("cardtype")=trim(request.Form("CardType"))
		rs("cardno")=trim(request.Form("CardNo"))
		rs("jobmoney")=trim(request.Form("Jobmoney"))
		rs("jobyear")=trim(request.Form("Jobyears"))
		rs("jobschool")=trim(request.Form("Jobschool"))
		rs("studylevel")=trim(request.Form("Study"))
		rs("email")=trim(request.Form("Email"))
		rs("phone")=trim(request.Form("Phone"))
		rs("Exppay")=trim(request.Form("Exppay"))
		rs("Studystory")=trim(request.Form("Studystory"))
		rs("Jobstory")=trim(request.Form("Jobstory"))
		rs.update
		rs.close

if MailOpen_con=true then
	 mailbody="<div>姓名 : "&trim(request.Form("Truename"))&"</div><div>专业 : "&trim(request.Form("Speciality"))&"</div><div>户口所在地 : "&trim(request.Form("Oldaddress"))&"</div><div>身高 : "&trim(request.Form("Standing"))&"</div><div>出生日期 : "&trim(request.Form("Birthday"))&"</div><div>证件类型 :"&trim(request.Form("CardType"))&"</div><div>证件号码 :"&trim(request.Form("CardNo"))&"</div><div>目前收入 :"&trim(request.Form("Jobmoney"))&"</div><div>从业年限 :"&trim(request.Form("Jobyears"))&"</div><div>电子邮箱 :"&trim(request.Form("Email"))&"</div><div>联系电话 :"&trim(request.Form("Phone"))&"</div><div>学业情况 :"&trim(request.Form("Studystory"))&"</div><div>工作经历 :"&trim(request.Form("Jobstory"))&"</div>"
	call SendEmail(jobname,MailAccept_con,trim(request.Form("Truename")),mailbody,"") 

	 end if

 	response.Write("<script>alert('提交成功');location='?';</script>")
		call gopage("js:back:-2",0)
	end if
end if
%>
<%
sub news
set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Article where classid=(select classid from TB_ArticleType where classname='媒体报道' ) order by "&NewsPXMethod
rs.open sql,conn,1,1
titleChrNum=50
rs.pagesize =12
page=clng(request("page"))
if page<=0 then page=1 
if page > rs.pagecount then page=rs.pagecount
if not rs.eof then rs.AbsolutePage=page
if rs.eof and rs.bof then
	response.Write("<a href=#>No Information</a>")
else
%>
<table  width="100%" cellpadding="0" cellspacing="0" border="0">
<%
for i=1 to rs.pagesize
if rs.eof then exit for
if i=1 then
%>
<tr>
<td style="padding-bottom:30px">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
   <%if rs("Picsmall")<>"" then%>
    <td valign="top" width="175"><a href="?id=<%=rs("id")%>&classid=<%=rs("classid")%>"><img src="<%=JumpRel%><%=rs("Picsmall")%>" width="163" height="104" style="display: block; margin: 0 auto;" /></a></td>
    <%end if%>
    <td valign="top">
       <p><strong><a href="?id=<%=rs("id")%>&classid=<%=rs("classid")%>"><%=rs("title")%></a></strong></p>
       <p style="color:#fb6911">来源：<%=rs("author")%>&nbsp;&nbsp;<%=year(rs("AddTime"))%>-<%=month(rs("AddTime"))%>-<%=day(rs("AddTime"))%></p>
       <p><%=gotTopic(RemoveHTML(rs("content")),300)%></p>
    </td>
  </tr>
</table>

</td>
</tr>
<%else%>
<tr>
<td height="30">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td style="border-bottom:1px solid #FCE9CD" width="72%">
  <span style="float:left"> <a href="?id=<%=rs("id")%>&classid=<%=rs("classid")%>" onFocus="this.blur();"><em><%=rs("title")%></em></a></span>  
</td>
<td style="border-bottom:1px solid #FCE9CD" width="18%" ><span style="color:#fb6911"> 来源：<%=rs("author")%>&nbsp;&nbsp;</span></td>
<td style="border-bottom:1px solid #FCE9CD"  width="10%"><span style="color:#fb6911"><%=year(rs("AddTime"))%>-<%=month(rs("AddTime"))%>-<%=day(rs("AddTime"))%></span></td>
</tr>
</table></td>
</tr>
<%end if

rs.movenext
next
%>
</table>

<p style="padding:15px 0">
<%
pageObj.pageskin=6
pageObj.img_path="../image/"
response.Write pageObj.link(rs.recordcount,rs.pagesize,page,"?page=",qryString)
%>
</p>
<%
end if
rs.close
set rs=nothing

end sub

sub shownews(id)'显示新闻内容'
dim arrLink()
dim arrTitle()
set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Article where ID>0 "
if request("classid")<>"" then sql=sql&"and classid="&request("classid")&" "
sql=sql&"order by "&NewsPxMethod
rs.open sql,conn,1,1
for i=1 to rs.recordcount
  ReDim Preserve arrLink(i-1)
  arrLink(i-1)=rs("ID")
  ReDim Preserve arrTitle(i-1)
  arrTitle(i-1)=rs("Title")
rs.movenext
next
rs.close
set rs=nothing
set rs=server.CreateObject("ADODB.Recordset")   
sql="select * from TB_Article where ID>0 "
if id<>"" then sql=sql&"and ID="&clng(id)&" "
sql=sql&"order by "&NewsPxMethod
rs.Open sql,Conn,1,3
rs("Hits")=rs("Hits")+1
rs.update
strTemp="<table width='100%' border='0' cellspacing='0' cellpadding='0' align='center'>"
strTemp=strTemp&"<tr><td height='30' align='center'><strong style='font-size:14px; color:#ff6600'>"&rs("Title")&"</strong></td></tr>"
strTemp=strTemp&"<tr><td height='30' align='center'>来源："&rs("author")&""&AddDate_lang&rs("Addtime")&Hits_lang&rs("Hits")&"</td></tr>"
strTemp=strTemp&"<tr><td style='border-top:1px dashed #cccccc; padding:10px'>"
strContent=replace(rs("Content"),"uploadfiles/",JumpRel&"uploadfiles/")
strContent=replace(strContent,"ImgUpload/",JumpRel&"ImgUpload/")
ContentLen=len(strContent)
CurrentPage=trim(request("page"))
if Instr(strContent,"[NextPage]")<=0 then
	strTemp=strTemp&strContent
else
	arrContent=split(strContent,"[NextPage]")
	pages=Ubound(arrContent)+1
	if CurrentPage="" then
		CurrentPage=1
	else
		CurrentPage=Cint(CurrentPage)
	end if
	if CurrentPage<1 then CurrentPage=1
	if CurrentPage>pages then CurrentPage=pages
	strTemp=strTemp&arrContent(CurrentPage-1)
	strTemp=strTemp&"<p align='center'>"
	pageObj.pageskin=3
	strTemp=strTemp&pageObj.link(pages,1,CurrentPage,"?page=","&id="&rs("ID")&"")
	strTemp=strTemp&"</p>"
end if
strTemp=strTemp&"</td></tr><tr><td align='center' height='80'><input type='button' style='background:url(../images/else/btn_bg.jpg);width:43px; height:19px; border:0; color:#ffffff' value='返回' onclick='history.back()'></td></tr><tr><td height='30'>"
for o=0 to ubound(arrLink)
  if arrLink(o)=rs("id") then
	  if o>0 then
		strTemp=strTemp&"<a href='?id="&arrLink(o-1)&"&classid="&request("classid")&"'>"&prevLink_lang&"："&arrTitle(o-1)&"</a>"
	  end if
	  strTemp=strTemp&"<br>"
	  if o<ubound(arrLink) then
		strTemp=strTemp&"<a href='?id="&arrLink(o+1)&"&classid="&request("classid")&"'>"&nextLink_lang&"："&arrTitle(o+1)&"</a>"
	  end if
  end if
next
strTemp=strTemp&"</td></tr></table>"
response.write strTemp
rs.close
set rs=nothing
end sub

sub shownews1(id)'显示新闻内容'
dim arrLink()
dim arrTitle()
set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Article where ID>0 "
if request("classid")<>"" then sql=sql&"and classid="&request("classid")&" "
sql=sql&"order by "&NewsPxMethod
rs.open sql,conn,1,1
for i=1 to rs.recordcount
  ReDim Preserve arrLink(i-1)
  arrLink(i-1)=rs("ID")
  ReDim Preserve arrTitle(i-1)
  arrTitle(i-1)=rs("Title")
rs.movenext
next
rs.close
set rs=nothing
set rs=server.CreateObject("ADODB.Recordset")   
sql="select * from TB_Article where ID>0 "
if id<>"" then sql=sql&"and ID="&clng(id)&" "
sql=sql&"order by "&NewsPxMethod
rs.Open sql,Conn,1,3
rs("Hits")=rs("Hits")+1
rs.update
strTemp="<table width='100%' border='0' cellspacing='0' cellpadding='0' align='center'>"
strTemp=strTemp&"<tr><td height='30' align='center'><strong style='font-size:14px; color:#ff6600'>"&rs("Title")&"</strong></td></tr>"
strTemp=strTemp&"<tr><td height='30' align='center'>来源："&rs("author")&""&AddDate_lang&rs("Addtime")&Hits_lang&rs("Hits")&"</td></tr>"
strTemp=strTemp&"<tr><td style='border-top:1px dashed #cccccc; padding:10px'>"
strContent=replace(rs("Content"),"uploadfiles/",JumpRel&"uploadfiles/")
strContent=replace(strContent,"ImgUpload/",JumpRel&"ImgUpload/")
ContentLen=len(strContent)
CurrentPage=trim(request("page"))
if Instr(strContent,"[NextPage]")<=0 then
	strTemp=strTemp&strContent
else
	arrContent=split(strContent,"[NextPage]")
	pages=Ubound(arrContent)+1
	if CurrentPage="" then
		CurrentPage=1
	else
		CurrentPage=Cint(CurrentPage)
	end if
	if CurrentPage<1 then CurrentPage=1
	if CurrentPage>pages then CurrentPage=pages
	strTemp=strTemp&arrContent(CurrentPage-1)
	strTemp=strTemp&"<p align='center'>"
	pageObj.pageskin=3
	strTemp=strTemp&pageObj.link(pages,1,CurrentPage,"?page=","&id="&rs("ID")&"")
	strTemp=strTemp&"</p>"
end if
strTemp=strTemp&"</td></tr><tr><td align='center' height='80'><input type='button' style='background:url(../images/else/btn_bg.jpg);width:43px; height:19px; border:0; color:#ffffff' value='返回' onclick='history.back()'></td></tr><tr><td height='30'>"
for o=0 to ubound(arrLink)
  if arrLink(o)=rs("id") then
	  if o>0 then
		strTemp=strTemp&"<a href='?id="&arrLink(o-1)&"&classid="&request("classid")&"'>"&prevLink_lang&"："&arrTitle(o-1)&"</a>"
	  end if
	  strTemp=strTemp&"<br>"
	  if o<ubound(arrLink) then
		strTemp=strTemp&"<a href='?id="&arrLink(o+1)&"&classid="&request("classid")&"'>"&nextLink_lang&"："&arrTitle(o+1)&"</a>"
	  end if
  end if
next
strTemp=strTemp&"</td></tr></table>"
response.write strTemp
rs.close
set rs=nothing
end sub


sub information(Ititle,Ilt,Ione)'显示页面内容'
set rs=server.CreateObject("ADODB.RecordSet")   
sql="select * from Information where ID>0 "
if Ititle<>"" then sql=sql&"and Title='"&Ititle&"' "
if Ilt<>"" then sql=sql&"and ID="&clng(Ilt)&" "
if Ione<>"" then sql=sql&"and OneClassID="&clng(Ione)&" "
sql=sql&"order by px desc,ID desc"
rs.Open sql,Conn,1,3
rs("Hits")=rs("Hits")+1
rs.update

strContent=rs("Content")
ContentLen=len(strContent)
CurrentPage=trim(request("page"))
if Instr(strContent,"[NextPage]")<=0 then
	strTemp=strTemp&strContent
else
	arrContent=split(strContent,"[NextPage]")
	pages=Ubound(arrContent)+1
	if CurrentPage="" then
		CurrentPage=1
	else
		CurrentPage=Cint(CurrentPage)
	end if
	if CurrentPage<1 then CurrentPage=1
	if CurrentPage>pages then CurrentPage=pages
	strTemp=strTemp&arrContent(CurrentPage-1)
	strTemp=strTemp&"<p align='center'>"
	pageObj.pageskin=4
	strTemp=strTemp&pageObj.link(pages,1,CurrentPage,"?page=","&Ilt="&rs("ID")&"&Ione="&rs("OneClassID")&"&Ititle="&rs("Title")&"")
	strTemp=strTemp&"</p>"
end if

response.write strTemp
rs.close
set rs=nothing
end sub


sub information1'显示页面内容'
set rs=server.CreateObject("ADODB.RecordSet")   
sql="select * from Information where ID>0 and Title='企业荣誉' and ID=4 and OneClassID=3 "
sql=sql&"order by px desc,ID desc"
rs.Open sql,Conn,1,3
rs("Hits")=rs("Hits")+1
rs.update

strContent=rs("Content")
ContentLen=len(strContent)
CurrentPage=trim(request("page"))
if Instr(strContent,"[NextPage]")<=0 then
	strTemp=strTemp&strContent
else
	arrContent=split(strContent,"[NextPage]")
	pages=Ubound(arrContent)+1
	if CurrentPage="" then
		CurrentPage=1
	else
		CurrentPage=Cint(CurrentPage)
	end if
	if CurrentPage<1 then CurrentPage=1
	if CurrentPage>pages then CurrentPage=pages
	strTemp=strTemp&arrContent(CurrentPage-1)
	strTemp=strTemp&"<p align='center'>"
	pageObj.pageskin=4
	strTemp=strTemp&pageObj.link(pages,1,CurrentPage,"?page=","")
	strTemp=strTemp&"</p>"
end if

response.write strTemp
rs.close
set rs=nothing
end sub
%>





