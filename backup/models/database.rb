Backup::Model.new(:contacts_db, 'Backup database') do
  split_into_chunks_of 250

  db_config           = YAML.load_file('config/database.yml')['production']
  app_config          = YAML.load_file('config/application.yml')

  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = db_config['database']
    db.username           = db_config['username']
    db.password           = db_config['password']
    db.host               = db_config['host']
    db.port               = 3306
    db.additional_options = ['--quick']#, "--single-transaction"]
  end

  compress_with Gzip

  store_with SFTP do |server|
    server.username = app_config['BACKUP_USERNAME']
    server.password = app_config['BACKUP_PASSWORD']
    server.ip       = app_config['BACKUP_HOST']
    server.port     = 22
    server.path     = '~/MySQL'
    server.keep     = 5
    # Additional options for the SSH connection.
    # server.ssh_options = {}
  end

end
