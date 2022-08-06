package crm.setting.dao;

import crm.setting.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User login(Map<String, String> map);//等下调用此处的方法，进行与数据库的交互，然后获得所需的数据
    List<User> getUserList();
}
