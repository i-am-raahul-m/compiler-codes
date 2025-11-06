#include <bits/stdc++.h>
using namespace std;

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

    map<pair<string, string>, string> table;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            cout << "D[" << states[i] << "," << alpha[j] << "] = ";
            cin >> table[{states[i], alpha[j]}];
        }
    }

    string parse; cin >> parse;
    string iter = init_st;
    cout << init_st;
    for (int i = 0; i < parse.length(); i++) {
        iter = table[{iter, string(1, parse[i])}];
        cout << " --> " << iter;
    }
    cout << endl;
    if (finals.count(iter)) cout << "Accepted." << endl;
    else cout << "Rejected." << endl;

    return 0;
}