/*

DDF Audio Library Import Required

State 0 = Starting Page

State 1 = Multiple Choice Page

State 2 = Continuing Page (if answered correct answer)

State 3 = Losing Page (if answered wrong answer)

State 4 = Bonus Level Page

State 5 = Gamemode Selection Page (the page that appears after "Start" is clicked in state 0)

State 6 = Winning Page (only in campaign mode)

State 7 = Instructions/Help Page

Hope that clarifies everythig :)
*/

//import the library for audio, since the processing audio library is not working for me.
import ddf.minim.*;
Minim minim;
//Initializing the audio for the music that will be played when the code start
AudioPlayer startingAudio;
//Initializing the audio for the music that will be played when the player is on the multiple choice question
AudioPlayer intense;
//Initializing the audio for the music that will be played when the player is on the bonus level page
AudioPlayer bonusAudio;
//Initializing the audio that will be played if the player chooses the correct answer
AudioPlayer approve;
//Initializing the audio that will be played if the zombie catches up to the main character
AudioPlayer died;
//Initializing the audio that will be played if the player chooses the wrong answer
AudioPlayer disapprove;

//Initializing the variable to change the font
PFont font;

//Initializing the image that will be displayed as the background for the main menu page
PImage backgroundHome;
//Initializing the image that will display the main character in all the questions
PImage mainCharacter;
//Initializing the image that will display as the background for the mutliple choice question
PImage multipleChoiceBackground;
//Initializing the image that will display the zombie
PImage zombie;
//Initializing the image that will be used as a background for the boxes in the gamemode selection page that has a stone texture
PImage stone;
//Initializing the image that will be used as a background for the boxes in the main menu page that has a brick texture
PImage brick;
//Initializing the image that will be used as a background for the boxes in the multiple choice page that has a grass texture
PImage grass;
//Initializing the image that will be used as a background for the box that will display the equation that has a birch wood texture
PImage birch;
////Initializing the image that will be used as a background for the bonus level page
PImage bonusLevelBackground;
////Initializing the image that will be used as a background for the ganenide selection page
PImage gamemodeBackground;

//Initializing a variable that will maintain the gamemode selected
boolean campaignMode = false;
//Initializing a variable that will maintain the return button to the main menu from the congrats page (state 6)
boolean mainMenuTrigger = false;

//Initiliaizing and assigning a variable that will check if the number inputted in the bonus level is correct
int num = 0;
//Initiliaizing and assigning a variable that will basically used for a system to display the bonus level page after every 5 questions
int bonusRound = 0;
//Initiliaizing and assigning a variables that will act as a randomizer for the equations/questions
int randomizer1 = 15;
int randomizer2 = 30;
//Initiliaizing and assigning a variable that will be used to display the player's high score in the gamemode selection page
int highScore = 0;
//Initiliaizing and assigning a variable that will maintain the instruction page the player is on
int instructionPages = 0;

//Initiliaizing x and y variables that will randomize the location of the correct answer in the multiple choice question
int x;
int y;

//Initiliazing variables to display the options in the multiple choice question
int n1;
int n2;
int n3;
int n4;
int n5;
int n6;
int n7;
int n8;

//state variable
int state = 0;
//score variable
int score = 0;

float zombieX;
float zombieSpeed;

String instructionText;
String str_num = "";


//first set
float[] randomizerX1 = new float[2];
float[] randomizerY1 = new float[2];
//second set
float[] randomizerX2 = new float[2];
float[] randomizerY2 = new float[2];
//third set
float[] randomizerX3 = new float[2];
float[] randomizerY3 = new float[2];
//fourth set
float[] randomizerX4 = new float[2];
float[] randomizerY4 = new float[2];

//setup function - runs once
void setup() {
    //set canvas size 450 x-axis and 450 y-axis (450,450)
    
    size(1000,1000);
    //These arrays will be used to plot the numbers in the mutliple choice question
    randomizerX1[0] = width / 3;
    randomizerX1[1] = width / 1.5;

    randomizerY1[0] = height / 3;
    randomizerY1[1] = height / 1.5;

    randomizerX2[0] = width / 3;
    randomizerX2[1] = width / 1.5;

    randomizerY2[0] = height / 3;
    randomizerY2[1] = height / 1.5;

    randomizerX3[0] = width / 3;
    randomizerX3[1] = width / 1.5;

    randomizerY3[0] = height / 3;
    randomizerY3[1] = height / 1.5;

    randomizerX4[0] = width / 3;
    randomizerX4[1] = width / 1.5;

    randomizerY4[0] = height / 3;
    randomizerY4[1] = height / 1.5;


    //set the zombie speed to 0.3
    zombieSpeed = width - width / 1.00066711141;
    
    //load all the images needed
    bonusLevelBackground = loadImage("bonusLevelBackground.jpg");
    backgroundHome = loadImage("back.png");
    mainCharacter = loadImage("steve2D.png");
    zombie = loadImage("zombie2D.png");
    stone = loadImage("stone.jpg");
    brick = loadImage("brick.png");
    grass = loadImage("grass.png");
    gamemodeBackground = loadImage("gamemodeBackground.png");
    multipleChoiceBackground = loadImage("multipleChoiceBackground.jpg");
    birch = loadImage("birch.png");
    

    //load the font: minecraft theme
    font = createFont("Minecraft.ttf", 128);
    textFont(font);
    
    //setting font size for any upcoming text to 20
    textSize(width / 22.5);
    
    //using textAlign to center the text to be in the center of the options boxes
    textAlign(CENTER);
    
    //loading the audios needed
    minim = new Minim(this);
    startingAudio = minim.loadFile("music1.aiff");
    intense = minim.loadFile("lol.mp3");
    bonusAudio = minim.loadFile("bonusLevelAudio.mp3");
    approve = minim.loadFile("approve.mp3");
    died = minim.loadFile("died.mp3");
    disapprove = minim.loadFile("disapprove.mp3");
    
    //play the starting music
    startingAudio.play();

}



