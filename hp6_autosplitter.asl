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
	settings.Add("autostart", true, "Autostart on first cutscene (full game run)");
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
	return current.cutscene != old.cutscene && (current.cutscene == "ns01.vp6" && settings["autostart"]);
}

update
{

	if (current.cutscene == "ns01.vp6" && vars.gamestate == 0) {vars.gamestate = 10;} // starting new game
	else if (vars.gamestate == 10 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 11;}
	else if (current.map == 0 && vars.gamestate == 11) {vars.gamestate = 12;}
	else if (current.cutscene == "ns02.vp6") {vars.gamestate = 20;} // finish Burrow
	else if (current.cutscene == "ns03.vp6") {vars.gamestate = 30;} // get to castle
	else if (current.cutscene == "ns04.vp6") {vars.gamestate = 40;} // first memory
	else if (vars.gamestate == 40 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 41;}
	else if (old.map == 51 && current.map == 51 && vars.gamestate == 41) {vars.gamestate = 42;}
	else if (vars.gamestate == 42 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 43;}
	else if (old.map == 56 && current.map == 56 && vars.gamestate == 43) {vars.gamestate = 44;}
	else if (current.cutscene == "ns05.vp6") {vars.gamestate = 50;} // cursed Katie Bell
	else if (vars.gamestate == 50 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 51;}
	else if (vars.gamestate == 51 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 52;}
	else if (vars.gamestate == 52 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 53;} 
	else if (old.map == 56 && current.map == 56 && vars.gamestate == 53) {vars.gamestate = 54;}
	else if (current.cutscene == "ns07.vp6") {vars.gamestate = 60;} // after Hermione seeing Ron and Lav
	else if (vars.gamestate == 60 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 61;}
	else if (vars.gamestate == 61 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 62;}
	else if (old.map == 60 && current.map == 60 && vars.gamestate == 62) {vars.gamestate = 63;}
	else if (current.cutscene == "ns08.vp6") {vars.gamestate = 70;} // after following Snape and Malfoy
	else if (current.cutscene == "ns09.vp6") {vars.gamestate = 80;} // after duels in Burrow
	else if (current.cutscene == "night2day.vp6" && vars.gamestate == 80) {vars.gamestate = 90;} // after brewing polyjuice potion
	else if (current.cutscene == "ns10.vp6") {vars.gamestate = 100;} // second memory
	else if (vars.gamestate == 100 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 101;}
	else if (current.map == 56 && vars.gamestate == 101) {vars.gamestate = 102;}
	else if (vars.gamestate == 102 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 103;}
	else if (vars.gamestate == 103 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 104;}
	else if (current.cutscene == "ns11.vp6") {vars.gamestate = 110;} // after getting trapped
	else if (vars.gamestate == 110 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 111;}
	else if (old.map == 45 && current.map == 45 && vars.gamestate == 111) {vars.gamestate = 112;}
	else if (current.cutscene == "night2day.vp6" && vars.gamestate == 112) {vars.gamestate = 120;} // after Ron being poisoned
	else if (vars.gamestate == 120 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 121;}
	else if (vars.gamestate == 121 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 122;}
	else if (current.map == 56 && vars.gamestate == 122) {vars.gamestate = 123;}
	else if (current.cutscene == "night2day.vp6" && vars.gamestate == 123) {vars.gamestate = 130;} // after Quidditch vs Huffelpuff
	else if (vars.gamestate == 130 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 131;}
	else if (current.cutscene == "ns12.vp6") {vars.gamestate = 140;} // after Malfoy chase
	else if (vars.gamestate == 140 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 141;}
	else if (vars.gamestate == 141 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 142;}
	else if (vars.gamestate == 142 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 143;}
	else if (vars.gamestate == 143 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 144;}
	else if (old.map == 17 && current.map == 17 && vars.gamestate == 144) {vars.gamestate = 145;}
	else if (current.cutscene == "ns13.vp6") {vars.gamestate = 150;} // third memory
	else if (vars.gamestate == 150 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 151;}
	else if (vars.gamestate == 151 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 152;}
	else if (old.map == 56 && current.map == 56 && vars.gamestate == 152) {vars.gamestate = 153;}
	else if (vars.gamestate == 153 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 154;}
	else if (old.map == 42 && current.map == 42 && vars.gamestate == 154) {vars.gamestate = 155;}
	else if (current.cutscene == "ns14.vp6") {vars.gamestate = 160;} // to cave
	else if (current.cutscene == "ns15.vp6") {vars.gamestate = 170;} // from cave
	else if (vars.gamestate == 170 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 171;}
	else if (current. map == 45 && vars.gamestate == 171 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 172;}
	else if (current.map == 9 && vars.gamestate == 172 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 173;}
	else if (current.map == 41 && vars.gamestate == 173 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 174;}
	else if (current.cutscene == "ns16.vp6") {vars.gamestate = 180;} // final cinematic

}

split
{
	// cutscene splits
	if (current.cutscene != old.cutscene && (
			current.cutscene == "ns02.vp6" // Diagon Alley
			 || current.cutscene == "ns03.vp6" // hogwarts
			 || current.cutscene == "ns05.vp6" // hogsmeade
			 || current.cutscene == "ns08.vp6" // sneaky follow
			 || current.cutscene == "ns09.vp6" // the burrow
			 || current.cutscene == "ns11.vp6" // astronomy trap
			 || current.cutscene == "ns15.vp6" // inferi
		))
	{
		return true;
	}

	return (current.map != old.map &&
		(current.map == 56 && (
		 	vars.gamestate == 43 // tryouts
			 || vars.gamestate == 53 // quidditch 1
		 	 || vars.gamestate == 101 // practice
		 	 || vars.gamestate == 122 // quidditch 2
		 	 || vars.gamestate == 152 // final
	 	)) // quidditch stuffs

		 || (old.map == 64 && current.map == 18 && (
		 	vars.gamestate == 30 // potions class
		 	|| vars.gamestate == 104 // potion of euphoria
	 	)) // potions


		 || (current.map == 0 && vars.gamestate == 11) //Burrow Flying
		 || (old.map == 40 && current.map == 23 && vars.gamestate == 30) // dueling club
		 || (old.map == 66 && current.map == 51 && vars.gamestate == 41) // goyle fight	 
		 || (old.map == 62 && current.map == 60 && vars.gamestate == 62) // Slughorn party
		 || (old.map == 64 && current.map == 12) // polyjuice
		 || (old.map == 21 && current.map == 17 && vars.gamestate == 90) // noisy hitter
		 || (old.map == 62 && current.map == 45 && vars.gamestate == 111) // won-won in love
		 || (old.map == 49 && current.map == 59 && vars.gamestate == 131) // sectumsempra
		 || (old.map == 43 && current.map == 41) // felix felicis
		 || (old.map == 66 && current.map == 17 && vars.gamestate == 144) // crabbe fight
		 || (current.map == 42 && vars.gamestate == 154) // wiggenweld
		 || (current.map == 41 && vars.gamestate == 174) // screw you bella
	);
}
