package crm.setting.service.Impl;

import crm.exception.LoginException;
import crm.setting.dao.UserDao;
import crm.setting.domain.User;
import crm.setting.service.UserService;
import crm.utils.DateTimeUtil;
import crm.utils.SqlSessionUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    private SqlSession session=SqlSessionUtil.getSqlSession();
    private UserDao userDao=session.getMapper(UserDao.class);
    //private UserDao userDao= SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String,String> map=new HashMap<String, String>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user=userDao.login(map);//通过login方法与数据库的交互，获得user对象，进行登录验证

        System.out.println(user);//此行的作用是验证到这里时，是否成功从数据库中查询出了user对象

        if (user==null){
            throw new LoginException("账号密码错误，请验证后在登录!");
        }
        //如果程序能够成功执行到该行，说明账号密码正确，需要进行验证下面的信息
        //验证账号有效时间是否过期
        //判断账号的锁定状态
        //判断ip地址是否在有效范围内

        //验证时间
        String expireTime=user.getExpireTime();
        String currentTime= DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime)<0){
            throw new LoginException("账号已超出有限使用时间，请联系相关管理员！");
        }

        //判断锁定状态
        String lockState=user.getLockState();
        if ("0".equals(lockState)){
            throw new LoginException("账号已锁定，请联系管理员进行处理");

        }
        //判断ip地址
        String allowIps=user.getAllowIps();
        if (!allowIps.contains(ip)){
            throw new LoginException("ip地址受限，请在允许范围内使用！");
        }
        //如果程序能够执行到此处，证明一切正常，返回user对象
        return user;
    }

    public List<User> getUserList() {
        List<User> userList=userDao.getUserList();
        return userList;
    }
}