/*This function is randomize the options and the location of the boxes for the multiple choice questions. I made a seprate function for it because if I put everything in one funtion
then its gonna keep randomizing everything all the time, as I will be calling it in draw. Therefore, I made this function so it gets called only once in the mousePressed function
*/
void optionsRandomizer() {
    //set the zombie x location to 460 (out of the canvas)
    zombieX = width / 0.97826086956;
    //randomize x and y variables. These variables are used to plot the correct answer. The other wrong answers will be plotted according to the correct answer
    x = int(random(2));
    y = int(random(2));
    //randomizing all the options numbers according to n1 and n2 (the correct answer)
    //the randomizer1 and randomizer2 variables are used to be the range of numbers that will be picked from for the questions
    //I did not just use numbers because I want the questions to get harder after each bonus level. So what I will be doing is adding 35/45 to these 2 variables so the questions get harder
    n1 = int(random(randomizer1, randomizer2));
    n2 = int(random(randomizer1, randomizer2));
    n3 = n1 + int(random(2, 3));
    n4 = n2 + int(random(2, 3));
    n5 = n1 - int(random(2, 3));
    n6 = n2 - int(random(2, 3));
    n7 = n1 + int(random(4, 6));
    n8 = n2 + int(random(4, 6));
}

//this function draws the gamemode selection page, which is the page that appears after you click on start.
void gamemodeSelection() {
    //set the background image and make it a little darker to make it easier for the players to read the text
    push();
    tint(80);
    image(gamemodeBackground, 0, 0, width, height);
    pop();
    fill(255);

    //a simple for loop to draw the options/boxes
    for (float modeBoxesY = height / 18; modeBoxesY <= height / 2; modeBoxesY += height / 2.57) {
        push();
        tint(230);
        //here I added a rect behind the boxes so I could have a thicker stroke. I did this because stroke(); does not work on images.
        strokeWeight(6);
        rect(width / 3.33, modeBoxesY, width / 2.5, height / 9);
        image(stone, width / 3.33, modeBoxesY, width / 2.5, height / 9);
        pop();
        fill(0, 180, 0);
        rect(width / 2.812, height / 1.125, width / 3.6, height / 9, 4);
        fill(255);
        text("Help", width / 2, height / 1.046);
    }
    //displaying the text and the high score.
    fill(255);
    text("Campagin Mode", width / 2, height / 8.1818);
    text("Infinite Mode", width / 2 + 5, height / 1.956);
    push();
    textSize(width / 25);
    text("High Score:" + highScore, width / 2 + width / 3, height / 1.956);
    pop();
    textSize(width / 34.6153846154);
    text("In this mode, your goal is to get a score of 30.\n The game consists of 4 multiple choice questions.\n There will be a bonus level after every 4 multiple choice questions\nThe questions will get harder after every bonus level.", width / 2, height / 4.5);
    text("This mode is the same as the Campagin mode, \nexcept for one slight change. \n There will be an infinite amount of questions. \n The questions will get harder after every 5 questions.", width / 1.875, height / 1.60714285714);

    textSize(width / 22.5);

}
//this function will draw the mutltiple choice questions page.
void optionsQuestion() {
    //Displaying the image selected for the background and making it a little darker.
    push();
    tint(130);
    image(multipleChoiceBackground, 0, 0, width / 0.9, height);
    pop();
    fill(0);
    //plotting the zombie and the main character on the screen.
    image(zombie, zombieX, height / 1.40625, width / 4.5, height / 3.46153846154);
    image(mainCharacter, width / -9, height / 0.97826086956 - height / 2.25, width / 2.64705882353, height / 2.25);
    //animating the zombie to walk towards our main character
    zombieX = zombieX - zombieSpeed;
    // an if statement that checks if the zombie have touched the main character
    if (zombieX <= width / 4.5) {
        //if the zombie touches the main character then go to state 3, which is the losing screen.
        state = 3;
        textSize(width / 15);
        fill(255, 0, 0);
        //display game over
        text("GAME OVER", width / 2, height / 1.91489361702);
        textSize(width / 22.5);
        fill(0);
        push();
        //changing the colour of the main charcter to be red
        tint(255, 0, 0);
        image(mainCharacter, width / -9, height / 0.97826086956 - height / 2.25, width / 2.64705882353, height / 2.25);
        pop();
        //play the sound of being hit/or dying
        died.rewind();
        died.play();
    }


    fill(255, 255, 255, 100);
    //another for loop to draw the boxes that will display the options
    for (float boxesX = width / 4.5; boxesX <= width / 1.8; boxesX += width / 3) {
        for (float boxesY = height / 4.5; boxesY <= height / 1.8; boxesY += width / 3) {
            push();
            tint(250, 250, 250, 210);
            //here I used the same idea of a rect behind the boxes to add a thicker stroke.
            strokeWeight(3);
            rect(boxesX, boxesY, width / 4.5, height / 4.5);
            image(grass, boxesX, boxesY, width / 4.5, height / 4.5);
            pop();
        }


    }
    //change colour to black for the text colour
    fill(0);
    //display the right answer in one of the boxes randomly
    text(n1 + n2, randomizerX1[x], randomizerY1[y]);
    //display the equation you need to solve at the top; the sum of the two numbers is n1 and n2, which is the number display in the line above
    push();
    strokeWeight(3);
    //adding a rect behind the image to have a thicker stroke.
    rect(width / 3, height / 18, width / 3.10344827586, height / 11.25);
    //displaying the birch wood image at the top for the equation
    image(birch, width / 3, height / 18, width / 3.10344827586, height / 11.25);
    fill(0);
    textSize(width / 19.5652173913);
    //displaying the two number that need to be added together to get the right answer
    text(n1 + " + " + n2, width / 2, height / 9);
    pop();

    //The upcoming big chunk of if else statements is to basically check where the correct answer is and plot the other wrong answers according to it.

    //check if the correct answer is in the top left box
    if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 3) {
        
        //plot the other "wrong" options in the other boxes according to the right answer location. First changing the location and then display the text(option)

        //first wrong options - top right
        randomizerX2[x] = width / 1.5;
        randomizerY2[y] = height / 3;
        text(n3 + n4, randomizerX2[x], randomizerY2[y]);

        //second wrong option - bottom left
        randomizerX3[x] = width / 3;
        randomizerY3[y] = height / 1.5;
        text(n5 + n6, randomizerX3[x], randomizerY3[y]);


        //third and last wrong option - bottom right
        randomizerX4[x] = width / 1.5;
        randomizerY4[y] = height / 1.5;
        text(n7 + n8, randomizerX4[x], randomizerY4[y]);


        //check if the correct answer is in the top right box
    } else if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 3) {

        //display the first wrong option - top left
        randomizerX2[x] = width / 3;
        randomizerY2[y] = height / 3;
        text(n3 + n4, randomizerX2[x], randomizerY2[y]);

        //display the second wrong option - bottom right
        randomizerX3[x] = width / 1.5;
        randomizerY3[y] = height / 1.5;
        text(n5 + n6, randomizerX3[x], randomizerY3[y]);

        //display the third wrong option - bottom right
        randomizerX4[x] = width / 3;
        randomizerY4[y] = height / 1.5;
        text(n7 + n8, randomizerX4[x], randomizerY4[y]);

        //check if the correct answer is in the bottom left box
    } else if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 1.5) {

        //display the first wrong option - top left
        randomizerX2[x] = width / 3;
        randomizerY2[y] = height / 3;
        text(n3 + n4, randomizerX2[x], randomizerY2[y]);

        //display the second wrong option - bottom right
        randomizerX3[x] = width / 1.5;
        randomizerY3[y] = height / 1.5;
        text(n5 + n6, randomizerX3[x], randomizerY3[y]);

        //display the third wrong option - top right
        randomizerX4[x] = width / 1.5;
        randomizerY4[y] = height / 3;
        text(n7 + n8, randomizerX4[x], randomizerY4[y]);

        //check if the correct answer is in the bottom right box
    } else if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 1.5) {

        //display the first wrong option - top left
        randomizerX2[x] = width / 3;
        randomizerY2[y] = height / 3;
        text(n3 + n4, randomizerX2[x], randomizerY2[y]);

        //display the second wrong option - bottom left
        randomizerX3[x] = width / 3;
        randomizerY3[y] = height / 1.5;
        text(n5 + n6, randomizerX3[x], randomizerY3[y]);

        //display the third wrong option - top right
        randomizerX4[x] = width / 1.5;
        randomizerY4[y] = height / 3;
        text(n7 + n8, randomizerX4[x], randomizerY4[y]);

    }

    //always display the score on the top right of the screen
    fill(255);
    text("Score: " + score, width / 1.15384615385, height / 9);

}

