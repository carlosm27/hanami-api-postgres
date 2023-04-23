class App < Hanami::API
    
use Hanami::Middleware::BodyParser, :json

DB_HOST = 'localhost'
DB_PORT = 5432
DB_NAME = 'hanami_db'
DB_USER = 'postgres'
DB_PASSWORD = 'Barcelona.1899'

db = PG::Connection.new(
    host: DB_HOST,
    port: DB_PORT,
    dbname: DB_NAME,
    user: DB_USER,
    password: DB_PASSWORD
  )

  user = {

    name: 'Jane',
    profession: 'Accountant'
  }
    db.exec("DROP TABLE IF EXISTS records;")
    db.exec("CREATE TABLE IF NOT EXISTS records (id SERIAL PRIMARY KEY, name varchar (150) NOT NULL, profession varchar (150) NOT NULL);")
    db.exec("INSERT INTO records (name, profession) VALUES ($1, $2)", [user[:name], user[:profession]])
      

  def create_records(db)
    conn.transaction do |txn|
      txn.execute("DROP TABLE IF EXISTS records;")
      txn.exec("CREATE TABLE IF NOT EXISTS records (id INT PRIMARY KEY, name varchar (150) NOT NULL, profession varchar (150) NOT NULL);")
      txn.exec("INSERT INTO records (name, profession) VALUES (%s, %s), (Carlos, Student)")
      
      puts 'Table created successfully'
    end
  end
  # Create a new record
  post '/records' do
    puts params
    sql = "INSERT INTO records (name, profession) VALUES ($1, $2) RETURNING id, name, profession"
    result = db.exec(sql, [params[:name], params[:profession]])
    json result.first.to_h
  end

  # Get all records
  get '/records' do
    sql = "SELECT id, name, profession FROM records"
    result = db.exec(sql)
    json result.map { |record| { id: record['id'], name: record['name'], description: record['profession'] } }
  end

end  