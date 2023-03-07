// This is a rather long-winded script put together to enable linked mesh to be toggable through a script driven menu within Second Life.
// Do this this being highly personal to the mesh I wanted to use, this will need to be heavily altered by anyone who wishes to use this as a base.

// Code that enables to pull mesh objects by their name.
alphaset(integer alpha, string find, integer faces)
{
        integer i = llGetNumberOfPrims();
        for (; i >= 0; --i)
        {
        if(llGetLinkName(i) == find)
        {
        llSetLinkAlpha(i,alpha,faces);
        }
    }
}

//Letting the script know my KEY.
key zen = "d4f55417-8476-43dc-a7ed-cb93ba14d1fd";

// Flip switch to enable/disable itneractions.
integer enabled = 1;

// Setting the hover text.
string hoverText = "Click My Head to\nAlter Me";
vector COLOR_WHITE = <1.0, 1.0, 1.0>;
float  OPAQUE      = 1.0;
integer textEnabled = 0;

// Base level of the script menu.
string message = "\nWelcome to my interactive menu!\nVersion 1.0";
list coreOptions = ["X", "Strip Me!", "Shape Folder", "Breast Sizes", "Shape Size", "Clothing Options"];

string shapeFolderText = "\nChoose Between Shape Folders";
list shapeFolder = ["Standard", "Main Menu", "Short Stack"];

string clothingMessage = "\nChoose a category!";
list clothingSizes = ["Basics", "Main Menu"];


string breastMessage = "\nAre we going big today or full on hyper? :3";
list breastChoices = ["Hypers(BB)", "x", "Hypers(Smoosh)", "Biggies(BB)", "Why...?", "Biggies(Smoosh)"];

string shapeMessage = "\nPick a breast size you prefer. ;3";
list shapeSize = ["50", "60", "70", "80", "90", "100", "Main Menu"];

string basicMessage = "\nBasics of the basics.\n(Booty Shorts currently not working...)";
list basicClothing = ["Warmers", "Skirt", "FFIX", "Booty Shorts", "Main Menu"];

string biggiesMessage = "\nChoose a top!\nOnly works if Biggies is enabled, not Hypers.";
list biggiesClothing = ["Batty Biggies Pasties BB", "Biggies Tank Top", "Biggies Cleavage Top", "Biggies Sling", "Squish", "Main Menu", "x", "Bikini?", "x"];

string hypersMessage = "\nChoose a top!\nOnly works if Hypers is enabled, not Biggies.";
list hypersClothing = ["Ring Top Hyper BB", "Drape", "Main Menu"];


//1 = Biggies
//2 = Hypers
//3 = WhyTits
//4 = MegaTidz
integer breastCheck;

//0 = Disabled
//1 = Biggies BigBig
//2 = Biggies Smoosh
//3 = Hypers BigBig
//4 = Hypers Smoosh
//5 = Why Tits
//6 = MegaTidz
integer nipCheck;

integer warmerCheck             =   0;
integer hypersRingTopCheck      =   0;
integer hypersDrapesCheck       =   0;
integer pastiesCheck            =   0;
integer ffixCheck               =   0;
integer skirtCheck              =   0;
integer bootyShortsCheck        =   0;
integer biggiesSlingCheck       =   0;
integer biggiesCleavageCheck    =   0;
integer biggiesTankCheck        =   0;
integer squishCheck             =   0;
integer BBikiniCheck            =   0;

//0 = Normal Shape
//1 = Short Stack Shape
integer shape = 0;

//5 = 50
//6 = 60
//7 = 70
//8 = 80
//9 = 90
//10 = 100
integer getCurrentSize = 5;

key ToucherID;
integer channelDialog;

integer listenId; // OUR NEW HANDLE

//Make those breasts bounce when clothing is taken off!
string bustBounce = "CH-Breast-Bounce-Reset";
string bounce = "bounce";

