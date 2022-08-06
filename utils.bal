import ballerinax/mysql;
import ballerina/sql;
import ballerina/file;
import ballerina/io;

function createMysqlConnection(DatabaseConfig databaseConfig) returns mysql:Client|sql:Error {
    return check new(host=databaseConfig.HOST, port=databaseConfig.PORT, user=databaseConfig.USER, database=databaseConfig.DATABASE);
}

function writeToCsvFile(string[] csvRow) returns error? {
    string filePath = <string>local_csv_file["PATH"];
    if check file:test(filePath, file:EXISTS) is false { 
        check createCsvFileWithHeader(filePath);
    }
    string[][] csvContent = [csvRow];
    check io:fileWriteCsv(filePath, csvContent, io:APPEND);
}

function createCsvFileWithHeader(string filePath) returns error? {
    string[][] header = [["CustomerID", "FirstName", "LastName", "CreatedDateTime"]];
    check io:fileWriteCsv(filePath, header);
}
