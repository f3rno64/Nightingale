use nightingale_development;

if(db.system.users.find().count() == 0) {
  db.addUser("nightingale", "XdBWymEvQ1tGyd6XSSxxpeBdm5QGKTga");
}
