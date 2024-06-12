// Arduinoにビルド(?)して、PCからの受信データに応じてモータを制御するプログラム
int ko1=7;
int ko2=8;
int mat=0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin( 9600 ); 

  pinMode(ko1,OUTPUT);
  pinMode(ko2,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
//  digitalWrite(ko1, LOW);
  digitalWrite(ko2, LOW);

  if ( Serial.available() ) {       // 受信データがあるか？
     mat=1;
       }
  else{
     mat=0;
       }

  if(mat==0){
    digitalWrite(ko1, HIGH);

    delay(100);
  }
  else{
    digitalWrite(ko1, LOW);

    delay(100);
    }
}
