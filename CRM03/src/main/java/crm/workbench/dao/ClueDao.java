package crm.workbench.dao;

import crm.workbench.domain.Activity;
import crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    int save(Clue clue);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    Clue getById(String id);

    int update(Clue clue);

    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    Clue detail(String id);

    int delete(String clueId);
}