default
{

    state_entry()
    {
        if(llGetAttached()) {
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            llRequestPermissions(llGetOwner(), PERMISSION_OVERRIDE_ANIMATIONS);
        }
        channelDialog = -1 - (integer)("0x" + llGetSubString( (string)llGetKey(), -7, -1) );
        
        if(textEnabled == 0) {
            llSetText("", COLOR_WHITE, OPAQUE);   
        }
    }

    touch_start(integer num_detected)
    {
        ToucherID = llDetectedKey(0);
        if(ToucherID != zen){
            if(enabled == 1) {
                llDialog(ToucherID, message, coreOptions, channelDialog);
            } else {
                //Not doing shit.
            }
        }
        else {
                llOwnerSay(llGetDisplayName(ToucherID) + " is interacting with me." );
                llDialog(ToucherID, message, coreOptions, channelDialog);
            }
        listenId = llListen(channelDialog, "", ToucherID, "");// OUR NEW LISTEN
    }


 listen(integer channel, string name, key id, string message)
    {
        if(message == "menu") {
            llDialog(ToucherID, message, coreOptions, channelDialog);
        }
        if(enabled == 1) {
            coreOptions = ["Unlocked", "Strip Me!", "Shape Folder", "Breast Sizes", "Shape Size", "Clothing Options", "HoverText"];
        } else {
            coreOptions = ["Locked", "Strip Me!", "Shape Folder", "Breast Sizes", "Shape Size", "Clothing Options", "HoverText"];
    }

        if(message == "Unlocked") {
            if(id == zen) {
                enabled = 0;
                llOwnerSay("Locked.");
            }
        }

        if(message == "Locked") {
            if(id == zen) {
                enabled = 1;
                llOwnerSay("Unlocked.");
            }
        }
        
        if (message == "HoverText") {
            if(id ==zen) {
                if(textEnabled == 0) {
                    textEnabled = 1;
                    llSetText(hoverText, COLOR_WHITE, OPAQUE); 
                }
                else {
                    textEnabled = 0;
                    llSetText("", COLOR_WHITE, OPAQUE);    
                }
            }   
        }

        if(message == "Main Menu") {
            llDialog(ToucherID, message, coreOptions, channelDialog);
        }

        if (breastCheck == 1 && nipCheck == 1){
            clothingSizes = ["Basics", "Biggies Clothing", "Main Menu"];
        }

        if (breastCheck == 3 && nipCheck == 5) {
            clothingSizes = ["Basics", "Main Menu"];
        }

        if (breastCheck == 2 && nipCheck == 3) {
            clothingSizes = ["Basics", "Hypers Clothing", "Main Menu"];
        }

        if(message == "Breast Sizes") {
            llDialog(ToucherID, breastMessage, breastChoices, channelDialog);
        }

        if(message == "Clothing Options") {
            llDialog(ToucherID, clothingMessage, clothingSizes, channelDialog);
        }

        if(message == "Basics") {
            llDialog(ToucherID, basicMessage, basicClothing, channelDialog);
        }

        if(message == "Biggies Clothing") {
            llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
        }

        if(message == "Hypers Clothing") {
            llDialog(ToucherID, hypersMessage, hypersClothing, channelDialog);
        }

        if(message == "Shape Size") {
            llDialog(ToucherID, shapeMessage, shapeSize, channelDialog);
        }

        if(message == "Shape Folder") {
            llDialog(ToucherID, shapeFolderText, shapeFolder, channelDialog);
        }



     integer linknum = llDetectedLinkNumber(0);

        if(message == "Strip Me!")
        {
            llOwnerSay(llGetDisplayName(ToucherID) + " stripped me!" );

            //Breasts
            if(breastCheck == 1 && nipCheck == 1) {
                alphaset(1, "Biggies Boobs",-1);
                alphaset(1, "Biggies - Nip BigBig",-1);
              }

            if(breastCheck == 1 && nipCheck == 2) {
                alphaset(1, "Biggies - Nip Smoosh",-1);
                alphaset(1, "Biggies - Nip BigBig",-1);
              }

            if(breastCheck == 2 && nipCheck == 3) {
                alphaset(1, "Hypers Boobs",-1);
                alphaset(1, "Hypers - Nips BigBig",-1);
              }

            if(breastCheck == 2 && nipCheck == 4) {
                alphaset(1, "Hypers Boobs",-1);
                alphaset(1, "Hypers - Nips Smoosh",-1);
              }

            if(breastCheck == 3 && nipCheck == 5) {
                alphaset(1, "WhyTits", -1);
            }

            if(breastCheck == 4 && nipCheck == 6) {
                alphaset(1, "MegaTidz", -1);
            }


              //Squish Failsafe
            if(squishCheck == 1) {
                breastCheck = 1;
                nipCheck = 1;
                alphaset(1, "Biggies Boobs",-1);
                alphaset(1, "Biggies - Nip BigBig",-1);
            }

            //Clothing
            alphaset(0, "Ring Top Hyper BB",-1);
            hypersRingTopCheck = 0;

            alphaset(0, "HyperDrapes",-1);
            hypersRingTopCheck = 0;

            alphaset(0, "Batty Biggies Pasties BB",-1);
            pastiesCheck = 0;

            alphaset(0, "Biggies Sling",-1);
            biggiesSlingCheck = 0;

            alphaset(0, "Biggies Cleavage Top",-1);
            biggiesCleavageCheck = 0;

            alphaset(0, "Biggies Tank Top",-1);
            biggiesTankCheck = 0;

            alphaset(0, "Squish",-1);
            squishCheck = 0;

            alphaset(0, "Biggies Bikini",-1);
            BBikiniCheck = 0;

            alphaset(0, "Warmers",-1);
            warmerCheck = 0;

            alphaset(0, "Skirt",-1);
            skirtCheck = 0;

            alphaset(0, "FFIX",-1);
            ffixCheck = 0;

            alphaset(0, "Booty Shorts",-1);
            bootyShortsCheck = 0;
        }

        if(message == "Mega Tits") {
            llOwnerSay(llGetDisplayName(ToucherID) + " gave me MEGA tits!" );

            //Biggies
            alphaset(0, "Biggies Boobs",-1);
            alphaset(0, "Biggies - Nip BigBig",-1);
            alphaset(0, "Biggies - Nip Smoosh",-1);
            //Hypers
            alphaset(0, "Hypers Boobs",-1);
            alphaset(0, "Hypers - Nips BigBig",-1);
            alphaset(0, "Hypers - Nips Smoosh",-1);
            //WhyTits
            alphaset(0, "WhyTits", -1);
            //MegaTits
            alphaset(1, "MegaTidz", -1);

            //Clothing
            alphaset(0, "Ring Top Hyper BB",-1);
            hypersRingTopCheck = 0;

            alphaset(0, "HyperDrapes",-1);
            hypersRingTopCheck = 0;

            alphaset(0, "Batty Biggies Pasties BB",-1);
            pastiesCheck = 0;

            alphaset(0, "Biggies Sling",-1);
            biggiesSlingCheck = 0;

            alphaset(0, "Biggies Cleavage Top",-1);
            biggiesCleavageCheck = 0;

            alphaset(0, "Biggies Tank Top",-1);
            biggiesTankCheck = 0;

            alphaset(0, "Squish",-1);
            squishCheck = 0;

            alphaset(0, "Biggies Bikini",-1);
            BBikiniCheck = 0;

            breastCheck = 4;
            nipCheck = 6;
        }

        if(message == "Hypers(BB)")
        {
            llOwnerSay(llGetDisplayName(ToucherID) + " gave me HYPER tits!" );
            //llStartAnimation(bounce);
            //llSetTimerEvent(5.0);

        //Biggies
          alphaset(0, "Biggies Boobs",-1);
          alphaset(0, "Biggies - Nip BigBig",-1);
          alphaset(0, "Biggies - Nip Smoosh",-1);
        //Hypers
          alphaset(1, "Hypers Boobs",-1);
          alphaset(1, "Hypers - Nips BigBig",-1);
          alphaset(0, "Hypers - Nips Smoosh",-1);

        //WhyTits
          alphaset(0, "WhyTits", -1);
        //MegaTits
          alphaset(0, "MegaTidz", -1);

          //Clothing
          alphaset(0, "Ring Top Hyper BB",-1);
          hypersRingTopCheck = 0;

          alphaset(0, "HyperDrapes",-1);
          hypersRingTopCheck = 0;

          alphaset(0, "Batty Biggies Pasties BB",-1);
          pastiesCheck = 0;

          alphaset(0, "Biggies Sling",-1);
          biggiesSlingCheck = 0;

          alphaset(0, "Biggies Cleavage Top",-1);
          biggiesCleavageCheck = 0;

          alphaset(0, "Biggies Tank Top",-1);
          biggiesTankCheck = 0;

          alphaset(0, "Squish",-1);
          squishCheck = 0;

          alphaset(0, "Biggies Bikini",-1);
          BBikiniCheck = 0;

          breastCheck = 2;
          nipCheck = 3;
        }

        if(message == "Hypers(Smoosh)")
        {
            llOwnerSay(llGetDisplayName(ToucherID) + " gave me HYPER tits!" );

            //llStartAnimation(bounce);
            //llSetTimerEvent(5.0);

        //Biggies
          alphaset(0, "Biggies Boobs",-1);
          alphaset(0, "Biggies - Nip BigBig",-1);
          alphaset(0, "Biggies - Nip Smoosh",-1);
        //Hypers
          alphaset(1, "Hypers Boobs",-1);
          alphaset(0, "Hypers - Nips BigBig",-1);
          alphaset(1, "Hypers - Nips Smoosh",-1);

        //WhyTits
          alphaset(0, "WhyTits", -1);
        //MegaTits
          alphaset(0, "MegaTidz", -1);

          //Clothing
          alphaset(0, "Ring Top Hyper BB",-1);
          hypersRingTopCheck = 0;

          alphaset(0, "HyperDrapes",-1);
          hypersRingTopCheck = 0;

          alphaset(0, "Batty Biggies Pasties BB",-1);
          pastiesCheck = 0;

          alphaset(0, "Biggies Sling",-1);
          biggiesSlingCheck = 0;

          alphaset(0, "Biggies Cleavage Top",-1);
          biggiesCleavageCheck = 0;

          alphaset(0, "Biggies Tank Top",-1);
          biggiesTankCheck = 0;

          alphaset(0, "Squish",-1);
          squishCheck = 0;

          alphaset(0, "Biggies Bikini",-1);
          BBikiniCheck = 0;

          breastCheck = 2;
          nipCheck = 4;
        }

        if(message == "Biggies(BB)")
        {
            llOwnerSay(llGetDisplayName(ToucherID) + " gave me BIG tits!" );
            //llStartAnimation(bounce);
            //llSetTimerEvent(5.0);

        //Biggies
          alphaset(1, "Biggies Boobs",-1);
          alphaset(1, "Biggies - Nip BigBig",-1);
          alphaset(0, "Biggies - Nip Smoosh",-1);
        //Hypers
          alphaset(0, "Hypers Boobs",-1);
          alphaset(0, "Hypers - Nips BigBig",-1);
          alphaset(0, "Hypers - Nips Smoosh",-1);

        //WhyTits
          alphaset(0, "WhyTits", -1);
        //MegaTits
          alphaset(0, "MegaTidz", -1);

         //Clothing
         alphaset(0, "Ring Top Hyper BB",-1);
         hypersRingTopCheck = 0;

         alphaset(0, "HyperDrapes",-1);
         hypersRingTopCheck = 0;

         alphaset(0, "Batty Biggies Pasties BB",-1);
         pastiesCheck = 0;

         alphaset(0, "Biggies Sling",-1);
         biggiesSlingCheck = 0;

         alphaset(0, "Biggies Cleavage Top",-1);
         biggiesCleavageCheck = 0;

         alphaset(0, "Biggies Tank Top",-1);
         biggiesTankCheck = 0;

         alphaset(0, "Squish",-1);
         squishCheck = 0;

         alphaset(0, "Biggies Bikini",-1);
         BBikiniCheck = 0;

          breastCheck = 1;
          nipCheck = 1;
        }

        if(message == "Biggies(Smoosh)")
        {
            llOwnerSay(llGetDisplayName(ToucherID) + " gave me BIG tits!" );
            //llStartAnimation(bounce);
            //llSetTimerEvent(5.0);

        //Biggies
          alphaset(1, "Biggies Boobs",-1);
          alphaset(0, "Biggies - Nip BigBig",-1);
          alphaset(1, "Biggies - Nip Smoosh",-1);
        //Hypers
          alphaset(0, "Hypers Boobs",-1);
          alphaset(0, "Hypers - Nips BigBig",-1);
          alphaset(0, "Hypers - Nips Smoosh",-1);

        //WhyTits
          alphaset(0, "WhyTits", -1);
        //MegaTits
          alphaset(0, "MegaTidz", -1);

          //Clothing
          alphaset(0, "Ring Top Hyper BB",-1);
          hypersRingTopCheck = 0;

          alphaset(0, "HyperDrapes",-1);
          hypersRingTopCheck = 0;

          alphaset(0, "Batty Biggies Pasties BB",-1);
          pastiesCheck = 0;

          alphaset(0, "Biggies Sling",-1);
          biggiesSlingCheck = 0;

          alphaset(0, "Biggies Cleavage Top",-1);
          biggiesCleavageCheck = 0;

          alphaset(0, "Biggies Tank Top",-1);
          biggiesTankCheck = 0;

          alphaset(0, "Squish",-1);
          squishCheck = 0;

          alphaset(0, "Biggies Bikini",-1);
          BBikiniCheck = 0;

          breastCheck = 1;
          nipCheck = 2;
        }

        if(message == "Why...?")
        {
            llOwnerSay(llGetDisplayName(ToucherID) + " gave me QUAD tits!" );
            //llStartAnimation(bounce);
            //llSetTimerEvent(5.0);

        //Biggies
          alphaset(0, "Biggies Boobs",-1);
          alphaset(0, "Biggies - Nip BigBig",-1);
          alphaset(0, "Biggies - Nip Smoosh",-1);
        //Hypers
          alphaset(0, "Hypers Boobs",-1);
          alphaset(0, "Hypers - Nips BigBig",-1);
          alphaset(0, "Hypers - Nips Smoosh",-1);

        //WhyTits
          alphaset(1, "WhyTits", -1);
        //MegaTits
          alphaset(0, "MegaTidz", -1);

          //Clothing
          alphaset(0, "Ring Top Hyper BB",-1);
          hypersRingTopCheck = 0;

          alphaset(0, "HyperDrapes",-1);
          hypersRingTopCheck = 0;

          alphaset(0, "Batty Biggies Pasties BB",-1);
          pastiesCheck = 0;

          alphaset(0, "Biggies Sling",-1);
          biggiesSlingCheck = 0;

          alphaset(0, "Biggies Cleavage Top",-1);
          biggiesCleavageCheck = 0;

          alphaset(0, "Biggies Tank Top",-1);
          biggiesTankCheck = 0;

          alphaset(0, "Squish",-1);
          squishCheck = 0;

          alphaset(0, "Biggies Bikini",-1);
          BBikiniCheck = 0;

          breastCheck = 3;
          nipCheck = 5;
        }

//Start Basics

        if(message == "Warmers") {
            if(warmerCheck == 0) {
                alphaset(1, "Warmers",-1);
                warmerCheck = 1;
            } else {
                alphaset(0, "Warmers",-1);
                warmerCheck = 0;
            }
            llDialog(ToucherID, basicMessage, basicClothing, channelDialog);
        }

        if(message == "FFIX") {
            if(ffixCheck == 0) {
                alphaset(1, "FFIX",-1);
                ffixCheck = 1;
            } else {
                alphaset(0, "FFIX",-1);
                ffixCheck = 0;
            }
            llDialog(ToucherID, basicMessage, basicClothing, channelDialog);
        }

        if(message == "Skirt") {
            if(skirtCheck == 0) {
                alphaset(1, "Skirt",-1);
                skirtCheck = 1;

                alphaset(0, "Booty Shorts",-1);
                bootyShortsCheck = 0;
            } else {
                alphaset(0, "Skirt",-1);
                skirtCheck = 0;
            }
            llDialog(ToucherID, basicMessage, basicClothing, channelDialog);
        }

        if(message == "Booty Shorts") {
            if(bootyShortsCheck == 0) {
                alphaset(0, "Skirt",-1);
                skirtCheck = 0;

                alphaset(1, "Booty Shorts",-1);
                bootyShortsCheck = 1;
            } else {
                alphaset(0, "Booty Shorts",-1);
                bootyShortsCheck = 0;
            }
            llDialog(ToucherID, basicMessage, basicClothing, channelDialog);
        }

//End Basics


//Start Hyper Clothing


        if(message == "Ring Top Hyper BB") {

        if (breastCheck == 2 && nipCheck == 3) {
            if(hypersRingTopCheck == 0) {

                alphaset(1, "Ring Top Hyper BB",-1);
                hypersRingTopCheck = 1;

                alphaset(0, "Batty Biggies Pasties BB",-1);
                pastiesCheck = 0;


                alphaset(0, "Biggies Sling",-1);
                biggiesSlingCheck = 0;

                alphaset(0, "Biggies Cleavage Top",-1);
                biggiesCleavageCheck = 0;

                alphaset(0, "Biggies Tank Top",-1);
                biggiesTankCheck = 0;

                alphaset(0, "Squish",-1);
                squishCheck = 0;

                alphaset(0, "Biggies Bikini",-1);
                BBikiniCheck = 0;

                alphaset(0, "HyperDrapes",-1);
                hypersRingTopCheck = 0;


            } else {
                //llStartAnimation(bustBounce);
                //llSetTimerEvent(5.0);
                alphaset(0, "Ring Top Hyper BB",-1);
                hypersRingTopCheck = 0;
                llDialog(ToucherID, hypersMessage, hypersClothing, channelDialog);
            }
            llDialog(ToucherID, hypersMessage, hypersClothing, channelDialog);
        } else {
            llOwnerSay("Bitch we too small...");
            llDialog(ToucherID, hypersMessage, hypersClothing, channelDialog);
        }
        }

        if(message == "Drape") {

        if (breastCheck == 2 && nipCheck == 3) {
            if(hypersRingTopCheck == 0) {

                alphaset(1, "HyperDrapes",-1);
                hypersRingTopCheck = 1;

                alphaset(0, "Batty Biggies Pasties BB",-1);
                pastiesCheck = 0;


                alphaset(0, "Biggies Sling",-1);
                biggiesSlingCheck = 0;

                alphaset(0, "Biggies Cleavage Top",-1);
                biggiesCleavageCheck = 0;

                alphaset(0, "Biggies Tank Top",-1);
                biggiesTankCheck = 0;

                alphaset(0, "Squish",-1);
                squishCheck = 0;

                alphaset(0, "Biggies Bikini",-1);
                BBikiniCheck = 0;

                alphaset(0, "Ring Top Hyper BB",-1);
                hypersRingTopCheck = 0;

                llDialog(ToucherID, hypersMessage, hypersClothing, channelDialog);
            } else {
                //llStartAnimation(bustBounce);
                //llSetTimerEvent(5.0);
                alphaset(0, "HyperDrapes",-1);
                hypersRingTopCheck = 0;
                llDialog(ToucherID, hypersMessage, hypersClothing, channelDialog);
            }
        } else {
            llOwnerSay("Bitch we too small...");
            llDialog(ToucherID, hypersMessage, hypersClothing, channelDialog);
        }
        }


//End Hyper Clothing

//Biggies Clothing Start

            if(message == "Batty Biggies Pasties BB") {

            if (breastCheck == 1 && nipCheck == 1) {

                alphaset(1, "Biggies Boobs",-1);
                alphaset(1, "Biggies - Nip BigBig",-1);

                if(pastiesCheck == 0) {

                    alphaset(0, "Ring Top Hyper BB",-1);
                    hypersRingTopCheck = 0;

                    alphaset(0, "HyperDrapes",-1);
                    hypersRingTopCheck = 0;

                    alphaset(1, "Batty Biggies Pasties BB",-1);
                    pastiesCheck = 1;

                    alphaset(0, "Biggies Sling",-1);
                    biggiesSlingCheck = 0;

                    alphaset(0, "Biggies Cleavage Top",-1);
                    biggiesCleavageCheck = 0;

                    alphaset(0, "Biggies Tank Top",-1);
                    biggiesTankCheck = 0;

                    alphaset(0, "Squish",-1);
                    squishCheck = 0;

                    alphaset(0, "Biggies Bikini",-1);
                    BBikiniCheck = 0;

                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
                } else {
                    //llStartAnimation(bustBounce);
                    //llSetTimerEvent(5.0);
                    alphaset(0, "Batty Biggies Pasties BB",-1);
                    pastiesCheck = 0;
                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
                }
            } else {
                llOwnerSay("Bitch we too big...");
                llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
            }
            }

            if(message == "Biggies Sling") {

            if (breastCheck == 1 && nipCheck == 1) {

                alphaset(1, "Biggies Boobs",-1);
                alphaset(1, "Biggies - Nip BigBig",-1);

                if(biggiesSlingCheck == 0) {

                    alphaset(0, "Ring Top Hyper BB",-1);
                    hypersRingTopCheck = 0;

                    alphaset(0, "HyperDrapes",-1);
                    hypersRingTopCheck = 0;

                    alphaset(0, "Batty Biggies Pasties BB",-1);
                    pastiesCheck = 0;

                    alphaset(1, "Biggies Sling",-1);
                    biggiesSlingCheck = 1;

                    alphaset(0, "Biggies Cleavage Top",-1);
                    biggiesCleavageCheck = 0;

                    alphaset(0, "Biggies Tank Top",-1);
                    biggiesTankCheck = 0;

                    alphaset(0, "Squish",-1);
                    squishCheck = 0;

                    alphaset(0, "Biggies Bikini",-1);
                    BBikiniCheck = 0;

                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);

                } else {
                    //llStartAnimation(bustBounce);
                    //llSetTimerEvent(5.0);
                    alphaset(0, "Biggies Sling",-1);
                    biggiesSlingCheck = 0;
                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
                }
            } else {
                llOwnerSay("Bitch we too big...");
                llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
            }
            }

            if(message == "Biggies Cleavage Top") {

            if (breastCheck == 1 && nipCheck == 1) {
                if(biggiesCleavageCheck == 0) {

                    alphaset(1, "Biggies Boobs",-1);
                    alphaset(1, "Biggies - Nip BigBig",-1);

                    alphaset(0, "Ring Top Hyper BB",-1);
                    hypersRingTopCheck = 0;

                    alphaset(0, "HyperDrapes",-1);
                    hypersRingTopCheck = 0;

                    alphaset(0, "Batty Biggies Pasties BB",-1);
                    pastiesCheck = 0;

                    alphaset(0, "Biggies Sling",-1);
                    biggiesSlingCheck = 0;

                    alphaset(1, "Biggies Cleavage Top",-1);
                    biggiesCleavageCheck = 1;

                    alphaset(0, "Biggies Tank Top",-1);
                    biggiesTankCheck = 0;

                    alphaset(0, "Squish",-1);
                    squishCheck = 0;

                    alphaset(0, "Biggies Bikini",-1);
                    BBikiniCheck = 0;

                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);

                } else {
                    //llStartAnimation(bustBounce);
                    //llSetTimerEvent(5.0);
                    alphaset(0, "Biggies Cleavage Top",-1);
                    biggiesCleavageCheck = 0;
                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
                }
            } else {
                llOwnerSay("Bitch we too big...");
                llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
            }
            }

            if(message == "Biggies Tank Top") {

            if (breastCheck == 1 && nipCheck == 1) {
                if(biggiesTankCheck == 0) {

                    alphaset(1, "Biggies Boobs",-1);
                    alphaset(1, "Biggies - Nip BigBig",-1);

                    alphaset(0, "Ring Top Hyper BB",-1);
                    hypersRingTopCheck = 0;

                    alphaset(0, "HyperDrapes",-1);
                    hypersRingTopCheck = 0;

                    alphaset(0, "Batty Biggies Pasties BB",-1);
                    pastiesCheck = 0;

                    alphaset(0, "Biggies Sling",-1);
                    biggiesSlingCheck = 0;

                    alphaset(0, "Biggies Cleavage Top",-1);
                    biggiesCleavageCheck = 0;

                    alphaset(1, "Biggies Tank Top",-1);
                    biggiesTankCheck = 1;

                    alphaset(0, "Squish",-1);
                    squishCheck = 0;

                    alphaset(0, "Biggies Bikini",-1);
                    BBikiniCheck = 0;
                    
                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);

                } else {
                    //llStartAnimation(bustBounce);
                    //llSetTimerEvent(5.0);
                    alphaset(0, "Biggies Tank Top",-1);
                    biggiesTankCheck = 0;
                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
                }
            } else {
                llOwnerSay("Bitch we too big...");
                llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
            }
            }

            if(message == "Squish") {

            if (breastCheck == 1 && nipCheck == 1) {
                if(squishCheck == 0) {
                    //We gotta disable the hyper and biggies mesh breasts for this to work...
                    //Biggies
                      alphaset(0, "Biggies Boobs",-1);
                      alphaset(0, "Biggies - Nip BigBig",-1);
                      alphaset(0, "Biggies - Nip Smoosh",-1);
                    //Hypers
                      alphaset(0, "Hypers Boobs",-1);
                      alphaset(0, "Hypers - Nips BigBig",-1);
                      alphaset(0, "Hypers - Nips Smoosh",-1);


                    alphaset(0, "Ring Top Hyper BB",-1);
                    hypersRingTopCheck = 0;

                    alphaset(0, "HyperDrapes",-1);
                    hypersRingTopCheck = 0;

                    alphaset(0, "Batty Biggies Pasties BB",-1);
                    pastiesCheck = 0;

                    alphaset(0, "Biggies Sling",-1);
                    biggiesSlingCheck = 0;

                    alphaset(0, "Biggies Cleavage Top",-1);
                    biggiesCleavageCheck = 0;

                    alphaset(0, "Biggies Tank Top",-1);
                    biggiesTankCheck = 0;

                    alphaset(1, "Squish",-1);
                    squishCheck = 1;

                    alphaset(0, "Biggies Bikini",-1);
                    BBikiniCheck = 0;

                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);

                } else {
                    //llStartAnimation(bustBounce);
                    //llSetTimerEvent(5.0);
                    alphaset(0, "Squish",-1);
                    squishCheck = 0;
                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
                }
            } else {
                llOwnerSay("Bitch we too big...");
                llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
            }
            }

            if(message == "Bikini?") {

                if (breastCheck == 1 && nipCheck == 1) {
                    if(BBikiniCheck == 0) {
                        
                        alphaset(0, "Ring Top Hyper BB",-1);
                        hypersRingTopCheck = 0;
    
                        alphaset(0, "HyperDrapes",-1);
                        hypersRingTopCheck = 0;
    
                        alphaset(0, "Batty Biggies Pasties BB",-1);
                        pastiesCheck = 0;
    
                        alphaset(0, "Biggies Sling",-1);
                        biggiesSlingCheck = 0;
    
                        alphaset(0, "Biggies Cleavage Top",-1);
                        biggiesCleavageCheck = 0;
    
                        alphaset(0, "Biggies Tank Top",-1);
                        biggiesTankCheck = 0;
    
                        alphaset(0, "Squish",-1);
                        squishCheck = 0;
    
                        alphaset(1, "Biggies Bikini",-1);
                        BBikiniCheck = 1;
    
                        llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
    
                    } else {
                        //llStartAnimation(bustBounce);
                        //llSetTimerEvent(5.0);
                        alphaset(0, "Biggies Bikini",-1);
                        BBikiniCheck = 0;
                        llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
                    }
                } else {
                    llOwnerSay("Bitch we too big...");
                    llDialog(ToucherID, biggiesMessage, biggiesClothing, channelDialog);
                }
                }

