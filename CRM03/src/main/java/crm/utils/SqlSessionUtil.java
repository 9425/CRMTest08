package crm.utils;

import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class SqlSessionUtil {
	
	private SqlSessionUtil(){

	}


	/*
	* 这个类的作用就是创建session，使用my-batis框架
	* */
	private static SqlSessionFactory factory;
	
	static{
		
		String resource = "mybatis-config.xml";
		InputStream inputStream = null;
		//Reader reader=null;
		try {
			//加载主配置文件
			inputStream = Resources.getResourceAsStream(resource);
			//reader=Resources.getResourceAsReader(resource);
		} catch (IOException e) {
			e.printStackTrace();
		}
		//创建SqlSessionFactory对象
		factory =
		 new SqlSessionFactoryBuilder().build(inputStream);
		
	}
	
	private static ThreadLocal<SqlSession> t = new ThreadLocal<SqlSession>();
	
	public static SqlSession getSqlSession(){
		
		SqlSession session = t.get();
		
		if(session==null){
			//通过工厂对象获得SqlSession对象
			session = factory.openSession();
			t.set(session);
		}
		
		return session;
		
	}
	
	public static void myClose(SqlSession session){
		
		if(session!=null){
			session.close();
			t.remove();
		}
		
	}
	
	
}
