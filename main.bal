import ballerina/io;
import ballerina/http;
import ballerinax/mysql;
import ballerina/time;
import ballerina/sql;

configurable DatabaseConfig database_config = ?;
configurable map <int> service_config = ?;
configurable map <string> local_csv_file = ?;

service /customer on new http:Listener(<int>service_config["PORT"]) {

    resource function post create (@http:Payload json payload) returns string|error? {
        Customer customer = check payload.fromJsonWithType();

        mysql:Client mysqlClient = check createMysqlConnection(database_config);
        sql:ExecutionResult result = check insertCustomerIntoDB(mysqlClient, customer);
        io:println(result);

        // check writeToCsvFile(createCsvRow(result, customer));
        return "Successfully inserted customer into database with CustomerID = " + result.lastInsertId.toString();
    }
}

function insertCustomerIntoDB(mysql:Client mysqlClient, Customer customer) returns sql:ExecutionResult|sql:Error {
    return check mysqlClient->execute(`
            INSERT INTO Customers (FirstName, LastName, DOB, Email)
            VALUES (${customer.name.first_name}, ${customer.name.last_name},  
                ${customer.date_of_birth}, ${customer.email})
        `);
}

function createCsvRow(sql:ExecutionResult result, Customer customer) returns string[] {
    string customerCreatedDateTime = time:utcToString(time:utcNow(3));
    string lastInsertId = result.lastInsertId.toString();
    return [lastInsertId, customer.name.first_name, customer.name.last_name, customerCreatedDateTime];
}