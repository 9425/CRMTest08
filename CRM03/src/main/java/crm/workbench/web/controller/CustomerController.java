package crm.workbench.web.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CustomerController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到联系人控制器中，真的进来啦...");
        String path = request.getServletPath();
        if ("/workbench/activity/getUserList.do".equals(path)) {
            // getUserList(request,response);
        } else if ("/workbench/activity/save.do".equals(path)) {
            //save(request,response);
        }
    }
}
