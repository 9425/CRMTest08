package crm.web.filter;

import crm.setting.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        System.out.println("进入到验证用户是否登录过，防止恶意登录的过滤器");
        HttpServletRequest request=(HttpServletRequest) req;
        HttpServletResponse response=(HttpServletResponse) resp;
        String path=request.getServletPath();//进入到过滤器时的访问路径
        System.out.println("进入到过滤器时的访问路径："+path+"---");
        //不应该拦截的资源自动放行
        /*
        * 过滤器在web中进行设置时，所选的为设置过滤所有的.do和.jsp文件
        * */

        /*
        * 为什么禁止所有的.dom和.jsp文件访问，但是唯独可以将这两个进行放行呢？？？
        *     我们在访问登录界面的时候，需要用到这两个链接，在访问登录页面的时候，我们是访问login.jsp链接，但是我们在输入密码之后
        *     点击登录按钮，此时访问的是login.do链接。，因此登录操作需要用到这两个链接，如果将这两个链接设置为禁止访问，我们无法进行
        *     登录操作
        * */
        if ("/login.jsp".equals(path)||"/setting/user/login.do".equals(path)){
            System.out.println("退出验证用户登录的过滤器中...");
            chain.doFilter(req, resp);
            //上面两个链接和登录有关，需要进行放行
        }else{
            //此处进行过滤的方式是验证session域中是否有“user”对象，以前做的时候，验证的是
            //session是否存在，但是此时用这种方式不太合适
            HttpSession session=request.getSession();
            User user=(User) session.getAttribute("user");

            //如果user不为null.说明登陆过，此时需要进行放行
            if (user!=null){
                System.out.println("退出验证用户登录的过滤器中...");
                chain.doFilter(req,resp);
            //反之则没有进行登录过
            }else {
                //使其重定向到登录页
                /*
                * 重定向的路径怎么写？
                *     在实际项目开发中，对于路径的使用，不论操的是前端还收后端，应该一律使用绝对路径
                *     关于转发和重定向的路径写法如下：
                *         转发：
                *             使用的是一种特殊的绝对路径的使用方式，这种绝对路径前面不加项目名，这种路径
                *             称之为内部路径/login.jsp
                *         重定向：
                *             使用的是传统绝对路径的写法，前面必须以/项目名开头，后面跟具体的资源路径
                *             /crm/login.jsp
                *       为什么使用重定向，使用转发不行吗？
                *           转发之后，路径会停留在老路径上，而不是跳转之后最新资源的路径
                *           我们应该在为用户跳转到登录页的同时，将浏览器的地址栏应该设置为最新资源路径
                * */
                System.out.println("退出验证用户登录的过滤器中...");
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
        }
    }

    public void init(FilterConfig config) throws ServletException {

    }

}
