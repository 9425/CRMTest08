package crm.workbench.web.controller;

import crm.setting.domain.User;
import crm.setting.service.Impl.UserServiceImpl;
import crm.setting.service.UserService;
import crm.utils.DateTimeUtil;
import crm.utils.PrintJson;
import crm.utils.ServiceFactory;
import crm.utils.UUIDUtil;
import crm.vo.PaginationVO;
import crm.workbench.domain.Activity;
import crm.workbench.domain.ActivityRemark;
import crm.workbench.service.AcitivityService;
import crm.workbench.service.Impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到了市场活动控制器。。。真的进来了");
        String path=request.getServletPath();//此处是获取访问的路径

        //此处用if来判断路径是为了使用一个servlet来控制activity的相关操作即可
        if ("/workbench/activity/getUserList.do".equals(path)){
            getUserList(request,response);
        }else if("/workbench/activity/save.do".equals(path)){
            save(request,response);
        }else if ("/workbench/activity/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/activity/delete.do".equals(path)){
            delete(request,response);
        }else if ("/workbench/activity/getUserListAndActivity.do".equals(path)){
            getUserListAndActivity(request,response);
        }else if ("/workbench/activity/update.do".equals(path)){
            update(request,response);
        }else if ("/workbench/activity/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/activity/getRemarkListByAid.do".equals(path)){
            getRemarkListById(request,response);
        }else if ("/workbench/activity/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if ("/workbench/activity/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/activity/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }


    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到执行修改备注的操作中...");
        String id=request.getParameter("id");//这里的id也就是需要进行修改的备注id
        String noteContent=request.getParameter("noteContent");
        String editTime=DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="1";

        ActivityRemark activityRemark=new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditFlag(editFlag);
        activityRemark.setEditTime(editTime);
        activityRemark.setEditBy(editBy);

        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=acitivityService.updateRemark(activityRemark);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("ar",activityRemark);
        PrintJson.printJsonObj(response,map);


    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到备注添加操作中...");
        String noteContent=request.getParameter("noteContent");
        String activityId=request.getParameter("activityId");
        String id=UUIDUtil.getUUID();
        String createTime=DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="0";

        ActivityRemark activityRemark=new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setActivityId(activityId);
        activityRemark.setCreateBy(createBy);
        activityRemark.setCreateTime(createTime);
        activityRemark.setEditFlag(editFlag);
        System.out.println(activityRemark);
        AcitivityService acitivityService=(AcitivityService)ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=acitivityService.saveRemark(activityRemark);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("ar",activityRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除备注操作...");
        String id=request.getParameter("id");
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=acitivityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到根据市场活动id,取得备注信息列表...");
        String activityId=request.getParameter("activityId");
        System.out.println(activityId);
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> activityRemarkList=acitivityService.getRemarkListByAid(activityId);
        System.out.println(activityRemarkList.size());
        System.out.println(activityRemarkList);//经过测试，已经成功的从后台取得了数据
        PrintJson.printJsonObj(response,activityRemarkList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //跳转到详细信息页面的操作流程，首先通过前端传递id，然后后台接收到id之后，将id传送到后台，获取详细信息，最后跳转到详细信息页面，
        //将信息展示到网页上
        System.out.println("跳转到详细信息页的操作...");
        String id=request.getParameter("id");
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity=acitivityService.detail(id);
        //当跳转到详细信息页面的时候，已经将activity保存到缓存域中，当需要进行操作activity的时候，我们只需要从缓存域中提取即可
        request.setAttribute("a",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行市场活动修改操作...");
        String id=request.getParameter("id");
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String startDate=request.getParameter("startDate");
        String endDate=request.getParameter("endDate");
        String cost=request.getParameter("cost");
        String description=request.getParameter("description");
        //修改时间：当前系统时间
        String editTime=DateTimeUtil.getSysTime();//此处的修改时间在前端不显示，但是在后端要留有记录
        //修改人：当前登录用户
        String editBy=((User)request.getSession().getAttribute("user")).getName();//同理，此处的修改人在前端不进行显示，但是在后端我们要留有记录

        Activity activity=new Activity();//将此时需要进行修改的对象打包为一个activity对象，然后进行解析
        activity.setId(id);
        activity.setCost(cost);
        activity.setStartDate(startDate);
        activity.setOwner(owner);
        activity.setEndDate(endDate);
        activity.setName(name);
        activity.setDescription(description);
        activity.setEditBy(editBy);
        activity.setEditTime(editTime);
        //System.out.println(activity);
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=acitivityService.update(activity);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到用户信息查询列表和根据市场活动id查询单挑的操作");
        String id=request.getParameter("id");
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        /*
        * 总结：
        *     controller调用service方法，返回值应该是什么，根据的是前端需要什么，就要从service层取得什么
        *     前端需要的，管业务层去要
        *     uList
        *     a
        *     以上两项信息，复用率不高，我们选择使用map的形式将其打包，然后传递到前端
        * */
        Map<String,Object> map=acitivityService.getUserListAndActivity(id);
        PrintJson.printJsonObj(response,map);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行市场活动删除操作...");
        String ids[]=request.getParameterValues("id");
        //request.getParamValues与request.getParameter的区别：
        //前者用去取出checkbox中的值，虽然名字相同，但是可以将值取出放入一个数组中，后者
        //则是取出相对应名字的数值
        System.out.println(ids);
        for (int i=0;i<ids.length;i++){
            System.out.println(ids[i]);
        }
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=acitivityService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询市场活动信息列表的操作(加有条件查询)");
        String name=request.getParameter("name");
        String owner=request.getParameter("owner");
        String startDate=request.getParameter("startDate");
        String endDate=request.getParameter("endDate");
        String pageNoStr=request.getParameter("pageNo");
        //每页展出的记录数
        int pageNo=Integer.valueOf(pageNoStr);
        String pageSizeStr=request.getParameter("pageSize");
        //计算出略过的记录数
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;

        Map<String,Object> map=new HashMap<String, Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        //创建出代理对象
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        //通过代理对象调用dao层与数据库及进行交互，此处我们需要考虑将从数据库中返回的值，是
        //将其打包为一个vo对象，以供以后使用还是将其打包为map对象，只是在这一次中进行使用
        //打包为vo对象速度比较快，并且方便
        //打包为map对象需要一个个将数据put进入map集合，重复且工作量较大
        //此处因为将会重复使用此种方式，因此选择打包为vo对象，以方便下次的使用
        PaginationVO<Activity> vo=acitivityService.pageList(map);
        //通过上述的方式，就可以获得前端所需的数据
        //前端所需的数据形式如下：
        /*
        * vo-->{"total":100,"dataList":[{市场活动1}{市场活动2}{市场活动3}...]}
        * */
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到执行市场活动添加操作...");
        String id= UUIDUtil.getUUID();
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String startDate=request.getParameter("startDate");
        String endData=request.getParameter("endDate");
        String cost=request.getParameter("cost");
        String description=request.getParameter("description");
        //创建时间，通过取得系统当前时间进行赋值
        String createTime= DateTimeUtil.getSysTime();
        //创建人：当前登录用户
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        Activity activity=new Activity();
        activity.setId(id);    //系统生成
        activity.setCost(cost);
        activity.setStartDate(startDate);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setEndDate(endData);
        activity.setDescription(description);
        activity.setCreateTime(createTime);    //创建时的系统时间
        activity.setCreateBy(createBy);       //创建时的创建人
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=acitivityService.save(activity);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到取得用户信息列表函数中...");
        //此处是创建出UserService每一个具体实现的代理对象，代理对象运行时的具体函数在
        //TransactionInvocationHandler
        UserService us=(UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList=us.getUserList();
        //将获取的List集合以json字符串的形式进行打包输出

        System.out.println(userList);//这行代码是查看是否收到了数据库返回的数据
        PrintJson.printJsonObj(response,userList);
    }
}
