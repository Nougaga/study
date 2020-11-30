#include <iostream>
#include <sstream>
#include <stack>
#include <queue>

using namespace std;

void applyRules(vector<char>* ptr_r,
                queue<char>* ptr_c,
                stack<char>* ptr_f){
    // cout<<(*ptr_c).back();


}


void solution(int numOfOrder, string *orderArr) {
  // TODO: 이곳에 코드를 작성하세요. 추가로 필요한 함수와 전역변수를 선언해서 사용하셔도 됩니다.
    vector<char> result;
    queue<char> bracket_contents;
    stack<char> bracket_front;

    for(int order=0; order<numOfOrder; order++){
        string target = orderArr[order];
        int numOfChar = sizeof(orderArr);
        for(int i=0; i<numOfChar; i++){
            char target_i = target[i];
            if(target_i==')'){
                // cout<<string((*(&result)).begin(),(*(&result)).end())<<endl;
                applyRules(&result, &bracket_contents, &bracket_front);
            }
            else if (bracket_front.size()==0){
                result.push_back(target_i);
            }
            else{
                if (target_i=='('){
                    bracket_front.push(result.back());
                    result.pop_back();
                }
                bracket_contents.push(target_i);
            }
        }
        // cout<<string(result.begin(),result.end())<<endl;
        result.clear();
    }
}

struct input_data {
  int numOfOrder;
  string *orderArr;
};

void process_stdin(struct input_data& inputData) {
  string line;
  istringstream iss;

  getline(cin, line);
  iss.str(line);
  iss >> inputData.numOfOrder;

  inputData.orderArr = new string[inputData.numOfOrder];
  for (int i = 0; i < inputData.numOfOrder; i++) {
    getline(cin, line);
    iss.clear();
    iss.str(line);
    iss >> inputData.orderArr[i];
  }
}

int main() {
  struct input_data inputData;
  process_stdin(inputData);

  solution(inputData.numOfOrder, inputData.orderArr);
  return 0;
}
/*




*/