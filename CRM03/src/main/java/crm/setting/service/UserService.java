package crm.setting.service;

import crm.exception.LoginException;
import crm.setting.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct,String loginPwd,String ip)throws LoginException;
    List<User> getUserList();
}
