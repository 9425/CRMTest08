package crm.workbench.service;

import crm.vo.PaginationVO;
import crm.workbench.domain.Activity;
import crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface AcitivityService {
   boolean save(Activity a);

   PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String, Object> getUserListAndActivity(String id);

    boolean update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    boolean deleteRemark(String id);

    boolean saveRemark(ActivityRemark activityRemark);

    boolean updateRemark(ActivityRemark activityRemark);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByNameAndNotByClueId2(String aname);
}
