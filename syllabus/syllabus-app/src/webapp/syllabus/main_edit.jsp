<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://sakaiproject.org/jsf2/sakai" prefix="sakai" %>
<%@ taglib uri="http://sakaiproject.org/jsf/syllabus" prefix="syllabus" %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<f:view>
<jsp:useBean id="msgs" class="org.sakaiproject.util.ResourceLoader" scope="session">
   <jsp:setProperty name="msgs" property="baseName" value="org.sakaiproject.tool.syllabus.bundle.Messages"/>
</jsp:useBean>
	<sakai:view_container title="#{msgs.title_list}">
	<sakai:view_content>

<script>includeLatestJQuery('main_edit.jsp');</script>
<link rel="stylesheet" href="/library/webjars/jquery-ui/1.12.1/jquery-ui.min.css" type="text/css" />
<script src="/library/js/lang-datepicker/lang-datepicker.js"></script>
<script src="js/syllabus.js"></script>
<script>
  var dataChanged = false;
  var idPrefix = 'syllabusMainEdit:dataTable:';
  $(document).ready(function() {
  			$("input.dateInputStart").each(function(){
				localDatePicker({
  							input: $(this)[0],
  							useTime: 1,
  							parseFormat: 'YYYY-MM-DD HH:mm:ss',
  							allowEmptyDate: true,
  							val: $(this).val(),
  							ashidden: {
  									iso8601: $(this).attr('id').replace(idPrefix,'').replace(':dataStartDate','dataStartDateISO8601')}
  				});
  			});
			$("input.dateInputEnd").each(function(){
  				localDatePicker({
  							input: $(this)[0],
  							useTime: 1,
  							parseFormat: 'YYYY-MM-DD HH:mm:ss',
  							allowEmptyDate: true,
  							val: $(this).val(),
  							ashidden: {
  									iso8601: $(this).attr('id').replace(idPrefix,'').replace(':dataEndDate','dataEndDateISO8601')}
  				});
  			});

			var menuLink = $('#syllabusMenuBulkEditLink');
			menuLink.addClass('current');
			menuLink.find('a').removeAttr('href');

  });
  $(function() {
  	
  	//setup data change listener
  	$('input').change(function() {
    	dataChanged = true;
	});
  	
  	//disable calendar options that are in draft:
  	disableCalendarOptions();
  	//add listeners to the calendar dates for the calendar checkbox:
  	$(".dateInputStart").change(function(){
  		checkCalendarDates(this);
  	});
  	$(".dateInputEnd").change(function(){
  		checkCalendarDates(this);
  	});
  	
  });
  
	function toggleCalendarCheckbox(postCheckbox){
		$(postCheckbox).parent().parent().find(".calendarBox").each(function(){
			if(postCheckbox.checked){
				$(this).removeAttr("disabled");
			}else{
				$(this).attr("disabled", "disabled");
				this.checked = false;
			}
		});
	}
	
	function checkStartEndDates(calendarCheckbox){
		if(calendarCheckbox.checked){
			//check that this rows has either start or end dates set
			var startTime = $(calendarCheckbox).parent().parent().find(".dateInputStart").val();
			var endTime = $(calendarCheckbox).parent().parent().find(".dateInputEnd").val();
			if((startTime == null || "" == $.trim(startTime))
					&& (endTime == null || "" == $.trim(endTime))){
				showMessage("<h:outputText value="#{msgs.calendarDatesNeeded}"/>", false);
				calendarCheckbox.checked = false;
			}
		}
	}
	
	var deleteClick;
            
	function assignWarningClick(link) {
  		if (link.onclick == confirmPost) {
    		return;
  		}
                
  		deleteClick = link.onclick;
  		link.onclick = confirmPost;
	}

	function confirmPost(){
		if(dataChanged){
			var agree=confirm('<h:outputText value="#{msgs.main_edit_confirmDataChanged}"/>');
			if (agree)
				return deleteClick();
			else
				return false ;
		}else{
			return deleteClick();
		}
	}
	
	function toggleAllCalendarOptions(toggleCheckbox){
		$('.calendarBox').each(function(){
			if(toggleCheckbox.checked){
				//make sure that the post option is checked otherwise don't check it as well as the start or end date isn't null
				if($(this).parent().parent().find(".postBox:checked").length == 1){
					var startTime = $(this).parent().parent().find(".dateInputStart").val();
					var endTime = $(this).parent().parent().find(".dateInputEnd").val();
					if((startTime != null && "" != $.trim(startTime)) || (endTime != null && "" != $.trim(endTime))){
						//at least one date is set
						this.checked = true;
					}else{
						showMessage("<h:outputText value="#{msgs.calendarDatesNeededToggle}"/>", false);
					}
				}
			}else{
				this.checked = false;
			}
		});
	}

	function toggleAllPostOptions(toggleCheckbox){
		$('.postBox').each(function(){
			if(toggleCheckbox.checked){
				this.checked = true;
			}else{
				this.checked = false;
				//make sure calendar option is unchecked
				$(this).parent().parent().find(".calendarBox").removeAttr("checked");
			}
			toggleCalendarCheckbox(this);
		});
	}
	
	function disableCalendarOptions(){
		$('.calendarBox').each(function(){
			if($(this).parent().parent().find(".postBox:checked").length == 0){
				$(this).attr("disabled", "disabled");
			}
		});
	}
	
	//used for when a date is changed, it will check that the calendar checkbox is not checked if
	//both dates are empty
	function checkCalendarDates(dateInput){
		var startTime = $(dateInput).parent().parent().find(".dateInputStart").val();
		var endTime = $(dateInput).parent().parent().find(".dateInputEnd").val();
		if((startTime == null || "" == $.trim(startTime)) && (endTime == null || "" == $.trim(endTime))){
			//both start and end dates are null, so make sure the calendar checkbox is unchecked:
			$(dateInput).parent().parent().find(".calendarBox").removeAttr("checked");
		}
	}
 </script>
<div>
	<span id="successInfo" class="sak-banner-success popupMessage" style="display:none; float: left;"></span>
	<span id="warningInfo" class="sak-banner-warn popupMessage" style="display:none; float: left;"></span>
</div>
        <script>
        	// if redirected, just open in another window else
        	// open with size approx what actual print out will look like
        	function printFriendly(url) {
        		if (url.indexOf("printFriendly") == -1) {
        			window.open(url,"mywindow");
        		}
        		else {
        			window.open(url,"mywindow","width=960,height=1100,scrollbars=yes");
        		}
        	}
        </script>

        <h:form id="syllabusMainEdit">
          <%@ include file="mainMenu.jsp" %>
   	      <h:messages globalOnly="true" layout="table" styleClass="sak-banner-error" rendered="#{!empty facesContext.maximumSeverity}" />
		  <sakai:tool_bar_message value="#{msgs.mainEditNotice}" />
			<syllabus:syllabus_ifnot test="#{SyllabusTool.syllabusItem.redirectURL}">
			  <h:outputText escape="false" value="#{msgs.redirect_explanation} " />
			  <h:outputLink target="_blank" rel="noopener" title="#{msgs.openLinkNewWindow}" value="#{SyllabusTool.syllabusItem.redirectURL}">
			    <h:outputText escape="false" value="#{SyllabusTool.syllabusItem.redirectURL}" />
			  </h:outputLink>
			</syllabus:syllabus_ifnot>

			<div class="table-responsive">
				<h:dataTable id="dataTable" value="#{SyllabusTool.entries}" var="eachEntry" summary="#{msgs.mainEditListSummary}" styleClass="table table-striped table-bordered"
								columnClasses="text-left,text-center,text-center,text-center,text-center,text-center,text-center" >
							<h:column rendered="#{! SyllabusTool.displayNoEntryMsg}">
								<f:facet name="header">
									<h:outputText value="#{msgs.mainEditHeaderItem}" />
								</f:facet>
								<h:inputText value="#{eachEntry.entry.title}"/>
								<f:verbatim><br/></f:verbatim>
								<h:commandLink action="#{eachEntry.processListRead}" value="#{msgs.edit_details}" title="#{msgs.goToItem} #{eachEntry.entry.title}" onmousedown="assignWarningClick(this);"/>
								
								
							</h:column>
							<h:column rendered="#{! SyllabusTool.displayNoEntryMsg}">
								<f:facet name="header">
									<h:outputText value="" />
								</f:facet>
								<h:commandLink action="#{eachEntry.processUpMove}" styleClass="button" style="text-decoration:none" title="#{msgs.mainEditLinkUpTitle}" rendered="#{SyllabusTool.editAble == 'true'}">
												<f:verbatim><span class="fa fa-long-arrow-up" alt="</f:verbatim><h:outputText value="#{msgs.mainEditLinkUpTitle}" /><f:verbatim>" ></span></f:verbatim>
									<h:outputText value="(#{eachEntry.entry.title})" styleClass="skip"/>
								</h:commandLink>
								<h:outputText value=" "/>
								<h:commandLink action="#{eachEntry.processDownMove}" styleClass="button" style="text-decoration:none" title="#{msgs.mainEditLinkDownTitle}" rendered="#{SyllabusTool.editAble == 'true'}">
																<f:verbatim><span class="fa fa-long-arrow-down" alt="</f:verbatim><h:outputText value="#{msgs.mainEditLinkDownTitle}" /><f:verbatim>" ></span></f:verbatim>
									<h:outputText value="(#{eachEntry.entry.title})" styleClass="skip"/>
								</h:commandLink>
							</h:column>
							<h:column rendered="#{! SyllabusTool.displayNoEntryMsg}" headerClass="text-center">
								<f:facet name="header">
									<h:outputText value="#{msgs.mainEditHeaderStartTime}"/>
								</f:facet>
								<h:inputText styleClass="dateInput dateInputStart" value="#{eachEntry.startDateString}" id="dataStartDate"/>
							</h:column>	
							<h:column rendered="#{! SyllabusTool.displayNoEntryMsg}" headerClass="text-center">
								<f:facet name="header">
									<h:outputText value="#{msgs.mainEditHeaderEndTime}"/>
								</f:facet>
								<h:inputText styleClass="dateInput dateInputEnd" value="#{eachEntry.endDateString}" id="dataEndDate"/>
							</h:column>
							<h:column rendered="#{! SyllabusTool.displayNoEntryMsg && SyllabusTool.calendarExistsForSite}" headerClass="text-center">
								<f:facet name="header">
									<h:panelGroup>
										<h:outputText value="#{msgs.mainEditHeaderInCalendar}"/>
											<br/>
											<h:selectBooleanCheckbox title="#{msgs.mainEditHeaderInCalendar}" onchange="toggleAllCalendarOptions(this);"/>
									</h:panelGroup>
								</f:facet>
								<h:selectBooleanCheckbox styleClass="calendarBox" value="#{eachEntry.entry.linkCalendar}" title="#{msgs.selectThisCheckBoxCal}" onchange="checkStartEndDates(this)"/>
							</h:column>
							<h:column rendered="#{! SyllabusTool.displayNoEntryMsg}" headerClass="text-center">
								<f:facet name="header">
									<h:panelGroup>
										<h:outputText value="#{msgs.mainEditHeaderStatus}"/>
											<br/>
											<h:selectBooleanCheckbox title="#{msgs.mainEditHeaderStatus}" onchange="toggleAllPostOptions(this);"/>
									</h:panelGroup>
								</f:facet>
								<h:selectBooleanCheckbox styleClass="postBox" value="#{eachEntry.posted}" title="#{msgs.selectThisCheckBoxPublish}" onchange="toggleCalendarCheckbox(this);" />
							</h:column>
							<h:column rendered="#{! SyllabusTool.displayNoEntryMsg}" headerClass="text-center">
								<f:facet name="header">
									<h:panelGroup>
										<h:outputText value="#{msgs.mainEditHeaderRemove}"/>
											<br/>
											<h:selectBooleanCheckbox title="#{msgs.mainEditHeaderRemove}" onchange="$('.deleteBox').attr('checked', this.checked);"/>
									</h:panelGroup>
								</f:facet>
								<h:selectBooleanCheckbox styleClass="deleteBox" value="#{eachEntry.selected}" title="#{msgs.selectThisCheckBox}"/>
							</h:column>
				</h:dataTable>
			</div>
			 <f:verbatim><p class="act"></f:verbatim>	
				<h:commandButton 
				     value="#{msgs.update}" 
					 action="#{SyllabusTool.processListDelete}"
					 title="#{msgs.update}"
				     rendered="#{! SyllabusTool.displayNoEntryMsg}"
					 accesskey="s" styleClass="active" />
				<h:commandButton 
				     value="#{msgs.cancel}"
					 action="#{SyllabusTool.processMainEditCancel}"
					 title="#{msgs.button_cancel}"
				     rendered="#{! SyllabusTool.displayNoEntryMsg}"
					 accesskey="x" />
			<f:verbatim></p></f:verbatim>

        </h:form>
	</sakai:view_content>
	</sakai:view_container>
</f:view>
