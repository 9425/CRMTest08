package crm.workbench.dao;

import crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {
    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    int unbund(String id);

    int bound(ClueActivityRelation clueActivityRelation);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int delete(ClueActivityRelation clueActivityRelation);
}
