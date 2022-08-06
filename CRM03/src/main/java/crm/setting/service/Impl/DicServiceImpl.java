package crm.setting.service.Impl;

import crm.setting.dao.DicTypeDao;
import crm.setting.dao.DicValueDao;
import crm.setting.domain.DicType;
import crm.setting.domain.DicValue;
import crm.setting.service.DicService;
import crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicServiceImpl implements DicService {
    /*
    * 使用到那个Dao,我们就要映射哪一个Dao
    *
    * */
    private DicValueDao dicValueDao= SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);
    private DicTypeDao dicTypeDao=SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);

    public Map<String, List<DicValue>> getAll() {
        //现在考虑怎么样才能实现将数据库中的数据分为多个List集合，然后打包放到map集合中
        Map<String,List<DicValue>> map=new HashMap<String, List<DicValue>>();
        //将其分类我们使用到DicType中的code在循环中进行分类放置于List集合中
        //将字典类型列表取出
        List<DicType> dicTypeList=dicTypeDao.getTypeList();
        //将字典类型列表遍历
        for (DicType dicType:dicTypeList){
            //取得每一种类型的字符编码
            String code=dicType.getCode();

            //根据所取得的字符编码，获取字典值列表
            List<DicValue> dicValueList=dicValueDao.getListByCode(code);
            //每一次将取回的值放置于map中
            map.put(code,dicValueList);
        }
        return map;
    }
}
