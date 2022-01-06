// HP6 autosplitter
// Made by PrudenGaming & xLink
// base code & memory locations obtained from Marczeslaw
// Works only with dedicated splits

state("hp6")
{
	string50 cutscene: 0x00965B80, 0xC, 0x203;
	byte map: 0x4928BC;
	uint inDuel: 0xBCD354;
	uint inPotion: 0xBCD42C;
	uint inQuidditch: 0xBCD6DC;
}

startup
{
	settings.Add("NOTE", false, "If going for potion skip and failling, those splits become manual");
	settings.Add("autostart", true, "Autostart on first cutscene (full game run)");
	settings.Add("burrow_flying", true, "splits on finishing flying at the burrow");
	settings.Add("cauldrons", true, "splits on leaving the burrow");
	settings.Add("enter_hogwarts", true, "splits after running up hill with luna");
	settings.Add("enter_potions_1", false, "splits on map change to potions class");
	settings.Add("first_potion", false, "splits on first potion in class");
	settings.Add("second_potion", false, "splits on second potion in class");
	settings.Add("third_potion", true, "splits on final potion in class");
	settings.Add("enter_duelling", false, "splits on Entering the great hall for duelling club");
	settings.Add("leave_duelling", true, "splits on exiting the great hall after duelling club");
	settings.Add("goyle_fight", true, "splits after goyle fight at stone circle");
	settings.Add("enter_quidditch_1", false, "splits when entering quidditch building");
	settings.Add("quidditch_tryouts", true, "splits after quidditch tryouts and cutscene");
	settings.Add("greenhouses", false, "splits on starting volubilis");
	settings.Add("volubilis", false, "splits after completing volubilis potion");
	settings.Add("shrinking_solution", false, "splits after completing shrinking solution");
	settings.Add("crabbe_fight", false, "splits after defeating Crabbe");
	settings.Add("hogsmeade", true, "splits after leaving with Hermione to Hogsmeade");
	settings.Add("ctc_duel", false, "splits after defeating Slytherin in CTC on way to quidditch");
	settings.Add("enter_quidditch_2", false, "splits upon entering quidditch building");
	settings.Add("slytherin_match", true, "splits upon finishing Slytherin match");
	settings.Add("enter_party", false, "splits on entering slughorns office");
	settings.Add("ponche", true, "splits on finishing the Punch");
	settings.Add("follow_snape", true, "splits on cutscene after snape talks to draco");
	settings.Add("burrow_fights", true, "splits on cutscene after fights at burrow");
	settings.Add("enter_potions_2", false, "splits upon entering potions classroom");
	settings.Add("polyjuice", true, "splits after creating the polyjuice potion");
	settings.Add("noisy_hitter", true, "splits after entering dumbledores office at noisy hitter");
	settings.Add("ravenclaw_duelling_club", false, "splits after deafeating junior duel at ravenclaw duelling club");
	settings.Add("enter_quidditch_3", false, "Splits on entering quidditch building");
	settings.Add("quidditch_practice", true, "Splits after quidditch practice");
	settings.Add("slytherin_duel", false, "splits after Slytherin duel outside greenhouses");
	settings.Add("enter_potions_3", false, "Splits on entering potions classroom after lavender");
	settings.Add("euphoria", true, "splits on completing potion of euphoria");
	settings.Add("astronomy_trap", true, "splits on exiting the astronomy tower trap");
	settings.Add("drunk_ron", false, "splits on entering slughorns office as ron");
	settings.Add("love_potion", true, "splits after completing the antidote");
	settings.Add("enter_quidditch_4", false, "splits on entering quidditch pitch after talking to mcclaggen");
	settings.Add("hufflepuff", true, "splits on completing hufflepuff match");
	settings.Add("sectumsempra", true, "splits on defeating Draco in bathroom");
	settings.Add("liquid_luck", false, "splits on starting fertilizer after liquid luck");
	settings.Add("fertilizer", true, "splits on completing fertilizer");
	settings.Add("crabbe_fight_2", true, "splits on defeating Crabbe at stone circle after aragog funeral");
	settings.Add("ravenclaw_match", true, "splits on beating ravenclaw quidditch match");
	settings.Add("wiggenweld", true, "Splits on creating wiggenweld potion");
	settings.Add("leave_hogwarts", false, "splits on leaving hogwarts with dumbledore");
	settings.Add("inferi", true, "splits on deafeating inferi");
	settings.Add("bella", true, "END splits after final fight");
}

init
{
	vars.gamestate = 0;
	
	vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
		var textSettings = timer.Layout.Components
			.Where(x => x.GetType().Name == "TextComponent")
			.Select(x => x.GetType().GetProperty("Settings")
			.GetValue(x, null));
		var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
		if (textSetting == null)
		{
			var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
			var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
			timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

			textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
			textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
		}

		if (textSetting != null)
			textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
	});
}

