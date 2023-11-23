import java.util.Arrays;
import java.util.Collections;
import java.util.List;

final int SPADES = 0;
final int CLUBS = 1;
final int HEARTS = 2;
final int DIAMONDS = 3;
void setup(){
  size(800,800);
  background(0,150,0);
  fill(255);
  
  
}

List<card> deck = createDeck();

void draw(){
  background(0,150,0);
  int x = 0;
  int y = 0;
  for(int i = 0; i < deck.size();i++){
    deck.get(i).drawCard(x,y);
    x += 20;
    if(x == 260){
      x = 0;
      y += 200;
    }
  }
}

void keyPressed(){
  if(key == ' '){
    card c1 = deal(deck);
    println(c1);
  }
  if(key == 'a'){
    deck = createDeck();
  }
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
  return temp;
}
