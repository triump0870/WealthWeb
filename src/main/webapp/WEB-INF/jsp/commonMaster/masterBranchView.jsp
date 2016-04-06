<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@page import="com.fn.pfolio.valueObject.WebConstants"%>
<%@page import="com.fn.pfolio.util.ResourceConstant"%>
<%@page import="com.fn.pfolio.valueObjects.Constants"%>
<%@ taglib uri="/WEB-INF/lib/rl-admin.tld" prefix="rl" %>
<%@page import="com.rx.web.util.UtilProp"%>

<style type="text/css">
legend{
   margin-bottom:15px;
}
</style>
<%String jasperServerPath = (String) request.getSession().getAttribute("bankbranch.jasperpath");
%>
<ul class="breadcrumb">
	<li><a href="../secureGate/home"><spring:message code="navigation.home"/></a><span class="divider">/</span>
	</li>
	<li><spring:message code="navigation.master"/><span class="divider">/</span></li>
	<li><spring:message code="navigation.bankDpBroker"/><span class="divider">/</span></li>
	<li class="active"><spring:message code="navigation.branchBank"/></li>
</ul>
<div class="well">
<fieldset>
	<%	String appInstance = UtilProp.getAppInstance();
		if(!appInstance.equals(Constants.APP_INSTANCE_IIFLW)){	%>
	<legend><spring:message code="masterBranchView.branchBankView"/></legend>
	
	 <table id="masterBranchTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>Id</th>
				<th>Branch Name</th>
				<th>Branch Short Name</th>
				<th>Bank Name</th>
				<th>IFSC Code</th>
				<th>City</th>

			</tr>
		</thead>
		<tbody>
			<c:forEach var="branch" items="${commonMasterForm.branchList}">
				<tr>
					<td>${branch.id}</td>
					<td>${branch.name}</td>
					<td>${branch.shortName}</td>
					<td>${branch.bankId.name}</td>
					<td>${branch.ifscCode}</td>
					<td>${branch.cityId.name}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%	}else{%>
			<legend><spring:message code="masterBranchView.branchBankView"/><span class="lnks"><a href="#" onclick="window.open( '<%=jasperServerPath %>')">(View All Bank Branches)</a></span></legend>
		<%}%>


	<div class="control-group">
		<div class="controls">
			<br /> <br />
			<div class="form-actions">
			<rl:btnAccess action="<%=Constants.REQUEST_TYPE_CREATE%>" screenCode="<%=ResourceConstant.SCREEN_BANK_BRANCH%>">
				<input type="button" name="create" id="create" value="Create" onclick="parent.location='./createMasterBranch'" class="btn-small btn-warning" />
			</rl:btnAccess>
			<rl:btnAccess action="<%=Constants.REQUEST_TYPE_UPDATE%>" screenCode="<%=ResourceConstant.SCREEN_BANK_BRANCH%>">	
				<input type="button" name="edit" id="edit" value="Edit" class="btn-small btn-warning" />
			</rl:btnAccess>
			<rl:btnAccess action="<%=Constants.REQUEST_TYPE_DELETE%>" screenCode="<%=ResourceConstant.SCREEN_BANK_BRANCH%>">	 
				<input type="button" name="delete" id="delete" value="Delete" class="btn-small btn-warning" />
			</rl:btnAccess>
			<rl:btnAccess action="<%=Constants.REQUEST_TYPE_VIEW%>" screenCode="<%=ResourceConstant.SCREEN_BANK_BRANCH%>">	
				<input type="button" name="view" id="view" value="View" class="btn-small btn-warning"/>
			</rl:btnAccess>	
			</div>
		</div>
	</div>
</fieldset>
<div class="row-fluid">
			<%
				String statusMessage = (String) session.getAttribute("statusMsg");
			if (statusMessage != null) {
			%>
			<div  id="msg" class="alert alert-success" style="text-align:center;background-color: #DFF0D8;border-color: #D6E9C6;color: #468847;">
				<h6>
					<%=statusMessage%>
				</h6>
				<% session.removeAttribute("statusMsg");
					} %>
			</div>
			</div>
