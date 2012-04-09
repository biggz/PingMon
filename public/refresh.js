var bAutoRefresh = true;
var auto_refresh = setInterval(
function()
{
	if (bAutoRefresh) {
		$('#content').unload().load('/graph');
	};
}, 20000);



$(document).ready(function(){ 
 	$('#content').load('/graph');
 	jQuery('#content').load('/graph');
 	$("#content").mousedown(function() {
  		bAutoRefresh = false;
	});

	 $("#reset").click(function() {
  		$('#content').unload().load('/graph');
	});
});
