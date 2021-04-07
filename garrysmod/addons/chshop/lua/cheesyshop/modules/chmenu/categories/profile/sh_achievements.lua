
--[[
Reward rules (Judging by effort):

- XP:
Minimal: 100
Semi-small: 200
Small: 500
Semi-medium: 750
Medium: 1000
Big: 2000
Very big: 2500
Maximum: 3000

- Credits:
Minimal: 50
Semi-small: 100
Small: 200
Semi-medium: 300
Medium: 500
Big: 1000
Very big: 1200
Maximum: 1500
]]

achievements = {}

achievements[1] = {title = "Rookie dookie", description = "Reach level 5.", xp = 200, credits = 100} -- Semi-small
achievements[2] = {title = "Feed that hairy baby!", description = "Watch \"Caracal Screams for Food\" by DailyPicksandFlicks.", xp = 100, credits = 50} -- Minimal
achievements[3] = {title = "Stale is just another word for delicious", description = "Eat popcorn a total of 144 times in a row.", xp = 200, credits = 100} -- Semi-small
achievements[4] = {title = "Flaming Hot Cheato (Currently Unavailable)", description = "Kill 3 people without dying at the arena.", xp = 100, credits = 50} -- Minimal
achievements[5] = {title = "Pretty colors make me happy!", description = "Watch 15 videos. (They must be at least 2 minutes in length)", xp = 500, credits = 200} -- Small
achievements[6] = {title = "I don't even remember how I got here...", description = "Join the server for the first time.", xp = 0, credits = 250, coupon = true} -- Custom
achievements[7] = {title = "I can't feel my eyes and I'm loving it!", description = "Watch a video longer than 3 hours.", xp = 750, credits = 300} -- Semi-medium
achievements[8] = {title = "Smug kid", description = "Watch \"PEACE AND TRANQUILITY\" by Manndarinchik.", xp = 200, credits = 100} -- Semi-small
achievements[9] = {title = "Dooky", description = "Just dooky", xp = 100, credits = 50} -- Minimal
achievements[10] = {title = "1 day from retirement", description = "Reach level 50.", xp = 1000, credits= 500} -- Medium
achievements[11] = {title = "Wolfy-wolf", description = "Be a wolf, do wolf things...", xp = 500, credits= 200} -- Small, for being smart
achievements[12] = {title = "Professional Zombie", description = "Watch 150 videos. (They must be at least 2 minutes in length)", xp = 750, credits = 300} -- Semi-medium
achievements[13] = {title = "Why can't I stop eating this...", description = "Eat popcorn 1444 times in a row.", xp = 500, credits = 200} -- Small
achievements[14] = {title = "Bite the dust", description = "Die. (In the game)", xp = 100, credits = 50} -- Minimal
achievements[15] = {title = "Wasabi (Currently Unavailable)", description = "Kill 6 people without dying at the arena.", xp = 200, credits = 100} -- Semi-small 
achievements[16] = {title = "I'm getting too old for this crap...", description = "Reach level 100.", xp = 2000, credits = 1000} -- Big
achievements[17] = {title = "One with the interwebs", description = "Watch 1500 videos. (They must be at least 2 minutes in length)", xp = 2000, credits = 1000} -- Big
achievements[18] = {title = "Ghost Pepper (Currently Unavailable", description = "Kill 12 people without dying at the arena.", xp = 500, credits = 200} -- Small
achievements[19] = {title = "Hardcore hooligan", description = "Reach level 500.", xp = 3000, credits = 1500} -- Maximum
achievements[20] = {title = "Groovy", description = "Listen to \"Canned Heat\" uploaded by Jamiroquai - Topic while cracking open a hot one.", xp = 200, credits = 100} -- Semi-small
achievements[21] = {title = "I'm about to end this casino's whole wallet", description = "Win a total of 30.000 Credits from slot machines.", xp = 1000, credits = 500} -- Medium
achievements[22] = {title = "Use it wisely (Currently Unavailable)", description = "You wasted 30.000 Credits on the slot machine. Here, have some in return.", xp = 1000, credits = 500} -- Medium
achievements[23] = {title = "R i g g e d (Currently Unavailable)", description = "Win the jackpot.", xp = 2000, credits= 1000} -- Big
achievements[24] = {title = "Cobalt Velvet", description = "Listen to \"VA-11 HALL-A - Second Round [Full Album]\" uploaded by Michael Kelly.", xp = 750, credits = 300} -- Semi-medium
achievements[25] = {title = "I'll be back", description = "Watch \"DE　DE　N　DEN　DE　DE　N\" uploaded by Mr.CharlY.", xp = 100, credits = 50} -- Minimal
achievements[26] = {title = "Tree puncher", description = "Find the minecraft theater.", xp = 500, credits = 200} -- Small
achievements[27] = {title = "OwO", description = "No erp. >:c", xp = 100, credits = 50} -- Minimal
achievements[28] = {title = "Brought snacks", description = "Have a total of 2 hours of playtime.", xp = 200, credits = 100} -- Semi-small
achievements[29] = {title = "Took a big nap", description = "Watch a video longer than 10 hours.", xp = 2000, credits = 1000} -- Big
achievements[30] = {title = "A day on Jupiter", description = "You have a total of 10 hours of playtime. Thank you. c:", xp = 500, credits = 200} -- Small
achievements[31] = {title = "DOOT", description = "Watch \"Dootdoot Band E2m1 Doot Anomaly\" uploaded by R. Zapata.", xp = 200, credits = 100} -- Semi small
achievements[32] = {title = "I like it here...", description = "You played for 50 hours, woah.", xp = 750, credits = 300} -- Semi-medium
achievements[33] = {title = "UwU", description = "Hint: The name of a cutie.", xp = 200, credits = 100} -- Semi-small
achievements[34] = {title = "Make yourself at home", description = "Have week worth of hours of playtime.", xp = 1000, credits = 500} -- Medium
achievements[35] = {title = "My own room (Currently Unavailable)", description = "Rent a private theater.", xp = 100, credits = 50} -- Minimal
achievements[36] = {title = "Get the hecc out of my room I'm playing minecraft (Currently Unavailable)", description = "Use the blacklist system.", xp = 100, credits = 50} -- Minimal
achievements[37] = {title = "I play since the beta", description = "Played before version 1.0, enjoy some free credits.", xp = 0, credits = 30000} -- Custom
achievements[38] = {title = "Why hoard them when i can use them?", description = "Spend a total of 30.000 Credits on the shop.", xp = 750, credits = 300} -- Semi-medium
achievements[39] = {title = "Building a collection (Currently Unavailable)", description = "Own 5 playermodels.", xp = 500, credits = 200} -- Small
achievements[40] = {title = "We know.", description = "Watch \"Marine: im horny\" uploaded by rafe terbs.", xp = 100, credits = 50} -- Minimal
achievements[41] = {title = "Truest bop", description = "Listen to the absolute bop \"home depot theme song\" uploaded by stardust9.", xp = 200, credits = 100} -- Semi-small
achievements[42] = {title = "Are ya winning son?", description = "Watch \"Gawr Gura Are ya Winning?\" uploaded by Bakuretsu.", xp = 100, credits = 50} -- Minimal
achievements[43] = {title = "Let's go sunshine Amigos!", description = "Watch \"NomNomNom but Korone speaks english\" uploaded by dloow.", xp = 200, credits = 100} -- Semi-small
achievements[44] = {title = "On his hip", description = "Watch \"ＢＩＧ ＩＲＯＮ\" uploaded by sc6ut.", xp = 200, credits = 100} -- Semi-small
achievements[45] = {title = "We are number 1", description = "Watch \"students need the teacher but he is busy with something else\" uploaded by punpun.", xp = 100, credits = 50} -- Minimal
achievements[46] = {title = "i learnt how to code to make this 1 achievement", description = "3D animated dragon with shades.", xp = 100, credits = 50} -- Minimal
achievements[47] = {title = "Where are you sending them?!", description = "Watch \"I have done nothing but teleport bread for three days.\" uploaded by Omrimg2.", xp = 100, credits = 50} -- Minimal
achievements[48] = {title = "Valve's Disney Princess", description = "Watch \"G Man Yakuza 0 24 Hour Cinderlla (SFM)\" uploaded by TrooperVasiliy.", xp = 100, credits = 50} -- Minimal
achievements[49] = {title = "a", description = "Watch \"a\" uploaded by Food x Food.", xp = 100, credits = 50} -- Minimal
achievements[50] = {title = "Stickin' chicken", description = "Watch\"STICKIN MY DICK IN A CHICKEN\" uploaded by Buttered And Hot.", xp = 100, credits = 50} -- Minimal
achievements[51] = {title = "Jojo Strike", description = "Watch \"Jojo's Bizarre Bowling Adventure\" uploaded by sparkiegames.", xp = 100, credits = 50} -- Minimal
achievements[52] = {title = "12 shots", description = "Watch \"12 shots\" uploaded by Ash.", xp = 200, credits = 100} -- Semi-small
achievements[53] = {title = "Bonfire Lit", description = "Light the bonfire.", xp = 500, credits = 200} -- Small
achievements[54] = {title = "Free Stuff", description = "Trick or Treat at Pulse's house. (Halloween 2020)", xp = 200, credits = 100} -- Semi-small
achievements[55] = {title = "The Beginning", description = "Find patient zero. (Halloween 2020)", xp = 200, credits = 100} -- Semi-small
achievements[56] = {title = "Bad Luck", description = "Catch the cat flying above the city streets. (Halloween 2020)", xp = 500, credits = 200} -- Small
achievements[57] = {title = "It's free real estate", description = "You have an entire month of playtime... rent is free.", xp = 1500, credits = 3000} -- Maximum
achievements[58] = {title = "No way...", description = "Reach level 1000... what?", xp = 666, credits = 666} -- Holy crap dude
achievements[59] = {title = "I've seen it all", description = "You've watched a total of 10.000 videos, congrats!", xp = 1500, credits = 3000} -- Maximum
achievements[60] = {title = "Why can't I hold all these playermodels? (Currently Unavailable)", description = "Own 32 playermodels from the shop.", xp = 1000, credits = 2000} -- Big
achievements[61] = {title = "Insane collector (Currently Unavailable)", description = "Own all 79 shop playermodels.", xp = 1500, credits = 3000} -- Maximum
achievements[62] = {title = "The Queeking (Unavailable until leaderboards fill up)", description = "(Either queen or king, or both) Been the top player in any leaderboard, congratulations!", xp = 0, credits = 0} -- Nothing
achievements[63] = {title = "That's me (Unavailable until leaderboards fill up)", description = "Have your name appear on any leaderboard.", xp = 0, credits = 0} -- Nothing
achievements[64] = {title = "Well, what is it? (Currently Unavailable)", description = "Have 25 confirmed kills.", xp = 100, credits = 50} -- Minimal
achievements[65] = {title = "Massacre (Currently Unavailable)", description = "Have 100 confirmed kills.", xp = 200, credits = 100} -- Semi-small
achievements[66] = {title = "Killer Queen (Currently Unavailable)", description = "Have 600 confirmed kills.", xp = 500, credits = 200} -- Small
achievements[67] = {title = "Okay, you're scary (Currently Unavailable)", description = "Have 1000 confirmed kills.", xp = 750, credits = 300} -- Semi-medium
achievements[68] = {title = "Merry Christmas!", description = "Drop by Pulse's house and grab your present. (Christmas 2020)", xp = 200, credits = 100} -- Semi-small
achievements[69] = {title = "Bro Wake Up It's 2006!", description = "Watch \"Bro wake up its 2006\" by fabioproductions.", xp = 100, credits = 50} -- Minimal

