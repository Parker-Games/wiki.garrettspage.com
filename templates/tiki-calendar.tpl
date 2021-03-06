{* $Id$ *}

{title admpage="calendar"}
	{if $displayedcals|@count eq 1}
		{tr}Calendar:{/tr} {assign var=x value=$displayedcals[0]}{$infocals[$x].name}
	{else}
		{tr}Calendar{/tr}
	{/if}
{/title}
<div id="calscreen">
	<div class="t_navbar mb-4">
		<div class="btn-group float-right">
			{if ! $js}<ul class="cssmenu_horiz"><li>{/if}
			<a class="btn btn-link" data-toggle="dropdown" data-hover="dropdown" href="#">
				{icon name='menu-extra'}
			</a>
			<ul class="dropdown-menu dropdown-menu-right">
				<li class="dropdown-title">
					{tr}Monitoring{/tr}
				</li>
				<li class="dropdown-divider"></li>
				{if $displayedcals|@count eq 1 and $user and $prefs.feature_user_watches eq 'y'}
					<li class="dropdown-item">
						{if $user_watching eq 'y'}
							<a href="tiki-calendar.php?watch_event=calendar_changed&amp;watch_action=remove" hspace="1">
								{icon name="stop-watching"} {tr}Stop monitoring{/tr}
							</a>
						{else}
							<a href="tiki-calendar.php?watch_event=calendar_changed&amp;watch_action=add" hspace="1">
								{icon name="watch"} {tr}Monitor{/tr}
							</a>
						{/if}
					</li>
				{/if}
				{if $displayedcals|@count eq 1 and $prefs.feature_group_watches eq 'y' and ( $tiki_p_admin_users eq 'y' or $tiki_p_admin eq 'y' )}
					<li class="dropdown-item">
						<a href="tiki-object_watches.php?objectId={$displayedcals[0]|escape:"url"}&amp;watch_event=calendar_changed&amp;objectType=calendar&amp;objectName={$infocals[$x].name|escape:"url"}&amp;objectHref={'tiki-calendar.php?calIds[]='|cat:$displayedcals[0]|escape:"url"}" hspace="1">
							{icon name="watch-group"} {tr}Group Monitor{/tr}
						</a>
					</li>
				{/if}
			</ul>
			{if ! $js}</li></ul>{/if}
		</div>
		{if $tiki_p_admin_calendar eq 'y' or $tiki_p_admin eq 'y'}
			{if $displayedcals|@count eq 1}
				{button href="tiki-admin_calendars.php?calendarId={$displayedcals[0]}" _type="link" _text="{tr}Edit{/tr}" _icon_name="edit"}
			{/if}
			{button href="tiki-admin_calendars.php?cookietab=1" _type="link" _text="{tr}Admin{/tr}" _icon_name="admin"}
		{/if}

