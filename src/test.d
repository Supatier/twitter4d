import twitter4d;
import std.stdio, std.json, std.conv, std.regex;
import std.file;

int main() {
        string configLocation = "config.json";
        JSONValue[string] config = parseJSON(readText(configLocation)).object;
        Twitter4D t4d;
        if (!configLocation.exists) {
                writeln("Config file not found.");
                return 1;
        }
        if ("consumerKey" !in config) {
                writeln("Consumer key not found, please check your config file.");
                return 1;
        }
        if ("consumerSecret" !in config) {
                writeln("Consumer secret not found, please check your config file.");
                return 1;
        }

        if ("accessToken" in config && "accessTokenSecret" in config) {
                t4d = new Twitter4D(cleanJSONString(config["consumerKey"]), cleanJSONString(config["consumerSecret"]),
                                cleanJSONString(config["accessToken"]),
                                cleanJSONString(config["accessTokenSecret"]));
        } else {
                writeln("Access token not found, ignoring.");
                t4d = new Twitter4D(cleanJSONString(config["consumerKey"]),
                                cleanJSONString(config["consumerSecret"]));
        }

        writeln(t4d.request("POST", "statuses/update.json", ["status" : "test"]));
        writeln(parseJSON(t4d.request("GET", "account/verify_credentials.json", ["" : ""])));

        foreach (line; t4d.stream()) {
                if (match(line.to!string, regex(r"\{.*\}"))) {
                        auto parsed = parseJSON(line.to!string);
                        if ("text" in parsed.object) //tweet
                                writefln("\r[%s]:%s - [%s]", parsed.object["user"].object["name"],
                                                parsed["created_at"], parsed.object["text"]);
                }
        }
        return 0;

}
