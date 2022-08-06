package crm.workbench.service.Impl;

import crm.utils.SqlSessionUtil;
import crm.workbench.dao.ContactsDao;
import crm.workbench.domain.Contacts;
import crm.workbench.service.ContactsService;

import java.util.List;

public class ContactsServiceImpl implements ContactsService {
    private ContactsDao contactsDao= SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    public List<Contacts> getContactsListByName(String aname) {
        List<Contacts> contactsList=contactsDao.getContactsListByName(aname);
        return contactsList;
    }
}
