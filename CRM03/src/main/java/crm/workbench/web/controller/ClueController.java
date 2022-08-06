package crm.workbench.web.controller;

import crm.setting.dao.UserDao;
import crm.setting.domain.User;
import crm.setting.service.Impl.UserServiceImpl;
import crm.setting.service.UserService;
import crm.utils.DateTimeUtil;
import crm.utils.PrintJson;
import crm.utils.ServiceFactory;
import crm.utils.UUIDUtil;
import crm.vo.PaginationVO;
import crm.workbench.domain.Activity;
import crm.workbench.domain.Clue;
import crm.workbench.domain.ClueRemark;
import crm.workbench.domain.Tran;
import crm.workbench.service.AcitivityService;
import crm.workbench.service.ClueService;
import crm.workbench.service.Impl.ActivityServiceImpl;
import crm.workbench.service.Impl.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到线索控制器中，真的进来啦...");
        String path = request.getServletPath();
        if ("/workbench/clue/getUserList.do".equals(path)) {
            getUserList(request,response);
        } else if ("/workbench/clue/save.do".equals(path)) {
            save(request,response);
        }else if ("/workbench/clue/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/clue/getUserListAndClue.do".equals(path)){
            getUserListAndClue(request,response);
        }else if ("/workbench/clue/update.do".equals(path)){
            update(request,response);
        }else if ("/workbench/clue/delete.do".equals(path)){
            delete(request,response);
        }else if ("/workbench/clue/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/clue/showDetail.do".equals(path)){
            showDetail(request,response);
        }else if ("/workbench/clue/deleteZhuanFa.do".equals(path)){
            deleteZhuanFa(request,response);
        }else if ("/workbench/clue/getRemarkListByAid.do".equals(path)){
            getRemarkListByAid(request,response);
        }else if ("/workbench/clue/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/clue/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if ("/workbench/clue/getActivityListByClueId.do".equals(path)){
            getActivityListByClueId(request,response);
        }else if ("/workbench/clue/unbund.do".equals(path)){
            unbund(request,response);
        }else if ("/workbench/clue/getActivityListByNameAndNotByClueId.do".equals(path)){
            getActivityListByNameAndNotByClueId(request,response);
        }else if ("/workbench/clue/bund.do".equals(path)){
            bound(request,response);
        }else if ("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }else if ("/workbench/clue/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索备注更新控制层中...");
        String id=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String editTime=DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="1";

        ClueRemark clueRemark=new ClueRemark();
        clueRemark.setId(id);
        clueRemark.setNoteContent(noteContent);
        clueRemark.setEditFlag(editFlag);
        clueRemark.setEditTime(editTime);
        clueRemark.setEditBy(editBy);
        System.out.println("将要修改的clueRemark为："+clueRemark);

        ClueService clueService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.updateRemark(clueRemark);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("cr",clueRemark);
        System.out.println("clueRemark："+clueRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进行到线索转换控制层");
        String clueId = request.getParameter("clueId");

        //接收是否需要创建交易的标记
        String flag = request.getParameter("flag");//如果提交的不是表单元素，那么flag可能为null

        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        Tran tran=null;
        if("a".equals(flag)){

            tran = new Tran();

            //接收交易表单中的参数
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            String id = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();


            tran.setId(id);
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setActivityId(activityId);
            tran.setCreateBy(createBy);
            tran.setCreateTime(createTime);

        }
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag1=clueService.convert(clueId,tran,createBy);
        if (flag1){
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }
    }

    private void bound(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到将市场活动与线索进行关联的控制层...");
        String clueId=request.getParameter("clueId");
        String activityId[]=request.getParameterValues("activityId");//这里的data本质上与放在url栏进行传送是一样的，单个数据就用单个数据接收，多的话就用数组进行接收
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.bound(clueId,activityId);
        System.out.println("关联层："+flag);
        PrintJson.printJsonFlag(response,flag);
        //PrintJson.printJsonObj(response,flag);
    }

    private void getActivityListByNameAndNotByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到通过模糊查询相关市场活动，然后进行市场活动关联的控制层...");
        String aname=request.getParameter("aname");
        String clueId=request.getParameter("clueId");
        //后台操作流程为：通过anamem模糊查询出相关的市场活动，然后去掉已经关联了的市场活动，然后将其进行展示
        Map<String,String> map=new HashMap<String, String>();
        map.put("aname",aname);
        map.put("clueId",clueId);
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList=acitivityService.getActivityListByNameAndNotByClueId(map);
        PrintJson.printJsonObj(response,activityList);
    }

    private void unbund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到将线索与市场活动关联进行取消的控制器中...");
        String id=request.getParameter("id");
        //服务只有一个，但是要操作相对应的表的话，需要相对应的dao文件
        ClueService clueService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.unbund(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到通过clueId获取与其相关联的市场活动控制器中...");
        String clueId=request.getParameter("clueId");
        AcitivityService acitivityService=(AcitivityService)ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList=acitivityService.getActivityListByClueId(clueId);
        System.out.println("clueId："+activityList);
        PrintJson.printJsonObj(response,activityList);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除备注的控制页中...");
        String id=request.getParameter("id");
        ClueService acitivityService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=acitivityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到保存备注的操作页面中...");
        String noteContent=request.getParameter("noteContent");
        String clueId=request.getParameter("clueId");
        String id=UUIDUtil.getUUID();
        String createTime=DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="0";

        ClueRemark clueRemark=new ClueRemark();
        clueRemark.setId(id);
        clueRemark.setNoteContent(noteContent);
        clueRemark.setClueId(clueId);
        clueRemark.setCreateBy(createBy);
        clueRemark.setCreateTime(createTime);
        clueRemark.setEditFlag(editFlag);
        System.out.println(clueRemark);
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.saveRemark(clueRemark);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("cr",clueRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void getRemarkListByAid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到操作备注添加与删除的控制页...");
        String clueId=request.getParameter("clueId");
        ClueService clueService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<ClueRemark> clueRemarkList=clueService.getRemarkListByAid(clueId);
        PrintJson.printJsonObj(response,clueRemarkList);
    }

    private void deleteZhuanFa(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到删除转发操作页...");
        String id=request.getParameter("id");
        request.getRequestDispatcher("/workbench/clue/index.jsp").forward(request,response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改细节之后进行更新控制页...");
        String id=request.getParameter("id");
        ClueService clueService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue=clueService.showDetail(id);
        PrintJson.printJsonObj(response,clue);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到跳转为详情信息页...");
        //使用超链接进入控制器中时，需要发送到后台的数据放置于超链接之中，同样通过取name得形式获取值
        String id=request.getParameter("id");//此处的id为线索的id值
        System.out.println(id);
        //通过id获取clue,然后将其放入缓存域，之后通过缓存域读取使用，这是转发数据的交互方法
        //如果是ajax的话，直接将数据以json的形式发送到前端页面，前端页面获取即可
        ClueService clueService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue=clueService.detail(id);
        System.out.println(clue);
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除线索的操作中...");
        //以下这行代码是错误的写法，因为param中可能包含有多个id,如果仅仅包含有一个id,我们使用getParameter是没有错误的，但是此时有多个，需要使用数组
        //接收相应的数据
        //System.out.println(123);

        //前面我们所传的参数为param,但是因为所传的包含多个id,因此要使用id进行取值，使用param取值为错误手法
        //String ids[]=request.getParameterValues("param");
        String ids[]=request.getParameterValues("id");
        System.out.println(ids);
        System.out.println(ids.length);
        for (int i=0;i<ids.length;i++){
            System.out.println(ids[i]);
        }
        //System.out.println(ids);
        //String param=request.getParameter("param");
        ClueService clueService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行线索的修改操作...");
        String owner=request.getParameter("owner");
        String id=request.getParameter("id");//此处的id是为了指定所要修改的clue
        String company=request.getParameter("company");
        String fullname=request.getParameter("fullname");
        String job=request.getParameter("job");//此处的id是为了指定所要修改的clue
        String email=request.getParameter("email");
        String phone=request.getParameter("phone");
        String website=request.getParameter("website");//此处的id是为了指定所要修改的clue
        String mphone=request.getParameter("mphone");
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");//此处的id是为了指定所要修改的clue
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");
        String appellation=request.getParameter("appellation");//此处的id是为了指定所要修改的clue
        String clueState=request.getParameter("state");
        String source=request.getParameter("source");
        String editTime=DateTimeUtil.getSysTime();//此处为修改时间
        String editBy=((User)request.getSession().getAttribute("user")).getName();

        Clue clue=new Clue();

        clue.setId(id);
        clue.setAddress(address);
        clue.setAppellation(appellation);
        clue.setCompany(company);
        clue.setContactSummary(contactSummary);
        clue.setDescription(description);
        clue.setEmail(email);
        clue.setFullname(fullname);
        clue.setJob(job);
        clue.setMphone(mphone);
        clue.setNextContactTime(nextContactTime);
        clue.setOwner(owner);
        clue.setPhone(phone);
        clue.setSource(source);
        clue.setState(clueState);
        clue.setWebsite(website);
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);

        ClueService clueService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.update(clue);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索通过id查询单条中...");
        String id=request.getParameter("id");
        ClueService clueService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Map<String,Object> map=clueService.getUserListAndClue(id);
        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询线索信息列表的操作(加有条件查询)");
        String fullname=request.getParameter("fullname");
        String company=request.getParameter("company");
        String phone=request.getParameter("phone");
        String source=request.getParameter("source");
        String owner=request.getParameter("owner");
        String mphone=request.getParameter("mphone");
        String state=request.getParameter("state");
        String pageNoStr=request.getParameter("pageNo");
        //每页展出的记录数
        int pageNo=Integer.valueOf(pageNoStr);
        String pageSizeStr=request.getParameter("pageSize");
        //计算出略过的记录数
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        ClueService clueService=(ClueService) ServiceFactory.getService(new ClueServiceImpl());
        PaginationVO<Clue> vo=clueService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索保存函数中...");
        //线索的id用工具生成一个唯一的标识码
        String id = UUIDUtil.getUUID();

        //下面的值全部从前端传递并获取
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");

        //线索的创建事件由时间工具进行生成
        String createTime = DateTimeUtil.getSysTime();

        //创建人为当前的登录用户，从session域中将用户对象取出，获取姓名
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        //以下的数据从前端输入获取
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        Clue clue=new Clue();
        clue.setId(id);
        clue.setAddress(address);
        clue.setWebsite(website);
        clue.setState(state);
        clue.setSource(source);
        clue.setPhone(phone);
        clue.setOwner(owner);
        clue.setNextContactTime(nextContactTime);
        clue.setMphone(mphone);
        clue.setJob(job);
        clue.setFullname(fullname);
        clue.setEmail(email);
        clue.setDescription(description);
        clue.setCreateTime(createTime);
        clue.setCreateBy(createBy);
        clue.setContactSummary(contactSummary);
        clue.setCompany(company);
        clue.setAppellation(appellation);

        //boolean flag= ClueService.save(clue);此行写错了，应该使用动态代理对象域数据库进行交互
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImpl());
        boolean flag=clueService.save(clue);
        System.out.println(flag);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        //此处要将数据库中的用户传递到前端
        /*
        * 对于查询到的一个一个的用户要使用什么进行封装？
        *     我们可以将其封装到List集合中，但是要怎么封装？？？
        * */
        System.out.println("clue:进入到取得用户信息列表函数中...");
        //要获得数据库中的用户对象，需要使用动态代理对象调用userDao，所以下面将创建动态代理对象
        //和user有关的操作，我们使用userService来进行实现，但是我们定义的仅仅是接口的userService，因此
        //我们需要使用动态代理来创建userService
        UserService userService=(UserService)ServiceFactory.getService(new UserServiceImpl());
        //现在可以使用动态代理对象来操作dao层获取user对象
        List<User> userList=userService.getUserList();
        //System.out.println(userList);判断是否取得了用户数据
        //userList中存放的是一个个user对象，将其打包为json格式的对象
        PrintJson.printJsonObj(response,userList);
    }
}