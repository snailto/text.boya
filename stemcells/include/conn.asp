﻿<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001" LCID="2052"%>
<%Response.CodePage="65001":Response.Charset="utf-8":Response.LCID="2052"%>
<!--#include file="../../include/config.asp"-->
<!--#include file="../../include/md5.asp"-->
<!--#include file="../../include/function.asp"-->
<!--#include file="../../include/pager.class.asp"-->
<!--#include file="../../include/mail.class.asp"-->
<% 
JumpRel="../"
call OpenConn(JumpRel)
%>
<!--#include file="../../global.asp"-->


<%
sub Treatment
set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Article where classid=(select classid from TB_ArticleType where classname='治疗案例' )  order by addtime desc "
rs.open sql,conn,1,1
titleChrNum=50
rs.pagesize =4
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
  <ul>
	<li class="img_bg">
		<a href="?id=<%=rs("id")%>&classid=<%=rs("classid")%>"><img src="../<%=rs("picsmall")%>" width="131" height="84" style="display: block" /></a></li>
	<li class="img_con">
		<p>
			<a href="?id=<%=rs("id")%>&classid=<%=rs("classid")%>"><strong>
			<%=rs("title")%></strong></a>
			</p>
		<p>
			<%=gotTopic(RemoveHTML(rs("content")),300)%>
		</p>
	</li>
</ul>
<%

rs.movenext
next
%>
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



sub showTreatment(id)'显示新闻内容'
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
strTemp=strTemp&"<tr><td height='30' align='center'>"&AddDate_lang&rs("Addtime")&Hits_lang&rs("Hits")&"</td></tr>"
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
		strTemp=strTemp&"<a href='?id="&arrLink(o-1)&"'>"&prevLink_lang&"："&arrTitle(o-1)&"</a>"
	  end if
	  strTemp=strTemp&"<br>"
	  if o<ubound(arrLink) then
		strTemp=strTemp&"<a href='?id="&arrLink(o+1)&"'>"&nextLink_lang&"："&arrTitle(o+1)&"</a>"
	  end if
  end if
next
strTemp=strTemp&"</td></tr></table>"
response.write strTemp
rs.close
set rs=nothing
end sub




sub Research
set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Article where classid=(select classid from TB_ArticleType where classname='研究新动态' )"
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
for i=1 to rs.pagesize
if rs.eof then exit for
%>
  <ul>
	<li class="img_bg">
		<a href="?id=<%=rs("id")%>"><img src="../<%=rs("picsmall")%>" width="131" height="84" style="display: block" /></a></li>
	<li class="img_con">
		<p>
			<a href="?id=<%=rs("id")%>"><strong>
			<%=rs("title")%></strong></a>
			</p>
		<p>
			<%=gotTopic(RemoveHTML(rs("content")),300)%>
		</p>
	</li>
</ul>
<%

rs.movenext
next
%>
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






sub Research1
set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Article where classid=(select classid from TB_ArticleType where classname='临床进展' )  order by starttime desc"
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<head>
<title>为何存储干细胞（博雅干细胞库）-BOYALIFE博雅干细胞科技有限公司</title>
<link href="../css/common.css" rel="stylesheet" type="text/css" />
<link href="../css/else.css" rel="stylesheet" type="text/css" />

    <script src="../js/jquery-1.4.min.js" type="text/javascript"></script>

    <script src="../js/nav.js" type="text/javascript"></script>

    <!--[if IE 6]>
	    <script type="text/javascript" src="../js/DD_belatedPNG.js" ></script>
	    <script type="text/javascript">
	    DD_belatedPNG.fix('.left_side ul li a:hover,.left_side ul li.left_current a');
	    </script>
    <![endif]-->
<meta name="Keywords" content="博雅干细胞库,符合国际标准的高端干细胞库,国际干细胞联合研究中心,无锡国际干细胞联合研究中心" /><meta name="Description" content="博雅干细胞库2009年成立于无锡，博雅干细胞库是由博雅干细胞科技有限公司整体运营的，由来自全球知名的干细胞存储、研究团队组建，中国内地首家也是唯一一家按照国际AABB（美国血库协会）标准设计和建立的干细胞库，代表着目前该领域国际最领先的技术水平。" /></head>
<body>

    <div id="wrap">
        
        

