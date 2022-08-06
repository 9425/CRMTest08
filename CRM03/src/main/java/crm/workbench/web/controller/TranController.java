package crm.workbench.web.controller;

import crm.setting.domain.User;
import crm.setting.service.Impl.UserServiceImpl;
import crm.setting.service.UserService;
import crm.utils.DateTimeUtil;
import crm.utils.PrintJson;
import crm.utils.ServiceFactory;
import crm.utils.UUIDUtil;
import crm.vo.PaginationVO;
import crm.workbench.domain.*;
import crm.workbench.service.AcitivityService;
import crm.workbench.service.ContactsService;
import crm.workbench.service.CustomerService;
import crm.workbench.service.Impl.ActivityServiceImpl;
import crm.workbench.service.Impl.ContactsServiceImpl;
import crm.workbench.service.Impl.CustomerServiceImpl;
import crm.workbench.service.Impl.TranServiceImpl;
import crm.workbench.service.TranService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到交易控制器中，真的进来啦...");
        String path = request.getServletPath();
        if ("/workbench/transaction/add.do".equals(path)){
            /*add(request,response);*/
            add(request,response);
        }else if ("/workbench/transaction/getActivityListByNameAndNotByClueId.do".equals(path)){
            getActivityListByNameAndNotByClueId(request,response);
        }else if ("/workbench/transaction/getContactsListByName.do".equals(path)){
            getContactsListByName(request,response);
        }else if ("/workbench/transaction/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/transaction/getCustomerName.do".equals(path)){
            getCustomerName(request,response);
        }else if ("/workbench/transaction/save.do".equals(path)){
            save(request,response);
        }else if ("/workbench/transaction/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/transaction/getRemarkListByTranId.do".equals(path)){
            getRemarkListByTranId(request,response);
        }else if ("/workbench/transaction/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/transaction/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if ("/workbench/transaction/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if ("/workbench/transaction/showTranHistoryListByTranId.do".equals(path)){
            showTranHistoryListByTranId(request,response);
        }else if ("/workbench/transaction/changeStage.do".equals(path)){
            changeStage(request,response);
        }else if ("/workbench/chart/transaction/getCharts.do".equals(path)){
            getCharts(request,response);
        }
    }

    private void getCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得交易阶段数量统计图表的数据");

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        /*

            业务层为我们返回
                total
                dataList

                通过map打包以上两项进行返回


         */
        Map<String,Object> map = ts.getCharts();

        PrintJson.printJsonObj(response, map);

    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行改变阶段的操作");

        String id = request.getParameter("id");//用来寻找所需要修改的tran
        String stage = request.getParameter("stage");
        String money = request.getParameter("money");
        String expectedDate = request.getParameter("expectedDate");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        Tran t = new Tran();
        Map<String,String> pMap = (Map<String,String>)this.getServletContext().getAttribute("pMap");
        t.setPossibility(pMap.get(stage));
        t.setId(id);
        t.setStage(stage);
        t.setMoney(money);
        t.setExpectedDate(expectedDate);
        t.setEditBy(editBy);
        t.setEditTime(editTime);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        boolean flag = ts.changeStage(t);


        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("t", t);

        PrintJson.printJsonObj(response, map);
    }

    private void showTranHistoryListByTranId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到通过tranId获取与其相关联的交易历史控制层中...");
        String tranId=request.getParameter("tranId");
        TranService tranService=(TranService)ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> tranList=tranService.getTranHistoryListByTranId(tranId);
        System.out.println("tranList："+tranList);
        PrintJson.printJsonObj(response,tranList);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到交易备注更新控制层中...");
        String id=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String editTime=DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="1";

        TranRemark tranRemark=new TranRemark();
        tranRemark.setId(id);
        tranRemark.setNoteContent(noteContent);
        tranRemark.setEditFlag(editFlag);
        tranRemark.setEditTime(editTime);
        tranRemark.setEditBy(editBy);
        System.out.println("将要修改的clueRemark为："+tranRemark);

        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.updateRemark(tranRemark);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("tr",tranRemark);
        System.out.println("clueRemark："+tranRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除备注的控制页中...");
        String id=request.getParameter("id");
        TranService acitivityService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag=acitivityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到备注保存操作的控制层中...");
        String noteContent=request.getParameter("noteContent");
        String tranId=request.getParameter("tranId");
        String id=UUIDUtil.getUUID();
        String createTime=DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="0";

        TranRemark tranRemark=new TranRemark();
        tranRemark.setId(id);
        tranRemark.setNoteContent(noteContent);
        tranRemark.setTranId(tranId);
        tranRemark.setCreateBy(createBy);
        tranRemark.setCreateTime(createTime);
        tranRemark.setEditFlag(editFlag);
        System.out.println("所要添加保存的tranRemark："+tranRemark);
        TranService tranService=(TranService)ServiceFactory.getService(new TranServiceImpl());
        boolean flag=tranService.saveRemark(tranRemark);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("cr",tranRemark);
        PrintJson.printJsonObj(response,map);
    }

    private void getRemarkListByTranId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到操作备注添加与删除的控制页...");
        String TranId=request.getParameter("TranId");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranRemark> tranRemarkList=tranService.getRemarkListByTranId(TranId);
        System.out.println("tranRemarkList："+tranRemarkList);
        PrintJson.printJsonObj(response,tranRemarkList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到查看交易的详细信息控制层...");
        //使用超链接进入控制器中时，需要发送到后台的数据放置于超链接之中，同样通过取name得形式获取值
        String id=request.getParameter("id");//此处的id为交易的id值
        System.out.println(id);
        //通过id获取clue,然后将其放入缓存域，之后通过缓存域读取使用，这是转发数据的交互方法
        //如果是ajax的话，直接将数据以json的形式发送到前端页面，前端页面获取即可
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran=tranService.detail(id);
        System.out.println(tran);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入到交易保存控制层...");

        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName"); //此处我们暂时只有客户名称，还没有id
        System.out.println("customerName："+customerName+"-------------------------------------------");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String possibility=request.getParameter("possibility");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        System.out.println("contactsId："+contactsId+"-------------------------------------------");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran t = new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setType(type);
        t.setSource(source);
        t.setActivityId(activityId);
        t.setContactsId(contactsId);
        t.setCreateTime(createTime);
        t.setCreateBy(createBy);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setNextContactTime(nextContactTime);
        t.setPossibility(possibility);
        System.out.println(t);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        boolean flag = ts.save(t,customerName);

        if(flag){

            //如果添加交易成功，跳转到列表页
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");

        }
    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到自动补全控件的控制层...");
        String name = request.getParameter("name");

        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        List<String> sList = cs.getCustomerName(name);

        PrintJson.printJsonObj(response, sList);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询交易信息列表的操作(加有条件查询)");
        String name=request.getParameter("name");
        String customerName=request.getParameter("customerName");
        String stage=request.getParameter("stage");
        String source=request.getParameter("source");
        String owner=request.getParameter("owner");
        String type=request.getParameter("type");
        String contactsName=request.getParameter("contactsName");
        String pageNoStr=request.getParameter("pageNo");
        //每页展出的记录数
        int pageNo=Integer.valueOf(pageNoStr);
        String pageSizeStr=request.getParameter("pageSize");
        //计算出略过的记录数
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("name",name);
        map.put("customerId",customerName);
        map.put("stage",stage);
        map.put("source",source);
        map.put("owner",owner);
        map.put("contactsId",contactsName);
        map.put("type",type);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImpl());
        PaginationVO<Tran> vo=tranService.pageList(map);
        System.out.println("所查出的交易为："+vo);
        PrintJson.printJsonObj(response,vo);
    }

    private void getContactsListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到通过模糊查询相关联系人，然后进行联系人关联的控制层...");
        String aname=request.getParameter("aname");
        //String clueId=request.getParameter("clueId");
        //后台操作流程为：通过anamem模糊查询出相关的市场活动，然后去掉已经关联了的市场活动，然后将其进行展示
        //Map<String,String> map=new HashMap<String, String>();
        //map.put("aname",aname);
        //map.put("clueId",clueId);
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> contactsList=contactsService.getContactsListByName(aname);
        System.out.println("查询联系人为："+contactsList);
        PrintJson.printJsonObj(response,contactsList);
    }

    private void getActivityListByNameAndNotByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到通过模糊查询相关市场活动，然后进行市场活动关联的控制层222...");
        String aname=request.getParameter("aname");
        //String clueId=request.getParameter("clueId");
        //后台操作流程为：通过anamem模糊查询出相关的市场活动，然后去掉已经关联了的市场活动，然后将其进行展示
        //Map<String,String> map=new HashMap<String, String>();
        //map.put("aname",aname);
        //map.put("clueId",clueId);
        AcitivityService acitivityService=(AcitivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList=acitivityService.getActivityListByNameAndNotByClueId2(aname);
        System.out.println("查询市场活动为："+activityList);
        PrintJson.printJsonObj(response,activityList);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //此处在跳转到添加页之前先进入控制器是为了能够动态输入owner
        System.out.println("进入到跳转到交易添加页的操作");

        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> uList = us.getUserList();

        request.setAttribute("uList", uList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request, response);
    }
}
