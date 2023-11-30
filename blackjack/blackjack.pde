import java.util.Arrays;
import java.util.Collections;
import java.util.List;

final int SPADES = 0;
final int CLUBS = 1;
final int HEARTS = 2;
final int DIAMONDS = 3;

List<card> deck;
IntList dealt = new IntList();
ArrayList<card> player = new ArrayList<card>();
ArrayList<card> dealer = new ArrayList<card>();
int playerScore;
int dealerScore;
boolean playerTurn;
boolean playing;
boolean advice;
boolean resetDeck;
int win = 0;
int loss = 0;
int tie = 0;

void setup(){
  frameRate(60);
  size(1000,800);
  background(0,150,0);
  fill(255);
  deck = createDeck();
  dealt.clear();
  startGame();
}

void draw(){
  background(0,150,0);
  //int x = 0;
  //int y = 0;
  //for(int i = 0; i < deck.size();i++){
  //  deck.get(i).drawCard(x,y);
  //  x += 20;
  //  if(x == 260){
  //    x = 0;
  //    y += 200;
  //  }
  //}
  drawUI(playerTurn);
  displayDealer(dealer,270,100,playerTurn);
  displayPlayer(player,270,500);
  checkLoss(playerTurn);
  if(playing){
    dealersTurn(playerTurn);
  }
  if(!playing){
    playAgain();
  }
}

void keyPressed(){
  if(key == ' '){
    card c1 = deal(deck);
    println(c1);
  }
  if(key == 's'){
    deck = shuffle(deck);
  }
  if(key == 'a'){
    deck = createDeck();
  }
  if(key == 'r'){
    resetDeck = true;
  }
}

void mousePressed(){
  if(playerTurn && mouseX > 100 && mouseX < 225 && mouseY > 360 && mouseY < 460){
    hit();
  }
  if(playerTurn && mouseX > 500 && mouseX < 626 && mouseY > 360 && mouseY < 460){
    stand();
  }
  if(playerTurn && mouseX > 50 && mouseX < 160 && mouseY > 50 && mouseY < 85){
    advice = !advice;
  }
  if(!playing){
    startGame();
    playing = true;
  }
}

void startGame(){
  if(deck.size() < 8 || resetDeck == true){
    dealt.clear();
    deck = createDeck();
    resetDeck = false;
  }
  deck = shuffle(deck);
  playerScore = 0;
  dealerScore = 0;
  player.clear();
  dealer.clear();
  player.add(deal(deck));
  player.add(deal(deck));
  dealer.add(deal(deck));
  dealer.add(deal(deck));
  playerTurn = true;
  playing = true;
}

void drawUI(boolean playerTurn){
  fill(0,255,0);
  rect(100,360,125,100);
  rect(500,360,125,100);
  fill(0);
  textSize(35);
  text("Hit",135,420);
  text("Stand",520,420);
  text("Cards Left: " + str(deck.size()),25,775);
  textSize(15);
  text(" (click 'R' to reset deck for next round)",25,790);
  textSize(35);
  text("W/L/D : " + str(win) + "/" + str(loss) + "/" + str(tie),400,775);
  dealerScore = calculateScore(dealer,playerTurn);
  playerScore = calculateScore(player,false);
  textSize(35);
  text("Dealer: " + str(dealerScore),300,360);
  text("Player: " + str(playerScore),300,460);
  if(advice){
    fill(0,255,0);
  } else {
    fill(255,0,0);
  }
  rect(50,50,110,35);
  fill(0);
  textSize(20);
  if(advice){
    text("Advice: ON",55,75);
    displayAdvice();
  } else {
    text("Advice: OFF",55,75);
  }
  
  
}

void displayAdvice(){
  textSize(30);
  text("Help:",750,50);
  //int y = 300;
  //for(int i = 1;i < 10;i++){
  //  text(str(i) + ": " + str(calculateProbability(i)),813,y);
  //  y+=40;
  //}
  //text("10 (value): " + str(calculateProbability(10)),705,y);
  float probability = calculateCumulativeProbability();
  text("Probability to bust: \n" + str(probability),700,100);
  text("You Should:",700,200);
  if(probability < 0.47){
    text("HIT",850,200);
  } else {
    text("STAND",850,200);
  }
}

float calculateProbability(int value){
  int valueDealt = 0;
  if(!dealt.hasValue(value)){
    valueDealt = 0;
  } else {
    for(int i = 0;i < dealt.size();i++){
      if(dealt.get(i) == value){
        valueDealt++;
      }
    }
  }
  if(value == 10){
    return (16.0 - valueDealt) / (52.0 - dealt.size());
  }
  return (4.0 - valueDealt) / (52.0 - dealt.size());
}

