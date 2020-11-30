#include <iostream>
#include <sstream>
#include <vector>
#include <algorithm>

using namespace std;

struct Player{
    char nameOfPlayer;
    int numOfBeingSulae=0;
    bool isQuick=false;
};

void solution(  int numOfAllPlayers, 
                int numOfQuickPlayers, 
                char *namesOfQuickPlayers, 
                int numOfGames, 
                int *numOfMovesPerGame) {
    // 자리
    vector<Player> sites;

    // 술래 init
    Player currentSulae;
    currentSulae.nameOfPlayer = char(65);
    currentSulae.numOfBeingSulae++;
    if(find(namesOfQuickPlayers,namesOfQuickPlayers+numOfQuickPlayers,currentSulae.nameOfPlayer)!=namesOfQuickPlayers+numOfQuickPlayers)
        currentSulae.isQuick = true;

    // 앉아있는 사람들 init
    for(int i=0; i<numOfAllPlayers-1; i++){
        Player seatedPlayer;
        seatedPlayer.nameOfPlayer = char(i+66);
        if(find(namesOfQuickPlayers,namesOfQuickPlayers+numOfQuickPlayers,seatedPlayer.nameOfPlayer)!=namesOfQuickPlayers+numOfQuickPlayers)
            seatedPlayer.isQuick = true;
        sites.push_back(seatedPlayer);
    }
    int numOfSites = numOfAllPlayers-1;

    // game start
    int currentPos = 0;
    for(int i=0; i<numOfGames; i++){
        currentPos += numOfMovesPerGame[i];
        currentPos %= numOfSites;
        if (currentPos<0)
            currentPos += numOfSites;

        if (!sites[currentPos].isQuick){    // 술래 바꾸기
            Player temp = sites[currentPos];
            sites[currentPos] = currentSulae;
            currentSulae = temp;
        }
        currentSulae.numOfBeingSulae += 1;
    }

    // print results
    for (int i=0; i<numOfSites; i++){
        cout<<sites[i].nameOfPlayer<<" "
            <<sites[i].numOfBeingSulae<<endl;
    }
    cout<<currentSulae.nameOfPlayer<<" "<<currentSulae.numOfBeingSulae<<endl;
}

struct input_data {
  int numOfAllPlayers;
  int numOfQuickPlayers;
  char *namesOfQuickPlayers;
  int numOfGames;
  int *numOfMovesPerGame;
};

void process_stdin(struct input_data& inputData) {
  string line;
  istringstream iss;

  getline(cin, line);
  iss.str(line);
  iss >> inputData.numOfAllPlayers;

  getline(cin, line);
  iss.clear();
  iss.str(line);
  iss >> inputData.numOfQuickPlayers;

  getline(cin, line);
  iss.clear();
  iss.str(line);
  inputData.namesOfQuickPlayers = new char[inputData.numOfQuickPlayers];
  for (int i = 0; i < inputData.numOfQuickPlayers; i++) {
    iss >> inputData.namesOfQuickPlayers[i];
  }

  getline(cin, line);
  iss.clear();
  iss.str(line);
  iss >> inputData.numOfGames;

  getline(cin, line);
  iss.clear();
  iss.str(line);
  inputData.numOfMovesPerGame = new int[inputData.numOfGames];
  for (int i = 0; i < inputData.numOfGames; i++) {
    iss >> inputData.numOfMovesPerGame[i];
  }
}

int main() {
  struct input_data inputData;
  process_stdin(inputData);

  solution(inputData.numOfAllPlayers, 
					 inputData.numOfQuickPlayers, 
					 inputData.namesOfQuickPlayers, 
					 inputData.numOfGames, 
					 inputData.numOfMovesPerGame);
  return 0;
}