package crm.setting.web.controller;

import crm.exception.LoginException;
import crm.setting.domain.User;
import crm.setting.service.Impl.UserServiceImpl;
import crm.setting.service.UserService;
import crm.utils.MD5Util;
import crm.utils.PrintJson;
import crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到用户控制器");
        String path=request.getServletPath();
        //下面的语句是进行判断访问路径是否正确
        if ("/setting/user/login.do".equals(path)){
            login(request,response);//执行到此处时，证明访问路径是正确的，因此我们可以进行登录验证，此时执行login方法进行验证
        }else if ("/setting/user/xxx.do".equals(path)){
            //xxx
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到验证登录操作...");
        String loginAct=request.getParameter("loginAct");
        String loginPwd=request.getParameter("loginPwd");
       // System.out.println(loginAct);
        //将密码的明文转为MD5的密文形式
        loginPwd= MD5Util.getMD5(loginPwd);//加密后的密码

        //接收浏览器端的ip地址
        String ip=request.getRemoteAddr();
       // System.out.println(ip);
        System.out.println("-----------------ip:"+ip);
        System.out.println(123);
        //未来业务层的开发，统一使用代理类形态的接口对象,传入
        UserService us=(UserService) ServiceFactory.getService(new UserServiceImpl());
        System.out.println(123);
        try {
            System.out.println("进入到try-catch");
            User user=us.login(loginAct,loginPwd,ip);//此处的us为代理后的对象，传入zs，经过代理后由ls进行操作，因此当在处理请求时，如果出现了异常，此时将不会抛出到controller层，而是直接在代理
            //层进行了处理，因此我们要进行相关的修正，使得异常能够抛出到controller层
            request.getSession().setAttribute("user",user);//将从数据库中得到的user对象存放到session域中
            //只要服务器打开，就能够获取session域中的数据
            //如果程序执行到此处，说明业务层没有为controller抛出任何异常
            //表示登录成功
            PrintJson.printJsonFlag(response,true);//此处利用已经写好的工具，将其转为所需要的json字符串
        } catch (LoginException e) {
            //但是当程序执行失败，运行到了catch块的信息，说明业务层为我们验证登录失败，抛出了异常
            e.printStackTrace();
            String msg=e.getMessage();
            //作为controller层，需要为ajax请求提供多项信息，可以有两种方式：
            //(1)将多项信息打包成map,将map解析为json串
            //(2)创建一个Vo
            /*   private boolean success/false;
                 private String msg;
            *
            * */
            //实际操作中对于是需要创建Vo类还是使用map集合将有如下判断：
            /*
            * 如果对于所展现的信息将来还会大量的使用，我们创建一个vo类，使用方便
            * 如果对于所展现的信息只有在这个需求种能够使用，我们使用map集合就可以了
            * */
            Map<String,Object> map=new HashMap<String, Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }
}