<script type="text/javascript"> 
    var CurrentUrl = window.location.href;
       function House() {
            //alert(title);
              window.external.addFavorite(CurrentUrl,"BOYALIFE博雅干细胞科技有限公司")
       }

</script>

        
<!--#include file="../../inc_head.asp"-->

<!--#include file="../../inc_nav.asp"-->

        <div class="lv_content">  <div class="lv_banner1"><img src="images/banner.jpg" width="960" height="200"></div>
            
            <div class="lv_box">
                
                <div class="left_side">
                    <div class="left_side_tit">
                        <img src="../images/else/left_tit02.jpg" style="display: block;" />
                    </div>
                    
<ul>
    <li><a href="index.html" onFocus="this.blur();">干细胞简历</a></li>
    <li><a href="Zxxb.html" onFocus="this.blur();">脐带血造血干细胞</a></li> <li><a href="Czxb.html" onFocus="this.blur();">脐带间充质干细胞</a></li>
	<li><a href="Tpxb.html" onFocus="this.blur();">胎盘干细胞</a></li>
		
    <li><a href="Disease.html" onFocus="this.blur();">可治疗的疾病</a></li>
    <li><a href="Donation.html" onFocus="this.blur();">互捐互赠</a></li>
    <li><a href="Treatment.html" onFocus="this.blur();">治疗案例</a></li>
	
    <li class="left_current"><a href="Research.html" onFocus="this.blur();">研究新动态</a></li>
</ul>
<div class="left_img">
    <a href="index.html">
        <img src="../images/else/img01.jpg" style="display: block;" /></a>
</div>

<!--#include file="../../inc_leftLastNews.asp"-->

                </div>
                
                <div class="rignt_con">
                    <div class="lv_tree">
                        <div class="lv_tree_tit">
                            <img src="../images/default/ico01.jpg" align="absmiddle" />&nbsp;&nbsp;研究新动态</div>
                        <p>
                            您现在的位置：<span><a href="../index.html">首页</a></span> - <span><a href="index.html">为何存储干细胞</a></span>
                            - <span class="lv_tree_current"><a href="#">临床进展</a></span></p>
                    </div>
                    <div class="box">
                        <div class="treat_list">
<%
for i=1 to rs.pagesize
if rs.eof then exit for
%>

  <ul>
	<li class="img_bg">
		<a href="?id=<%=rs("id")%>"><img src="../<%=rs("picsmall")%>" width="131" height="84" style="display: block" /></a></li>
	<li class="img_con">
		<p>
			<a href="?id=<%=rs("id")%>"><strong>
			<%=rs("title")%></strong></a>
			</p>
		<p>
			<%=gotTopic(RemoveHTML(rs("content")),300)%>
		</p>
	</li>
</ul>
<%

rs.movenext
next
%>
<p style="padding:15px 0">
<%
pageObj.pageskin=6
pageObj.img_path="../image/"
response.Write pageObj.link(rs.recordcount,rs.pagesize,page,"?page=",qryString)
%>
</p>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        
<!--#include file="../../inc_foot.asp"-->

    </div>
<!-- boyalife.com Baidu tongji analytics -->
<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F73b8ef2157e56c7b6d0ef7c2598feff0' type='text/javascript'%3E%3C/script%3E"));
</script>
</body>
</html>

            

<%
end if
rs.close
set rs=nothing
end sub


sub showTreatment1(id)'显示新闻内容'
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
strTemp=strTemp&"<tr><td height='30' align='center'>"&AddDate_lang&rs("Addtime")&Hits_lang&rs("Hits")&"</td></tr>"
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
		strTemp=strTemp&"<a href='?id="&arrLink(o-1)&"'>"&prevLink_lang&"："&arrTitle(o-1)&"</a>"
	  end if
	  strTemp=strTemp&"<br>"
	  if o<ubound(arrLink) then
		strTemp=strTemp&"<a href='?id="&arrLink(o+1)&"'>"&nextLink_lang&"："&arrTitle(o+1)&"</a>"
	  end if
  end if
