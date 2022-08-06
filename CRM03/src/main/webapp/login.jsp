<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        /*写上script代码，加上我们对于登录的限制
        *
        * */
        $(function () {
            /*if (window.top!=window){
                window.top.location
                =window.location
            }*/
            /*上面一句代码什么意思？*/
            /*判断当前的窗口是否为最上层窗口，如果不是最上层窗口
            * ，那么使其变为最上层窗口，防止被别的窗口覆盖，误导浏览者*/

            //为登录按钮绑定事件，执行登录操作
            $("#loginAct").val("");//当页面加载完毕，将用户文本框中的内容清空

            $("#loginAct").focus();//页面加载完毕之后，将用户的文本框自动获得焦点


            $("#submitBtn").click(function () {
                login();
            })

            //为当前登录窗口绑定敲键盘事件
            //event:这个参数可以取得我们所敲的是哪一个键
            $(window).keydown(function (event) {
                //alert(event.keyCode) //用来进行测试事件是否绑定成功

                //如果取得的键位码值位13，表示敲了回车键
                if (event.keyCode==13){
                    login();//当敲下回车键时，我们也调用登录函数进行登录验证
                }
            })

        })
        function login() {
            //$("#msg").html(456) 判断能够将值传递到msg中
            //alert(123); //验证login是否有效
            //下面将具体写出登录中所需要判断的内容
            //验证账号不能为空，取得账号密码
            //将文本中的左右空格去掉，使用$.trim(文本)
            var loginAct=$.trim($("#loginAct").val());
            //alert(loginAct) 测试能否取到文本框中的值

            //alert($("#loginPwd").val()); // 通过这里可以知道，浏览器传递过来的值的确是被接收到了的

            var loginPwd=$.trim($("#loginPwd").val());
            //alert(loginPwd) 测试能否取到文本框中的值
            if (loginAct==""||loginPwd==""){
                $("#msg").html("账号密码不能为空...");
                return false;
            }
            /*以上是进行前端的验证，前端验证通过后，下面将继续进行验证后端*/
            /*上述前端验证通过之后，进行相关的后端验证操作*/

            //后端验证账号密码
            /*使用ajax的方式与后端进行互动*/
            $.ajax({
                url:"setting/user/login.do", //此处为进行后端登录验证时，需要访问的servlet
                data:{ //此处为传入需要进行验证的数据
                    "loginAct":loginAct,
                    "loginPwd":loginPwd
                },
                type:"post",//因为发送的数据涉及到密码，使用post的方式进行发送
                dataType:"json",//返回的数据格式为json格式
                success:function (data) {//此处的data为ajax请求处理成功之后，返回的数据
                    /*
                    * data的信息定义格式如下：
                    *     {"successs":true/false,"msg":"返回相关的错误信息"}
                    * */
                    //如果登录成功
                    if (data.success){
                        //跳转到工作台的初始页面(欢迎页)
                        window.location.href="workbench/index.jsp";
                    //如果登录失败
                    }else {
                        $("#msg").html(data.msg);
                    }
                }
            })
        }
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd">
                </div>
                <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: #b92c28"></span>

                </div>
                <%--
                注意：当按钮写在form表单中时，默认的行为就是提交表单，因此我们如果想要修改
                按钮的默认行为，使得按钮点击时的行为为我们所需要的，因此我们要将按钮的类型修改为
                button,按钮所触发的行为应该是我们自己手动写js代码来决定的
                --%>
                <button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录123</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>