/*This function belongs to the mutltiple choice question as well. The reason I have a seprate function to check if the mouse is being pressed and doing code accordingly is because I'm using the
optionsQuestion(); function in the help page. If I have the code of optionsQuestionDetector(); function inside the optionsQuestion(); players will be able to interact with the help page
which I do not want
*/
void optionsQuestionDetector() {

    //check if the mouse is pressed (not held)
    if (mousePressed) {
        //check if the mouse was pressed in the top left box location
        if (mouseX >= width / 4.5 && mouseX <= width / 2.25 && mouseY >= height / 4.5 && mouseY <= height / 2.25) {

            //check if the correct answer is in the top left box
            if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 3) {
                //if so change the box colour to green and change state to be state 2 (continuing state) 
                fill(0, 250, 0);
                rect(width / 4.5, height / 4.5, width / 4.5, height / 4.5);
                fill(0);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                state = 2;
                //play the approving audio
                approve.rewind();
                approve.play();
                //add 1 to the score and 1 to the bonusRound variable
                score++;
                bonusRound++;

                //display the continue box
                fill(255, 0, 0);
                rect(width / 1.36363636364, height / 1.16883116883, width / 3.75, height / 9);
                fill(0);
                text("Continue", width / 1.15384615385, height / 1.07142857143);

                //else, check if the correct answer is in the top right box
            } else if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 3) {
                //if so then change the box colour of the top right box (the correct answer) to be green
                fill(0, 255, 0);
                rect(width / 1.8, height / 4.5, width / 4.5, height / 4.5);

                //change the top left box (which was pressed) to be red.
                fill(255, 0, 0);
                rect(width / 4.5, height / 4.5, width / 4.5, height / 4.5);
                //change colour to black and display all the numbers, basically reseting the frame.
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);

                //change the state to the lost state
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in red
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove audio
                disapprove.rewind();
                disapprove.play();


                //check if the correct answer is in the bottom left box
            } else if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 1.5) {
                //if so, change the colour of the bottom left box to be green (the correct answer)
                fill(0, 255, 0);
                rect(width / 4.5, height / 1.8, width / 4.5, height / 4.5);
                //change the colour of the top left box to be red (the box pressed)
                fill(255, 0, 0);
                rect(width / 4.5, height / 4.5, width / 4.5, height / 4.5);
                //change colour to black and display all text agai (reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);

                //change state to 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over text in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();

                //else, check if the correct answer is in the bottom right box
            } else if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 1.5) {
                //if so, change the bottom right box colour to be green (the correct answer)
                fill(0, 255, 0);
                rect(width / 1.8, height / 1.8, width / 4.5, width / 4.5);
                //change the top left box colour to be red (the box pressed)
                fill(255, 0, 0);
                rect(width / 4.5, height / 4.5, width / 4.5, height / 4.5);
                //change colour to black and display the numbers again(reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);

                //change the state to 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();

            }

        }
        //check if the top right box is pressed
        else if (mouseX >= width / 1.8 && mouseX <= width / 1.28571428571 && mouseY >= height / 4.5 && mouseY <= height / 2.25) {

            //check if the top right box is pressed (the correct answer (which is also b being pressed))
            if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 3) {
                //change the colour of the top right box to be green
                fill(0, 255, 0);
                rect(width / 1.8, height / 4.5, width / 4.5, height / 4.5);
                fill(0);
                //display the text of the correct answer again, which is in the same box pressed (reset frame)
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to state 2 (continuing state)
                state = 2;
                //play the approve/correct answer audio
                approve.rewind();

                approve.play();
                //add 1 to score and bonusRound variable
                score++;
                bonusRound++;
                //display the continuing box in bottom right
                fill(255, 0, 0);
                rect(width / 1.36363636364, height / 1.16883116883, width / 3.75, height / 9);
                fill(0);
                text("Continue", width / 1.15384615385, height / 1.07142857143);

                //else if the correct answer is in the bottom left box
            } else if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 1.5) {
                //change the colour of the bottom left box to be green (correct answer)
                fill(0, 255, 0);
                rect(width / 4.5, height / 1.8, width / 4.5, height / 4.5);
                //change the colour of the top right box to be red
                fill(255, 0, 0);
                rect(width / 1.8, height / 4.5, width / 4.5, height / 4.5);
                //change colour to black and display all numbers again (reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to be state 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();


                //else if the correct answer is in the top left box
            } else if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 3) {
                //change the colour of the top left box to be green (correct answer)
                fill(0, 255, 0);
                rect(width / 4.5, height / 4.5, width / 4.5, height / 4.5);
                //HEEEEEEEEEEEEEERRRRRRRRRREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
                //change the colour of the top right box to be red (box pressed)
                fill(255, 0, 0);
                rect(width / 1.8, height / 4.5, width / 4.5, height / 4.5);
                //change colour to be black and display numbers again (reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();

                //else if the correct answer is in the bottom right box
            } else if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 1.5) {
                //change the colour of the bottom right box to be green (correct answer)
                fill(0, 255, 0);
                rect(width / 1.8, height / 1.8, width / 4.5, height / 4.5);
                //change the colour of the top right box to be red (box pressed)
                fill(255, 0, 0);
                rect(width / 1.8, height / 4.5, width / 4.5, height / 4.5);
                //change colour to black and display the numbers again (reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to be state 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();


            }
            //else if the bottom left box is being pressed
        } else if (mouseX >= width / 4.5 && mouseX <= width / 2.25 && mouseY >= height / 1.8 && mouseY <= height / 1.28571428571) {
            //if the correct answer is in the bottom left box
            if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 1.5) {
                //change the colour of the bottom left box to be green (correct answer box)
                fill(0, 255, 0);
                rect(width / 4.5, height / 1.8, width / 4.5, height / 4.5);
                //change colour to black and display the corrct answer number again (reset frame)
                fill(0);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to state 2 (continuing state)
                state = 2;
                //play the approve/correct answer audio
                approve.rewind();
                approve.play();
                //add 1 to score and bonusRound variable
                score++;
                bonusRound++;
                //display the continue option bottom right of screen
                fill(255, 0, 0);
                rect(width / 1.36363636364, height / 1.16883116883, width / 3.75, height / 9);
                fill(0);
                text("Continue", width / 1.15384615385, height / 1.07142857143);

                //else if the correct answer is in the top left box
            } else if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 3) {
                //change the top left box colour to be green (correct answer)
                fill(0, 255, 0);
                rect(width / 4.5, height / 4.5, width / 4.5, height / 4.5);
                //change the colour of the bottom left box to be red (box pressed)
                fill(255, 0, 0);
                rect(width / 4.5, height / 1.8, width / 4.5, width / 4.5);
                //change colour to black and display all numbers again (reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();

                //else if the corect answer is in the top right box
            } else if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 3) {
                //change the colour of the top right box to be green (correct answer)
                fill(0, 255, 0);
                rect(width / 1.8, height / 4.5, width / 4.5, height / 4.5);
                //change the colour of the bottom left box to red (box pressed)
                fill(255, 0, 0);
                rect(width / 4.5, height / 1.8, width / 4.5, height / 4.5);
                //change colour to 0 and display all numbers again (reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrongn answer audio
                disapprove.rewind();
                disapprove.play();

                //else if the correct answer is in the bottom right box
            } else if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 1.5) {
                //change the colour of the bottom right box to green (correct answer)
                fill(0, 255, 0);
                rect(width / 1.8, height / 1.8, width / 4.5, height / 4.5);
                //change the colour of the bottom left box to red (box pressed)
                fill(255, 0, 0);
                rect(width / 4.5, height / 1.8, width / 4.5, height / 4.5);
                //change colour to 0 and display all numbers again
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to state 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();


            }
            //else if the bottom right box is pressed
        } else if (mouseX >= width / 1.8 && mouseX <= width / 1.28571428571 && mouseY >= height / 1.8 && mouseY <= height / 1.28571428571) {
            //if the correct answer is in the bottom right box
            if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 1.5) {
                //change the colour of the bottom right box to be green (correct answer)
                fill(0, 250, 0);
                rect(width / 1.8, height / 1.8, width / 4.5, height / 4.5);
                //change the colour to 0 and display the number again (reset frame)
                fill(0);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to state 2 (continuing state)
                state = 2;
                //play the approve/correct answer audio
                approve.rewind();
                approve.play();
                //add 1 to score and bonusRound
                score++;
                bonusRound++;
                //display the continue button in the bottom right of the screen
                fill(255, 0, 0);
                rect(width / 1.36363636364, height / 1.16883116883, width / 3.75, height / 9);
                fill(0);
                text("Continue", width / 1.15384615385, height / 1.07142857143);

                //else if the correct answer is in the top left box
            } else if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 3) {
                //change the colour of the top left box to green (correct answer)
                fill(0, 255, 0);
                rect(width / 4.5, height / 4.5, width / 4.5, height / 4.5);
                //change the colour of the bottom right box to be red (box pressed)
                fill(255, 0, 0);
                rect(width / 1.8, height / 1.8, width / 4.5, height / 4.5);
                //change colour to black and display the numbers again (reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();

                //else, if the correct answer is in the top right box
            } else if (randomizerX1[x] == width / 1.5 && randomizerY1[y] == height / 4.5) {
                //change the colour of the top right box to green (correct answer)
                fill(0, 255, 0);
                rect(width / 1.8, height / 4.5, width / 4.5, height / 4.5);
                //change the colour of the bottom right box to red (box pressed)
                fill(255, 0, 0);
                rect(width / 1.8, height / 1.8, width / 4.5, height / 4.5);
                //change colour to black and display the numbers again (reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change state to 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();

                //else, if the correct answer is in the bottom left box
            } else if (randomizerX1[x] == width / 3 && randomizerY1[y] == height / 1.5) {
                //change the colour of the bottom left box to green (correct answer)
                fill(0, 255, 0);
                rect(width / 4.5, height / 1.8, width / 4.5, height / 4.5);
                //change the colour of the bottom right box to red (box pressed)
                fill(255, 0, 0);
                rect(width / 1.8, height / 1.8, width / 4.5, height / 4.5);
                //change colour to black and display the numbers again (reset frame)
                fill(0);
                text(n7 + n8, randomizerX4[x], randomizerY4[y]);
                text(n5 + n6, randomizerX3[x], randomizerY3[y]);
                text(n3 + n4, randomizerX2[x], randomizerY2[y]);
                text(n1 + n2, randomizerX1[x], randomizerY1[y]);
                //change the state to 3 (losing state)
                state = 3;
                textSize(width / 15);
                fill(255, 0, 0);
                //display game over in the middle of the screen
                text("GAME OVER", width / 2, height / 1.91489361702);
                textSize(width / 22.5);
                fill(0);
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();
            }
        }
    }

}
/*this function is called for the help page. The idea of the help page is to show the player how the game will proceed without letting them interact. Therefore, the functions for the 
bonus level page and for the multiple choice question will be called, but without their if-else statements for mousePressed.
*/
void instructions() {
    //set -always- the zombie x location to be 330
    zombieX = width / 1.36363636364;
    //this is a simple if statement to change the text displayed on the screen. This is much more concise than other ways

    //if the player is on the first instruction page then:
    if (instructionPages == 0) {
        //change the instructionText value to the following:
        instructionText = "The game consists\n of 4 multiple choice questions\n followed by a bonus level";

        //else if the player is on the second instructions page
    } else if (instructionPages == 1) {
        //change the instructionText value to the following:
        instructionText = "If you do not answer\nbefore the zombie reaches you,\n you will lose";

        //else if the player is on the third instructions page
    } else if (instructionPages == 2) {
        //change the instructionText value to the following:
        instructionText = "After every 4 multiple choice\n questions you will get a bonus level\nwhere you will type out\n the correct answer";

        //else if the player is on the fourth instructions page
    } else if (instructionPages == 3) {
        //change the instructionText value to the following:
        instructionText = "The questions will get harder\nand the zombie will get faster\nafter each bonus level";
    }

    //if the player is on the first and second instructions pages then do the following code, as the first and second pages have the same code except for changing the text displayed
    if (instructionPages == 0 || instructionPages == 1) {
        //call the optionsQuestion function, which draws the screen for the multiple choice question
        optionsQuestion();
        //set the zombie x location to 330
        zombieX = width / 1.36363636364;
        //displaying the instructionText text, the same text that had an else-if statement above
        push();
        textSize(width / 32.1428571429);
        text(instructionText, width / 2, height / 1.21621621622);
        pop();
        //setting up the boxes for the "Next" and "Back" buttons
        fill(255);
        fill(0, 200, 0);
        rect(width / 1.125, height / 2 - height / 18, width / 9, height / 10);
        fill(200, 0, 0);
        rect(0, height / 2 - height / 18, width / 9, height / 10);
        fill(0);
        push();
        //display the "Next" and "Back" text on their buttons.
        textSize(width / 28.125);
        text("Next", width / 1.05882352941, height / 2);
        text("Back", width / 18, height / 2);
        pop();

        //else, if the player is on the third or the fourth instructions page, then execute the following code, it is the same idea as for the first and second page.
    } else if (instructionPages == 2 || instructionPages == 3) {
        //set the zombie x location to 330
        zombieX = width / 1.36363636364;
        //call the bonusLevel function, which draws the screen for the bonus level question.
        bonusLevel();
        //display the instructionText text, which is different for each instruction page.
        push();
        textSize(width / 32.1428571429);
        fill(255);
        text(instructionText, width / 2, height / 1.36363636364);
        pop();
        //setting up the boxes for "Next" and "Back" buttons on the screen
        fill(255);
        fill(0, 200, 0);
        rect(width / 1.125, height / 2 - height / 18, width / 9, height / 10);
        fill(200, 0, 0);
        rect(0, height / 2 - height / 18, width / 9, height / 10);
        fill(0);
        push();
        textSize(width / 28.125);
        //display the text "Next" and "Back" on their boxes
        text("Next", width / 1.05882352941, height / 2);
        text("Back", width / 18, height / 2);
        pop();
    }
    //if we are on the last instructionPages, then change the "Next" button to be "Main Menu" instead
    if (instructionPages == 3) {
        fill(0, 200, 0);
        rect(width / 1.25, height / 2 - height / 18, width / 5, height / 10);
        fill(0);
        push();
        textSize(width / 28.125);
        text("Main Menu", width / 1.11111111111, height / 2);
        pop();

    }



}

