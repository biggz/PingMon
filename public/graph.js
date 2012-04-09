var bAutoRefresh = true;
$(function () {
    var chart;

    $(document).ready(function() {

        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'container',
                type: 'area',
                animation: false,
                zoomType: 'x'
            },
            credits: { enabled: false},
            plotOptions: {
                series: {
                  animation: false,
                  lineWidth: 2,
                  shadow: false,
                  stickyTracking: false,
                },
                area: {
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
                text: '8.8.8.8'
            },
            xAxis: {
                type: 'datetime',
                maxZoom: 60000 , // 3 Minutes
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
                    text: 'Reply (m)'
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
                data: @@data

            }]
        });
    });
})