achVideos = {}

achVideos[1] = {
name = "Caracal Screams for Food",
link = "xQ49jtlz_3I", 
lenght = 31, 
achID = 2}

achVideos[2] = {
name = "Peace and Tranquility",
link = "dbn-QDttWqU",
lenght = 256,
achID = 8}

achVideos[3] = {
name = "Canned Heat",
link = "ZA3JOX2pN2A",
lenght = 330,
achID = 20}

achVideos[4] = {
name = "VA-11 HALL-A OST",
link = "H8w_Q57RQJc",
lenght = 6530,
achID = 24}

achVideos[5] = {
name = "DE　DE　N　DEN　DE　DE　N",
link = "Dsn7dB_gD0s",
lenght = 41,
achID = 25}

achVideos[6] = {
name = "Doot",
link = "IqnZgCSwOsw",
lenght = 95,
achID = 31}

achVideos[8] = {
name = "We know.",
link = "mZvLRWtCnkI",
lenght = 10,
achID = 40}

achVideos[9] = {
name = "Truest bop",
link = "ycPDM8OVqLI",
lenght = 30,
achID = 41}

achVideos[10] = {
name = "Are ya winning son?",
link =  "cENBGShOLKo",
lenght = 9,
achID = 42}

achVideos[11] = {
name = "Let's go sunshine Amigos!",
link = "l0az6y5qG6Y",
lenght = 37,
achID = 43}