void mousePressed() {

    //if the player is on state 0 - the main page
    if (state == 0) {
        //check if the mouse is being pressed inside the "Start" button
        if (mouseX >= width / 2.8125 && mouseX <= width / 1.55172413793 && mouseY >= height / 9 && mouseY <= height / 4.5) {
            //if so, change the state to 5 - choosing a gamemode state
            state = 5;
        } else if (mouseX >= width / 2.8125 && mouseX <= width / 1.55172413793 && mouseY >= height / 2.25 && mouseY <= height / 1.8) {
            //else, if the mouse is being pressed inside the "Help" button then:
            //change the instructionPages variable to be 0, which is the first instruction page
            instructionPages = 0;
            //change the state to 7 - help page state
            state = 7;
            //call the optionsRandomizer(); function ONCE to display some real numbers on the help screen, not just 0
            optionsRandomizer();
        } else if (mouseX >= width / 2.8125 && mouseX <= width / 1.55172413793 && mouseY >= height / 1.28571428571 && mouseY <= height / 1.125) {
            //else, if the mouse is being pressed inside the "Exit" button
            //exit and close the code
            exit();
        }
    } else if (state == 1) {
        //else, if the player is on state 1, then call the optionsQuestionDetector(); function, which is the function made to observe the mouse interactions of the player
        optionsQuestionDetector();

        //else, if the player is on state 2 - the continuing state:
    } else if (state == 2) {

        //if the mouse is being pressed on the "Continue" button then:
        if (mouseX >= width / 1.36363636364 && mouseX <= width && mouseY >= height / 1.16883116883 && mouseY <= height / 1.03448275862) {
            //change the state back to 1 (the multiple choice question state)
            state = 1;
            //call the optionsRandomizer(); and the optionsQuestions(); function once.
            optionsRandomizer();
            optionsQuestion();
        }

        //else if the player is on state 4 - bonus level state:
    } else if (state == 4) {
        //if the mouse is being pressed inside the "Continue" button:
        if (mouseX >= width / 1.36363636364 && mouseX <= width && mouseY >= height / 1.16883116883 && mouseY <= height / 1.03448275862) {
            //NOTE - bonusRound increases with score, which means whenever the player finishes 5 multiple choice question the bonusRound will be equal to 5. The idea behind it is to make a system
            //that changes the question/page after every 5 multiple choice question and display the bonus level instead.
            //if bonusRound is equal to 5 then execute the following code
            if (bonusRound == 5) {
                //this code is to randomize and set up the round for the bonus level:

                //set zombie x location to 460 (out f the canvas.
                zombieX = width / 0.97826086956;
                //randomize the correct answer numbers, which basically means all the numbers because of the fact that the rest of the numbers depend on these 2 numbers
                n1 = int(random(randomizer1, randomizer2));
                n2 = int(random(randomizer1, randomizer2));
                //pause the bonus level audio
                bonusAudio.rewind();
                bonusAudio.play();
                //play the audio for the multiple choice question
                intense.pause();
                bonusRound = 0;
            }
        }
        //else, if the player is in state 5 - the gamemode selection state:
    } else if (state == 5) {

        //if the mouse is being pressed inside the "Campagin Mode" button:
        if (mouseX >= width / 3.33333333333 && mouseX <= height / 1.42857142857 && mouseY >= height / 18 && mouseY <= height / 6) {
            //change the campaginMode variable to true. There is an if statement that will be activiated when campaignMode is equal to true, which basically says "If the player reaches to score 30
            //then change the continue button destination to be a congrats page.
            campaignMode = true;
            //change state to 1 - multiple choice state
            state = 1;
            //play the intense audio (the audio for multiple choice questions
            intense.rewind();
            intense.play();
            //pause the main page audio
            startingAudio.pause();

            //call the optionsRandomizer(); function to randomize the numbers ONCE
            optionsRandomizer();
            zombieSpeed = (width - width / 1.00066711141)*2;

            //else if the mouse is being pressed inide the "Infinite Mode" button:
        } else if (mouseX >= width / 3.33333333333 && mouseX <= width / 1.42857142857 && mouseY >= height / 2.25 && mouseY <= height / 1.8) {
            //change state to 1 - multiple choice question
            state = 1;
            //call the optionsRandomizer(); function to randomize the questions ONCE
            optionsRandomizer();
            //make sure campaignMode is equal to false so that the if statement inside draw is not activated
            campaignMode = false;
            //play the intense audio (multiple choice question audio)
            intense.rewind();
            intense.play();
            //pause the starting page audio
            startingAudio.pause();
            zombieSpeed = (width - width / 1.00066711141)*2;;

            //else if the mouse is being pressed inside the "Help" button:
        } else if (mouseX >= width / 2.8125 && mouseX <= width / 1.57894736842 && mouseY >= height / 1.125 && mouseY <= height) {
            //change instructionPages variable to be 0
            instructionPages = 0;
            //change state to 7 - instructions/help page state
            state = 7;
            //call the optionsRandomizer(); function ONCE to randomize the numbers in the help page
            optionsRandomizer();
        }


        //else, if the player is in state 6 - congrats page state:
    } else if (state == 6) {
        /*This might be a little confusing. I have a mainMenuTrigger variable which is in first equals to false, I have this variable because I want two seprte codes to be called when the same
        button is clicked, a code on the first click and the second code on the second click. So I added a mainMenuTrigger variable and an if statement
        which says "If it is false (which is happening) then execute the first code and change the variable's value to true so that this code does not get executed again" and then
        an else if statement that says "else if the mainMenuTrigger is equal to true (which is happening after the first click) then execute the second code)"
        Hope that makes sense
        */
        //if the mouse is being pressed inside the "Continue" button:
        if (mouseX >= width / 1.36363636364 && mouseX <= width && mouseY >= height / 1.16883116883 && mouseY <= height / 1.03448275862) {
            //check if the mainMenuTrigger variable is equal to false
            if (mainMenuTrigger == false) {
                //display the congrats page
                background(230, 255, 255);
                text("CONGRATS! \n YOU WON", width / 2, height / 2);
                //display the "Main Menu" button, which now replaced the "Continue" button.
                fill(255, 0, 0);
                rect(width / 1.36363636364, height / 1.16883116883, width / 3.75, height / 9);
                fill(0);
                text("Main Menu", width / 1.15384615385, height / 1.07142857143);
                //set the mainMenuTrigger to true so that this code does not get executed again
                mainMenuTrigger = true;

                //check if the mainMenuTrigger variable is equal to true, which should be happening after the first click
            } else if (mainMenuTrigger == true) {
                //pause the multiple choice music and the bonus level music and play the starting music
                intense.pause();
                bonusAudio.pause();
                startingAudio.rewind();
                startingAudio.play();
                //reset the score to 0 and change the state to 0 (main menu state)
                state = 0;
                score = 0;
            }
        }

        //else if the player is on state 7 - instructions/help state
    } else if (state == 7) {
        //This is a simple if-else statement to make sure that whenever the next or the back buttons are clicked they do not go higher or lower than the page numbers that exist
        if (instructionPages >= -2 && instructionPages <= 2) {
            //if the mouse is being pressed inside the "Next" button:
            if (mouseX >= width / 1.125 && mouseX <= width && mouseY >= height / 2.25 && mouseY <= height / 1.83673469388) {
                //add 1 to the instructionPages variable; change the instruction page to the next one
                instructionPages++;
                //else if the mouse is being pressed inside the "Back" button
            } else if (mouseX >= 0 && mouseX <= width / 9 && mouseY >= height / 2.25 && mouseY <= height / 1.83673469388) {
                //subtract 1 from the instrucionPages variable; change the instructions page to the previous one
                instructionPages--;
            }
            //else, which is mainly set to be if the instructionPages is higher than 3, because it will never go below -1 due to the code below
        } else {
            //if mouse is being pressed inside the "Next" -which is now "Main Menu"- button:
            if (mouseX >= width / 1.25 && mouseX <= width && mouseY >= height / 2.25 && mouseY <= height / 1.83673469388) {
                //set the instructionPages to -1
                instructionPages = -1;

                //else if the mouse is being pressed inside the "Back" button:
            } else if (mouseX >= 0 && mouseX <= width / 9 && mouseY >= height / 2.25 && mouseY <= height / 1.83673469388) {
                //subtact 1 from instructionPages variable; change the page to the previous one
                instructionPages--;
            }
        }
        //this is always running when state is equal to 7 (instructions state)
        //if the instructionPages variable value is ever below 0, then change the state to 0 (main menu state)
        if (instructionPages < 0) {
            state = 0;
        }
    }

}

