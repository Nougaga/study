#include <iostream>
#include <sstream>
#include <vector>
#include <algorithm>
#include <stack>

using namespace std;

int read_cluster(pair<int,int> startPos, int sizeOfMatrix, int **matrix){
  stack<pair<int,int>> taskStack;
  taskStack.push(startPos);
  int res = 0;
  while(1){
    // breakpoint
    if (taskStack.size() <= 0)
      break;

    pair<int,int> currentPos = taskStack.top();
    taskStack.pop();
    res++;
    int row = currentPos.first;
    int column = currentPos.second;

    // top
    row--;
    if(row>=0 && matrix[row][column]){
      taskStack.push(make_pair(row,column));
      matrix[row][column] = 0;
    }
    // bottom
    row += 2;
    if(row<sizeOfMatrix && matrix[row][column]){
      taskStack.push(make_pair(row,column));
      matrix[row][column] = 0;
    }
    // left
    row--;
    column--;
    if(column>=0 && matrix[row][column]){
      taskStack.push(make_pair(row,column));
      matrix[row][column] = 0;
    }
    // right
    column += 2;
    if(column<sizeOfMatrix && matrix[row][column]){
      taskStack.push(make_pair(row,column));
      matrix[row][column] = 0;
    }
  }

  return res;
}

void solution(int sizeOfMatrix, int **matrix) {
  vector<int> res;
  for(int i=0;i<sizeOfMatrix;i++){
    for(int j=0;j<sizeOfMatrix;j++){
      if (matrix[i][j]){
        int element;
        matrix[i][j] = 0;
        element = read_cluster(make_pair(i,j), sizeOfMatrix, matrix);
        res.push_back(element);
      }
    }
  }
  int length_res = res.size();
  cout<<length_res<<endl;
  if (length_res){
    sort(res.begin(), res.end(), less<int>());
    for(int i=0;i<length_res;i++){
      cout<<res[i];
      if (i<length_res-1){
        cout<<" ";
      }
    }   
  }
  cout<<endl;
}

struct input_data {
  int sizeOfMatrix;
  int **matrix;
};

void process_stdin(struct input_data& inputData) {
  string line;
  istringstream iss;

  getline(cin, line);
  iss.str(line);
  iss >> inputData.sizeOfMatrix;

  inputData.matrix = new int*[inputData.sizeOfMatrix];
  for (int i = 0; i < inputData.sizeOfMatrix; i++) {
    getline(cin, line);
    iss.clear();
    iss.str(line);
    inputData.matrix[i] = new int[inputData.sizeOfMatrix];
    for (int j = 0; j < inputData.sizeOfMatrix; j++) {
      iss >> inputData.matrix[i][j];
    }
  }
}

int main() {
  struct input_data inputData;
  process_stdin(inputData);

  solution(inputData.sizeOfMatrix, inputData.matrix);
  return 0;
}