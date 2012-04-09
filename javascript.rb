def print_graph
	graph = "
var bAutoRefresh = true;    
$(function () {
    var chart;

    $(document).ready(function() {
        //Disable auto refresh on left mouse click on graph
        $('#container').mousedown(function() {
            bAutoRefresh = false;
        });
        //Enable auto refresh on left mouse click on Zoom button
        $('resetZoomButton').mousedown(function() {
            bAutoRefresh = true;
        });

        //Create chart
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'container',
                type: 'areaspline',
                animation: false,
                zoomType: 'x',
                events: {
                    load: function() {
                        // set up the updating of the chart every 5 seconds
                        setInterval(function() {
                            $.getJSON('data.json', function(data) {
                                if (bAutoRefresh){
                                    chart.series[0].setData(data);
                                };
                            });
                        }, 5000);
                    }
                }
            },
            credits: { enabled: false},
            plotOptions: {
                series: {
                  animation: false,
                  lineWidth: 2,
                  shadow: false,
                  stickyTracking: false,
                },
                spline: {
                  marker: {
                    enabled: true,
                    fillColor: '#535353',
                    lineColor: null,
                    lineWidth: 2,
                    radius: 3,
                    states: {
                        hover: {
                            enabled: true
                        }
                    }
                  }
                },
                areaspline: {
                    marker: {
                    enabled: true,
                    fillColor: '#535353',
                    lineColor: null,
                    lineWidth: 2,
                    radius: 3,
                    states: {
                        hover: {
                            enabled: true
                        }
                    }
                  }
                },
            },
            title: {
                text: '#{@@host}'
            },
            xAxis: {
                type: 'datetime',
                maxZoom: 60000 , // 1 Minute
                dateTimeLabelFormats: { // don't display the dummy year
                    second: '%H:%M:%S',
                    minute: '%H:%M',
                    hour: '%H:%M',
                    day: '%e of %b',
                    week: '%e. %b',
                }
            },
            yAxis: {
                title: {
                    text: 'Ping (ms)'
                },
                min: 0
            },
            tooltip: {
                formatter: function() {
                        return '<b>'+ this.y +'ms</b><br/>'+
                        Highcharts.dateFormat('%a %m %b<br/>%H:%M:%S', this.x);
                }
            },
            series: [{
                name: 'Ping (ms)',
                color: '#89A54E',            
                data: #{@@data}

            }]
        });
    });
});"
	return graph
end