//Biggies Clothing End

//Shape Size Start

if(message == "Standard") {
    shape = 0;

    if(getCurrentSize == 5) llOwnerSay("@attachover:JackelHeadBimbo/50=force");
    if(getCurrentSize == 6) llOwnerSay("@attachover:JackelHeadBimbo/60=force");
    if(getCurrentSize == 7) llOwnerSay("@attachover:JackelHeadBimbo/70=force");
    if(getCurrentSize == 8) llOwnerSay("@attachover:JackelHeadBimbo/80=force");
    if(getCurrentSize == 9) llOwnerSay("@attachover:JackelHeadBimbo/90=force");
    if(getCurrentSize == 10) llOwnerSay("@attachover:JackelHeadBimbo/100=force");
}

if(message == "Short Stack") {
    shape = 1;

    if(getCurrentSize == 5) llOwnerSay("@attachover:JackelHeadBimbo/SS/50=force");
    if(getCurrentSize == 6) llOwnerSay("@attachover:JackelHeadBimbo/SS/60=force");
    if(getCurrentSize == 7) llOwnerSay("@attachover:JackelHeadBimbo/SS/70=force");
    if(getCurrentSize == 8) llOwnerSay("@attachover:JackelHeadBimbo/SS/80=force");
    if(getCurrentSize == 9) llOwnerSay("@attachover:JackelHeadBimbo/SS/90=force");
    if(getCurrentSize == 10) llOwnerSay("@attachover:JackelHeadBimbo/SS/100=force");
}

