#include <string>
#include <algorithm>
#include <vector>
#include <queue>

using namespace std;

int solution(int n, vector<vector<int>> computers) {
    int answer = 0;
    vector<int> visited = {};
    
    for(int startPos=0; startPos<n; startPos++){
        if (find(visited.begin(),visited.end(),startPos)==visited.end()){
            answer++;
            queue<int> tasks;
            tasks.push(startPos);
            visited.push_back(startPos);
            while(1){
                // breakpoint
                if(tasks.size()<=0)
                    break;
                int currentPos = tasks.front();
                tasks.pop();
                vector<int> nextPosList = computers[currentPos];
                for(int nextPos=0; nextPos<n; nextPos++){
                    if(nextPosList[nextPos]==1 && 
                    find(visited.begin(),visited.end(),nextPos)==visited.end()){
                        tasks.push(nextPos);
                        visited.push_back(nextPos);
                    }
                }
            }
        }
    }
    return answer;
}

#include <iostream>
int main(){
    int n = 3;
    vector<vector<int>> computers = {{1, 1, 0}, {1, 1, 1}, {0, 1, 1}};
    cout<<solution(n, computers)<<endl; // 2 나와야 함
}