</div>




<script type="text/javascript" charset="utf-8">
		$(document)
				.ready(
						function() {
							/* START: Init the table */
							oTable = $('#masterBranchTable')
									.dataTable(
											{
												"aoColumns" : [ /* ID*/{
													"bSearchable" : false,
													"bVisible" : false
												}, null, null, null, null,null ],
												"aaSorting" : [ [ 0, "desc" ] ],
												"bProcessing" : true,
												"bDeferRender" : true,
												"sPaginate" : true,
												"sPaginationType" : "bootstrap",
												"sDom" : 'T<"clear">lfrtip',
												"oTableTools" : {
													"sSwfPath" : DATA_TABLE_SWF_FILE,
													"aButtons" : [
															"copy",
															"csv",
															{
																"sExtends" : "xls",
																"sFileName" : "Branch (Bank).xls"
															},

															{
																"sExtends" : "pdf",
																"mColumns" : [
																		1, 2,
																		3, 4,5],
																"sPdfOrientation" : "landscape",
																"bHeader" : true,
																"bFooter" : true

															}, "print" ]
												}
											});
							/* END: Init the table */

							/* Add a click handler to the rows - this could be used as a callback */
							$("#masterBranchTable tbody").click(
									function(event) {
										$(oTable.fnSettings().aoData).each(
												function() {
													$(this.nTr).removeClass(
															'row_selected');
												});
										$(event.target.parentNode).addClass(
												'row_selected');
									});

							/* Click handler for the delete row */
							$('#delete')
									.click(
											function() {

												var anSelected = fnGetSelected(oTable);
												var aPos = oTable
														.fnGetPosition(anSelected[0]);
												var aData = oTable
														.fnGetData(aPos);
												var ans = confirm('Are you sure you want to delete this row?');
												if (ans == true) {
													$
															.ajax({
																type : 'GET',
																url : './deleteMasterBranch',
																data : {
																	id : aData[0]
																},

																success : function() {
																	alert("Deleted Successfully");
																	oTable
																			.fnDeleteRow(anSelected[0]);
																},
																error : function(
																		jqXHR,
																		textStatus,
																		errorThrown) {
																	/* alert("Cannot delete this record,since linked records are present"); */
																}
															});
												}
											});
							/* Get the DataTables object again - this is not a recreation, just a get of the object */
							function fnShowHide(iCol) {
								var oTable = $('#masterBranchTable')
										.dataTable();
								var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
								oTable
										.fnSetColumnVis(iCol, bVis ? false
												: true);
							}

							/* Add a click handler for the edit row */
							$('#edit').click(
									function() {
										var anSelected = fnGetSelected(oTable);
										var aPos = oTable
												.fnGetPosition(anSelected[0]);
										var aData = oTable.fnGetData(aPos);
										//call(aData[0]);
										window.open("./editMasterBranch?id="
												+ aData[0], "_self");
									});
							$('#view').click(
									function() {
										var anSelected = fnGetSelected(oTable);
										var aPos = oTable
												.fnGetPosition(anSelected[0]);
										var aData = oTable.fnGetData(aPos);
										//call(aData[0]);
										window.open("./masterBranchIndView?id="
												+ aData[0], "_self");
									});
						});

		/* Get the rows which are currently selected */
		function fnGetSelected(oTableLocal) {
			var aReturn = new Array();
			var aTrs = oTableLocal.fnGetNodes();

			for ( var i = 0; i < aTrs.length; i++) {
				if ($(aTrs[i]).hasClass('row_selected')) {
					aReturn.push(aTrs[i]);
				}
			}
			if (aReturn.length < 1) {
				alert("Please select a row");
			}
			return aReturn;
		}
	</script>
	<script type="text/javascript" charset="utf-8">
	$(document).ready(function() {
		$("#msg").fadeOut(10000);
	});
	</script>