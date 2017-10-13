//2014 Temperature Grapher
//See Temperature/Humidity Grapher for redesign.

import processing.serial.*;
Serial myPort;
PFont Font1;
String val;
int temperatureValue = 0;
int temperatureMax = 0;
int temperatureMin = 0;
float average;
float sum = 0.00;
int numcount = 0; //number of values accounted for in the average
int previoustime = 0;
int graphX = 100;
int graphY = 1024 - 85;
int numberX = 0;
int numberY = 0;
int minpointX = 145;
float oldaverage = 0.00;
PImage img;
int onetimetemp = 0;
boolean drawnBoolean = false;
int onetime = 0;
void setup() {
    size(1280, 1024);
    println(Serial.list());
    myPort = new Serial(this, Serial.list()[1], 9600);
    background(255);
    Font1 = createFont("Vineta BT", 15);
    img = loadImage("back.jpg");
}

void draw() {
    int time = millis();
    if (onetime == 0) {
        image(img, 0, 0);
        drawWords();
        drawNumbersHorizontal();
        drawNumbersVertical();
        onetime++;
    }
    while (myPort.available() > 0) {
        delay(1000);
        val = myPort.readString();
        if (val.length() > 69 && val.length() < 72) {
            temperatureValue = Integer.parseInt(val.substring(val.indexOf("Temperature") + 13, val.indexOf("Temperature") + 15));
            if (onetimetemp == 0) {

                temperatureMin = temperatureValue;
                onetimetemp++;

            }

            average();
            println("ThisAverage " + average);
        }
        println(temperatureValue);

        //    println(numcount);
        println(time);
        max();
        println("maxtemp" + temperatureMax);
        min();
        println("mintemp" + temperatureMin);
    }

    bigGraph();
    checkIfThirtyMinutes(time);

}

void bigGraph() {


    fill(255);
    rect(100, 100, 5, height - 200);
    rect(100, height - 100, width - 200, 5);
}

void max() {
    if (temperatureValue > temperatureMax) {
        temperatureMax = temperatureValue;
    }
}
void min() {
    if (temperatureValue != 0 && temperatureValue < temperatureMin) {
        temperatureMin = temperatureValue;
    }
}

void average() {
    if (temperatureValue != 0) {
        sum += temperatureValue;
        numcount++;
        average = sum / numcount;
    }
}

void checkIfThirtyMinutes(int time) {
    if (time - previoustime > 10000) {
        //draws the min temperature point
        fill(255);
        strokeWeight(10);
        stroke(255, 66, 66);
        point(minpointX, height - (temperatureMin * 15) - 95);
        stroke(255, 0, 255);
        point(minpointX, height - (temperatureMax * 15) - 95);
        stroke(0, 233, 250);
        point(minpointX, height - (average * 15) - 95);
        if (temperatureMin == temperatureMax) {
            stroke(250, 250, 0);
            point(minpointX, height - (temperatureMax * 15) - 95);
        }
        strokeWeight(1);
        stroke(255);
        line(minpointX, height - (average * 15) - 95, minpointX - 45, height - (oldaverage * 15) - 95);
        minpointX = minpointX + 45;

        //ends the min temperature draw point code

        previoustime = time;
        numcount = 0;
        temperatureMax = 0;
        temperatureMin = 0;

        oldaverage = average;



        average = 0.00;
        onetimetemp = 0;
        sum = 0;

    }
}

void drawWords() {

    if (drawnBoolean == false) {
        pushMatrix(); //pushes a matrix so we can make adjustments such as rotating
        float x = 30;
        float y = 400;
        textAlign(CENTER, BOTTOM);
        textSize(30);
        translate(x, y);
        rotate(-HALF_PI); //we rotate the text by 180 degrees.
        fill(255);
        text("TemperatureValue(°C)", -85, 0);
        popMatrix();
        textSize(30);
        fill(255);
        text("Temperature Over Time", width / 2, 50);
        text("Time in Minutes", width / 2, height - 20);
        textSize(15);

        drawnBoolean = true;
    }
}

void drawNumbersHorizontal() {
    while (graphX < width - 75) {
        fill(255);
        textFont(Font1);
        textSize(15);
        text(numberX, graphX, height - 75);
        numberX = numberX + 30;
        graphX = graphX + 45;
    }
}

void drawNumbersVertical() {
    while (graphY > 100) {
        fill(255);
        textFont(Font1);
        textSize(15);
        text(numberY, 80, graphY);
        numberY = numberY + 1;
        graphY = graphY - 15;
    }
}