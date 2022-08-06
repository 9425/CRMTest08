<%--
  Created by IntelliJ IDEA.
  User: yang hui
  Date: 2021/4/20
  Time: 19:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
jquery中不支持循环，加入此列，使得可以直接将从application域中获取的对象进行循环
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    /*
    * 此处为写在jsp中的java脚本，具体是什么作用还不太理解
    * */
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
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
    <link rel="stylesheet" type="text/css" href="../../jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="../../jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="../../jquery/bs_pagination/en.js"></script>
    <script type="text/javascript">

        $(function(){

            //使用bootstrap中的日历插件
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });
            /*
            * 为创建按钮绑定事件，打开添加操作的模态窗口
            * */
            $("#addBtn").click(function () {
                /*此处使用ajax是为了局部刷新页面，在弹出的模态窗口展开时，提前将数据准备好*/
                $.ajax({
                    url:"getUserList.do",
                    type:"get",
                    dataType:"json",
                    success:function (data) {
                        /*
                        * 对返回的data进行分析，也就是对我们所需要从后端获取的data格式进行判断
                        * 此处的data是将用户的那么发送到前端页面展示给用户
                        * 此处返回给前端的data是一个json,然而这个json中应该是的每一个用户的具体信息
                        * 但是要怎么取出data中具体每一个对象的信息呢？？？
                        *     我们可以遍历data,没循环一次获取一个data中的用户，根据用户的key取出value
                        * data:
                        *     [{"id":?,"name":?,"logAct":?,....}{}{}]
                        * */
                        /*
                        * 此处的用户是用下拉框进行展示的，我们如何将循环的到的信息放置到下拉框中呢？
                        *    下拉框使用select进行展示的，select中可以使用html和text文本两种方式进行填充，此处只要将循环得到的字符串
                        *    放置到select中的html中即可
                        * */
                        var html="";
                        /*
                        * ajax中对于集合的遍历有固定的形式
                        * */
                        $.each(data,function (i,n) {
                            /*
                            * 循环中i指代的是此时的变量为集合中的第几个元素，n代表集合中的某个元素
                            * */
                            html+="<option value='"+n.id+"'>"+n.name+"</option>"
                        });
                        //alert(html);
                        $("#create-owner").html(html);
                        /*
                        * 元素获取成功之后，打开模态窗口
                        * */

                        //如何设置打开模态窗口时，默认选中的对象为当前登录用户呢？
                        //获取session中存取的数值，要使用ei表达式，使用{}进行包裹
                          var id="${user.id}";
                          //alert(id)
                        //将id值设置为一确定值时，将会默认选取此对象
                        $("#create-owner").val(id);
                        $("#createClueModal").modal("show")
                    }
                })
            })

            $("#saveBtn").click(function () {
                $.ajax({
                    url:"save.do",
                    data:{
                        "fullname" : $.trim($("#create-fullname").val()),
                        "appellation" : $.trim($("#create-appellation").val()),
                        "owner" : $.trim($("#create-owner").val()),
                        "company" : $.trim($("#create-company").val()),
                        "job" : $.trim($("#create-job").val()),
                        "email" : $.trim($("#create-email").val()),
                        "phone" : $.trim($("#create-phone").val()),
                        "website" : $.trim($("#create-website").val()),
                        "mphone" : $.trim($("#create-mphone").val()),
                        "state" : $.trim($("#create-state").val()),
                        "source" : $.trim($("#create-source").val()),
                        "description" : $.trim($("#create-description").val()),
                        "contactSummary" : $.trim($("#create-contactSummary").val()),
                        "nextContactTime" : $.trim($("#create-nextContactTime").val()),
                        "address" : $.trim($("#create-address").val())
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        /*
                        * 我们将线索的具体进行发送到后台，后台对信息进行保存，保存成功之后关闭模态窗口
                        * */
                        if (data.success){
                            pageList(1,$("#cluePage").bs_pagination('getOption','rowsPerPage'));
                            $("#clueAddForm")[0].reset();
                            $("#createClueModal").modal("hide");
                        }else {
                            alert("线索保存失败...")
                        }
                    }
                })
            })
            //为查询按钮绑定事件，触发pageList方法
            $("#searchBtn").click(function () {
                //alert(123)
                /*
                * 在此处还有一些特殊需要进行的操作，等下在考虑
                * */
                /*$("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-startDate").val($.trim($("#search-startDate").val()));
                $("#hidden-endDate").val($.trim($("#search-endDate").val()));*/
                //点击查询按钮时，更新隐藏域
                //alert($.trim($("#search-company").val()))
                $("#hidden-fullname").val($.trim($("#search-fullname").val()));
                $("#hidden-company").val($.trim($("#search-company").val()));
                //alert($("#hidden-company").val())
                $("#hidden-phone").val($.trim($("#search-phone").val()));
                $("#hidden-source").val($.trim($("#search-source").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-mphone").val($.trim($("#search-mphone").val()));
                $("#hidden-state").val($.trim($("#search-state").val()));
                //alert(123)
                pageList(1,2)
            })

            //为全选的复选框绑定事件，使其能够在被点击时触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked",this.checked);
            })

            //实现当所展示列表中的所有选项被打上√时，全选框打上√
            /*$("input[name=xz]").click(function () {
                alert(123)
            })*/
            //以上两行代码是无法进行运行的，因为在列表所展示的内容是动态进行生成的，
            //动态生成的元素是不能够以普通绑定事件的形式来进行操作的
            //动态生成的元素，我们要以on方法的形式来触发事件
            //语法：
            //$(需要绑定的有效外层元素).on(绑定事件的方式，需要绑定的元素的jquery对象，回调函数)
            $("#clueBody").on("click",$("input[name=xz]"),function () {
                $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
            })

            /*
            * 还是一个查询，通过将需要修改的id传递到后台，先进行铺垫，然后打开相应的模态窗口
            * */
            //为修改按钮绑定事件，打开修改操作的模态窗口
            $("#editBtn").click(function () {
                var $xz=$("input[name=xz]:checked");//此行代码的作用为将dom对象转换为jquery对象
                if ($xz.length==0){
                    alert("请选择需要进行修改的对象...")
                } else if ($xz.length>1){
                    alert("每次仅能修改一条记录...")
                } else {
                    //此处从选中的dom对象中取出id
                    var id=$xz.val();
                    $.ajax({
                        url:"getUserListAndClue.do",
                        data:{
                            "id":id
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data) {
                            //alert(123)
                            //接下来我们将判断接收到的data的形式
                            /*
                            * data
                            *     用户列表
                            *     市场活动对象
                            *     {"uList":[{用户1}{用户2}{用户3}...],"a":{市场活动}}
                            *
                            * */
                            //处理所有者下拉框
                            var html="<option></option>";
                            $.each(data.uList,function (i,n) {
                                html+="<option value='"+n.id+"'>"+n.name+"</option>";
                            })
                            $("#edit-owner").html(html);
                            //alert(html)
                            //处理单条clue

                            $("#edit-owner").val(data.c.owner);//这一行代码好奇怪呀，为什么将c中的owner取出赋值到edit-owner中就可以使其取到值，但是c中的owner数代码呀
                            $("#edit-id").val(data.c.id);
                            //alert(data.c.id)
                            $("#edit-company").val(data.c.company);
                            //alert(data.c.company)
                            //$("#edit-appellation").val(data.c.appellation);
                            $("#edit-fullname").val(data.c.fullname);
                            //alert(data.c.fullname)
                            $("#edit-job").val(data.c.job);
                            //alert(data.c.job)
                            $("#edit-email").val(data.c.email);
                            //alert(data.c.email)
                            $("#edit-phone").val(data.c.phone)
                            //alert(data.c.phone)
                            $("#edit-website").val(data.c.website);
                            //alert(data.c.website)
                            $("#edit-mphone").val(data.c.mphone);
                            //alert(data.c.mphone)
                            $("#edit-description").val(data.c.description)
                            //alert(data.c.description)
                            $("#edit-contactSummary").val(data.c.contactSummary);
                            //alert(data.c.contactSummary)
                            $("#edit-nextContactTime").val(data.c.nextContactTime);
                            //alert(data.c.nextContactTime)
                            $("#edit-address").val(data.c.address)
                            $("#edit-appellation").val(data.c.appellation)
                            $("#edit-clueState").val(data.c.state)
                            $("#edit-source").val(data.c.source)

                            //alert(data.c.address)
                            //当所有的值都填写好之后，打开修改操作的模态窗口
                            $("#editClueModal").modal("show");
                        }
                    })
                }
            })



            $("#updateBtn").click(function () {
                $.ajax({
                    url:"update.do",
                    data:{
                        "owner":$.trim($("#edit-owner").val()),//这里的owner是user的id,
                        "id":$.trim($("#edit-id").val()),
                        "company":$.trim($("#edit-company").val()),
                        "fullname":$.trim($("#edit-fullname").val()),
                        "job":$.trim($("#edit-job").val()),
                        "email":$.trim($("#edit-email").val()),
                        "phone":$.trim($("#edit-phone").val()),
                        "website":$.trim($("#edit-website").val()),
                        "mphone":$.trim($("#edit-mphone").val()),
                        "description":$.trim($("#edit-description").val()),
                        "contactSummary":$.trim($("#edit-contactSummary").val()),
                        "nextContactTime":$.trim($("#edit-nextContactTime").val()),
                        "address":$.trim($("#edit-address").val()),
                        "appellation":$.trim($("#edit-appellation").val()),
                        "state":$.trim($("#edit-clueState").val()),
                        "source":$.trim($("#edit-source").val())
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        //现在考虑将前端的数据传送到后端之后，需要从后端获取什么样的数据？
                        /*
                        * data:
                        *     {"success":true/false}
                        * */
                        if (data.success){
                            //修改成功之后
                            //刷新市场活动信息列表（局部进行刷新）
                            /*
                            * 修改操作结束之后，应该维持在当前页，维持每页展现的记录数
                            *
                            * */
                            pageList($("#cluePage").bs_pagination('getOption','currentPage'),$("#cluePage").bs_pagination('getOption','rowsPerPage'));
                            //关闭模态窗口
                            $("#editClueModal").modal("hide");
                        }else{
                            alert("修改市场活动失败...")
                        }
                    }
                })
            })


            //为删除按钮绑定事件，执行市场活动删除
            $("#deleteBtn").click(function () {
                //找到复选框中所有打✔的复选框的jquery对象
                //此处将在页面所展示的dom对象name全部都取为xz,因此当取出name=xz的dom对象时，将会取出多个dom对象，将此dom对象转化为jquery对象时，将会得到一个jquery数组
                var $xz=$("input[name=xz]:checked");  //此处代码的含义是将dom对象转化为jquery对象

                //alert($xz.length)此行代码为测试将dom对象转化为jquery对象是否成功
                if ($xz.length==0){
                    alert("请选择需要删除的记录...");

                    //当length不等于1的时候，那么此时一定选中了大于等于一条记录

                } else{
                    if (confirm("是否确定删除所选记录")){
                        //拼接将要发送到后台的参数
                        var param="";
                        //将$xz中的每一个dom对象遍历出来，取其value值，就相当于取得了需要删除对象的id值
                        for (var i=0;i<$xz.length;i++){
                            param+="id="+$($xz[i]).val();
                            //因为每一个id之间我们需要使用&进行分隔，但是最后一个符号不需要进行分隔
                            if (i<$xz.length-1){
                                param+="&";
                            }
                        }
                        //alert(param);//此行代码为测试是否成功将参数取出
                        //id=50680f45c9e04dc59faf1bb0d5fa039b&id=60c7884993dd4270b472824f4d1e6967
                        //上面一行数据为param的输出值，在data中直接书写param,此时实际上相当于输入了一堆name为id的值
                        $.ajax({
                            url:"delete.do",
                            data:param,
                            type:"post",
                            dataType:"json",
                            success:function (data) {
                                //此处我们预先判断data的数据形式
                                //data{"success":true/false}
                                if (data.success){
                                    //删除成功成功以后，回到第一页，维持每页展示的记录数
                                    //alert("删除成功...")
                                    //pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerpage'));
                                    pageList(1,2);
                                }else {
                                    alert("删除市场活动失败...")
                                }
                            }
                        })
                    }
                }
            })



            pageList(1,2);//此处代码的作用是当页面加载完毕之后，不进行任何的点击操作，自动将页面进行分页
        });
        /*
        * 分页的本质还是进行查询，没点击更换一次页面查询一次，每一查询的取值都是从隐藏域中进行取值，因此可以保持点击的时候可以维持不变
        * 将查询结果展示到网页上
        * */
        function pageList(pageNo,pageSize) {
            $("#qx").prop("checked",false)
            $("#search-fullname").val($.trim($("#hidden-fullname").val()));
            $("#search-company").val($.trim($("#hidden-company").val()));
            $("#search-phone").val($.trim($("#hidden-phone").val()));
            $("#search-source").val($.trim($("#hidden-source").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-mphone").val($.trim($("#hidden-mphone").val()));
            $("#search-state").val($.trim($("#hidden-state").val()));
            $.ajax({
                url:"pageList.do",
                data:{
                    /*
                    * 下面传入的数据是从搜索框中传入的！！！
                    * 当搜索框中没有相关的输入时，默认输入的值为空，执行全局搜索
                    * */
                    "pageNo":pageNo,
                    "pageSize":pageSize,
                    "fullname":$.trim($("#search-fullname").val()),
                    "company":$.trim($("#search-company").val()),
                    "phone":$.trim($("#search-phone").val()),
                    "source":$.trim($("#search-source").val()),
                    "owner":$.trim($("#search-owner").val()),
                    "mphone":$.trim($("#search-mphone").val()),
                    "state":$.trim($("#search-state").val())
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    var html="";
                    $.each(data.dataList,function (i,n) {
                        html+='<tr class="active">';
                        //alert(n.fullname)
                        //alert(n.id)
                        html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
                        html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'detail.do?id='+n.id+'\';">'+n.fullname+'</a></td>';
                        html+='<td>'+n.company+'</td>';
                        html+='<td>'+n.mphone+'</td>';
                        html+='<td>'+n.phone+'</td>';
                        html+='<td>'+n.source+'</td>';
                        html+='<td>'+n.owner+'</td>';
                        html+='<td>'+n.state+'</td>';
                    })
                    //alert(html)
                    $("#clueBody").html(html)
                    var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
                    $("#cluePage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数
                        visiblePageLinks: 3, // 显示几个卡片
                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,
                        //该回调函数时在，点击分页组件的时候触发的
                        onChangePage : function(event, data){
                            pageList(data.currentPage , data.rowsPerPage);
                        }
                    })
                }
            })
        }

    </script>
</head>
<body>
<input type="hidden" id="hidden-fullname"/>
<input type="hidden" id="hidden-company"/>
<input type="hidden" id="hidden-phone"/>
<input type="hidden" id="hidden-source"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-mphone"/>
<input type="hidden" id="hidden-state"/>
<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="clueAddForm" role="form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者1<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司1<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <%--<option></option>
                                <option>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>--%>
                                <c:forEach items="${appellation}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <%--<option>试图联系</option>
                                <option>将来联系</option>
                                <option>已联系</option>
                                <option>虚假线索</option>
                                <option>丢失线索</option>
                                <option>未联系</option>
                                <option>需要条件</option>--%>
                                <c:forEach items="${clueState}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
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
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id"/><%--此处为添加了一个保存id的隐藏域--%>
                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <%--<option selected>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>--%>
                                <c:forEach items="${appellation}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueState">
                                <option></option>
                                <%--<option>试图联系</option>
                                <option>将来联系</option>
                                <option selected>已联系</option>
                                <option>虚假线索</option>
                                <option>丢失线索</option>
                                <option>未联系</option>
                                <option>需要条件</option>--%>
                                <c:forEach items="${clueState}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <%--<option selected>广告</option>
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
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>




<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称12</div>
                        <input class="form-control" id="search-fullname" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" id="search-company" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" id="search-phone" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="search-source">
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
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" id="search-owner" type="text">
                    </div>
                </div>



                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" id="search-mphone" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="search-state">
                            <option></option>
                            <%--<option>试图联系</option>
                            <option>将来联系</option>
                            <option>已联系</option>
                            <option>虚假线索</option>
                            <option>丢失线索</option>
                            <option>未联系</option>
                            <option>需要条件</option>--%>
                            <c:forEach items="${clueState}" var="c">
                                <option value="${c.value}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询123</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建1</button>
                <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改123</button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueBody">
                <%--<tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;">
            <div id="cluePage"></div>
            <%--<div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">首页</a></li>
                        <li class="disabled"><a href="#">上一页</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">下一页</a></li>
                        <li class="disabled"><a href="#">末页</a></li>
                    </ul>
                </nav>
            </div>--%>
        </div>

    </div>

</div>
</body>
</html>