start 
{
	vars.gamestate = 0;
	return current.cutscene != old.cutscene && (current.cutscene == "ns01.vp6" && settings["autostart"]);
}

update {}

split
{
	if (vars.gamestate == 0 && current.cutscene == "ns01.vp6") {vars.gamestate = 10;} // Starting new game
	else if (vars.gamestate == 10 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 11; if (settings["burrow_flying"]) {return true;}} // Burrow flying
	else if (vars.gamestate == 11 && current.cutscene == "ns02.vp6") {vars.gamestate = 15; if (settings["cauldrons"]) {return true;}} // Cauldrons
	else if (vars.gamestate == 15 && current.cutscene == "ns03.vp6") {vars.gamestate = 20; if (settings["enter_hogwarts"]) {return true;}} // Enter Hogwarts
	else if (vars.gamestate == 20 && old.map == 18 && current.map == 64) {vars.gamestate = 21; if (settings["enter_potions_1"]) {return true;}} // enter potions
	else if (vars.gamestate == 21 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 22;} // tutorial
	else if (vars.gamestate == 22 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 23; if (settings["first_potion"]) {return true;}} // first potion
	else if (vars.gamestate == 23 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 24;} // tutorial
	else if (vars.gamestate == 24 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 25;}
	else if (vars.gamestate == 25 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 26; if (settings["second_potion"]) {return true;}} // second potion
	else if (vars.gamestate == 26 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 27; if (settings["third_potion"]) {return true;}} // third potion
	else if (vars.gamestate == 27 && old.map == 64 && current.map == 18) {vars.gamestate = 28;} // leaving potions
	else if (vars.gamestate == 28 && old.map == 23 && current.map == 40) {vars.gamestate = 29; if (settings["enter_duelling"]) {return true;}} //Enter duelling
	else if (vars.gamestate == 29 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 30;} // stupefy
	else if (vars.gamestate == 30 && old.map == 40 && current.map == 23) {vars.gamestate = 31; if (settings["leave_duelling"]) {return true;}} // Leave duelling
	else if (vars.gamestate == 31 && current.cutscene == "ns04.vp6") {vars.gamestate = 40;} // riddle cs
	else if (vars.gamestate == 40 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 41; if (settings["goyle_fight"]) {return true;}} // Goyle fight
	else if (vars.gamestate == 41 && old.map == 69 && current.map == 56) {vars.gamestate = 42; if (settings["enter_quidditch_1"]) {return true;}} // Enter quidditch
	else if (vars.gamestate == 42 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 43; if(settings["quidditch_tryouts"]) {return true;}} // Quidditch tryouts
	else if (vars.gamestate == 43 && old.inPotion == 0 && current.inPotion == 1) {vars.gamestate = 44; if (settings["greenhouses"]) {return true;}} // start potion
	else if (vars.gamestate == 44 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 45; if (settings["volubilis"]) {return true;}} // volubilis
	else if (vars.gamestate == 45 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 46;} // tutorial
	else if (vars.gamestate == 46 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 47;} // tutorial
	else if (vars.gamestate == 47 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 48; if (settings["shrinking_solution"]) {return true;}} // shrinking solution
	else if (vars.gamestate == 48 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 49; if (settings["crabbe_fight"]) {return true;}} // Crabbe fight
	else if (vars.gamestate == 49 && current.cutscene == "ns05.vp6") {vars.gamestate = 50; if (settings["hogsmeade"]) {return true;}} // hogsmeade
	else if (vars.gamestate == 50 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 51; if (settings["ctc_duel"]) {return true;}} // Duel
	else if (vars.gamestate == 51 && old.map == 69 && current.map == 56) {vars.gamestate = 52; if (settings["enter_quidditch_2"]) {return true;}} //  enter quidditch
	else if (vars.gamestate == 52 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 53;}
	else if (vars.gamestate == 53 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 54; if (settings["slytherin_match"]) {return true;}} // Slytherin match
	else if (vars.gamestate == 54 && old.map == 60 && current.map == 62) {vars.gamestate = 55; if (settings["enter_party"]) {return true;}} // enter party
	else if (vars.gamestate == 55 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 56;} // tutorial
	else if (vars.gamestate == 56 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 57; if (settings["ponche"]) {return true;}} // Ponche
	else if (vars.gamestate == 57 && current.cutscene == "ns08.vp6") {vars.gamestate = 60; if (settings["follow_snape"]) {return true;}} // Follow snape
	else if (vars.gamestate == 60 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 61;} // Burrow bella 1
	else if (vars.gamestate == 61 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 62;} // Burrow bella 2
	else if (vars.gamestate == 62 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 63;} // Burrow fenrir
	else if (vars.gamestate == 63 && current.cutscene == "ns09.vp6") {vars.gamestate = 70; if (settings["burrow_fights"]) {return true;}} // Burrow fights
	else if (vars.gamestate == 70 && old.map == 18 && current.map == 64) {vars.gamestate = 71; if (settings["enter_potions_2"]) {return true;}} // enter potions
	else if (vars.gamestate == 71 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 72; if (settings["polyjuice"]) {return true;}} // Polyjuice
	else if (vars.gamestate == 72 && old.map == 21 && current.map == 17) {vars.gamestate = 73; if (settings["noisy_hitter"]) {return true;}} // noisy hitter
	else if (vars.gamestate == 73 && current.cutscene == "ns10.vp6") {vars.gamestate = 80;} // Second memory
	else if (vars.gamestate == 80 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 81;} // tutorial
	else if (vars.gamestate == 81 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 82; if (settings["ravenclaw_duelling_club"]) {return true;}} // Ravenclaw duelling club
	else if (vars.gamestate == 82 && old.map == 69 && current.map == 56) {vars.gamestate = 83; if (settings["enter_quidditch_3"]) {return true;}} // Enter quidditch
	else if (vars.gamestate == 83 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 84; if (settings["quidditch_practice"]) {return true;}} // Quidditch practice
	else if (vars.gamestate == 84 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 85; if (settings["slytherin_duel"]) {return true;}} // slytherin duel
	else if (vars.gamestate == 85 && old.map == 18 && current.map == 64) {vars.gamestate = 86; if (settings["enter_potions_3"]) {return true;}} // Enter potions
	else if (vars.gamestate == 86 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 87; if (settings["euphoria"]) {return true;}} // Euphoria
	else if (vars.gamestate == 87 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 88;} // astronomy 1
	else if (vars.gamestate == 88 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 89;} // astronomy 2
	else if (vars.gamestate == 89 && current.cutscene == "ns11.vp6") {vars.gamestate = 90; if (settings["astronomy_trap"]) {return true;}} // astronomy trapped
	else if (vars.gamestate == 90 && old.map == 60 && current.map == 62) {vars.gamestate = 91; if (settings["drunk_ron"]) {return true;}} // Drunk ron
	else if (vars.gamestate == 91 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 92; if (settings["love_potion"]) {return true;}} // love potion
	else if (vars.gamestate == 92 && old.map == 69 && current.map == 57) {vars.gamestate = 93; if (settings["enter_quidditch_4"]) {return true;}} // enter quidditch
	else if (vars.gamestate == 93 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 94;} 
	else if (vars.gamestate == 94 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 95; if (settings["hufflepuff"]) {return true;}} // Hufflepuff match
	else if (vars.gamestate == 95 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 96; if (settings["sectumsempra"]) {return true;}} //sectumsempra
	else if (vars.gamestate == 96 && current.cutscene == "ns12.vp6") {vars.gamestate = 100;} // RoR kiss
	else if (vars.gamestate == 100 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 101;} // bridge fight 1
	else if (vars.gamestate == 101 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 102;} // bridge fight 2
	else if (vars.gamestate == 102 && old.inPotion == 0 && current.inPotion == 1) {vars.gamestate = 103; if (settings["liquid_luck"]) {return true;}} // Liquid luck
	else if (vars.gamestate == 103 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 104; if (settings["fertilizer"]) {return true;}} // fertilizer
	else if (vars.gamestate == 104 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 105; if (settings["crabbe_fight_2"]) {return true;}} // Crabbe fight
	else if (vars.gamestate == 105 && current.cutscene == "ns13.vp6") {vars.gamestate = 110;} // third memory
	else if (vars.gamestate == 110 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 111;}
	else if (vars.gamestate == 111 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 112; if (settings["ravenclaw_match"]) {return true;}} // Ravenclaw Match
	else if (vars.gamestate == 112 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 113; if (settings["wiggenweld"]) {return true;}} // wiggenweld
	else if (vars.gamestate == 113 && current.cutscene == "ns14.vp6") {vars.gamestate = 120; if (settings["leave_hogwarts"]) {return true;}} // to cave
	else if (vars.gamestate == 120 && current.cutscene == "ns15.vp6") {vars.gamestate = 130; if (settings["inferi"]) {return true;}} // Inferi
	else if (vars.gamestate == 130 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 131;} // first death eater
	else if (vars.gamestate == 131 && old.inDuel == 1 && current.inDuel == 0 && current.map == 45) {vars.gamestate = 132;} // second death eather
	else if (vars.gamestate == 132 && old.inDuel == 1 && current.inDuel == 0 && current.map == 9) {vars.gamestate = 133;} // Fenrir
	else if (vars.gamestate == 133 && old.inDuel == 1 && current.inDuel == 0 && current.map == 41) {vars.gamestate = 134; if (settings["bella"]) {return true;}} // end
	else if (vars.gamestate == 134) {vars.gamestate = 135;} // octo fix

}
