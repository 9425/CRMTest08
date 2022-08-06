package crm.workbench.service;

import crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> getContactsListByName(String aname);
}
