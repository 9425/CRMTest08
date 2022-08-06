package crm.workbench.dao;

import crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    List<ClueRemark> getRemarkListByAid(String clueId);

    int saveRemark(ClueRemark clueRemark);

    int deleteById(String id);

    int delete(ClueRemark clueRemark);

    int updateRemark(ClueRemark clueRemark);
}