next
strTemp=strTemp&"</td></tr></table>"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<head>
<title><%=rs("htitle")%></title>
<link href="../css/common.css" rel="stylesheet" type="text/css" />
<link href="../css/else.css" rel="stylesheet" type="text/css" />

    <script src="../js/jquery-1.4.min.js" type="text/javascript"></script>

    <script src="../js/nav.js" type="text/javascript"></script>

    <!--[if IE 6]>
	    <script type="text/javascript" src="../js/DD_belatedPNG.js" ></script>
	    <script type="text/javascript">
	    DD_belatedPNG.fix('.left_side ul li a:hover,.left_side ul li.left_current a');
	    </script>
    <![endif]-->
<meta name="Keywords" content="<%=rs("hkeywords")%>" />
<meta name="Description" content="<%=rs("hdescription")%>" />
</head>
<body>

    <div id="wrap">
        
        

<script type="text/javascript"> 
    var CurrentUrl = window.location.href;
       function House() {
            //alert(title);
              window.external.addFavorite(CurrentUrl,"BOYALIFE博雅干细胞科技有限公司")
       }

</script>

        
<!--#include file="../../inc_head.asp"-->

<!--#include file="../../inc_nav.asp"-->

        <div class="lv_content">  <div class="lv_banner1"><img src="images/banner.jpg" width="960" height="200"></div>
            
            <div class="lv_box">
                
                <div class="left_side">
                    <div class="left_side_tit">
                        <img src="../images/else/left_tit02.jpg" style="display: block;" />
                    </div>
                    
<ul>
    <li><a href="index.html" onFocus="this.blur();">干细胞简历</a></li>
    <li><a href="Zxxb.html" onFocus="this.blur();">脐带血造血干细胞</a></li> <li><a href="Czxb.html" onFocus="this.blur();">脐带间充质干细胞</a></li>
	<li><a href="Tpxb.html" onFocus="this.blur();">胎盘干细胞</a></li>
		
    <li><a href="Disease.html" onFocus="this.blur();">可治疗的疾病</a></li>
    <li><a href="Donation.html" onFocus="this.blur();">互捐互赠</a></li>
    <li><a href="Treatment.html" onFocus="this.blur();">治疗案例</a></li>
	
    <li class="left_current"><a href="Research.html" onFocus="this.blur();">研究新动态</a></li>
</ul>
<div class="left_img">
    <a href="index.html">
        <img src="../images/else/img01.jpg" style="display: block;" /></a>
</div>

<!--#include file="../../inc_leftLastNews.asp"-->

                </div>
                
                <div class="rignt_con">
                    <div class="lv_tree">
                        <div class="lv_tree_tit">
                            <img src="../images/default/ico01.jpg" align="absmiddle" />&nbsp;&nbsp;研究新动态</div>
                        <p>
                            您现在的位置：<span><a href="../index.html">首页</a></span> - <span><a href="index.html">为何存储干细胞</a></span>
                            - <span class="lv_tree_current"><a href="#">临床进展</a></span></p>
                    </div>
                    <div class="box">
                        <div class="treat_list">
<%

response.write strTemp
%>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        
<!--#include file="../../inc_foot.asp"-->

    </div>
<!-- boyalife.com Baidu tongji analytics -->
<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F73b8ef2157e56c7b6d0ef7c2598feff0' type='text/javascript'%3E%3C/script%3E"));
</script>
</body>
</html>

<%

rs.close
set rs=nothing
end sub




sub Research2
set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Article where classid=(select classid from TB_ArticleType where classname='行业风向标' )  order by starttime desc"
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<head>
<title>为何存储干细胞（博雅干细胞库）-BOYALIFE博雅干细胞科技有限公司</title>
<link href="../css/common.css" rel="stylesheet" type="text/css" />
<link href="../css/else.css" rel="stylesheet" type="text/css" />

    <script src="../js/jquery-1.4.min.js" type="text/javascript"></script>

    <script src="../js/nav.js" type="text/javascript"></script>

    <!--[if IE 6]>
	    <script type="text/javascript" src="../js/DD_belatedPNG.js" ></script>
	    <script type="text/javascript">
	    DD_belatedPNG.fix('.left_side ul li a:hover,.left_side ul li.left_current a');
	    </script>
    <![endif]-->
