package setting.test;

import crm.utils.DateTimeUtil;
import crm.utils.MD5Util;
import crm.utils.SqlSessionUtil;
import crm.workbench.dao.ClueDao;
import org.apache.ibatis.session.SqlSession;

public class test1 {
    private ClueDao clueDao=SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    public static void main(String[] args) {
        /*//验证失效时间
        String expireTime="2018-08-10 10:10:10";
        //当前系统时间
        String currentTime= DateTimeUtil.getSysTime();
        int count=expireTime.compareTo(currentTime);
        System.out.println(count);*/

        /*//验证账号是否处于锁定状态
        String lockState="0";
        if("0".equals(lockState)){
            System.out.println("账号被锁定，请联系管理员进行处理！");
        }*/

        /*//验证浏览器ip地址
        String ip="192.168.1.3";
        //允许访问的ip地址群
        String allowIps="192.168.1.1,192.168.1.2";
        if (allowIps.contains(ip)){
            System.out.println("ip地址有效，允许访问系统");
        }else {
            System.out.println("ip地址受限，请联系相关管理员进行处理！");
        }*/

        //此时MD5密文进行加密
       /* String pwd="yhnysgcgwjddndt1";
        pwd= MD5Util.getMD5(pwd);
        System.out.println(pwd);*/

       /*
       * 测试SqlSessionUtil工具哪里出了问题：
       *
       * */
   /*     System.out.println(123);
        SqlSession session= SqlSessionUtil.getSqlSession();
        System.out.println(session);*/

         System.out.println();
    }
}
