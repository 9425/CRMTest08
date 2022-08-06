package crm.workbench.dao;

import crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {
    List<TranRemark> getRemarkListByTranId(String tranId);

    int saveRemark(TranRemark tranRemark);

    int deleteById(String id);

    int updateRemark(TranRemark tranRemark);
}