<meta name="Keywords" content="博雅干细胞库,符合国际标准的高端干细胞库,国际干细胞联合研究中心,无锡国际干细胞联合研究中心" /><meta name="Description" content="博雅干细胞库2009年成立于无锡，博雅干细胞库是由博雅干细胞科技有限公司整体运营的，由来自全球知名的干细胞存储、研究团队组建，中国内地首家也是唯一一家按照国际AABB（美国血库协会）标准设计和建立的干细胞库，代表着目前该领域国际最领先的技术水平。" /></head>
<body>

    <div id="wrap">
        
        

<script type="text/javascript"> 
    var CurrentUrl = window.location.href;
       function House() {
            //alert(title);
              window.external.addFavorite(CurrentUrl,"BOYALIFE博雅干细胞科技有限公司")
       }

</script>

<!--#include file="../../inc_head.asp"-->

<!--#include file="../../inc_nav.asp"-->

        
        <div class="lv_content">  <div class="lv_banner1"><img src="images/banner.jpg" width="960" height="200"></div>
            
            <div class="lv_box">
                
                <div class="left_side">
                    <div class="left_side_tit">
                        <img src="../images/else/left_tit02.jpg" style="display: block;" />
                    </div>
                    
<ul>
    <li><a href="index.html" onFocus="this.blur();">干细胞简历</a></li>
    <li><a href="Zxxb.html" onFocus="this.blur();">脐带血造血干细胞</a></li> <li><a href="Czxb.html" onFocus="this.blur();">脐带间充质干细胞</a></li>
	<li><a href="Tpxb.html" onFocus="this.blur();">胎盘干细胞</a></li>
		
    <li><a href="Disease.html" onFocus="this.blur();">可治疗的疾病</a></li>
    <li><a href="Donation.html" onFocus="this.blur();">互捐互赠</a></li>
    <li><a href="Treatment.html" onFocus="this.blur();">治疗案例</a></li>
	
    <li class="left_current"><a href="Research.html" onFocus="this.blur();">研究新动态</a></li>
</ul>
<div class="left_img">
    <a href="index.html">
        <img src="../images/else/img01.jpg" style="display: block;" /></a>
</div>

<!--#include file="../../inc_leftLastNews.asp"-->

                </div>
                
                <div class="rignt_con">
                    <div class="lv_tree">
                        <div class="lv_tree_tit">
                            <img src="../images/default/ico01.jpg" align="absmiddle" />&nbsp;&nbsp;研究新动态</div>
                        <p>
                            您现在的位置：<span><a href="../index.html">首页</a></span> - <span><a href="index.html">为何存储干细胞</a></span>
                            - <span class="lv_tree_current"><a href="#">行业风向标</a></span></p>
                    </div>
                    <div class="box">
                        <div class="treat_list">
<%

for i=1 to rs.pagesize
if rs.eof then exit for
%>
  <ul>
	<li class="img_bg">
		<a href="?id=<%=rs("id")%>"><img src="../<%=rs("picsmall")%>" width="131" height="84" style="display: block" /></a></li>
	<li class="img_con">
		<p>
			<a href="?id=<%=rs("id")%>"><strong>
			<%=rs("title")%></strong></a>
			</p>
		<p>
			<%=gotTopic(RemoveHTML(rs("content")),300)%>
		</p>
	</li>
</ul>
<%

rs.movenext
next
%>
<p style="padding:15px 0">
<%
pageObj.pageskin=6
pageObj.img_path="../image/"
response.Write pageObj.link(rs.recordcount,rs.pagesize,page,"?page=",qryString)
%>
</p>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        
<!--#include file="../../inc_foot.asp"-->

    </div>
<!-- boyalife.com Baidu tongji analytics -->
<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F73b8ef2157e56c7b6d0ef7c2598feff0' type='text/javascript'%3E%3C/script%3E"));
</script>
</body>
</html>
<%
end if
rs.close
set rs=nothing
end sub



