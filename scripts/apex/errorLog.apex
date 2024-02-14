try{
    Contact newC = new Contact();
    newC.Email = 'newc@test.com';
    newC.Phone = null;
    newC.Title = 'NewC';

    insert newC;
} catch (Exception ex) {
    System.debug('ex:' + ex.getMessage());
    ErrorLogHelper.CreateError('test', 'errorlog', ex.getMessage());
}