//this function draws the screen for the bonus level question
void bonusLevel() {
    //check if bonusRound is equal to 0. This if statement is necessary because in state 4 (the bonus level state) bonusRound variale is not always set to 0, and I do not want the screen to be
    //displayed unless the bonusRound is equal to 0.
    if (bonusRound == 0) {
        //display the background image
        push();
        background(255);
        tint(140, 140, 140, 250);
        image(bonusLevelBackground, 0, 0, width, height);
        pop();

        //this if statement is to maintain the digits inputted down so that the whole number does not go outside the box.
        //check if the number inputted is bigger than 8 digits
        if (str_num.length() >= 8) {
            //if so, display "Too many numbers!" on the screen.
            text("Too many numbers!", width / 2, height / 1.125);
        }

        push();
        //display the birch iage for the equation at the top, I'm drawing a rect behind the image so I get a thicker stroke, since stroke(); does not work on images
        strokeWeight(3);
        rect(width / 3, height / 18, width / 3.10344827586, height / 11.25);
        image(birch, width / 3, height / 18, width / 3.10344827586, height / 11.25);
        fill(0);
        textSize(width / 19.5652173913);
        //display the equation inside the birch box
        text(n1 + " + " + n2, width / 2, height / 9);
        pop();
        //set the box for the number input
        fill(255);
        rect(width / 2.64705882353, height / 2.04545454545, width / 4.09090909091, height / 9, 10);
        fill(0);
        //str_num variable is the number inputted.
        text(str_num, width / 2, height / 1.8);
        fill(255);
        //display the score top right
        text("Score: " + score, width / 1.15384615385, height / 9);
        fill(255, 0, 0);
        //display the zombie on screen
        image(zombie, zombieX, height / 1.40625, width / 4.5, height / 3.46153846154);
        //display the main character on the screen
        image(mainCharacter, width / -9, height / 0.97826086956 - height / 2.25, width / 2.64705882353, height / 2.25);
        //display "BONUS LEVEL" text and change its colour randomly all the time
        fill(random(255), random(255), random(255));
        text("BONUS LEVEL", width / 2, height / 1.04651162791);
        //animate the zombie to move from right to left (getting closer to the main character)
        zombieX = zombieX - zombieSpeed;
        //check if the zombie has touched the main character:
        if (zombieX <= width / 4.5) {
            //if so, draw a box below the answering box
            //make its colour green and display the correct answer inside it
            fill(0, 255, 0);
            rect(width / 2.64705882353, height / 1.5, width / 4.09090909091, height / 9, 10);
            fill(0);
            text(n1 + n2, width / 2, height / 1.36363636364);

            //change the colour of the answering box to red and redisplay the answer was written (wrong answer) (reset frame)
            fill(255, 0, 0);
            rect(width / 2.64705882353, height / 2.04545454545, width / 4.09090909091, height / 9, 10);
            fill(0);
            text(str_num, width / 2, height / 1.8);
            fill(255, 0, 0);
            //display game over in the middle of the screen
            textSize(width / 15);
            fill(255, 0, 0);
            text("GAME OVER", width / 2, height / 2.25);
            textSize(width / 22.5);
            fill(0);
            push();
            //change the colour of the main character to be red
            tint(255, 0, 0);
            image(mainCharacter, width / -9, height / 0.97826086956 - height / 2.25, width / 2.64705882353, height / 2.25);
            pop();
            //change the state to state 3 (losing state)
            state = 3;
            //reset the number input to be empty so the previous answer does not show up when the player restarts the game and reaches to the bonus level again
            str_num = "";
            //reset the score to 0
            score = 0;
            //play the dying/being hit audio
            died.rewind();
            died.play();
            //pause the bonus level music
            bonusAudio.pause();


        }

    }
}