{* avoid Add Event being shown if no calendar is displayed *}
		{if $tiki_p_add_events eq 'y'}
			{button href="tiki-calendar_edit_item.php" _type="link" _text="{tr}Add Event{/tr}" _icon_name="create"}
		{/if}

		{if $tiki_p_view_events eq 'y' and $prefs.calendar_export eq 'y'}
			{button href="#" _onclick="toggle('exportcal');return false;" _text="{tr}Export{/tr}" _icon_name="import"}
		{/if}

		{if $viewlist eq 'list'}
			{capture name=href}?viewlist=table{if $smarty.request.todate}&amp;todate={$smarty.request.todate}{/if}{/capture}
			{button href=$smarty.capture.href _text="{tr}Calendar View{/tr}" _icon_name="calendar"}
		{else}
			{capture name=href}?viewlist=list{if $smarty.request.todate}&amp;todate={$smarty.request.todate}{/if}{/capture}
			{button href=$smarty.capture.href _text="{tr}List View{/tr}" _icon_name="list" _class="btn-info"}
		{/if}

		{if count($listcals) >= 1}
			{button href="#" _onclick="toggle('filtercal');return false;" _text="{tr}Visible Calendars{/tr}" _icon_name="eye"}

			{if count($thiscal)}
				<div id="configlinks" class="form-group row text-right">
					{assign var='maxCalsForButton' value=20}
					{if count($checkedCals) > $maxCalsForButton}<select size="5">{/if}
					{foreach item=k from=$listcals name=listc}
						{if $thiscal.$k}
							{assign var=thiscustombgcolor value=$infocals.$k.custombgcolor}
							{assign var=thiscustomfgcolor value=$infocals.$k.customfgcolor}
							{assign var=thisinfocalsname value=$infocals.$k.name|escape}
							{if count($checkedCals) > $maxCalsForButton}
								<option style="background:#{$thiscustombgcolor};color:#{$thiscustomfgcolor};" onclick="toggle('filtercal')">{$thisinfocalsname}</option>
							{else}
								{button href="#" _style="background:#$thiscustombgcolor;color:#$thiscustomfgcolor;border:1px solid #$thiscustomfgcolor;" _onclick="toggle('filtercal');return false;" _text="$thisinfocalsname"}
							{/if}
						{/if}
					{/foreach}
					{if count($checkedCals) > $maxCalsForButton}</select>{/if}
				</div>
			{else}
				{button href="" _style="background-color:#fff;padding:0 4px;" _text="{tr}None{/tr}"}
			{/if}
		{/if}
	</div>
{* show jscalendar if set *}
		{if $prefs.feature_jscalendar eq 'y'}
			<div class="jscalrow" style="display: inline-block">
				<form action="{$myurl}" method="post" name="f">
					{jscalendar date="$focusdate" id="trig" goto="$jscal_url" align="Bc"}
				</form>
			</div>
		{/if}




	{if $user and $prefs.feature_user_watches eq 'y' and isset($category_watched) and $category_watched eq 'y'}
	<div class="categbar">
		{tr}Watched by categories:{/tr}
		{section name=i loop=$watching_categories}
			{assign var=thiswatchingcateg value=$watching_categories[i].categId}
			{button href="tiki-browse_categories.php?parentId=$thiswatchingcateg" _text=$watching_categories[i].name|escape}
			&nbsp;
		{/section}
	</div>
	{/if}

	{if count($listcals) >= 1}
		<form class="modal-content" id="filtercal" method="get" action="{$myurl}" name="f" style="display:none;">
			<div class="modal-header caltitle">{tr}Group Calendars{/tr}</div>
			<div class="modal-body">
				<div class="caltoggle">
					{select_all checkbox_names='calIds[]' label="{tr}Check / Uncheck All{/tr}"}
				</div>
				{foreach item=k from=$listcals}
					<div class="calcheckbox">
						<input type="checkbox" name="calIds[]" value="{$k|escape}" id="groupcal_{$k}" {if $thiscal.$k}checked="checked"{/if}>
						<label for="groupcal_{$k}" class="calId{$k}">{$infocals.$k.name|escape} (id #{$k})</label>
					</div>
				{/foreach}
				<div class="calinput">
					<input type="hidden" name="todate" value="{$focusdate}">
					<input type="submit" class="btn btn-primary btn-sm" name="refresh" value="{tr}Refresh{/tr}">
				</div>
			</div>
		</form>
	{/if}

	{if $tiki_p_view_events eq 'y'}
		<form id="exportcal" class="modal-content" method="post" action="{$exportUrl}" name="f" style="display:none;">
			<input type="hidden" name="export" value="y">
			<div class="caltitle">{tr}Export calendars{/tr}</div>
			<div class="caltoggle">
				{select_all checkbox_names='calendarIds[]' label="{tr}Check / Uncheck All{/tr}"}
			</div>
			{foreach item=k from=$listcals}
				<div class="calcheckbox">
					<input type="checkbox" name="calendarIds[]" value="{$k|escape}" id="groupcal_{$k}" {if $thiscal.$k}checked="checked"{/if}>
					<label for="groupcal_{$k}" class="calId{$k}">{$infocals.$k.name|escape}</label>
				</div>
			{/foreach}
			<div class="calcheckbox">
				<a href="{$iCalAdvParamsUrl}">{tr}advanced parameters{/tr}</a>
			</div>
			<div class="calinput">
				<input type="submit" class="btn btn-primary btn-sm" name="ical" value="{tr}Export as iCal{/tr}">
				<input type="submit" class="btn btn-primary btn-sm" name="csv" value="{tr}Export as CSV{/tr}">
			</div>
		</form>
	{/if}

	{if $prefs.display_12hr_clock eq 'y'}
		{assign var="timeFormat" value=true}
	{else}
		{assign var="timeFormat" value=false}
	{/if}
	{jq}
		var year = {{$viewyear}};
		var calendarEl = document.getElementById('calendar');
		var calendar = new FullCalendar.Calendar(calendarEl, {
			themeSystem: 'bootstrap',
			eventTimeFormat: {
			  hour: 'numeric',
			  minute: '2-digit',
			  meridiem: '{{$timeFormat}}',
			  hour12: '{{$timeFormat}}'
			},
			timeZone: '{{$prefs.display_timezone}}',
			locale: '{{$prefs.language}}',
			headerToolbar: {
				left: 'prev,next today',
				center: 'title',
				right: 'year,semester,quarter,dayGridMonth,timeGridWeek,timeGridDay'
			},
			editable: true,
			events: 'tiki-calendar_json.php',
			slotMinTime: '{{$minHourOfDay}}',
			slotMaxTime: '{{$maxHourOfDay}}',
			buttonText: {
				today: "{tr}today{/tr}",
				year: "{tr}year{/tr}",
				semester: "{tr}semester{/tr}",
				quarter: "{tr}quarter{/tr}",
				month: "{tr}month{/tr}",
				week: "{tr}week{/tr}",
				day: "{tr}day{/tr}"
			},
			allDayText: '{tr}all-day{/tr}',
			firstDay: {{$firstDayofWeek}},
			slotDuration: '00:{{if $prefs.calendar_timespan|count_characters == 1}}0{{/if}}{{$prefs.calendar_timespan}}',
			initialView: {{if $prefs.calendar_view_mode === 'week'}}'timeGridWeek'{{elseif $prefs.calendar_view_mode === 'day'}}'timeGridDay'{{elseif $prefs.calendar_view_mode === 'month'}}'dayGridMonth'{{else}}'{{$prefs.calendar_view_mode}}'{{/if}},
			views: {
				quarter: {
					type: 'dayGrid',
					duration: { months: 3 },
					buttonText: 'quarter',
					dayCellContent: function(dayCell) {
						return moment(dayCell.date).format('M/D');
					},
					visibleRange: function(currentDate) {
						return {
							start: moment(currentDate).startOf('month').toDate(),
							end: moment(currentDate).add('2', 'months').endOf('month').toDate()
						};
					}
				},
				semester: {
					type: 'dayGrid',
					duration: { months: 6 },
					buttonText: 'semester',
					dayCellContent: function(dayCell) {
						return moment(dayCell.date).format('M/D');
					},
					visibleRange: function(currentDate) {
						return {
							start: moment(currentDate).startOf('month').toDate(),
							end: moment(currentDate).add('5', 'months').endOf('month').toDate()
						};
					}
				},
				year: {
					type: 'dayGrid',
					buttonText: '{tr}year{/tr}',
					dayCellContent: function($x) {
						return moment($x.date).format('M/D');
					},
					visibleRange: function(currentDate) {
						return {
							start: moment(currentDate).startOf('year').toDate(),
							end: moment(currentDate).startOf('year').add('11', 'months').endOf('month').toDate()
						};
					}
				}
			},
			eventDidMount: function(arg) {
				var event = arg.event;
				var element = $(arg.el);
				var dayGrid = $('.fc-daygrid-event').length;
				if (dayGrid > 0) {
					var backgroundColor = event._def.ui.backgroundColor;
					var textColor = event._def.ui.textColor;
					var eventDotElement = element.children('.fc-daygrid-event-dot');
					var styleDot = getComputedStyle(eventDotElement[0]);
					var defaultBackgroundColor = String(styleDot.border).match(/(rgb.{14})/)[0];
					var titleElement = element.children('.fc-event-title');

					var styleElement = getComputedStyle(titleElement[0]);
					var defaultTextColor = styleElement.color;
					if (backgroundColor == '#') {
						backgroundColor = defaultBackgroundColor
					}
					if (textColor == '#') {
						textColor = defaultTextColor;
					}
					$(element).parent('.fc-daygrid-event-harness').attr('style', 'background-color: ' + backgroundColor + '; border: 1px solid ' + textColor);
					$(element).children('.fc-event-time').attr('style', 'color: ' + textColor);
					$(element).children('.fc-event-title').attr('style', 'color: ' + textColor);
					eventDotElement.attr('style', 'display:none');
				}
				element.attr('title', event.title);
				element.data('content', event.extendedProps.description);
				element.popover({ trigger: 'hover', html: true, 'container': 'body', placement: 'bottom'});
			},
			eventClick: function(info) {
				info.jsEvent.preventDefault();
				var $this = $(info.el).tikiModal(" ");
				var event = info.event;
				if (event.url) {
					$.ajax({
						dataType: 'html',
						url: event.url + '&fullcalendar=y&isModal=1',
						success: function(data){
							var $dialog = $('#calendar_dialog').remove()
							$('#calendar_dialog_content', $dialog).html(data);
							$('#calendar_dialog h1, #calendar_dialog .navbar', $dialog ).remove();
							$('#calendar_dialog .modal-title', $dialog ).html();
							$dialog.appendTo('body').modal({backdrop: "static"});
							$this.tikiModal();
						}
					});
				}
			},
			dateClick: function(info) {
				$.ajax({
					dataType: 'html',
					url: 'tiki-calendar_edit_item.php?fullcalendar=y&todate=' + info.date.toUnix() + '&tzoffset=' + (new Date()).getTimezoneOffset() + '&isModal=1',
					success: function(data) {
						var $dialog = $('#calendar_dialog').remove();
						$('#calendar_dialog_content', $dialog ).html(data);
						$('#calendar_dialog h1, #calendar_dialog .navbar', $dialog ).remove();
						$('#calendar_dialog .modal-title', $dialog ).html();
						$dialog.appendTo('body').modal({backdrop: "static"});
					}
				});
			},
			eventResize: function(info) {
				$.post($.service('calendar', 'resize'), {
					calitemId: info.event.id,
					delta: info.delta
				});
			},
			eventDrop: function(info) {
				$.post($.service('calendar', 'move'), {
					calitemId: info.event.id,
					delta: info.delta
				});
			},
			height: 'auto'
		});
		calendar.render();
		addFullCalendarPrint('#calendar', '#calendar-pdf-btn', calendar);
	{/jq}
	{if $pdf_export eq 'y' and $pdf_warning eq 'n'}
		<a id="calendar-pdf-btn"  href="#" style="text-align: right; display: none">{icon name='pdf'} {tr}Export as PDF{/tr}</a>
	{/if}
	<div id="test"></div>
	<style type='text/css'>
		/* Fix pb with DatePicker */
		.ui-datepicker {
			z-index:9999 !important;
		}
		.fc .fc-scrollgrid, .fc .fc-scrollgrid table,
		.fc .fc-daygrid-body {
			width: 100% !important;
		}
		.fc-daygrid-event-harness {
			border-radius: 4px;
			margin: 0px 3px 0px;
		}
		.fc-event {
			display: block;
			white-space: break-spaces;
		}
		.fc-daygrid-day-events .fc-event-time {
			color: #ffffff;
			font-weight: bold;
		}
		.fc-daygrid-day-events .fc-event-title {
			color: #ffffff;
			font-weight: normal;
		}
		.fc-timegrid-event .fc-event-time {
			font-weight: bold;
		}
		.fc-timegrid-event .fc-event-title {
			font-weight: normal;
		}
		@media only screen and (max-width: 767px) {
			.fc-header-toolbar {
				display: block !important;
			}
			.fc-header-toolbar .fc-toolbar-chunk .btn-group .btn {
				padding: 0.375rem 0.1rem;
			}
		}
		@media print {
			.fc .fc-daygrid-day-top {
				border-bottom: 1px solid #dee2e6;
			}
		}
	</style>
	<div id='calendar'></div>

	<!--<div id='calendar_dialog'></div>-->

	<div id="calendar_dialog" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" id="calendar_dialog_content">
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	<p>&nbsp;</p>
</div>
{if $prefs.feature_jscalendar eq 'y' and $prefs.javascript_enabled eq 'y'}
	{js_insert_icon type="jscalendar"}
{/if}
