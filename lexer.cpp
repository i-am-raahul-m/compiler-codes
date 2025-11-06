#include <bits/stdc++.h>
#include <fstream>
using namespace std;

set<string> kw = {"if", "else", "for", "while", "int", "double"};
unordered_map<string, string> op = {{"+", "Addition"}, {"-", "Subtraction"}, {"*", "Multiplication"}, {"/", "Division"},
{"++", "Increment"}, {"--", "Decrement"}, {"=", "Assignment"}};
set<string> sym = {"(", ")", "{", "}", "[", "]", ",", ".", ";"};

bool isNum(string& token) {
    if (token.empty()) return false;
    int d = 0;
    for (char c : token) {
        if (isdigit(c)) continue;
        else if (d == 0 && c == '.') d++;
        else return false;
    }
    return true;
}

bool isId(string &token) {
    if (token.empty()) return false;
    if (!isalpha(token[0]) && token[0] != '_') return false;
    for (int i = 1; i < token.length(); i++) {
        if (!isalnum(token[i]) && token[i] != '_') return false;
    }
    if (kw.count(token)) return false;
    return true;
}

vector<string> tokenize(string line) {
    vector<string> tokens;
    string token = "";
    for (int i = 0; i < line.length(); i++) {
        char c = line[i];
        string C = string(1, c);
        if (isspace(c)) {
            if (!token.empty()) tokens.push_back(token);
            token.clear();
        }
        else if (isdigit(c) && token.empty()) {
            token += c;
            while (i+1 < line.length() && (isdigit(line[i+1]) || line[i+1] == '.')) {
                token += line[i+1];
                i++;
            }
            tokens.push_back(token);
            token.clear();
        }
        else if (op.count(C)) {
            if (!token.empty()) tokens.push_back(token);
            token.clear();
            if (i+1 < line.length() && (c == '+' && line[i+1] == '+' || c == '-' && line[i+1] == '-')) {
                string o = C + string(1, line[i+1]);
                tokens.push_back(o);
                i++;
            }
            else {
                tokens.push_back(C);
            }
        }
        else if (sym.count(C)) {
            if (!token.empty()) tokens.push_back(token);
            token.clear();
            tokens.push_back(C);
        }
        else token += c;
    }
    if (!token.empty()) tokens.push_back(token);
    return tokens;
}

void classify(vector<string> tokens) {
    for (string &token : tokens) {
        cout << token << " --> ";
        if (kw.count(token)) cout << "Keyword" << endl;
        else if (isId(token)) cout << "Identifier" << endl;
        else if (isNum(token)) cout << "Number" << endl;
        else if (op.count(token)) cout << op[token] << endl;
        else if (sym.count(token)) cout << "Symbol" << endl;
        else cout << "Invalid Token" << endl;
    }
}

int main() {
    //string line; cin >> ws; getline(cin, line);
    //string line = "int a = 23*b+(o-8.9)++;";
    string line;
    ifstream fin("code.txt");
    while (getline(fin, line)) {
        classify(tokenize(line));
    }
    fin.close();
    return 0;
}