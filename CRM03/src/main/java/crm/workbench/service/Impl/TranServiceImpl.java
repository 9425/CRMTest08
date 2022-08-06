package crm.workbench.service.Impl;

import crm.utils.DateTimeUtil;
import crm.utils.SqlSessionUtil;
import crm.utils.UUIDUtil;
import crm.vo.PaginationVO;
import crm.workbench.dao.CustomerDao;
import crm.workbench.dao.TranDao;
import crm.workbench.dao.TranHistoryDao;
import crm.workbench.dao.TranRemarkDao;
import crm.workbench.domain.Customer;
import crm.workbench.domain.Tran;
import crm.workbench.domain.TranHistory;
import crm.workbench.domain.TranRemark;
import crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImpl implements TranService {
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private CustomerDao customerDao=SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private TranHistoryDao tranHistoryDao=SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private TranRemarkDao tranRemarkDao=SqlSessionUtil.getSqlSession().getMapper(TranRemarkDao.class);

    public Map<String, Object> getCharts() {
        //取得total
        int total = tranDao.getTotal();

        //取得dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();

        //将total和dataList保存到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("total", total);
        map.put("dataList", dataList);

        //返回map
        return map;
    }

    public boolean changeStage(Tran t) {
        boolean flag = true;

        //改变交易阶段
        int count1 = tranDao.changeStage(t);
        if(count1!=1){

            flag = false;

        }

        //交易阶段改变后，生成一条交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        th.setPossibility(t.getPossibility());
        th.setStage(t.getStage());
        //添加交易历史
        int count2 = tranHistoryDao.save(th);
        if(count2!=1){

            flag = false;

        }

        return flag;
    }

    public List<TranHistory> getTranHistoryListByTranId(String tranId) {
        List<TranHistory> tranHistoryList=tranHistoryDao.getTranHistoryListByClueId(tranId);
        return tranHistoryList;
    }

    public boolean updateRemark(TranRemark tranRemark) {
        boolean flag=true;
        int count=tranRemarkDao.updateRemark(tranRemark);
        System.out.println("updateRemark："+count);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = tranRemarkDao.deleteById(id);
        if (count != 1) {
            return false;
        }
        return flag;
    }

    public boolean saveRemark(TranRemark tranRemark) {
        boolean flag = true;
        int count = tranRemarkDao.saveRemark(tranRemark);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    public List<TranRemark> getRemarkListByTranId(String tranId) {
        List<TranRemark> tranRemarkList = tranRemarkDao.getRemarkListByTranId(tranId);
        return tranRemarkList;
    }

    public Tran detail(String id) {
        Tran tran = tranDao.detail(id);
        System.out.println("Tran：" + tran);
        return tran;
    }

    public boolean save(Tran t, String customerName) {
           /*

            交易添加业务：

                在做添加之前，参数t里面就少了一项信息，就是客户的主键，customerId

                先处理客户相关的需求

                （1）判断customerName，根据客户名称在客户表进行精确查询
                       如果有这个客户，则取出这个客户的id，封装到t对象中
                       如果没有这个客户，则再客户表新建一条客户信息，然后将新建的客户的id取出，封装到t对象中

                （2）经过以上操作后，t对象中的信息就全了，需要执行添加交易的操作

                （3）添加交易完毕后，需要创建一条交易历史



         */

        boolean flag = true;

        Customer cus = customerDao.getCustomerByName(customerName);
        System.out.println("根据客户名字查出客户为："+cus);

        //如果cus为null，需要创建客户
        if(cus==null){

            System.out.println("因为所查客户为null，需要新建客户");
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setNextContactTime(t.getNextContactTime());
            cus.setOwner(t.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if(count1!=1){
                flag = false;
            }
            System.out.println("新建客户保存成功，新建客户为："+cus);
        }

        //通过以上对于客户的处理，不论是查询出来已有的客户，还是以前没有我们新增的客户，总之客户已经有了，客户的id就有了
        //将客户id封装到t对象中
        t.setCustomerId(cus.getId());

        //添加交易
        int count2 = tranDao.save(t);
        if(count2!=1){
            flag = false;
        }
        System.out.println("新建交易保存成功，新建交易为："+t);

        //添加交易历史
        System.out.println("交易新建成功后需要创建新的交易历史");
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());
        th.setPossibility(t.getPossibility());//此处为新添加的possibility
        int count3 = tranHistoryDao.save(th);
        if(count3!=1){
            flag = false;
        }
        System.out.println("交易历史创建成功，新建交易历史为："+th);
        return flag;
    }

    public PaginationVO<Tran> pageList(Map<String, Object> map) {
        int total = tranDao.getTotalByCondition(map);
        System.out.println(total);
        List<Tran> dataList = tranDao.getTranListByCondition(map);
        System.out.println(dataList.toString());
        //创建一个vo对象，将total和dataList封装到VO中
        PaginationVO<Tran> vo = new PaginationVO<Tran>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        return vo;
    }
}