if(shape == 1) {
        if(message == "50")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/SS/50=force");
            getCurrentSize = 5;
        }

        if(message == "60")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/SS/60=force");
            getCurrentSize = 6;
        }

        if(message == "70")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/SS/70=force");
            getCurrentSize = 7;
        }

        if(message == "80")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/SS/80=force");
            getCurrentSize = 8;
        }

        if(message == "90")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/SS/90=force");
            getCurrentSize = 9;
        }

        if(message == "100")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/SS/100=force");
            getCurrentSize = 10;
        }
    }

    if (shape == 0) {
        if(message == "50")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/50=force");
            getCurrentSize = 5;
        }

        if(message == "60")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/60=force");
            getCurrentSize = 6;
        }

        if(message == "70")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/70=force");
            getCurrentSize = 7;
        }

        if(message == "80")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/80=force");
            getCurrentSize = 8;
        }

        if(message == "90")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/90=force");
            getCurrentSize = 9;
        }

        if(message == "100")
        {
            llOwnerSay("@attachover:JackelHeadBimbo/100=force");
            getCurrentSize = 10;
        }
    }

//Shape Size End
  }

timer()
    {
        llSetTimerEvent(0.0);
        llStopAnimation(bustBounce);
        llStopAnimation(bounce);
    }

}
