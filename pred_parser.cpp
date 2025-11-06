#include <iostream>
#include <vector>
#include <string>
#include <set>
#include <map>
#include <unordered_map>
#include <unordered_set>
#include <stack>
#include <algorithm>
#include <iomanip>

using namespace std;

vector<string> productions;
unordered_set<char> nonterminals;
unordered_set<char> terminals;
unordered_map<char, set<char>> firstSets;
unordered_map<char, set<char>> followSets;
map<pair<char, char>, string> parseTable;
char startSymbol;

constexpr char EPSILON = '#';
constexpr char END_MARKER = '$';

void inputGrammar();
void extractSymbols();
void computeFirstSets();
void computeFollowSets();
set<char> computeFirstOfString(const string& str);
bool isNonterminal(char symbol);
string getStackString(stack<char> st);
void computeFirstAndFollow();
void buildParseTable();
void displaySets();
void displayParseTable();
void parseString();

void inputGrammar() {
    int numProductions;
    cout << "Enter number of productions: ";
    cin >> numProductions;

    productions.resize(numProductions);
    cout << "Enter productions:\n";
    for (int i = 0; i < numProductions; i++) {
        cin >> productions[i];
    }

    extractSymbols();
    startSymbol = productions[0][0];
}

void extractSymbols() {
    nonterminals.clear();
    terminals.clear();

    for (const auto& production : productions) {
        nonterminals.insert(production[0]);
        for (size_t i = 2; i < production.length(); i++) {
            char symbol = production[i];
            if (isupper(symbol)) {
                nonterminals.insert(symbol);
            } else if (symbol != EPSILON) {
                terminals.insert(symbol);
            }
        }
    }
    terminals.insert(END_MARKER);
}

void computeFirstSets() {
    for (char nt : nonterminals) {
        firstSets[nt].clear();
    }

    bool changed = true;
    while (changed) {
        changed = false;

        for (const auto& production : productions) {
            char lhs = production[0];
            string rhs = production.substr(2);

            if (rhs == string(1, EPSILON)) {
                if (firstSets[lhs].insert(EPSILON).second) {
                    changed = true;
                }
                continue;
            }

            for (size_t i = 0; i < rhs.length(); i++) {
                char symbol = rhs[i];

                if (!isupper(symbol)) {
                    if (firstSets[lhs].insert(symbol).second) {
                        changed = true;
                    }
                    break;
                } else {
                    bool hasEpsilon = false;
                    for (char t : firstSets[symbol]) {
                        if (t == EPSILON) {
                            hasEpsilon = true;
                        } else {
                            if (firstSets[lhs].insert(t).second) {
                                changed = true;
                            }
                        }
                    }
                    if (!hasEpsilon) {
                        break;
                    }
                    if (i == rhs.length() - 1) {
                        if (firstSets[lhs].insert(EPSILON).second) {
                            changed = true;
                        }
                    }
                }
            }
        }
    }
}

set<char> computeFirstOfString(const string& str) {
    set<char> result;

    if (str.empty()) {
        result.insert(EPSILON);
        return result;
    }

    for (size_t i = 0; i < str.length(); i++) {
        char symbol = str[i];

        if (!isupper(symbol)) {
            result.insert(symbol);
            break;
        } else {
            bool hasEpsilon = false;
            for (char t : firstSets[symbol]) {
                if (t == EPSILON) {
                    hasEpsilon = true;
                } else {
                    result.insert(t);
                }
            }
            if (!hasEpsilon) break;
            if (i == str.length() - 1) result.insert(EPSILON);
        }
    }

    return result;
}

void computeFollowSets() {
    for (char nt : nonterminals) {
        followSets[nt].clear();
    }

    followSets[startSymbol].insert(END_MARKER);

    bool changed = true;
    while (changed) {
        changed = false;

        for (const auto& production : productions) {
            char lhs = production[0];
            string rhs = production.substr(2);

            for (size_t i = 0; i < rhs.length(); i++) {
                char symbol = rhs[i];
                if (!isupper(symbol)) continue;

                string suffix = rhs.substr(i + 1);
                set<char> firstOfSuffix = computeFirstOfString(suffix);

                for (char t : firstOfSuffix) {
                    if (t != EPSILON) {
                        if (followSets[symbol].insert(t).second) {
                            changed = true;
                        }
                    }
                }

                if (firstOfSuffix.count(EPSILON) || suffix.empty()) {
                    for (char t : followSets[lhs]) {
                        if (followSets[symbol].insert(t).second) {
                            changed = true;
                        }
                    }
                }
            }
        }
    }
}

bool isNonterminal(char symbol) {
    return nonterminals.count(symbol) > 0;
}

