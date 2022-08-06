package crm.workbench.service.Impl;

import crm.setting.dao.UserDao;
import crm.setting.domain.User;
import crm.utils.SqlSessionUtil;
import crm.vo.PaginationVO;
import crm.workbench.dao.ActivityDao;
import crm.workbench.dao.ActivityRemarkDao;
import crm.workbench.domain.Activity;
import crm.workbench.domain.ActivityRemark;
import crm.workbench.service.AcitivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements AcitivityService {
    //当实现了一个服务的接口时，要使得能够在mapper文件中直接编写sql语句，需要在其中进行接口类的注册
    private ActivityDao activityDao= SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private UserDao userDao=SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    //在dao层中注册了这种变量，使其加载到mapper文件中，后面维持mapper文件中的方法名与此处的方法名一致，即可以直接写sql语句
    private ActivityRemarkDao activityRemarkDao=SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);

    public List<Activity> getActivityListByNameAndNotByClueId2(String aname) {
        List<Activity> activityList=activityDao.getActivityListByNameAndNotByClueId2(aname);
        return activityList;
    }

    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map) {
        List<Activity> activityList=activityDao.getActivityListByNameAndNotByClueId(map);
        return activityList;
    }

    public List<Activity> getActivityListByClueId(String clueId) {
        List<Activity> activityList=activityDao.getActivityListByClueId(clueId);
        return activityList;
    }

    public boolean updateRemark(ActivityRemark activityRemark) {
        boolean flag=true;
        int count=activityRemarkDao.updateRemark(activityRemark);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean deleteRemark(String id) {
        boolean flag=true;
        int count=activityRemarkDao.deleteById(id);
        if (count!=1){
            return false;
        }
        return flag;
    }

    public boolean saveRemark(ActivityRemark activityRemark) {
        boolean flag=true;
        int count=activityRemarkDao.saveRemark(activityRemark);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean save(Activity a) {
        boolean flag=true;
        int count= activityDao.save(a);   //具体与数据库的交互由dao层进行实现
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    public PaginationVO<Activity> pageList(Map<String, Object> map) {
        //获取返回的数据总条数
        //获取数据总条数的目的是为了进行数据的分页和显示
        int total=activityDao.getTotalByCondition(map);
        System.out.println(total);
        //取得dataList
        List<Activity> dataList=activityDao.getActivityListByCondition(map);
        System.out.println(dataList);
        //创建一个vo对象，将total和dataList封装到VO中
        PaginationVO<Activity> vo=new PaginationVO<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        return vo;
    }

    //此处传入的数组ids即为前端在复选框中选取的id值；
    public boolean delete(String[] ids) {
        boolean flag=true;
        //因为市场活动的备注是与是市场活动相关联的，我们删除市场活动时，必须同时删除与之相关的备注
        //查询出需要删除的备注的数量

        //在activityRemark表中，activityRemark中的activityId等于activity表中的id,两张表通过此进行关联
        int count1=activityRemarkDao.getCountByAids(ids);
        //删除备注，返回受到影响的条数（实际删除的数量）
        int count2=activityRemarkDao.deleteByAids(ids);
        if (count1!=count2){
            return false;
        }
        //删除市场活动
        int count3=activityDao.delete(ids);
        if (count3!=ids.length){
            return false;
        }
        return flag;
    }

    public Activity detail(String id) {
        Activity activity=activityDao.detail(id);
        return activity;
    }

    public List<ActivityRemark> getRemarkListByAid(String activityId) {
        List<ActivityRemark> activityRemarkList=activityRemarkDao.getRemarkListByAid(activityId);
        return activityRemarkList;
    }

    public boolean update(Activity activity) {
        boolean flag=true;
        int count=activityDao.update(activity);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    public Map<String, Object> getUserListAndActivity(String id) {
        //取uList
        List<User> userList=userDao.getUserList();
        //取a(a是所修改的具体市场活动的信息)
        Activity activity=activityDao.getById(id);
        //将uList和a打包封装到map中
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("uList",userList);
        map.put("a",activity);
        //将map返回到控制层转化为json字符串，然后通过控制层发送到前端页面即可
        return map;
    }
}