float calculateCumulativeProbability(){
  int toBust = 22 - minScore(player);
  float probabilityToBust = 0;
  for(int i = toBust; i < 11;i++){
    probabilityToBust += calculateProbability(i);
  }
  return probabilityToBust;
}

int minScore(ArrayList<card> hand){
  int val;
  int score = 0;
  for(int i = 0;i<hand.size();i++){
    val = hand.get(i).getVal();
    if(val == 10 || val == 11 || val == 12 || val == 13){
      score += 10;
    }
    else {
      score += val;
    }
  }
  return score;
}

void displayPlayer(ArrayList<card> hand,int x,int y){
  for(int i = 0; i < hand.size();i++){
    hand.get(i).drawCard(x,y);
    x += 50;
  }
}

void displayDealer(ArrayList<card> hand, int x, int y, boolean playerTurn){
  if(playerTurn){
    PImage back = loadImage("back.jpg");
    image(back,x,y,150,200);
    x += 50;
    for(int i = 1; i < hand.size();i++){
      hand.get(i).drawCard(x,y);
      x += 20;
    }
  } else {
      for(int i = 0; i < hand.size();i++){
      hand.get(i).drawCard(x,y);
      x += 50;
    }
  }
}

int calculateScore(ArrayList<card> hand, boolean hideFirst){
  int score = 0;
  int val;
  int i;
  int numAces = 0;;
  if(hideFirst){
    i = 1;
  } else {
    i = 0;
  }
  
  for(;i<hand.size();i++){
    val = hand.get(i).getVal();
    if(val == 10 || val == 11 || val == 12 || val == 13){
      score += 10;
    } 
    else if(val == 1){
      score += 11;
      numAces++;
    }
    else {
      score += val;
    }
  }
  
  while (score > 21 && numAces > 0){
    score -= 10;
    numAces--;
  }
  
  return score;
}

void checkLoss(boolean playerTurn){
  if(playerTurn){
    if(calculateScore(player,false) > 21){
      bust();
    }
    if(calculateScore(player,false) == 21){
      blackJack();
    }
  } else {
      if(calculateScore(dealer,false) > 21){
        win();
      }
      else if(calculateScore(dealer,false) > calculateScore(player,false)){
        lose();
      } 
      else if(calculateScore(dealer,false) == calculateScore(player,false)){
        tie();
      }
    }
}

void dealersTurn(boolean playerTurn){
  if(!playerTurn){
    if(frameCount % 10 == 0){
      dealer.add(deal(deck));
    }
  }
}

void hit(){
  player.add(deal(deck));
}

void stand(){
  playerTurn = false;
}

void blackJack(){
  fill(255);
  rect(200,600,400,50);
  fill(0);
  text("Blackjack! You win!",250,635);
  if(playing){
    win++;
  }
  playing = false;
}

void bust(){
  fill(255);
  rect(200,600,400,50);
  rect(200,200,400,50);
  fill(0);
  text("Bust!",350,635);
  text("Dealer Wins",275,235);
  if(playing){
    loss++;
  }
  playing = false;
}

void win(){
  fill(255);
  rect(200,600,400,50);
  fill(0);
  textSize(35);
  text("Congrats! You win!",250,635);
  if(playing){
    win++;
  }
  playing = false;
}

void tie(){
  fill(255);
  rect(200,600,400,50);
  fill(0);
  textSize(35);
  text("It's a draw!",250,635);
  if(playing){
    tie++;
  }
  playing = false;
}

void lose(){
  fill(255);
  rect(200,600,400,50);
  fill(0);
  textSize(35);
  text("Sorry, you lose!",275,635);
  if(playing){
    loss++;
  }
  playing = false;
}

void playAgain(){
  fill(0,0,255);
  rect(250,370,225,50);
  fill(0);
  textSize(20);
  text("        Click anywhere to \n                play again",250,390);
}

List<card> createDeck(){
  List<card> deck = new ArrayList<card>();
  for(int i = 0;i < 4;i++){
    for(int p = 1; p < 14;p++){
      deck.add(new card(p,i));
    }
  }
  return deck;
}

List<card> shuffle(List<card> oldDeck){
  Collections.shuffle(oldDeck);
  return oldDeck;
}

card deal(List<card> deck){
  card temp = deck.get(0);
  deck.remove(0);
  if(temp.getVal() > 10){
    dealt.append(10);
  } else {
    dealt.append(temp.getVal());
  }
  return temp;
}
