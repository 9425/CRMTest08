<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

    /*

        需求：

            根据交易表中的不同的阶段的数量进行一个统计，最终形成一个漏斗图（倒三角）

            将统计出来的阶段的数量比较多的，往上面排列
            将统计出来的阶段的数量比较少的，往下面排列

            例如：
                01资质审查  10条
                02需求分析  85条
                03价值建议  3条
                ...
                07成交      100

            sql:
                按照阶段进行分组

                resultType="map"

                select

                stage,count(*)

                from tbl_tran

                group by stage




     */

%>
<html>
<head>
    <%--<base href="<%=basePath%>">--%>
    <title>mytitle</title>
    <script type="text/javascript" src="../../../ECharts/echarts.min.js"></script>
    <script type="text/javascript" src="../../../jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript">
        $(function () {
            //页面加载完毕之后，绘制统计图
            /*$("#saveBtn").click(function () {
                alert(123)
            })
            alert(123)*///这部分是测试函数是否生效的页面
            getCharts();


            /*//第一次测试
            var myChart = echarts.init(document.getElementById('main'));
            // 指定图表的配置项和数据
            var option = {
                title: {
                    text: 'ECharts 入门示例'
                },
                tooltip: {},
                legend: {
                    data:['销量']
                },
                xAxis: {
                    data: ["衬衫","羊毛衫","雪纺衫","裤子","高跟鞋","袜子"]
                },
                yAxis: {},
                series: [{
                    name: '销量',
                    type: 'bar',
                    data: [5, 20, 36, 10, 10, 20]
                }]
            };

            // 使用刚指定的配置项和数据显示图表。
            myChart.setOption(option);*/


          /* //第二次测试
            option = {
                title: {
                    text: '漏斗图',
                    subtext: '纯属虚构'
                },
                tooltip: {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c}%"
                },
                toolbox: {
                    feature: {
                        dataView: {readOnly: false},
                        restore: {},
                        saveAsImage: {}
                    }
                },
                legend: {
                    data: ['展现','点击','访问','咨询','订单']
                },

                series: [
                    {
                        name:'漏斗图',
                        type:'funnel',
                        left: '10%',
                        top: 60,
                        //x2: 80,
                        bottom: 60,
                        width: '80%',
                        // height: {totalHeight} - y - y2,
                        min: 0,
                        max: 100,
                        minSize: '0%',
                        maxSize: '100%',
                        sort: 'descending',
                        gap: 2,
                        label: {
                            show: true,
                            position: 'inside'
                        },
                        labelLine: {
                            length: 10,
                            lineStyle: {
                                width: 1,
                                type: 'solid'
                            }
                        },
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1
                        },
                        emphasis: {
                            label: {
                                fontSize: 20
                            }
                        },
                        data: [
                            {value: 60, name: '访问'},
                            {value: 40, name: '咨询'},
                            {value: 20, name: '订单'},
                            {value: 80, name: '点击'},
                            {value: 100, name: '展现'}
                        ]
                    }
                ]
            };*/




        });


        function getCharts() {
            $.ajax({
                url:"getCharts.do",
                type:"get",
                dataType:"json",
                success:function (data) {
                    /*

                        data
                            {"total":100,"dataList":[{value: 60, name: '01资质审查'},{value: 114, name: '02需求分析'},{...}]}

                     */

                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    //我们要画的图
                    var option = {
                        title: {
                            text: '交易漏斗图',
                            subtext: '统计交易阶段数量的漏斗图'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}%"
                        },
                        toolbox: {
                            feature: {
                                dataView: {readOnly: false},
                                restore: {},
                                saveAsImage: {}
                            }
                        },

                        series: [
                            {
                                name:'交易漏斗图',
                                type:'funnel',
                                left: '10%',
                                top: 60,
                                //x2: 80,
                                bottom: 60,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: data.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data.dataList
                                /*
                                    [
                                        {value: 60, name: '01资质审查'},
                                        {value: 114, name: '02需求分析'},
                                        {value: 220, name: '03价值建议'},
                                        {value: 80, name: '06谈判复审'},
                                        {value: 100, name: '07成交'}
                                    ]
                                */
                            }
                        ]
                    };

                    myChart.setOption(option);

                }
            })
        }
    </script>
</head>
<body>
<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
<div id="main" style="width: 600px;height:400px;">666</div>
<%--<div class="modal-footer">
    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
    <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
</div>--%>
</body>
</html>
