<%--
  Created by IntelliJ IDEA.
  User: yang hui
  Date: 2021/4/20
  Time: 19:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
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
    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

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

            //为修改按钮绑定事件，打开修改操作的模态窗口
            $("#editBtn").click(function () {
                /*var $xz=$("input[name=xz]:checked");//此行代码的作用为将dom对象转换为jquery对象
                if ($xz.length==0){
                    alert("请选择需要进行修改的对象...")
                } else if ($xz.length>1){
                    alert("每次仅能修改一条记录...")
                } else {
                    //此处从选中的dom对象中取出id*/
                    //alert(123)
                    var id='${clue.id}';
                    //alert(id)
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
            })

            //为更新按钮绑定事件
            $("#updateBtn").click(function () {
                //alert(123)
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
                            //pageList($("#cluePage").bs_pagination('getOption','currentPage'),$("#cluePage").bs_pagination('getOption','rowsPerPage'));
                            //关闭模态窗口
                            //alert($("#edit-id").val())
                            showDetail();
                            $("#editClueModal").modal("hide");
                        }else{
                            alert("修改市场活动失败...")
                        }
                    }
                })
            })


            //为删除按钮绑定事件，执行市场活动删除
            $("#deleteBtn").click(function () {
                //alert("判断delete是否生效:"+123)
                //找到复选框中所有打✔的复选框的jquery对象
                //此处将在页面所展示的dom对象name全部都取为xz,因此当取出name=xz的dom对象时，将会取出多个dom对象，将此dom对象转化为jquery对象时，将会得到一个jquery数组
                /*var $xz=$("input[name=xz]:checked");  //此处代码的含义是将dom对象转化为jquery对象

                //alert($xz.length)此行代码为测试将dom对象转化为jquery对象是否成功
                if ($xz.length==0){
                    alert("请选择需要删除的记录...");

                    //当length不等于1的时候，那么此时一定选中了大于等于一条记录

                } else{*/
                var id='${clue.id}';
                //alert(id)
                var param="";
                //alert(id.length)
                    if (confirm("是否确定删除所选记录")){
                        //alert("真的确定删除了...")
                        param+="id="+id;
                        //alert(param)
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
                                    //pageList(1,2);
                                    //update(id)
                                    $.ajax({
                                        url:"deleteZhuanFa.do",
                                        data:{
                                            "id":"${clue.id}"
                                        },
                                        type:"get",
                                        dataType:"json",
                                        success:function (data) {
                                            alert("删除成功...")
                                        }
                                    })
                                    //alert("删除成功...")

                                    //http://localhost:8080/workbench/index.jsp
                                    //http://localhost:8080/CRM/workbench/index.jsp
                                    //top.location='/CRM/workbench/clue/index.jsp'//如果所跳转的页面不是主页面，那么要将其设为主页面
                                    self.location='/CRM/workbench/clue/index.jsp';//不将当前页面当作主页面
                                }else {
                                    alert("删除市场活动失败...")
                                }
                            }
                        })
                    }
            })

            //为备注保存按钮绑定事件，执行备注添加操作
            $("#saveRemarkBtn").click(function () {
                //alert(123)
                $.ajax({
                    url:"saveRemark.do",
                    data:{
                        "noteContent":$.trim($("#remark").val()),
                        "clueId":"${clue.id}"
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
                            html += '<div id="'+data.cr.id+'" class="remarkDiv" style="height: 60px;">';
                            html += '<img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id="e'+data.cr.id+'">'+data.cr.noteContent+'</h5>';
                            html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}_${clue.company}</b> <small style="color: gray;"> '+(data.cr.createTime)+' 由'+(data.cr.createBy)+'</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.cr.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.cr.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                            $("#remarkDiv").before(html);
                            //showRemarkList();
                        }else {
                            alert("删除失败...")
                        }
                    }
                })
            })


            $("#aname").keydown(function (event) {
                if (event.keyCode==13){
                    $.ajax({
                        url:"getActivityListByNameAndNotByClueId.do",
                        data:{
                            "aname" : $.trim($("#aname").val()),
                            "clueId" : "${clue.id}"
                        },
                        type:"get",
                        dataType:"json",
                        success:function (data) {
                            var html = "";
                            $.each(data,function (i,n) {
                                html+='<tr>'
                                html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';//此处的id值为市场活动的id值
                                html+='<td>'+n.name+'</td>'
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

            //为全选的复选框绑定事件，使其能够在被点击时触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked",this.checked);
            })


            $("#activitySearchBody").on("click",$("input[name=xz]"),function () {
                $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
            })

            //将市场活动与线索进行关联
            $("#bundBtn").click(function () {
                var $xz=$("input[name=xz]:checked");  //此处代码的含义是将dom对象转化为jquery对象
                if ($xz.length==0){
                    alert("请选择需要关联的市场活动...");
                    //$("#bundModal").modal("show");
                    return false;
                    //当length不等于1的时候，那么此时一定选中了大于等于一条记录
                } else{
                    if (confirm("是否确定关联所选市场活动")){
                        //拼接将要发送到后台的参数
                        var param = "clueId=${clue.id}&";
                        //将$xz中的每一个dom对象遍历出来，取其value值，就相当于取得了需要删除对象的id值
                        for (var i=0;i<$xz.length;i++){
                            param+="activityId="+$($xz[i]).val();
                            //因为每一个id之间我们需要使用&进行分隔，但是最后一个符号不需要进行分隔
                            if (i<$xz.length-1){
                                param+="&";
                            }
                        }
                        //alert(param);//此行代码为测试是否成功将参数取出
                        //id=50680f45c9e04dc59faf1bb0d5fa039b&id=60c7884993dd4270b472824f4d1e6967
                        //上面一行数据为param的输出值，在data中直接书写param,此时实际上相当于输入了一堆name为id的值
                        $.ajax({
                            url:"bund.do",
                            data:param,
                            type:"post",
                            dataType:"json",
                            success:function (data) {
                                //此处我们预先判断data的数据形式
                                //data{"success":true/false}
                                //alert(data)
                                if (data.success){
                                    //删除成功成功以后，回到第一页，维持每页展示的记录数
                                    //alert("删除成功...")
                                    //pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerpage'));
                                    showActivityList()
                                    //alert("关联成功...")
                                    $("#bundModal").modal("hide");
                                }else {
                                    alert("关联市场活动失败...")
                                }
                            }
                        })
                    }
                }
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

                            $("#e"+id).html(data.cr.noteContent);
                            $("#s"+id).html(data.cr.editTime+"由"+data.cr.editBy);
                            //更新内容之后，关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                        } else {
                            alert("修改备注失败...")
                        }
                    }
                })
            })

            showDetail();
            showRemarkList();
            showActivityList();
        });


        function showDetail() {
            //alert("showDetail")
            $.ajax({
                url:"showDetail.do",
                data:{
                    "id":"${clue.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    //alert(data.fullname)//当ajax返回的是一个类时，直接用data当作原来的类即可
                    var html="";
                    html+='<div style="position: relative; left: 40px; height: 30px;"> <div style="width: 300px; color: gray;">名称</div> <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>'+data.fullname+'</b></div>'
                    html+='<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div> <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>'+data.owner+'</b></div>'
                    html+='<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div> <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>'
                    html+='</div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 10px;"> <div style="width: 300px; color: gray;">公司</div> <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>'+data.company+'</b></div>'
                    html+='<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div> <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>'+data.job+'</b></div>'
                    html+='<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div> <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>'
                    html+='</div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 20px;"> <div style="width: 300px; color: gray;">邮箱</div> <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>'+data.email+'</b></div>'
                    html+='<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div> <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>'+data.phone+'</b></div>'
                    html+='<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div> <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>'
                    html+='</div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 30px;"> <div style="width: 300px; color: gray;">公司网站</div> <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>'+data.website+'</b></div>'
                    html+='<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div> <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>'+data.mphone+'</b></div>'
                    html+='<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div> <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>'
                    html+='</div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 40px;"> <div style="width: 300px; color: gray;">线索状态</div> <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>'+data.state+'</b></div>'
                    html+='<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div> <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>'+data.source+'</b></div>'
                    html+='<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div> <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>'
                    html+='</div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 50px;"> <div style="width: 300px; color: gray;">创建者</div> <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>'+data.createBy+'&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">'+data.createTime+'</small></div>'
                    html+='<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div> </div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 60px;"> <div style="width: 300px; color: gray;">修改者</div> <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>'+data.createTime+'&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">'+data.editTime+'</small></div>'
                    html+='<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div> </div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 70px;"> <div style="width: 300px; color: gray;">描述</div> <div style="width: 630px;position: relative; left: 200px; top: -20px;"> <b>'+data.description+' </b>'
                    html+='</div>'
                    html+='<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div> </div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 80px;"> <div style="width: 300px; color: gray;">联系纪要</div> <div style="width: 630px;position: relative; left: 200px; top: -20px;"> <b>'+data.contactSummary+' </b>'
                    html+='</div>'
                    html+='<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div> </div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 90px;"> <div style="width: 300px; color: gray;">下次联系时间</div> <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>'+data.nextContactTime+'</b></div>'
                    html+='<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div> </div>'
                    html+='<div style="position: relative; left: 40px; height: 30px; top: 100px;"> <div style="width: 300px; color: gray;">详细地址</div> <div style="width: 630px;position: relative; left: 200px; top: -20px;"> <b>'+data.address+' </b>'
                    html+='</div>'
                    html+='<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div> </div>'
                    $("#detailBody").html(html)
                }
            })
        }


        function showRemarkList() {
            $.ajax({
                url:"getRemarkListByAid.do",
                data:{
                    "clueId":"${clue.id}"
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
                        html+='<img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html+='<div style="position: relative; top: -40px; left: 40px;" >';
                        html+='<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
                        html+='<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}_${clue.company}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+'由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
                        html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        /*此处的id在进行前端页面展示的时候就已经进行了赋值到remarkId中，remarkId赋值到隐藏域中进行保存*/
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html+='&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html+='</div>';
                        html+='</div>';
                        html+='</div>';

                       /* <div class="remarkDiv" style="height: 60px;">
                        <img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">
                        <div style="position: relative; top: -40px; left: 40px;" >
                        <h5>哎呦！</h5>
                        <font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
                        <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                        <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                        </div>
                        </div>
                        </div>*/

                    })
                    $("#remarkDiv").before(html);
                }
            })
        }


        function deleteRemark(id) {
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

        function editRemark(id) {
            //alert(123)
            //将模态窗口中，隐藏域的id进行赋值
            //此处的id为从前端传递过来的值
            $("#remarkId").val(id);
            //找到指定的存放备注信息的h5标签
            var noteContent=$("#e"+id).html();
            //将h5中展现出来的信息，赋予到修改操作模态窗口中的文本域中
            $("#noteContent").val(noteContent);
            //以上信息处理完毕之后，将修改备注的模态窗口打开
            $("#editRemarkModal").modal("show");
        }



        //展示与市场活动相关联的函数
        function showActivityList() {
            $.ajax({
                url:"getActivityListByClueId.do",
                data:{
                    "clueId":"${clue.id}"
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    var html="";
                    $.each(data,function (i,n) {
                        html+='<tr>'
                        html+='<td>'+n.name+'</td>';
                        html+='<td>'+n.startDate+'</td>';
                        html+='<td>'+n.endDate+'</td>';
                        html+='<td>'+n.owner+'</td>';
                        html+='<td><a href="javascript:void(0);" onclick="unbund(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
                        html+='</tr>';
                    })
                    $("#activityBody").html(html);
                }
            })
        }

        //取消市场活动和线索相关联的函数
        function unbund(id) {
            if (confirm("是否确定取消关联")) {
                $.ajax({
                    url:"unbund.do",
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
                        if (data.success) {
                            showActivityList();
                        } else {
                            alert("删除备注失败...")
                        }

                    }
                })
            }
        }


        function showActivityListBySearch() {
            /*$("#aname").val("");
            $("#activitySearchBody").html("");*/
            cleanShowActivityListBySearch();
            $("#bundModal").modal("show");
        }

        function cleanShowActivityListBySearch() {
            $("#aname").val("");
            $("#activitySearchBody").html("");
            $("#qx").prop("checked",false);
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


<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动123</h4>
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
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="qx"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activitySearchBody">
                    <%--<tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"/></td>
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
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="bundBtn">关联</button>
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
                <h4 class="modal-title" id="myModalLabel">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id"/>
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
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                             <%--   <option selected>先生</option>
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
                               <%-- <option>试图联系</option>
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
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
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
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
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

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${clue.fullname}<small>${clue.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" onclick="window.location.href='convert2.jsp?id=${clue.id}&fullname=${clue.fullname}&appellation=${clue.appellation}&company=${clue.company}&owner=${clue.owner}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
        <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;" id="detailBody">
    <%--<div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>--%>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;" id="remarkBody">
    <div class="page-header">
        <h4>备注2</h4>
    </div>

    <!-- 备注1 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>哎呦！</h5>
            <font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <!-- 备注2 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="../../image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>呵呵！</h5>
            <font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;" id="activityTbody">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--<tr>
                    <td>发传单</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                    <td>zhangsan</td>
                    <td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>
                <tr>
                    <td>发传单</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                    <td>zhangsan</td>
                    <td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" onclick="showActivityListBySearch()" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动1245</a>
        <%--data-toggle="modal" data-target="#bundModal"--%>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>