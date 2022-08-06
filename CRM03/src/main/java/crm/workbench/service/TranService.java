package crm.workbench.service;

import crm.vo.PaginationVO;
import crm.workbench.domain.Tran;
import crm.workbench.domain.TranHistory;
import crm.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

public interface TranService {

    PaginationVO<Tran> pageList(Map<String, Object> map);

    boolean save(Tran t, String customerName);

    Tran detail(String id);

    List<TranRemark> getRemarkListByTranId(String tranId);

    boolean saveRemark(TranRemark tranRemark);

    boolean deleteRemark(String id);

    boolean updateRemark(TranRemark tranRemark);

    List<TranHistory> getTranHistoryListByTranId(String tranId);

    boolean changeStage(Tran t);

    Map<String, Object> getCharts();
}
