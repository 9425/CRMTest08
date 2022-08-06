package crm.web.listener;

import crm.setting.domain.DicValue;
import crm.setting.service.DicService;
import crm.setting.service.Impl.DicServiceImpl;
import crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import javax.servlet.http.HttpSessionBindingEvent;
import java.util.*;

public class SysInitListener implements ServletContextListener,
        HttpSessionListener, HttpSessionAttributeListener {

    /*
    * 对于监听器的创建，监听器用于监听三个作用域，想要监听那个作用域，只要将所要监听的作用域实现即可
    * */
    // Public constructor is required by servlet spec
    public SysInitListener() {
    }

    // -------------------------------------------------------
    // ServletContextListener implementation
    // -------------------------------------------------------
    public void contextInitialized(ServletContextEvent event) {
      /* This method is called when the servlet context is
         initialized(when the Web application is deployed). 
         You can initialize servlet context related data here.
      */
      /*
      * event:
      *      该参数能够取得监听对象，监听的是什么对象，通过该参数就能够取得什么对象，
      *      现在我们监听的是上下文作用域对象，此时我们就能够取得上下文作用域对象。
      * */
        System.out.println("上下文对象与创建了...");
        System.out.println("服务器处理缓存字典开始啦...");
        ServletContext application=event.getServletContext();
        //我们需要将数据字典中的值从数据库中取出，将其存放于上下文作用域
        DicService dicService=(DicService) ServiceFactory.getService(new DicServiceImpl());
        /*
        * 现在考虑一下如何将数据字典中的值往前端进行传送？
        *     这里选择将其打包放置于上下文作用域中，每次使用数据字典中的数据时，不用走后台，直接从前端获取即可
        *     可以管业务层许所要分类好的List,然后将list打包到一个map中
        * */
        Map<String, List<DicValue>> map=dicService.getAll();
        //System.out.println(map.size());
        Set<String> set=map.keySet();
        //System.out.println(123);
        /*
        * map集合的遍历需要使用迭代器，因为map集合中含有key和value,但是List集合的遍历只要使用普通的for循环即可
        * */
        for (String key:set){
            System.out.println(key);
            System.out.println(map.get(key));
            application.setAttribute(key,map.get(key));
        }
        System.out.println("服务器处理数据字典结束啦...");


        //------------------------------------------------------------------------

        //数据字典处理完毕后，处理Stage2Possibility.properties文件
        /*

            处理Stage2Possibility.properties文件步骤：
                解析该文件，将该属性文件中的键值对关系处理成为java中键值对关系（map）

                Map<String(阶段stage),String(可能性possibility)> pMap = ....
                pMap.put("01资质审查",10);
                pMap.put("02需求分析",25);
                pMap.put("07...",...);

                pMap保存值之后，放在服务器缓存中
                application.setAttribute("pMap",pMap);

         */

        //解析properties文件

        Map<String,String> pMap = new HashMap<String,String>();

        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");

        Enumeration<String> e = rb.getKeys();

        while (e.hasMoreElements()){

            //阶段
            String key = e.nextElement();
            //可能性
            String value = rb.getString(key);

            pMap.put(key, value);


        }

        //将pMap保存到服务器缓存中
        application.setAttribute("pMap", pMap);

        System.out.println("阶段与可能性的对应处理结束了！");

    }

    public void contextDestroyed(ServletContextEvent sce) {
      /* This method is invoked when the Servlet Context 
         (the Web application) is undeployed or 
         Application Server shuts down.
      */
    }

    // -------------------------------------------------------
    // HttpSessionListener implementation
    // -------------------------------------------------------
    public void sessionCreated(HttpSessionEvent se) {
        /* Session is created. */
    }

    public void sessionDestroyed(HttpSessionEvent se) {
        /* Session is destroyed. */
    }

    // -------------------------------------------------------
    // HttpSessionAttributeListener implementation
    // -------------------------------------------------------

    public void attributeAdded(HttpSessionBindingEvent sbe) {
      /* This method is called when an attribute 
         is added to a session.
      */
    }

    public void attributeRemoved(HttpSessionBindingEvent sbe) {
      /* This method is called when an attribute
         is removed from a session.
      */
    }

    public void attributeReplaced(HttpSessionBindingEvent sbe) {
      /* This method is invoked when an attibute
         is replaced in a session.
      */
    }
}
