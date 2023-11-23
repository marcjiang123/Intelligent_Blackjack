class card {
  private int number;
  private int suit;
  
  card(int n, int s){
    number = n;
    suit = s;
  }
  
  void drawCard(int x, int y){
    fill(255);
    rect(x,y,150,200,10);
    
    String numString;
    if(number > 1 && number < 11){
      numString = str(number);
      
    } else {
      switch(number){
        case 1:
          numString = "ace";
          break;
        case 11:
          numString = "jack";
          break;
        case 12:
          numString = "queen";
          break;
        case 13:
          numString = "king";
          break;
        default:
          numString = "invalid";
      }
    }
      
    String suitString;
    switch(suit){
      case SPADES:
        suitString = "spades";
        break;
      case CLUBS:
        suitString = "clubs";
        break;
      case HEARTS:
        suitString = "hearts";
        break;
      case DIAMONDS:
        suitString = "diamonds";
        break;
      default:
        suitString = "invalid";
        break;
    }
    String imgAddress = String.format("%s_of_%s.png",numString,suitString);
    PImage img = loadImage(imgAddress);
    image(img,x,y,150,200);
    
  }
    
}