string getStackString(stack<char> st) {
    string result;
    vector<char> temp;
    while (!st.empty()) {
        temp.push_back(st.top());
        st.pop();
    }
    reverse(temp.begin(), temp.end());
    for (char c : temp) result += c;
    return result;
}

void computeFirstAndFollow() {
    computeFirstSets();
    computeFollowSets();
}

void buildParseTable() {
    parseTable.clear();

    for (const auto& production : productions) {
        char lhs = production[0];
        string rhs = production.substr(2);

        set<char> firstOfRHS = computeFirstOfString(rhs);

        for (char t : firstOfRHS) {
            if (t != EPSILON) {
                parseTable[{lhs, t}] = production;
            }
        }

        if (firstOfRHS.count(EPSILON)) {
            for (char t : followSets[lhs]) {
                parseTable[{lhs, t}] = production;
            }
        }
    }
}

void displaySets() {
    cout << "\nFIRST Sets:\n";
    vector<char> nts(nonterminals.begin(), nonterminals.end());
    sort(nts.begin(), nts.end());

    for (char nt : nts) {
        cout << "FIRST(" << nt << ") = { ";
        bool firstOut = true;
        for (char s : firstSets[nt]) {
            if (!firstOut) cout << ", ";
            cout << s;
            firstOut = false;
        }
        cout << " }\n";
    }

    cout << "\nFOLLOW Sets:\n";
    for (char nt : nts) {
        cout << "FOLLOW(" << nt << ") = { ";
        bool firstOut = true;
        for (char s : followSets[nt]) {
            if (!firstOut) cout << ", ";
            cout << s;
            firstOut = false;
        }
        cout << " }\n";
    }
}

void displayParseTable() {
    cout << "\nLL(1) Parse Table:\n";

    vector<char> ntVec(nonterminals.begin(), nonterminals.end());
    vector<char> tVec(terminals.begin(), terminals.end());
    sort(ntVec.begin(), ntVec.end());
    sort(tVec.begin(), tVec.end());

    cout << setw(4) << "";
    for (char t : tVec) cout << setw(6) << t;
    cout << "\n";

    for (char nt : ntVec) {
        cout << setw(4) << nt;
        for (char t : tVec) {
            auto it = parseTable.find({nt, t});
            if (it != parseTable.end()) {
                cout << setw(6) << it->second;
            } else {
                cout << setw(6) << "-";
            }
        }
        cout << "\n";
    }
}

void parseString() {
    string input;
    cout << "\nEnter input string: ";
    cin >> input;
    input += END_MARKER;

    stack<char> parseStack;
    parseStack.push(END_MARKER);
    parseStack.push(startSymbol);

    size_t inputIndex = 0;

    cout << "\n" << setw(10) << "Stack"
         << setw(10) << "Input"
         << setw(10) << "Output" << "\n";

    while (!parseStack.empty()) {
        char top = parseStack.top();
        char currentInput = input[inputIndex];

        string stackStr = getStackString(parseStack);
        string inputStr = input.substr(inputIndex);

        if (top == END_MARKER && currentInput == END_MARKER) {
            cout << setw(10) << stackStr
                 << setw(10) << inputStr
                 << setw(10) << "Accept" << "\n";
            return;
        }

        if (!isNonterminal(top)) {
            if (top == currentInput) {
                cout << setw(10) << stackStr
                     << setw(10) << inputStr
                     << setw(10) << "Match" << "\n";
                parseStack.pop();
                inputIndex++;
            } else {
                cout << setw(10) << stackStr
                     << setw(10) << inputStr
                     << setw(10) << "Reject: mismatch" << "\n";
                return;
            }
        } else {
            auto it = parseTable.find({top, currentInput});
            if (it == parseTable.end()) {
                cout << setw(10) << stackStr
                     << setw(10) << inputStr
                     << setw(10) << "Reject: no rule" << "\n";
                return;
            }

            string production = it->second;
            string rhs = production.substr(2);

            cout << setw(10) << stackStr
                 << setw(10) << inputStr
                 << setw(10) << production << "\n";

            parseStack.pop();

            if (rhs != string(1, EPSILON)) {
                for (int i = static_cast<int>(rhs.length()) - 1; i >= 0; i--) {
                    parseStack.push(rhs[i]);
                }
            }
        }
    }

    cout << setw(10) << "-"
         << setw(10) << "-"
         << setw(10) << "Reject: stack empty" << "\n";
}

int main() {
    inputGrammar();
    computeFirstAndFollow();
    buildParseTable();
    displaySets();
    displayParseTable();
    parseString();
    return 0;
}
