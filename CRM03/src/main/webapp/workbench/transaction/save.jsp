<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

    Map<String,String> pMap = (Map<String,String>)application.getAttribute("pMap");

    Set<String> set = pMap.keySet();

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="../../jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="../../jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">
        /*
        * 此处为编写java脚本，将pMap集合中的数据转换为json数据
        * */
        var json = {

            <%

                for(String key:set){

                    String value = pMap.get(key);
            %>

            "<%=key%>" : <%=value%>,   //此处根据java脚本的特殊性质，不用编写判断是否为最后一个数据来添加“，”

            <%
                }

            %>

        };

        //object Object
        //alert(json);

        /*

            关于阶段和可能性
                是一种一一对应的关系
                一个阶段对应一个可能性
                我们现在可以将阶段和可能性想象成是一种键值对之间的对应关系
                以阶段为key，通过选中的阶段，触发可能性value

                stage               possibility
                key					value
                01资质审查			10
                02需求分析			25
                03价值建议			40
                ...
                ...
                07成交				100
                08..				0
                09..				0

                对于以上的数据，通过观察得到结论
                （1）数据量不是很大
                （2）这是一种键值对的对应关系

                如果同时满足以上两种结论，那么我们将这样的数据保存到数据库表中就没有什么意义了
                如果遇到这种情况，我们需要用到properties属性文件来进行保存
                stage2Possibility.properties
                01资质审查=10
                02需求分析=20
                ....


                stage2Possibility.properties这个文件表示的是阶段和键值对之间的对应关系
                将来，我们通过stage，以及对应关系，来取得可能性这个值
                这种需求在交易模块中需要大量的使用到

                所以我们就需要将该文件解析在服务器缓存中
                application.setAttribute(stage2Possibility.properties文件内容)


         */



        $(function () {

            //自动补全控件
            $("#create-customerName").typeahead({
                source: function (query, process) {
                    $.get(
                        "getCustomerName.do",
                        { "name" : query },
                        function (data) {
                            //alert(data);

                            /*

                                data
                                    [{客户名称1},{2},{3}]

                             */

                            process(data);
                        },
                        "json"
                    );
                },
                delay: 300
            });


            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $(".time1").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });


            //搜索市场活动源
            $("#aname").keydown(function (event) {
                if (event.keyCode==13){
                    $.ajax({
                        url:"getActivityListByNameAndNotByClueId.do",
                        data:{
                            "aname" : $.trim($("#aname").val()),
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data) {
                            var html = "";
                            $.each(data,function (i,n) {
                                html+='<tr>'
                                html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';//此处的id值为市场活动的id值
                                html+='<td id="'+n.id+'">'+n.name+'</td>'
                                html+='<td>'+n.startDate+'</td>'
                                html+='<td>'+n.endDate+'</td>'
                                html+='<td>'+n.owner+'</td>'
                                html+='</tr>'
                            })
                            $("#activitySearchBody").html(html);
                        }
                    })
                    return false;
                }
            })

            //为提交（市场活动）按钮绑定事件，填充市场活动源（填写两项信息 名字+id）
            $("#submitActivityBtn").click(function () {
                var $xz = $("input[name=xz]:checked");//这里已经确定了，一次只能选中一个市场
                //alert($xz.length)
                if ($xz.length==0){
                    alert("请选择市场活动源")
                }else if ($xz.length>1){
                    alert("每次只能选中一个市场活动源，请重新选择")
                } else {
                    if (confirm("是否确定所选市场活动作为市场活动源")){
                        //取得选中市场活动的id
                        var id = $xz.val();

                        //取得选中市场活动的名字
                        var name = $("#"+id).html();

                        //将以上两项信息填写到 交易表单的市场活动源中
                        //alert(id)
                        //alert(name)
                        $("#create-activityId").val(id);
                        $("#create-activitySrc").val(name);

                        //将模态窗口关闭掉
                        $("#findMarketActivity").modal("hide");
                    }
                }
            })

            //搜索联系人名称
            $("#aname2").keydown(function (event) {
                if (event.keyCode==13){
                    $.ajax({
                        url:"getContactsListByName.do",
                        data:{
                            "aname" : $.trim($("#aname2").val()),
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data) {
                            var html = "";
                            $.each(data,function (i,n) {
                                html+='<tr>'
                                html += '<td><input type="checkbox" name="yz" value="'+n.id+'"/></td>';//此处的id值为联系人的id值
                                html+='<td id="'+n.id+'">'+n.fullname+'</td>'
                                html+='<td>'+n.email+'</td>'
                                html+='<td>'+n.mphone+'</td>'
                                html+='</tr>'
                            })
                            $("#contactsSearchBody").html(html);
                        }
                    })
                    return false;
                }
            })

            //为提交（联系人）按钮绑定事件，填充市场活动源（填写两项信息 名字+id）
            $("#submitActivityBtn2").click(function () {
                var $yz = $("input[name=yz]:checked");//这里已经确定了，一次只能选中一个市场
                //alert($yz.length)
                if ($yz.length==0){
                    alert("请选择市场活动源")
                }else if ($yz.length>1){
                    alert("每次只能选中一个市场活动源，请重新选择")
                } else {
                    if (confirm("是否确定所选市场活动作为市场活动源")){
                        //取得选中市场活动的id
                        var id = $yz.val();

                        //取得选中市场活动的名字
                        var name = $("#"+id).html();

                        //将以上两项信息填写到 交易表单的市场活动源中
                        //alert(id)
                        //alert(name)
                        $("#create-contactsId").val(id);
                        //alert($("#create-contactsId").val())
                        $("#create-contactsName").val(name);

                        //将模态窗口关闭掉
                        $("#findContacts").modal("hide");
                    }
                }
            })

            //为全选的复选框绑定事件，使其能够在被点击时触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked",this.checked);
            })

            $("#activitySearchBody").on("click",$("input[name=xz]"),function () {
                $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
            })

            //为全选的复选框绑定事件，使其能够在被点击时触发全选操作
            $("#qx2").click(function () {
                $("input[name=yz]").prop("checked",this.checked);
            })

            $("#contactsSearchBody").on("click",$("input[name=yz]"),function () {
                $("#qx2").prop("checked",$("input[name=yz]").length==$("input[name=yz]:checked").length)
            })


            //为阶段的下拉框，绑定选中下拉框的事件，根据选中的阶段填写可能性
            $("#create-stage").change(function () {
                //alert(123) 测试change事件是否有用
                //取得选中的阶段
                var stage = $("#create-stage").val();
                //alert(stage) 测试是否能够取到stage值
                /*

                    目标：填写可能性

                    阶段有了stage
                    阶段和可能性之间的对应关系pMap，但是pMap是java语言中的键值对关系（java中的map对象）
                    我们首先得将pMap转换为js中的键值对关系json

                    我们要做的是将pMap
                        pMap.put("01资质审查",10);
                        pMap.put("02需求分析",25);
                        ...

                        转换为

                        var json = {"01资质审查":10,"02需求分析":25...};

                    以上我们已经将json处理好了

                    接下来取可能性

                 */

                //alert(stage);

                /*

                    对于传统固定的json串，我们使用json.key进行取出value值，但是现在json是可变的，我们需要使用json[key]来进行取值

                    我们现在以json.key的形式不能取得value
                    因为现在的stage是一个可变的变量
                    如果是这样的key，那么我们就不能以传统的json.key的形式来取值
                    我们要使用的取值方式为
                    json[key]


                 */
                var possibility = json[stage];
                //alert(possibility);

                //为可能性的文本框赋值
                $("#create-possibility").val(possibility);


            })


            //为保存按钮绑定事件，执行交易添加操作
            $("#saveBtn").click(function () {

                //发出传统请求，提交表单
                $("#tranForm").submit();

            })


        })



        function showActivityListBySearch() {
            /*$("#aname").val("");
            $("#activitySearchBody").html("");*/
            cleanShowActivityListBySearch();
            $("#findMarketActivity").modal("show");
        }

        function cleanShowActivityListBySearch() {
            $("#aname").val("");
            $("#activitySearchBody").html("");
            $("#qx").prop("checked",false);
        }

        function showContactsBySearch() {
            cleanShowActivityListBySearch2();
            $("#findContacts").modal("show");
        }

        function cleanShowActivityListBySearch2() {
            $("#aname2").val("");
            $("#contactsSearchBody").html("");
            $("#qx2").prop("checked",false);
        }
    </script>