sub showTreatment2(id)'显示新闻内容'
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
strTemp=strTemp&"<tr><td height='30' align='center'>"&AddDate_lang&rs("Addtime")&Hits_lang&rs("Hits")&"</td></tr>"
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
		strTemp=strTemp&"<a href='?id="&arrLink(o-1)&"'>"&prevLink_lang&"："&arrTitle(o-1)&"</a>"
	  end if
	  strTemp=strTemp&"<br>"
	  if o<ubound(arrLink) then
		strTemp=strTemp&"<a href='?id="&arrLink(o+1)&"'>"&nextLink_lang&"："&arrTitle(o+1)&"</a>"
	  end if
  end if
next
strTemp=strTemp&"</td></tr></table>"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<head>
<title><%=rs("htitle")%></title>
<link href="../css/common.css" rel="stylesheet" type="text/css" />
<link href="../css/else.css" rel="stylesheet" type="text/css" />

    <script src="../js/jquery-1.4.min.js" type="text/javascript"></script>

    <script src="../js/nav.js" type="text/javascript"></script>

    <!--[if IE 6]>
	    <script type="text/javascript" src="../js/DD_belatedPNG.js" ></script>
	    <script type="text/javascript">
	    DD_belatedPNG.fix('.left_side ul li a:hover,.left_side ul li.left_current a');
	    </script>
    <![endif]-->
<meta name="Keywords" content="<%=rs("hkeywords")%>" />
<meta name="Description" content="<%=rs("hdescription")%>" />
</head>
<body>

    <div id="wrap">
        
        

<script type="text/javascript"> 
    var CurrentUrl = window.location.href;
       function House() {
            //alert(title);
              window.external.addFavorite(CurrentUrl,"BOYALIFE博雅干细胞科技有限公司")
       }

</script>

<!--#include file="../../inc_head.asp"-->

<!--#include file="../../inc_nav.asp"-->

        
        <div class="lv_content">  <div class="lv_banner1"><img src="images/banner.jpg" width="960" height="200"></div>
            
            <div class="lv_box">
                
                <div class="left_side">
                    <div class="left_side_tit">
                        <img src="../images/else/left_tit02.jpg" style="display: block;" />
                    </div>
                    
<ul>
    <li><a href="index.html" onFocus="this.blur();">干细胞简历</a></li>
    <li><a href="Zxxb.html" onFocus="this.blur();">脐带血造血干细胞</a></li> <li><a href="Czxb.html" onFocus="this.blur();">脐带间充质干细胞</a></li>
	<li><a href="Tpxb.html" onFocus="this.blur();">胎盘干细胞</a></li>
		
    <li><a href="Disease.html" onFocus="this.blur();">可治疗的疾病</a></li>
    <li><a href="Donation.html" onFocus="this.blur();">互捐互赠</a></li>
    <li><a href="Treatment.html" onFocus="this.blur();">治疗案例</a></li>
	
    <li class="left_current"><a href="Research.html" onFocus="this.blur();">研究新动态</a></li>
</ul>
<div class="left_img">
    <a href="index.html">
        <img src="../images/else/img01.jpg" style="display: block;" /></a>
</div>

<!--#include file="../../inc_leftLastNews.asp"-->

                </div>
                
                <div class="rignt_con">
                    <div class="lv_tree">
                        <div class="lv_tree_tit">
                            <img src="../images/default/ico01.jpg" align="absmiddle" />&nbsp;&nbsp;研究新动态</div>
                        <p>
                            您现在的位置：<span><a href="../index.html">首页</a></span> - <span><a href="index.html">为何存储干细胞</a></span>
                            - <span class="lv_tree_current"><a href="#">行业风向标</a></span></p>
                    </div>
                    <div class="box">
                        <div class="treat_list">
<%

response.write strTemp
%>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        
<!--#include file="../../inc_foot.asp"-->

    </div>
<!-- boyalife.com Baidu tongji analytics -->
<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F73b8ef2157e56c7b6d0ef7c2598feff0' type='text/javascript'%3E%3C/script%3E"));
</script>
</body>
</html>
<%

rs.close
set rs=nothing
end sub



