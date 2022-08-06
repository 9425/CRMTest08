package crm.utils;

public class ServiceFactory {


	/*
	* 此类的作用是传入需要被代理的对象，创建出代理对象
	* */
	public static Object getService(Object service){
		
		return new TransactionInvocationHandler(service).getProxy();
		
	}
	
}
