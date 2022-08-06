package crm.vo;

import java.util.ArrayList;
import java.util.List;


//对于泛型的使用，如果要在一个类的里面使用泛型，必须前类名上就加上泛型
public class PaginationVO<T> {
    private int total;
    private List<T> dataList;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total){
        this.total=total;
    }

    public List<T> getDataList(){
        return dataList;
    }

    public void setDataList(List<T> dataList){
        this.dataList=dataList;
    }
}