achVideos[12] = {
name = "On his hip",
link = "GJ0mO8P37Eg",
lenght = 14,
achID = 44}

achVideos[13] = {
name = "We are number 1",
link = "dmaEIr7k3bI",
lenght = 15,
achID = 45}

achVideos[14] = {
name = "i learnt how to code to make this 1 achievement",
link = "GjjZacZSWT4",
lenght = 20,
achID = 46}

achVideos[15] = {
name = "Where are you sending them?!",
link = "NE1-dKc6R_I",
lenght = 15,
achID = 47}

achVideos[16] = {
name = "Valve's Disney Princess",
link = "hLbO1aqF4tQ",
lenght = 35,
achID = 48}

achVideos[17] = {
name = "a",
link = "jZ4wPkTTXzs",
lenght = 5,
achID = 49}

achVideos[18] = {
name = "Stickin' Chicken",
link = "95OBjfar1Ng",
lenght = 15,
achID = 50}

achVideos[19] = {
name = "Jojo Strike",
link = "QpXN0fVxigo",
lenght = 10,
achID = 51}

achVideos[20] = {
name = "12 shots",
link = "85VytffCvCo",
lenght = 35,
achID = 52}

achVideos[21] = {
name = "Bro Wake Up It's 2006!",
link = "NNJ21Gzp79E",
lenght = 17,
achID = 69}
    