</head>
<body>
<%--"clueId" : "${clue.id}"--%>
<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动123</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="aname" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="qx"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activitySearchBody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人111</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="aname2" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="qx2"/></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactsSearchBody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitActivityBtn2">提交</button>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易666</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form action="save.do" method="post" id="tranForm" class="form-horizontal" role="form"  style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionOwner" name="owner">
                <%--<option>zhangsan</option>
                <option>lisi</option>
                <option>wangwu</option>--%>
                    <option></option>
                    <c:forEach items="${uList}" var="u">
                        <option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
                    </c:forEach>
            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney" name="money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName" name="name">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time" id="create-expectedClosingDate" name="expectedDate">
        </div>
    </div>

    <div class="form-group">
        <label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-customerName" name="customerName" placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-stage" name="stage">
                <option></option>
                <%--<option>资质审查</option>
                <option>需求分析</option>
                <option>价值建议</option>
                <option>确定决策者</option>
                <option>提案/报价</option>
                <option>谈判/复审</option>
                <option>成交</option>
                <option>丢失的线索</option>
                <option>因竞争丢失关闭</option>--%>
                <c:forEach items="${stage}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型1</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType" name="type">
                <option></option>
                <%--<option>已有业务</option>
                <option>新业务</option>--%>
                <c:forEach items="${transactionType}" var="t">
                    <option value="${t.value}">${t.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility" name="possibility">
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource" name="source">
                <option></option>
                <%--<option>广告</option>
                <option>推销电话</option>
                <option>员工介绍</option>
                <option>外部介绍</option>
                <option>在线商场</option>
                <option>合作伙伴</option>
                <option>公开媒介</option>
                <option>销售邮件</option>
                <option>合作伙伴研讨会</option>
                <option>内部研讨会</option>
                <option>交易会</option>
                <option>web下载</option>
                <option>web调研</option>
                <option>聊天</option>--%>
                <c:forEach items="${source}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" onclick="showActivityListBySearch()"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activitySrc" placeholder="点击上面搜索" readonly>
            <input type="hidden" id="create-activityId" name="activityId"/>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" onclick="showContactsBySearch()"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-contactsName" placeholder="点击上面搜索" readonly>
            <input type="hidden" id="create-contactsId" name="contactsId"/>
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time1" id="create-nextContactTime" name="nextContactTime">
        </div>
    </div>

</form>
</body>
</html>