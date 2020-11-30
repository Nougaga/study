#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

int main()
{   
    vector<char> v1;
    vector<char> v2;

    v1.push_back('a');
    v1.push_back('a');
    v1.push_back('a');
    
    vector<char>* ptr_v1 = &v1;
    vector<char> v3 = *ptr_v1;

    cout<<string((*ptr_v1).begin(),(*ptr_v1).end())<<endl;
    return 0;
}