void keyPressed() {



   
    //if the player is in state 4 (bonus level state)
    if (state == 4) {
        //check if the variable used to display the answer is less than 7 digits, just to make sure it is not going outside the box
        if (str_num.length() <= 7) {
            //check if the key pressed is anywhere from 0 to 9, note that if any key other than numbers is being pressed nothing will happen.
            if (key >= '0' && key <= '9') {
                //then add this number/key pressed to str_num variable (the number displayed on the screen)
                str_num += key;

            }
        }

        //check if the "ENTER" key is being pressed
        if (key == ENTER) {
            //store the value of str_num (the answer inputted by the player) inside the new variable, num in an integer shape
            num = int(str_num);
            //check if num (the answer) is correct:
            if (num == n1 + n2) {
                //change the colour of the box to be green
                fill(0, 255, 0);
                rect(width / 2.64705882353, height / 2.04545454545, width / 4.09090909091, height / 9, 10);
                fill(0);
                //display the text again (reset frame)
                text(str_num, width / 2, height / 1.8);
                //add 1 to score
                score++;
                //add 1 to bonusRound variable, which maintains the bonus level
                bonusRound++;
                //change state to state 2 (continuing state)
                state = 2;
                //play the approve/correct answer audio
                approve.rewind();
                approve.play();
                //if you remember the randomizer1 and randomizer2 variables were used inside the random() code to represent the range of numbers in the options level in this way:
                //random(randomizer1,randomizer2). I said before that after each bonus level the questions will get harder
                //it gets harder because these 2 numbers are increasing after each bonus level by the 2 lines of code below:
                //add 30 to the value of randomizer1
                randomizer1 += 30;
                //add 45 to the of randomizer2
                randomizer2 += 45;
                //reset the str_num to be empty
                str_num = "";
                //add 0.1 to the zombieSpeed to make the zombie walk faster, aka the questions will get harder to answer
                zombieSpeed += (width - width / 1.00022227162)*2;
                //pause the bonus level music
                bonusAudio.pause();
                //play the multiple choice questions audio
                intense.rewind();
                intense.play();
            } else {
                //else, which means else if the number entered is NOT the correct answer:
                //pause the bonus level music
                bonusAudio.pause();
                //play the disapprove/wrong answer audio
                disapprove.rewind();
                disapprove.play();
                //if the score is higher than the highScore variable, then store the score variable inside the highScore variable
                //this just maintains the high score that is displayed in the gamemode selection page
                if (score > highScore) {
                    highScore = score;

                }

                //draw a new box below the answering box and change its colour to green
                fill(0, 255, 0);
                rect(width / 2.64705882353, height / 1.5, width / 4.09090909091, height / 9, 10);
                fill(0);

                //display the correct answer inside this box
                text(n1 + n2, width / 2, height / 1.36363636364);
                //change the colour of the answering box to red
                fill(255, 0, 0);
                rect(width / 2.64705882353, height / 2.04545454545, width / 4.09090909091, height / 9, 10);
                fill(0);
                text(str_num, width / 2, height / 1.8);
                fill(255, 0, 0);

                //reset the str_num to be empty
                str_num = "";
                //change the state to 3 (losing state)
                state = 3;
                //reset the score to 0
                score = 0;
            }

        }
    }
    //if the "BACKSPACE" key is pressed:
    if (key == BACKSPACE) {
        //basically subtract 1 char from the str_num variable, which is the answer entered by the player
        str_num = str_num.substring(0, max(0, str_num.length() - 1));
    }

}
//this function draws the main menu page
void startingPage() {
    //display the background image for the main menu page
    push();
    //make it a little darker to make the text easier to read
    tint(180);
    image(backgroundHome, 0, 0, width, height);
    textSize(width / 15);
    fill(255);
    //display the game name at the top; Minematics
    text("Minematics", width / 2, height / 15);
    pop();
    fill(255);
    //basic for loop to draw the options boxes (start, help, and exit)
    for (float startingBoxesY = height / 9; startingBoxesY <= height / 1.28571428571; startingBoxesY += height / 3) {
        push();
        //the same trick is used here, where I drew a rect behind the boxes to have a thicker stroke.
        strokeWeight(3);
        stroke(0);
        tint(255);
        strokeWeight(6);
        rect(width / 2.8125, startingBoxesY, width / 3.46153846154, height / 9);
        image(brick, width / 2.8125, startingBoxesY, width / 3.46153846154, height / 9);
        pop();

    }
    //display the text inside each box
    fill(0);
    text("Start", width / 2, height / 5.625);
    text("Help", width / 2, height / 1.95652173913);
    text("Exit", width / 2, height / 1.18421052632);

}





