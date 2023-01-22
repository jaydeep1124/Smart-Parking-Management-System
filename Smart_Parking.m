clc
clear all
close all
format compact % fromat style to reduce blank spaces on screen
NumberOfCars=0;  %Initial parking spot is empty since no car parked
availablespace=13; %Total 13 spots are available for parking  
Uno=arduino('COM8','Uno','libraries',{'ExampleLCD/LCDAddon','Servo','I2C'},'ForceBuild',true); %calling matlab library for LCD

%Connecting LCD libraries
lcd = addon(Uno,'ExampleLCD/LCDAddon','RegisterSelectPin','D2','EnablePin','D3','DataPins',{'D4','D5','D6','D7'}); %pin connections of LCD to Arduino
initializeLCD(lcd,'Rows', 2, 'Columns', 16);  % initializing LCD 

% Connecting the Servo Motor
Arm=servo(Uno,'D9','MinPulseDuration',700*10^-6,'Maxpulseduration',2300*10^-6);
configurePin(Uno,'A1','DigitalInput'); % Assigning the Enter button
configurePin(Uno,'A2','DigitalInput'); % Assigning Exit button
writeDigitalPin(Uno,'D13',1); %LED Green light connection
writeDigitalPin(Uno,'D12',0); %LED Red light connection
writePosition(Arm,0); % Intially barrier arm is closed

%LCD is clear initially 
clearLCD(lcd); 
printLCD(lcd,'Welcome!!!');% Printing Welcome message. 
pause(3)

clearLCD(lcd); 
printLCD(lcd,'Group Number: 23');% Printing group number
pause(3)

clearLCD(lcd); % Printing project partner name
printLCD(lcd,'Jaydeep Udit');% Printing project partner name
pause(3)
  
   for i = 11:-1:2
         printLCD(lcd,i); 
   end
 
printLCD(lcd,['Empty Spots:',num2str(availablespace)])  % Showing total empty slots

%using while condition to manipulate number of parking slots, red and green light and servo motor

while 1  % This loop will repeat till the condition is met.
    enter_push=readDigitalPin(Uno,'A1'); 
    exit_push=readDigitalPin(Uno,'A2');
    if availablespace>0
        if enter_push==true % If Enter buton is pressed
            clearLCD(lcd);
            printLCD(lcd,'Welcome!!! ') % Showing Welcome!!! messege
            availablespace=availablespace-1; % Decreasing available space by 1
            writeDigitalPin(Uno,'D13',1); % Green light ON
            writeDigitalPin(Uno,'D12',0); % Red light OFF
            writePosition(Arm,0.5) % Barrier arm opens at 90 degree
            pause(5) % Barier arm take 2 sec pause to pass the car
            writePosition(Arm,0) % Barrier arm closes
            str1='Empty Spots:'; % Display empty slots
            str2=num2str(availablespace); % showing available spaces
            printLCD(lcd,strcat(str1,str2));
        end
        writeDigitalPin(Uno,'D13',0); % Green light OFF
        writeDigitalPin(Uno,'D12',1); % Red light ON
    else
        clearLCD(lcd); 
        printLCD(lcd,'Plz Come Later'); % When no empty slot is there
        str1='Empty Spots:';
        str3=num2str(availablespace); % Display available spaces
        printLCD(lcd,strcat(str1,str3));
    end
    if availablespace<13
        if exit_push==true  %Exit button is pressed
            writeDigitalPin(Uno,'D13',1); % Red light ON
            writeDigitalPin(Uno,'D12',0); % Green light OFF
            clearLCD(lcd); 
            printLCD(lcd,'Safe Journey') 
            availablespace=availablespace+1; % Increasing available slot by 1
            str1='Empty Spots:';
            str2=num2str(availablespace); 
            printLCD(lcd,strcat(str1,str2)); 
            writePosition(Arm,0.5) % Barrier arm opens at 90 degree
            pause(3) % Barier arm take 2 sec pause to pass the car
            writePosition(Arm,0) % Barrier arm closes
        end
        writeDigitalPin(Uno,'D13',0); % Green light OFF
        writeDigitalPin(Uno,'D12',1); % Red light ON
    end
end

