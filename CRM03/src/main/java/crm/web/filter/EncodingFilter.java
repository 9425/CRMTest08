package crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        System.out.println("进入到过滤字符编码的过滤器中...");

        //过滤post请求中文参数乱码
        req.setCharacterEncoding("UTF-8");
        //过滤响应流响应中文乱码
        resp.setContentType("text/html;charset=utf-8");
        //将请求放行，放行也即将rep 和resp进行归还
        System.out.println("退出过滤字符编码的过滤器中...");
        chain.doFilter(req, resp);
    }

    public void init(FilterConfig config) throws ServletException {

    }

}