sub Research3
set rs=server.CreateObject("adodb.recordset")
sql="select * from TB_Article where classid=(select classid from TB_ArticleType where classname='学术课堂' ) order by px"
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<head>
<title>为何存储干细胞（博雅干细胞库）-BOYALIFE博雅干细胞科技有限公司</title>
<link href="../css/common.css" rel="stylesheet" type="text/css" />
<link href="../css/else.css" rel="stylesheet" type="text/css" />

    <script src="../js/jquery-1.4.min.js" type="text/javascript"></script>

    <script src="../js/nav.js" type="text/javascript"></script>

    <!--[if IE 6]>
	    <script type="text/javascript" src="../js/DD_belatedPNG.js" ></script>
	    <script type="text/javascript">
	    DD_belatedPNG.fix('.left_side ul li a:hover,.left_side ul li.left_current a');
	    </script>
    <![endif]-->
<meta name="Keywords" content="博雅干细胞库,符合国际标准的高端干细胞库,国际干细胞联合研究中心,无锡国际干细胞联合研究中心" /><meta name="Description" content="博雅干细胞库2009年成立于无锡，博雅干细胞库是由博雅干细胞科技有限公司整体运营的，由来自全球知名的干细胞存储、研究团队组建，中国内地首家也是唯一一家按照国际AABB（美国血库协会）标准设计和建立的干细胞库，代表着目前该领域国际最领先的技术水平。" /></head>
<body>

    <div id="wrap">
        
        

<script type="text/javascript"> 
    var CurrentUrl = window.location.href;
       function House() {
            //alert(title);
              window.external.addFavorite(CurrentUrl,"BOYALIFE博雅干细胞科技有限公司")
       }

</script>

<!--#include file="../../inc_head.asp"-->

<!--#include file="../../inc_nav.asp"-->

        
        <div class="lv_content">  <div class="lv_banner1"><img src="images/banner.jpg" width="960" height="200"></div>
            
            <div class="lv_box">
                
                <div class="left_side">
                    <div class="left_side_tit">
                        <img src="../images/else/left_tit05.jpg" style="display: block;" />
                    </div>
                    
<ul>
    <li class="left_current"><a href="../stemcells/Research3.html" onFocus="this.blur();">学术课堂</a></li>  
   
    <li><a href="../activities/NewsZx.html" onFocus="this.blur();">行业资讯</a></li>
    <li><a href="../activities/Video.html" onFocus="this.blur();">在线视频</a></li>
    <li><a href="../activities/Zazhi.html" onFocus="this.blur();">母婴杂志</a></li>
    <li><a href="../activities/Investigation.html" onFocus="this.blur();">在线调查</a></li>
</ul>
<div class="left_img">
    <a href="index.html">
        <img src="../images/else/img01.jpg" style="display: block;" /></a>
</div>

<!--#include file="../../inc_leftLastNews.asp"-->

                </div>
                
                <div class="rignt_con">
                    <div class="lv_tree">
                        <div class="lv_tree_tit">
                            <img src="../images/default/ico01.jpg" align="absmiddle" />&nbsp;&nbsp;学术课堂</div>
                        <p>
                            您现在的位置：<span><a href="../index.html">首页</a></span> - <span><a href="index.html">资料库</a></span>
                            - <span class="lv_tree_current"><a href="#">学术课堂</a></span></p>
                    </div>
                    <div class="box">
                        <div class="treat_list">
<%
for i=1 to rs.pagesize
if rs.eof then exit for
%>
  <ul>
	<li class="img_bg">
		<a href="<%if ""&rs("picbig")&""<>"" Then%>../<%=rs("picbig")%><%else%>?id=<%=rs("id")%><%end if%>"><img src="../<%=rs("picsmall")%>" width="131" height="84" style="display: block" /></a></li>
	<li class="img_con">
		<p>
			<a href="<%if ""&rs("picbig")&""<>"" Then%>../<%=rs("picbig")%><%else%>?id=<%=rs("id")%><%end if%>"><strong>
			<%=rs("title")%></strong></a>
			</p>
		<p>
			<%=gotTopic(RemoveHTML(rs("content")),300)%>
		</p>
	</li>
</ul>
<%

rs.movenext
next
%>
<p style="padding:15px 0">
<%
pageObj.pageskin=6
pageObj.img_path="../image/"
response.Write pageObj.link(rs.recordcount,rs.pagesize,page,"?page=",qryString)
%>
</p>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        
<!--#include file="../../inc_foot.asp"-->

    </div>
