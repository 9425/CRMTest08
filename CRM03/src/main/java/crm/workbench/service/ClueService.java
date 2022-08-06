package crm.workbench.service;

import crm.vo.PaginationVO;
import crm.workbench.domain.Activity;
import crm.workbench.domain.Clue;
import crm.workbench.domain.ClueRemark;
import crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    PaginationVO<Clue> pageList(Map<String, Object> map);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue clue);

    boolean delete(String[] ids);

    Clue detail(String id);

    Clue showDetail(String id);

    List<ClueRemark> getRemarkListByAid(String clueId);

    boolean saveRemark(ClueRemark clueRemark);

    boolean deleteRemark(String id);

    boolean unbund(String id);

    boolean bound(String clueId, String[] activityId);

    boolean convert(String clueId, Tran tran, String createBy);

    boolean updateRemark(ClueRemark clueRemark);
}
