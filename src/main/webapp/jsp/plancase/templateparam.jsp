<%@ page contentType="text/html; charset=utf-8" language="java"
	import="java.sql.*" errorPage=""%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>编辑协议模板内容</title>

<style type="text/css">
<!--
.STYLE1 {
	font-size: 12px;
	color: #ffffff;
}

-->
.error_msg {
	font-size: 12px;
	color: #f00;
}

.tip {
	font-size: 12px;
	color: blue;
}
</style>


</head>

<body>
	<div>
		<%@ include file="/head.jsp"%>
	</div>
	<header id="head" class="secondary"></header>

	<!-- container -->
	<div class="container" style="width: auto; font-size: 14px">
		<ol class="breadcrumb">
			<li><a href="/">主页</a></li>
			<li class="active"><a href="/projectprotocolTemplate/load.do">测试协议模板</a></li>
			<li class="active">编辑协议模板内容</li>
		</ol>

		<div class="row">
			<!-- Article main content -->
			<article class="col-sm-9 maincontent" style="width:100%;">
			<header class="page-header">
			<h1 class="page-title" style="text-align: center;">编辑测试协议模板内容</h1>
			</header>

			<div class="col-md-12 col-sm-12">
				<div class="panel panel-default">
					<div class="panel-body">
						<h3 class="thin text-center">协议模板基本信息</h3>
						<table class="table table-striped" id="templatetable">
							<tr>
							    <td width="18%" style="font-weight:bold;">项目名称：${ptemplate.projectname}</td>
								<td width="25%" style="font-weight:bold;">模板名称：${ptemplate.name}</td>
								<td width="10%" style="font-weight:bold;">协议类型：${ptemplate.protocoltype}</td>
							    <td width="10%" style="font-weight:bold;">编码格式：${ptemplate.contentencoding}</td>
								<td width="10%" style="font-weight:bold;">超时时间：${ptemplate.connecttimeout}</td>
								<td width="27%" style="font-weight:bold;">备注：${ptemplate.remark}</td>
							</tr>
						</table>

                        <h3 class="thin text-center">协议模板参数</h3>
						<form id="templateparams" onsubmit="return check_form()">
							<div class="form-group">
								<table class="table table-striped" id="paramtable">
									<thead>
										<tr>
											<th>参数名</th>
											<th>参数默认值</th>
										</tr>
									</thead>
									<tbody id="paramtbody">
										<c:forEach var="t" items="${templateparams}" begin="0" step="1"
											varStatus="i">
											<tr id="paramrow-${i.count}">
												<td width="20%">
												<input type="text"	class="form-control" name="paramname" id="paramname${i.count}" value="${t.paramname }" />
												</td>
												<td width="76%">
												<input type="text"	class="form-control" name="param" id="param${i.count}" value="${t.param }" />
												<input id="id${i.count}" type="hidden" value="${t.id }" />
												</td>
												
												<td width="4%" style="vertical-align: middle;"><a
													class="fa fa-plus-circle fa-5"
													style="font-size: 20px; cursor: pointer;"
													onclick="addparam(this)"></a> <a
													class="fa fa-minus-circle fa-5"
													style="font-size: 20px; cursor: pointer;"
													onclick="delparam(this)"></a>
													</td>													
											</tr>
											
										</c:forEach>
									</tbody>
								</table>
							</div>
							</br>
							<div class="row">
								<div class="col-lg-4 text-center" style="width: 100%">
									<button class="btn btn-action" type="submit">保 存</button>
								</div>
							</div>
						</form>
					</div>
				</div>

			</div>

			<p>&nbsp;</p>
			</article>
		</div>
	</div>

	<script type="text/javascript">

		$(document).ready(
				function() {
					$('#paramtable').bootstrapValidator({
						message : '当前填写信息无效！',
						//live: 'submitted',
						feedbackIcons : {
							valid : 'glyphicon glyphicon-ok',
							invalid : 'glyphicon glyphicon-remove',
							validating : 'glyphicon glyphicon-refresh'
						},
						fields : {
							paramname : {
								message : '【参数名】无效！',
								validators : {
									notEmpty : {
										message : '【参数名】不能为空'
									},
									stringLength : {
										min : 2,
										max : 50,
										message : '【参数名】长度必须在2~50个字符区间'
									}
								}
							},
							param : {
								message : '【参数默认值】无效！',
								validators : {
									notEmpty : {
										message : '【参数默认值】不能为空'
									},
									stringLength : {
										min : 1,
										max : 2000,
										message : '【参数默认值】长度必须在1~2000个字符区间'
									}
								}
							},
						}
					}).on(
							'success.form.bv',
							function(e) {
								// Prevent submit form
								e.preventDefault();
								var $form = $(e.target), validator = $form
										.data('bootstrapValidator');
								$form.find('.alert').html('参数创建成功！');
							});
				});
		
		String.prototype.replaceAll = function(s1,s2) { 
		    return this.replace(new RegExp(s1,"gm"),s2); 
		}

		// 提交表单
		function check_form() {
			var oTable = document.getElementById("paramtbody");
			var json = "";
			for (var i = 0; i < oTable.rows.length; i++) {
				var index = i + 1
				json = json + "{\"id\":" + $("#id" + index).val()+ ",";
				json = json + "\"paramname\":\"" + $("#paramname" + index).val().replaceAll("\"", "&quot;") + "\",";
				json = json + "\"param\":\"" + $("#param" + index).val().replaceAll("\"", "&quot;")	+ "\",";
				json = json + "\"templateid\":\"" + '${ptemplate.id}' + "\"}";
				if (i != oTable.rows.length - 1) {
					json = json + ",";
				}
			}
			json = "[" + json + "]"
			// 异步提交数据到action页面
			$.ajax({
				type : "POST",
				cache : false,
				async : true,
				dataType : "json",
				url : "editparam.do",
				contentType : "application/json", //必须有
				data : JSON.stringify(json),
				success : function(data, status) {
 				if (data.status == "success") {
 					toastr.success(data.ms);
					}else{
						toastr.info(data.ms);
					}
				},
				error : function() {
					toastr.error(data);
				}
			});

			return false;
		}

		function addparam(obj) {
			if (obj == null)
				return;
			var parentTD = obj.parentNode; //parentNode是父标签的意思，如果你的TD里用了很多div控制格式，要多调用几次parentNode
			var parentTR = parentTD.parentNode;
			var clonedNode = parentTR.cloneNode(true); // 克隆节点
			var oTable = document.getElementById("paramtbody");
			clonedNode.setAttribute("id", "paramrow-" + (oTable.rows.length + 1)); // 修改一下id 值，避免id 重复
			var o = clonedNode.childNodes;
			parentTR.parentNode.appendChild(clonedNode); // 在父节点插入克隆的节点 

			for (var i = 0; i < oTable.rows.length; i++) {
				var index = i + 1
 				oTable.rows[i].cells[0].childNodes[1].setAttribute("id","paramname"+index);
				oTable.rows[i].cells[1].childNodes[1].setAttribute("id","param"+index);
			}
		}

		function delparam(obj) {
			if (obj == null)
				return;
			var oTable = document.getElementById("paramtbody");
			if (oTable.rows.length < 2)
				return;

			var parentTD = obj.parentNode; //parentNode是父标签的意思，如果你的TD里用了很多div控制格式，要多调用几次parentNode
			var parentTR = parentTD.parentNode;
			var parentTBODY = parentTR.parentNode;
			parentTBODY.removeChild(parentTR);

			for (var i = 0; i < oTable.rows.length; i++) {
				var index = i + 1
				oTable.rows[i].cells[0].childNodes[1].setAttribute("id","paramname"+index);
				oTable.rows[i].cells[1].childNodes[1].setAttribute("id","param"+index);
			}
		}
	</script>
</body>
</html>
