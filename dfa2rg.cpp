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

    cout << "N: ";
    for (string &state : states) cout << state << " ";
    cout << endl;
    cout << "T: ";
    for (string &a : alpha) cout << a << " ";
    cout << endl;

    cout << "P: " << endl;
    string lhs;
    for (int i = 0; i < n; i++) {
        lhs = states[i];
        for (int j = 0; j < m; j++) {
            string rhs = table[{lhs, alpha[j]}];
            cout << lhs << " -> " << alpha[j] << rhs << endl;
            if (finals.count(rhs)) cout << lhs << " -> " << alpha[j] << endl;
        }
        if (lhs == init_st && finals.count(lhs)) cout << lhs << " -> e" << endl;
    }

    cout << "S: " << init_st << endl;

    return 0;
}