//call draw function
void draw() {
    //make sure the textAlign is cetnered
    textAlign(CENTER);
    //if the player is in state 0 - main menu state
    if (state == 0) {
        //set bonusRound to 0
        bonusRound = 0;
        //set randomizer1 to 15
        randomizer1 = 15;
        //set randomizer2 to 30
        randomizer2 = 30;
        //NOTE - I'm reseting the randomizer1 and randomizer2 variables in the draw function due to a glitch that I couldn't find out how to solve easier than this solution.
        //call the startingPage(); function to draw the main menu page
        startingPage();

        //else if the player is in state 1 - multiple choice question state:
    } else if (state == 1) {
        //call the optionsQuestion(); function to draw the multiple choice question page
        optionsQuestion();

        //else if the player is in state 2 - continue state
    } else if (state == 2) {
        //display the "Continue" button
        fill(255, 0, 0);
        rect(width / 1.36363636364, height / 1.16883116883, width / 3.75, height / 9);
        fill(0);
        text("Continue", width / 1.15384615385, height / 1.07142857143);

        //else if the player is in state 3 - losing state
    } else if (state == 3) {
        //display the "Exit" button
        fill(255, 0, 0);
        rect(width / 1.36363636364, height / 1.16883116883, width / 3.75, height / 9);
        fill(0);
        text("Exit", width / 1.15384615385, height / 1.07142857143);
        //check if the mouse is being pressed inside the exit button
        if (mousePressed) {
            if (mouseX >= width / 1.36363636364 && mouseX <= width && mouseY >= height / 1.16883116883 && mouseY <= height / 1.03448275862) {
                //basically maintains the highScore variable that is displayed in the gamemode selection page
                if (score > highScore) {
                    highScore = score;
                }
                //reset state to 0
                state = 0;
                //reset score to 0
                score = 0;
                //reset bonusRound to 0
                bonusRound = 0;
                //pause the multiple choice question music
                intense.pause();
                //play the main menu music
                startingAudio.rewind();
                startingAudio.play();
                //reset the zombe speed to 0.3
                zombieSpeed = (width - width / 1.00066711141)*2;
            }
        }
        //else if the player is in state 4 (bonus level state)
    } else if (state == 4) {
        bonusLevel();

        //else if the player is in state 5 - gamemode selection page
    } else if (state == 5) {
        //call the gamemodeSelection(); function
        gamemodeSelection();

        //else if the player is in state 7 (the help/instructions page state)
    } else if (state == 7) {
        //call the instructions(); function
        instructions();


    }
    //always check if campaignMode is equal to true:
    if (campaignMode == true) {
        //check if the player have reached a score of 31
        if (score == 31) {
            //if so, change the state to 6 (winning page state)
            state = 6;
        }
    }
    //always check if bonusRound is equal to 5
    if (bonusRound == 5) {
        //if so, change the state to 4 (bonus level state)
        state = 4;
    }
}

//THE END
