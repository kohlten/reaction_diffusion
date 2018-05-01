import dsfml.window;
import dsfml.system;
import dsfml.graphics;

import game;

void main()
{
	auto game = new Game(409, 409, Color(255, 255, 255));
	game.run();
}