<!-- boyalife.com Baidu tongji analytics -->
<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F73b8ef2157e56c7b6d0ef7c2598feff0' type='text/javascript'%3E%3C/script%3E"));
</script>
</body>
</html>

<%
end if
rs.close
set rs=nothing
end sub




sub showTreatment3(id)'显示新闻内容'
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
strTemp=strTemp&"<tr><td height='30' align='center'>"&AddDate_lang&rs("Addtime")&Hits_lang&rs("Hits")&"</td></tr>"
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
		strTemp=strTemp&"<a href='?id="&arrLink(o-1)&"'>"&prevLink_lang&"："&arrTitle(o-1)&"</a>"
	  end if
	  strTemp=strTemp&"<br>"
	  if o<ubound(arrLink) then
		strTemp=strTemp&"<a href='?id="&arrLink(o+1)&"'>"&nextLink_lang&"："&arrTitle(o+1)&"</a>"
	  end if
  end if
next
strTemp=strTemp&"</td></tr></table>"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<head>
<title><%=rs("htitle")%></title>
<link href="../css/common.css" rel="stylesheet" type="text/css" />
<link href="../css/else.css" rel="stylesheet" type="text/css" />

    <script src="../js/jquery-1.4.min.js" type="text/javascript"></script>

    <script src="../js/nav.js" type="text/javascript"></script>

    <!--[if IE 6]>
	    <script type="text/javascript" src="../js/DD_belatedPNG.js" ></script>
	    <script type="text/javascript">
	    DD_belatedPNG.fix('.left_side ul li a:hover,.left_side ul li.left_current a');
	    </script>
    <![endif]-->
<meta name="Keywords" content="<%=rs("hkeywords")%>" />
<meta name="Description" content="<%=rs("hdescription")%>" />
</head>
<body>

    <div id="wrap">
        
        

<script type="text/javascript"> 
    var CurrentUrl = window.location.href;
       function House() {
            //alert(title);
              window.external.addFavorite(CurrentUrl,"BOYALIFE博雅干细胞科技有限公司")
       }

</script>

<!--#include file="../../inc_head.asp"-->

<!--#include file="../../inc_nav.asp"-->

        
        <div class="lv_content">  <div class="lv_banner1"><img src="images/banner.jpg" width="960" height="200"></div>
            
            <div class="lv_box">
                
                <div class="left_side">
                    <div class="left_side_tit">
                        <img src="../images/else/left_tit05.jpg" style="display: block;" />
                    </div>
                    
<ul>
    <li class="left_current"><a href="../stemcells/Research3.html" onFocus="this.blur();">学术课堂</a></li>  
   
    <li><a href="../activities/NewsZx.html" onFocus="this.blur();">行业资讯</a></li>
    <li><a href="../activities/Video.html" onFocus="this.blur();">在线视频</a></li>
    <li><a href="../activities/Zazhi.html" onFocus="this.blur();">母婴杂志</a></li>
    <li><a href="../activities/Investigation.html" onFocus="this.blur();">在线调查</a></li>
</ul>
<div class="left_img">
    <a href="index.html">
        <img src="../images/else/img01.jpg" style="display: block;" /></a>
</div>

<!--#include file="../../inc_leftLastNews.asp"-->

                </div>
                
                <div class="rignt_con">
                    <div class="lv_tree">
                        <div class="lv_tree_tit">
                            <img src="../images/default/ico01.jpg" align="absmiddle" />&nbsp;&nbsp;学术课堂</div>
                        <p>
                            您现在的位置：<span><a href="../index.html">首页</a></span> - <span><a href="index.html">资料库</a></span>
                            - <span class="lv_tree_current"><a href="#">学术课堂</a></span></p>
                    </div>
                    <div class="box">
                        <div class="treat_list">
<%
response.write strTemp
%>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        
<!--#include file="../../inc_foot.asp"-->

    </div>
<!-- boyalife.com Baidu tongji analytics -->
<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F73b8ef2157e56c7b6d0ef7c2598feff0' type='text/javascript'%3E%3C/script%3E"));
</script>
</body>
</html>

<%
rs.close
set rs=nothing
end sub








%>
