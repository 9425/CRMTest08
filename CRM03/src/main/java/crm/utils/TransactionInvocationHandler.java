package crm.utils;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.apache.ibatis.session.SqlSession;


//这个类非常重要，将zs带入，得到ls代理对象，我们通过这个类来进行实现，同时我们可以知道，如果在将zs带入了，得到ls对象进行处理，此时里面有try catch ，所以如果我们在遇到异常时，
//将会在ls中就进行处理了，如果我们想将异常放置到controller层进行处理，我们应该在此类中将异常进行再次抛出，使得controller层能够接收到异常
public class TransactionInvocationHandler implements InvocationHandler{
	
	private Object target;
	
	public TransactionInvocationHandler(Object target){
		
		this.target = target;
		
	}

	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
		
		SqlSession session = null;
		
		Object obj = null;
		
		try{
			session = SqlSessionUtil.getSqlSession();
			
			obj = method.invoke(target, args);
			
			session.commit();
		}catch(Exception e){
			session.rollback();
			e.printStackTrace();
			
			//处理的是什么异常，继续往上抛什么异常

			throw e.getCause();//这段代码非常重要，他将决定controller层能否接收到所抛出的异常
		}finally{
			SqlSessionUtil.myClose(session);
		}
		
		return obj;
	}
	
	public Object getProxy(){
		
		return Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(),this);
		
	}
	
}











































