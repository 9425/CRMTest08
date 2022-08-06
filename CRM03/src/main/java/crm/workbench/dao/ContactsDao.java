package crm.workbench.dao;

import crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {
    int save(Contacts con);

    List<Contacts> getContactsListByName(String aname);
}
