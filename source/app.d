import dsfml.window;
import dsfml.system;
import dsfml.graphics;

import game;

void main()
{
	auto game = new Game(250, 250, Color(255, 255, 255));
	game.run();
}
