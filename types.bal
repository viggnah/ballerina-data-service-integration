type DatabaseConfig record {|
    string USER;
    string HOST;
    int PORT;
    string DATABASE;
|};

type Customer record {
    record {
        string first_name;
        string last_name;
    } name;
    string date_of_birth;
    string email;
};