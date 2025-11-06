#include <bits/stdc++.h>
using namespace std;

string stringify(set<string>& ip) {
    string res = "{";
    for (auto &iter : ip) res += iter + ",";
    if (res.length() != 1) res.pop_back(); 
    res += "}";
    return res;
}

void display_table(map<pair<set<string>, string>, set<string>> &table, vector<set<string>> &states, vector<string> &alpha) {
    int n = states.size();
    int m = alpha.size();

    cout << "  ";
    for (int i = 0; i < m; i++) cout << alpha[i] << " ";
    cout << endl;

    for (int i = 0; i < n; i++) {
        cout << stringify(states[i]) << " ";
        for (int j = 0; j < m; j++) {
            cout << stringify(table[{states[i], alpha[j]}]) << " ";
        }
        cout << endl;
    }
}

int main() {
    int n; cin >> n;
    vector<string> states(n);
    unordered_map<string, int> st_idx;
    for (int i = 0; i < n; i++) {
        cin >> states[i];
        st_idx[states[i]] = i;
    }

    string init_st; cin >> init_st;
    int f; cin >> f;
    set<string> finals;
    string temp;
    for (int i = 0; i < f; i++) {
        cin >> temp;
        finals.insert(temp);
    }

    int m; cin >> m;
    vector<string> alpha(m);
    unordered_map<string, int> al_idx;
    for (int i = 0; i < m; i++) {
        cin >> alpha[i];
        al_idx[alpha[i]] = i;
    }

    map<pair<string, string>, set<string>> table;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            cout << "D[" << states[i] << "," << alpha[j] << "] = ";
            string line;
            cin >> ws; getline(cin, line);
            stringstream ss(line);
            string s;
            while (ss >> s) if (s!= "-") table[{states[i], alpha[j]}].insert(s);
        }
    }

    queue<set<string>> Q;
    vector<set<string>> dfa_states;
    set<set<string>> dfa_finals;
    set<string> start = {init_st};
    map<pair<set<string>, string>, set<string>> dfa_table;

    set<string> iter = start;
    Q.push(iter);
    dfa_states.push_back(iter);
    while (!Q.empty()) {
        iter = Q.front(); Q.pop();
        for (auto &a : alpha) {
            set<string> new_state = {};
            for (auto &s : iter) {
                auto it = table.find({s,a});
                if (it != table.end()) for (auto &ns : it->second) new_state.insert(ns);
            }

            if (new_state.empty()) continue;
            if (find(dfa_states.begin(), dfa_states.end(), new_state) == dfa_states.end()) {
                Q.push(new_state);
                dfa_states.push_back(new_state);
            }

            dfa_table[{iter, a}] = new_state;
        }
        for (auto &s : iter) {
            if (finals.count(s)) dfa_finals.insert(iter);
        }
    }

    display_table(dfa_table, dfa_states, alpha);

    bool flag = true;
    string parse; cin >> parse;
    set<string> state = start;
    cout << stringify(state);
    for (int i = 0; i < parse.length(); i++) {
        auto it = dfa_table.find({state, string(1, parse[i])});
        if (it != dfa_table.end()) state = it->second;
        else {
            cout << "Rejected." << endl;
            flag = false;
            break;
        }
        cout << " --> " << stringify(state);
    }
    cout << endl;
    if (flag) {
        if (dfa_finals.count(state)) cout << "Accepted." << endl;
        else cout << "Rejected." << endl;
    }
    
    return 0;
}