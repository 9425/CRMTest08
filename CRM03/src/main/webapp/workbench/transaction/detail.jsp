<%@ page import="java.util.List" %>
<%@ page import="crm.setting.domain.DicValue" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
    //准备字典类型为stage的字典值列表
    List<DicValue> dvList = (List<DicValue>)application.getAttribute("stage");

    //准备阶段和可能性之间的对应关系
    Map<String,String> pMap = (Map<String,String>)application.getAttribute("pMap");

    //根据pMap准备pMap中的key集合
    Set<String> set = pMap.keySet();

    //准备：前面正常阶段和后面丢失阶段的分界点下标
    //为什么要准备前面正常阶段和后面丢失阶段的分界点下标？
    int point = 0;
    for(int i=0;i<dvList.size();i++){
        //取得每一个字典值
        DicValue dv = dvList.get(i);

        //从dv中取得value
        String stage = dv.getValue();
        //根据stage取得possibility
        String possibility = pMap.get(stage);

        //如果可能性为0，说明找到了前面正常阶段和后面丢失阶段的分界点
        if("0".equals(possibility)){

            point = i;

            break;

        }


    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="../../jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="../../jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="../../jquery/bs_pagination/en.js"></script>

    <style type="text/css">
        .mystage{
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }
        .closingDate{
            font-size : 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function(){
            $("#remark").focus(function(){
                if(cancelAndSaveBtnDefault){
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height","130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function(){
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height","90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function(){
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function(){
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function(){
                $(this).children("span").css("color","red");
            });

            $(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });


            $("#remarkBody").on("mouseover",".remarkDiv",function () {
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout",".remarkDiv",function () {
                $(this).children("div").children("div").hide();
            })

            //阶段提示框
            $(".mystage").popover({
                trigger:'manual',
                placement : 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });

            //为备注保存按钮绑定事件，执行备注添加操作
            $("#saveRemarkBtn").click(function () {
                //alert(123)
                $.ajax({
                    url:"saveRemark.do",
                    data:{
                        "noteContent":$.trim($("#remark").val()),
                        "tranId":"${tran.id}"
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        /*
                        * data:
                        *     {"success":true/false,"ar":{备注}}
                        * */
                        if (data.success){
                            //添加成功
                            //textarea文本域信息清空
                            $("#remark").val("");
                            //在textarea文本域上方新增一个div
                            /*
                            * 新增的div为从后台返回的ar中进行取值然后增加
                            * */
                            var html="";
                            html += '<div id="'+data.tr.id+'" class="remarkDiv" style="height: 60px;">';
                            html += '<img title="'+data.tr.createBy+'" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id="e'+data.tr.id+'">'+data.tr.noteContent+'</h5>';
                            html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.customerId}-${tran.name}</b> <small style="color: gray;"> '+(data.tr.createTime)+' 由'+(data.tr.createBy)+'</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.tr.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.tr.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                            $("#remarkDiv").before(html);
                            showRemarkList();
                        }else {
                            alert("删除失败...")
                        }
                    }
                })
            })

            //为更新备注按钮绑定事件
            $("#updateRemarkBtn").click(function () {
                //$("#editRemarkModal").modal("show");此处为无效代码
                var id=$("#remarkId").val();
                $.ajax({
                    url:"updateRemark.do",
                    data:{
                        "id":id,
                        "noteContent":$.trim($("#noteContent").val())
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        /*
                        * data:
                        *      {"success":true/false}
                        * */
                        //alert(data.cr.noteContent)
                        if (data.success){
                            //修改备注成功，更新div中相应的信息，需要更新的内容有noteContent,editTime,editBy
                            //alert(data.cr.noteContent)
                            //alert(data.cr.editTime+"由"+data.cr.editBy)

                            $("#e"+id).html(data.tr.noteContent);
                            $("#s"+id).html(data.tr.editTime+"由"+data.tr.editBy);
                            //更新内容之后，关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                        } else {
                            alert("修改备注失败...")
                        }
                    }
                })
            })


            showRemarkList();
            showTranHistory();
        });

        function showRemarkList() {
            $.ajax({
                url:"getRemarkListByTranId.do",
                data:{
                    "TranId":"${tran.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    //此处的data为我们需要从后端获取的数据
                    /*
                    * data:
                    *     [{备注1}{备注2}{备注3}...]
                    *     此处的n.id为从后端传递过来的id值进行赋值
                    * */
                    var html="";
                    $.each(data,function (i,n) {
                        html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
                        html+='<img title="'+n.createBy+'" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html+='<div style="position: relative; top: -40px; left: 40px;" >';
                        html+='<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
                        html+='<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.customerId}-${tran.name}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+'由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
                        html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        /*此处的id在进行前端页面展示的时候就已经进行了赋值到remarkId中，remarkId赋值到隐藏域中进行保存*/
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html+='&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html+='</div>';
                        html+='</div>';
                        html+='</div>';

                        /*
                        *
                        * <div class="remarkDiv" style="height: 60px;">
                          <img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">
                          <div style="position: relative; top: -40px; left: 40px;" >
                          <h5>哎呦！</h5>
                          <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
                          <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                          <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                          &nbsp;&nbsp;&nbsp;&nbsp;
                          <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                          </div>
                          </div>
                          </div>

                        * */

                    })
                    $("#remarkDiv").before(html);
                }
            })
        }

        function editRemark(id) {
            //alert(123)
            //alert($("#remarkId").val(id))
            //alert($("#e"+id).html())
            //将模态窗口中，隐藏域的id进行赋值
            //此处的id为从前端传递过来的值
            //在操作的时候，将此处的id进行传递，需要传递的id值存放在修改备注模态窗口的隐藏域中
            $("#remarkId").val(id);
            //找到指定的存放备注信息的h5标签
            var noteContent=$("#e"+id).html();
            //将h5中展现出来的信息，赋予到修改操作模态窗口中的文本域中
            $("#noteContent").val(noteContent);
            //以上信息处理完毕之后，将修改备注的模态窗口打开
            $("#editRemarkModal").modal("show");
        }

        function deleteRemark(id) {
            //$("#editRemarkModal").modal("show");
            //alert(123)
            $.ajax({
                url:"deleteRemark.do",
                data:{
                    "id":id
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    /*
                    * data为从后端传递过来前端所需的数据
                    * {"success":true/false}
                    * */
                    if (data.success){
                        //删除备注成功
                        /*
                        * 前面我们添加html内容的方式为使用before的方法，这种方法在删除备注之后，如果此时使用showRemarkList()进行刷新页面
                        * 是无效的，我们要是用找到需要删除记录的div,然后将div移除
                        * */
                        //showRemarkList();
                        $("#"+id).remove();
                    } else {
                        alert("删除备注失败...")
                    }
                }
            })
        }

        function showTranHistory() {
            //alert(123)
            $.ajax({
                url:"showTranHistoryListByTranId.do",
                data:{
                    "tranId":"${tran.id}",
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    //此时的data直接返回一个tranHitory数组，将数组进行遍历即可得到展示
                    var html="";
                    $.each(data,function (i,n) {
                        /*<tr>
                        <td>资质审查</td>
                        <td>5,000</td>
                        <td>10</td>
                        <td>2017-02-07</td>
                        <td>2016-10-10 10:10:10</td>
                        <td>zhangsan</td>
                        </tr>*/
                        html+='<tr>'
                        html+='<td>'+n.stage+'</td>'
                        html+='<td>'+n.money+'</td>'
                        html+='<td>'+n.possibility+'</td>'
                        html+='<td>'+n.expectedDate+'</td>'
                        html+='<td>'+n.createTime+'</td>'
                        html+='<td>'+n.createBy+'</td>'
                        html+='</tr>'

                    })
                    $("#tranHistoryBody").html(html);
                }
            })
        }

        function changeStage(stage,i) {
            /*alert(stage);
            alert(i);*/
            $.ajax({
                url:"changeStage.do",
                data:{
                    "id" : "${tran.id}",
                    "stage" : stage,
                    "money" : "${tran.money}",		//生成交易历史用
                    "expectedDate" : "${tran.expectedDate}"	//生成交易历史用
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    //修改成功之后，需要将所展示的详情信息页进行刷新，所赐此时需要进行传回一个tran对象用于刷新页面
                    /*

					data
						{"success":true/false,"t":{交易}}

				 */
                    if (data.success){
                        //改变阶段成功后
                        //(1)需要在详细信息页上局部刷新 刷新阶段，可能性，修改人，修改时间
                        $("#stage").html(data.t.stage);
                        $("#possibility").html(data.t.possibility);
                        $("#editBy").html(data.t.editBy);
                        $("#editTime").html(data.t.editTime);

                        //改变阶段成功后
                        //(2)将所有的阶段图标重新判断，重新赋予样式及颜色
                        showTranHistory();
                        changeIcon(stage,i);

                    } else {
                        alert("改变阶段失败");
                    }

                }
            })
        }

        function changeIcon(stage,index1) {
            //当前阶段
            var currentStage = stage;

            //当前阶段可能性
            var currentPossibility = $("#possibility").html();

            //当前阶段的下标
            var index = index1;

            //前面正常阶段和后面丢失阶段的分界点下标
            var point = "<%=point%>";

            /*alert("当前阶段"+currentStage);
            alert("当前阶段可能性"+currentPossibility);
            alert("当前阶段的下标"+index);
            alert("前面正常阶段和后面丢失阶段的分界点下标"+point);*/

            //如果当前阶段的可能性为0 前7个一定是黑圈，后两个一个是红叉，一个是黑叉
            //如果当前阶段的可能性为0 前7个一定是黑圈，后两个一个是红叉，一个是黑叉
            if(currentPossibility=="0"){

                //遍历前7个
                for(var i=0;i<point;i++){

                    //黑圈------------------------------
                    //移除掉原有的样式
                    $("#"+i).removeClass();
                    //添加新样式
                    $("#"+i).addClass("glyphicon glyphicon-record mystage");
                    //为新样式赋予颜色
                    $("#"+i).css("color","#000000");

                }

                //遍历后两个
                for(var i=point;i<<%=dvList.size()%>;i++){

                    //如果是当前阶段
                    if(i==index){

                        //红叉-----------------------------
                        $("#"+i).removeClass();
                        $("#"+i).addClass("glyphicon glyphicon-remove mystage");
                        $("#"+i).css("color","#FF0000");

                        //如果不是当前阶段
                    }else{

                        //黑叉----------------------------
                        $("#"+i).removeClass();
                        $("#"+i).addClass("glyphicon glyphicon-remove mystage");
                        $("#"+i).css("color","#000000");

                    }


                }



                //如果当前阶段的可能性不为0 前7个绿圈，绿色标记，黑圈，后两个一定是黑叉
            }else{

                //遍历前7个 绿圈，绿色标记，黑圈
                for(var i=0;i<point;i++){

                    //如果是当前阶段
                    if(i==index){

                        //绿色标记--------------------------
                        $("#"+i).removeClass();
                        $("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
                        $("#"+i).css("color","#90F790");

                        //如果小于当前阶段
                    }else if(i<index){

                        //绿圈------------------------------
                        $("#"+i).removeClass();
                        $("#"+i).addClass("glyphicon glyphicon-ok-circle mystage");
                        $("#"+i).css("color","#90F790");

                        //如果大于当前阶段
                    }else{

                        //黑圈-------------------------------
                        $("#"+i).removeClass();
                        $("#"+i).addClass("glyphicon glyphicon-record mystage");
                        $("#"+i).css("color","#000000");

                    }


                }

                //遍历后两个
                for(var i=point;i<<%=dvList.size()%>;i++){

                    //黑叉----------------------------
                    $("#"+i).removeClass();
                    $("#"+i).addClass("glyphicon glyphicon-remove mystage");
                    $("#"+i).css("color","#000000");
                }

            }


        }


    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新456</button>
            </div>
        </div>
    </div>
</div>


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${tran.customerId}-${tran.name}<small>￥${tran.money}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <%
        //对于此处的编写分为两个阶段：首先判断当前的可能性是否为0，如果为0，那么直接将通过stagelist将前七个可能性不为0的阶段赋值为黑圈，然后判断
        //可能性为0的阶段是否和当前阶段相等，如果等于当前阶段，那么此时将其改为红×，反之改为黑×

        //如果当前阶段的可能性不为0，那次此时应该将当前阶段所在集合中的下标进行获取，通过下标比对的方式，我们判断将给与什么样的图标
        //如果可能性为0，直接给出黑×，如果可能性不为0，那么此时将进行当前阶段的下标进行比对，如果相等，直接标出绿色符号，反之将给出绿圈



        //准备当前阶段
        Tran t = (Tran)request.getAttribute("tran");
        String currentStage = t.getStage();
        //准备当前阶段的可能性
        String currentPossibility = pMap.get(currentStage);

        //判断当前阶段
        //如果当前阶段的可能性为0 前7个一定是黑圈，后两个一个是红叉，一个是黑叉

        //后面需要判断当前阶段是否为
        if("0".equals(currentPossibility)){

            for(int i=0;i<dvList.size();i++){

                //取得每一个遍历出来的阶段，根据每一个遍历出来的阶段取其可能性
                //dvList是分不同类存放的dicValue,对于所取出的每一个对象就是dicValue

                DicValue dv = dvList.get(i);//divList是list集合

                //dicValue的value值就是每一个dicValue的交易阶段
                String listStage = dv.getValue();
                String listPossibility = pMap.get(listStage);
                //根据不同的交易阶段取出相对应的可能性
                //如果遍历出来的阶段的可能性为0，说明是后两个，一个是红叉，一个是黑叉
                if("0".equals(listPossibility)){

                    //如果遍历出来的可能性为0，那么此时找到了分界点
                    //如果是当前阶段
                    if(listStage.equals(currentStage)){

                        //判断此分界点是否为当前阶段
                        //红叉-----------------------------------------
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #FF0000;"></span>
    -----------
    <%
        //如果不是当前的阶段
    }else{

        //黑叉-----------------------------------------
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #000000;"></span>
    -----------
    <%
        }


        //如果遍历出来的阶段的可能性不为0，说明是前7个，一定是黑圈
    }else{

        //黑圈-----------------------------------------
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-record mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #000000;"></span>
    -----------
    <%
            }

        }

//判断possibility为0的括号
        //如果当前阶段的可能性不为0 前7个有可能性是绿圈，绿色标记，黑圈，后两个一定是黑叉
    }else{

        //准备当前阶段的下标
        int index = 0;
        for(int i=0;i<dvList.size();i++){

            DicValue dv = dvList.get(i);
            String stage = dv.getValue();
            //String possibility = pMap.get(stage);
            //如果遍历出来的阶段是当前阶段
            if(stage.equals(currentStage)){
                index = i;
                break;
            }
        }

        for(int i=0;i<dvList.size();i++) {

            //取得每一个遍历出来的阶段，根据每一个遍历出来的阶段取其可能性
            DicValue dv = dvList.get(i);
            String listStage = dv.getValue();
            String listPossibility = pMap.get(listStage);

            //如果遍历出来的阶段的可能性为0，说明是后两个阶段
            if("0".equals(listPossibility)){

                //黑叉--------------------------------------------
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #000000;"></span>
    -----------
    <%

        //如果遍历出来的阶段的可能性不为0 说明是前7个阶段 绿圈，绿色标记，黑圈
    }else{

        //如果是当前阶段
        if(i==index){

            //绿色标记-----------------------------------
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-map-marker mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
    -----------
    <%

        //如果小于当前阶段
    }else if(i<index){

        //绿圈----------------------------------------
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-ok-circle mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
    -----------
    <%

        //如果大于当前阶段
    }else{

        //黑圈----------------------------------------
    %>
    <span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-record mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #000000;"></span>
    -----------
    <%

                    }


                }

            }


        }


    %>


    <%--<span id="<%=i%>" onclick="changeStage('<%=listStage%>','<%=i%>')"
          class="glyphicon glyphicon-record mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dv.getText()%>" style="color: #000000;"></span>
    -------------%>



    <%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
    -----------
    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
    -----------
    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
    -----------
    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>--%>
    <%---------------%>
    <span class="closingDate">${tran.expectedDate}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="owner">${tran.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="money">${tran.money}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="name">${tran.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="expectedDate">${tran.expectedDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="customerId">${tran.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${tran.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="type">${tran.type}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${tran.possibility}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="source">${tran.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="activityId">${tran.activityId}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="contactsId">${tran.contactsId}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createBy">${tran.createBy}&nbsp;&nbsp;</b><small id="createTime" style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${tran.editBy}&nbsp;&nbsp;</b><small id="editTime" style="font-size: 10px; color: gray;">${tran.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b id="description">
                ${tran.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b id="contactSummary">
                ${tran.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="nextContactTime">${tran.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 100px; left: 40px;" id="remarkBody">
    <div class="page-header">
        <h4>备注123</h4>
    </div>

    <!-- 备注1 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>哎呦！</h5>
            <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <!-- 备注2 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>呵呵！</h5>
            <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody id="tranHistoryBody">
                <%--<tr>
                    <td>资质审查</td>
                    <td>5,000</td>
                    <td>10</td>
                    <td>2017-02-07</td>
                    <td>2016-10-10 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>需求分析</td>
                    <td>5,000</td>
                    <td>20</td>
                    <td>2017-02-07</td>
                    <td>2016-10-20 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>谈判/复审</td>
                    <td>5,000</td>
                    <td>90</td>
                    <td>2017-02-07</td>
                    <td>2017-02-09 10:10:10</td>
                    <td>zhangsan</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>