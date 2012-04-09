def print_graph
	graph = "var bAutoRefresh = true;
    $(function () {
            // a null signifies separate line segments
            var points = #{@@data};

            
            //id of the html <div>         
            var placeholder = $('#placeholder');

            var data = [{
                color: 3,
                data: points,
                lines: {show: true, fill: true}
            }]

            //Plot options      
            var options = {
                series: { lines: { show: true }, points: { show: true }, shadowSize: 0 },
                xaxis: {mode: 'time'},
                yaxis: {min: 0},
                selection: { mode: 'x' }
            }

            placeholder.bind('plotselected', function (event, ranges) {
                $('#selection').text(ranges.xaxis.from.toFixed(1) + ' to ' + ranges.xaxis.to.toFixed(1));
                    plot = $.plot(placeholder, data, $.extend(true, {}, options, { xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to }}));
            });

            placeholder.bind('plotunselected', function (event) {
                $('#selection').text('');
            });

            $.plot(placeholder,data, options);
        });"
	return graph
end

def print_refresh
    refresh = "var bAutoRefresh = true;
var auto_refresh = setInterval(
function()
{
    if (bAutoRefresh) {
        $('#content').unload().load('/graph');
    };
}, #{@@ping_retry*1000});



$(document).ready(function(){ 
    $('#content').load('/graph');

    $('#content').mousedown(function() {
        bAutoRefresh = false;
    });

     $('#reset).click(function() {
        $('#content').unload().load('/graph');
    });
});"
return refresh
end