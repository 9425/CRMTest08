package crm.workbench.service.Impl;

import crm.setting.dao.UserDao;
import crm.setting.domain.User;
import crm.utils.DateTimeUtil;
import crm.utils.ServiceFactory;
import crm.utils.SqlSessionUtil;
import crm.utils.UUIDUtil;
import crm.vo.PaginationVO;
import crm.workbench.dao.*;
import crm.workbench.domain.*;
import crm.workbench.service.ClueService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao=SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);

    public boolean updateRemark(ClueRemark clueRemark) {
        boolean flag=true;
        int count=clueRemarkDao.updateRemark(clueRemark);
        System.out.println("updateRemark："+count);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean convert(String clueId, Tran tran, String createBy) {
        //相当于要调用三个dao层，将contact和costumer,还有tran进行插入到三张表中
        String createTime = DateTimeUtil.getSysTime();
        boolean flag = true;
        //(1)通过线索id获取线索对象（线索对象当中封装了线索的信息）从中可以提取客户，联系人信息
        Clue c = clueDao.getById(clueId);
        System.out.println("通过clueId获取clue对象成功，clue对象为："+c);

        //(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        //转换的时候要判断客户是否存在，不存在要进行创建

        //以公司名字作为客户对象，创建客户
        String company = c.getCompany();
        Customer cus = customerDao.getCustomerByName(company);
        System.out.println("查询是否有客户对象成功，客户对象为："+cus);
        //如果cus为null，说明以前没有这个客户，需要新建一个
        if (cus == null) {
            System.out.println("因为此客户对象为空，所以需要创建客户对象");
            //通过线索提取客户信息
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setAddress(c.getAddress());
            cus.setWebsite(c.getWebsite());
            cus.setPhone(c.getPhone());
            cus.setOwner(c.getOwner());
            cus.setNextContactTime(c.getNextContactTime());
            cus.setName(company);
            cus.setDescription(c.getDescription());
            cus.setCreateTime(createTime);
            cus.setCreateBy(createBy);
            cus.setContactSummary(c.getContactSummary());
            //添加客户
            int count1 = customerDao.save(cus);
            System.out.println("客户对象创建成功,客户对象为："+cus);
            if (count1 != 1) {
                flag = false;
            }

        }
        //--------------------------------------------------------------------------
        //经过第二步处理后，客户的信息我们已经拥有了，将来在处理其他表的时候，如果要使用到客户的id
        //直接使用cus.getId();
        //--------------------------------------------------------------------------

        //(3)通过线索对象提取联系人信息，保存联系人
        System.out.println("通过线索对象提取联系人信息，保存联系人，此步骤不用判断联系人是否存在");
        Contacts con = new Contacts();
        con.setId(UUIDUtil.getUUID());
        con.setSource(c.getSource());
        con.setOwner(c.getOwner());
        con.setNextContactTime(c.getNextContactTime());
        con.setMphone(c.getMphone());
        con.setJob(c.getJob());
        con.setFullname(c.getFullname());
        con.setEmail(c.getEmail());
        con.setDescription(c.getDescription());
        con.setCustomerId(cus.getId());
        con.setCreateTime(createTime);
        con.setCreateBy(createBy);
        con.setContactSummary(c.getContactSummary());
        con.setAppellation(c.getAppellation());
        con.setAddress(c.getAddress());
        //添加联系人
        int count2 = contactsDao.save(con);
        System.out.println("联系人保存成功,所保存联系人为："+con);
        if (count2 != 1) {
            flag = false;
        }

        //--------------------------------------------------------------------------
        //经过第三步处理后，联系人的信息我们已经拥有了，将来在处理其他表的时候，如果要使用到联系人的id
        //直接使用con.getId();
        //--------------------------------------------------------------------------

        //(4) 线索备注转换到客户备注以及联系人备注
        //查询出与该线索关联的备注信息列表
        System.out.println("需要将线索的备注转换为客户以及联系人备注");
        List<ClueRemark> clueRemarkList = clueRemarkDao.getRemarkListByAid(clueId);
        System.out.println("需要转换的线索备注为："+clueRemarkList);
        //取出每一条线索的备注
        for (ClueRemark clueRemark : clueRemarkList) {

            //取出备注信息（主要转换到客户备注和联系人备注的就是这个备注信息）
            String noteContent = clueRemark.getNoteContent();

            //创建客户备注对象，添加客户备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setCustomerId(cus.getId());
            customerRemark.setEditFlag("0");
            customerRemark.setNoteContent(noteContent);
            int count3 = customerRemarkDao.save(customerRemark);
            if (count3 != 1) {
                flag = false;
            }

            //创建联系人备注对象，添加联系人
            ContactsRematk contactsRemark = new ContactsRematk();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setContactsId(con.getId());
            contactsRemark.setEditFlag("0");
            contactsRemark.setNoteContent(noteContent);
            int count4 = contactsRemarkDao.save(contactsRemark);
            if (count4 != 1) {
                flag = false;
            }

        }
        System.out.println("线索备注转换为客户以及联系人备注成功");

        //(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
        //查询出与该条线索关联的市场活动，查询与市场活动的关联关系列表
        System.out.println("需要将线索和市场活动的关系转化为联系人和市场活动的关系");
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByClueId(clueId);
        System.out.println("需要转换的线索和市场活动关系为："+clueActivityRelationList);
        //遍历出每一条与市场活动关联的关联关系记录
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {

            //从每一条遍历出来的记录中取出关联的市场活动id
            String activityId = clueActivityRelation.getActivityId();

            //创建 联系人与市场活动的关联关系对象 让第三步生成的联系人与市场活动做关联
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setContactsId(con.getId());
            //添加联系人与市场活动的关联关系
            int count5 = contactsActivityRelationDao.save(contactsActivityRelation);
            if (count5 != 1) {
                flag = false;
            }


        }
        System.out.println("将线索和市场活动关系转换为联系人和市场活动关系成功");
        //(6)如果有创建交易需求，创建一条交易
        if (tran != null) {
            System.out.println("此时交易不为null,有交易需求，需要创建交易");
            /*

                tran对象在controller里面已经封装好的信息如下：
                    id,money,name,expectedDate,stage,activityId,createBy,createTime

                接下来可以通过第一步生成的c对象，取出一些信息，继续完善对t对象的封装

             */

            tran.setSource(c.getSource());
            tran.setOwner(c.getOwner());
            tran.setNextContactTime(c.getNextContactTime());
            tran.setDescription(c.getDescription());
            tran.setCustomerId(cus.getId());
            tran.setContactSummary(c.getContactSummary());
            tran.setContactsId(con.getId());
            //添加交易
            int count6 = tranDao.save(tran);
            System.out.println("创建交易成功,创建的交易为："+tran);
            if (count6 != 1) {
                flag = false;
            }

            //(7)如果创建了交易，则创建一条该交易下的交易历史
            System.out.println("创建交易的同时需要创建交易历史");
            TranHistory th = new TranHistory();
            th.setId(UUIDUtil.getUUID());
            th.setCreateBy(createBy);
            th.setCreateTime(createTime);
            th.setExpectedDate(tran.getExpectedDate());
            th.setMoney(tran.getMoney());
            th.setStage(tran.getStage());
            th.setTranId(tran.getId());
            //添加交易历史
            int count7 = tranHistoryDao.save(th);
            System.out.println("创建交易历史成功，创建的交易历史为："+th);
            if(count7!=1){
                flag = false;
            }
        }

        //(8)删除线索备注
        for(ClueRemark clueRemark : clueRemarkList){

            int count8 = clueRemarkDao.delete(clueRemark);
            if(count8!=1){
                flag = false;
            }

        }
        System.out.println("线索备注转换完毕需要进行删除，删除成功");

        //(9) 删除线索和市场活动的关系
        for(ClueActivityRelation clueActivityRelation : clueActivityRelationList){

            int count9 = clueActivityRelationDao.delete(clueActivityRelation);
            if(count9!=1){

                flag = false;

            }

        }
        System.out.println("线索和市场活动关系转换完毕需要进行删除，删除成功");


        //(10) 删除线索
        int count10 = clueDao.delete(clueId);
        if(count10!=1){
            flag = false;
        }
        System.out.println("线索转换完毕需要进行删除，删除成功，flag："+flag);
        return flag;
    }

    public boolean bound(String clueId, String[] activityId) {
        //此处如果有多个市场活动需要进行关联怎么办？
        //将activityId进行遍历，没取出一个activityId时就进行关联一次
        boolean flag = true;
        for (String activityID : activityId) {
            //没取出一个activityId就进行关联一次
            //关联的方式就是直接创建一个clue_activity_relation对象然后进行赋值
            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtil.getUUID());
            clueActivityRelation.setActivityId(activityID);
            clueActivityRelation.setClueId(clueId);
            int count = clueActivityRelationDao.bound(clueActivityRelation);
            if (count != 1) {
                flag = false;
            }
        }
        return flag;
    }

    public boolean unbund(String id) {
        boolean flag = true;
        int count = clueActivityRelationDao.unbund(id);
        if (count != 1) {
            return false;
        }
        return flag;
    }

    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = clueRemarkDao.deleteById(id);
        if (count != 1) {
            return false;
        }
        return flag;
    }

    public boolean saveRemark(ClueRemark clueRemark) {
        boolean flag = true;
        int count = clueRemarkDao.saveRemark(clueRemark);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    public List<ClueRemark> getRemarkListByAid(String clueId) {
        List<ClueRemark> clueRemarkList = clueRemarkDao.getRemarkListByAid(clueId);
        return clueRemarkList;
    }

    public Clue showDetail(String id) {
        Clue clue = clueDao.detail(id);
        return clue;
    }

    public Clue detail(String id) {
        Clue clue = clueDao.detail(id);
        System.out.println("Clue：" + clue);
        return clue;
    }

    public boolean delete(String[] ids) {
        //从一张表中删除clue,需要将所有与clue相关联的全部删除，斩草除根
        boolean flag = true;
        //首先clue会影响clueReamrk，影响clueActivityRelation,在删除clue之前，应该将这与clue有关的这两个进行删除

        //将相关联的线索备注删除
        int count1 = clueRemarkDao.getCountByAids(ids);
        System.out.println("线索备注：" + count1);
        int count2 = clueRemarkDao.deleteByAids(ids);
        System.out.println("线索备注：" + count2);
        if (count1 != count2) {
            flag = false;
            return flag;
        }
        //将相关联的线索活动关系删除
        int count3 = clueActivityRelationDao.getCountByAids(ids);
        System.out.println("线索市场活动关系：" + count3);
        int count4 = clueActivityRelationDao.deleteByAids(ids);
        System.out.println("线索市场活动关系：" + count4);
        if (count3 != count4) {
            flag = false;
            return flag;
        }

        //将线索进行删除
        int count5 = clueDao.getCountByAids(ids);
        System.out.println("线索：" + count5);
        int count6 = clueDao.deleteByAids(ids);
        System.out.println("线索：" + count6);
        if (count5 != count6) {
            flag = false;
            return flag;
        }
        //传过来的是一个数组，怎样使用dao将其中的每一个获取然后从数据库中进行删除呢？
        //可以将数组直接传入dao中进行处理，不用将数组中的数据一个个提取出来，然后进行处理，下面提取数组中数据的方式是不合理的
        /*for (int i=0;i<ids.length;i++){
            count+=clueDao.delete(ids[i]);
        }
        if (count!=ids.length){
            flag=false;
            return flag;
        }else {
            return flag;
        }*/

        return flag;
    }

    public boolean update(Clue clue) {
        boolean flag = true;
        int count = clueDao.update(clue);
        if (count != 1) {
            flag = false;
            return flag;
        } else {
            return flag;
        }
    }

    public Map<String, Object> getUserListAndClue(String id) {
        List<User> list = userDao.getUserList();
        Clue clue = clueDao.getById(id);
        Map<String, Object> map = new HashMap<String, Object>();
        System.out.println("list:========" + list);
        System.out.println("clue:========" + clue);
        map.put("uList", list);
        map.put("c", clue);
        return map;
    }

    public PaginationVO<Clue> pageList(Map<String, Object> map) {
        int total = clueDao.getTotalByCondition(map);
        System.out.println(total);
        List<Clue> dataList = clueDao.getClueListByCondition(map);
        System.out.println(dataList.toString());
        //创建一个vo对象，将total和dataList封装到VO中
        PaginationVO<Clue> vo = new PaginationVO<Clue>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        return vo;
    }
    /*public PaginationVO<Clue> pageList(Map<String, Object> map) {
        int total=clueDao.getTotalByCondition(map);
        System.out.println(total);
        List<Clue> dataList=clueDao.getClueListByCondition(map);
        //创建一个vo对象，将total和dataList封装到VO中
        PaginationVO<Clue> vo=new PaginationVO<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        return vo;
    }*/
    /*public PaginationVO<Activity> pageList(Map<String, Object> map) {
        //获取返回的数据总条数
        //获取数据总条数的目的是为了进行数据的分页和显示
        int total=clueDao.getTotalByCondition(map);
        System.out.println(total);
        //取得dataList
        List<Activity> dataList=clueDao.getClueListByCondition(map);
        //创建一个vo对象，将total和dataList封装到VO中
        PaginationVO<Activity> vo=new PaginationVO<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        return vo;
    }*/

    public boolean save(Clue clue) {
        boolean flag = true;
        int count = clueDao.save(clue);
        System.out.println(count);
        if (count == 1) {
            return flag;
        } else {
            flag = false;
            return flag;
        }
    }
}