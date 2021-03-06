module game;

import dsfml.graphics;
import dsfml.window;
import dsfml.system;

import std.conv : to;
import std.random : uniform;
import std.stdio : writeln;
import std.math;

import helpFuncs;

struct Cell
{
	float a;
	float b;
}

class Game
{
	RenderWindow window;
	Vector2i size;
	Color color;
	ContextSettings settings;
	Cell*[][] cells;
	Cell*[][] next;
	Vertex[][] positions;
	float da = 1.0;
	float db = 0.5;
	float f = 0.0545;
	float k = 0.062;
	float t = 1.0;

	this(int x, int y, Color color)
	{
		this.size = Vector2i(x, y);
		this.color = color;
		this.window = new RenderWindow(VideoMode(this.size.x, this.size.y), "Reaction Diffusion Algorithm");
		this.window.setFramerateLimit(120);

		this.cells.length = this.size.x;
		this.next.length = this.size.x;
		this.positions.length = this.size.x;
		foreach (i; 0 .. this.size.x)
		{
			this.cells[i].length = this.size.y;
			this.next[i].length = this.size.y;
			this.positions[i].length = this.size.y;
			foreach (j; 0 .. this.size.y)
			{
				this.cells[i][j] = new Cell(1.0, 0.0);
				this.next[i][j] = new Cell(1.0, 0.0);
				this.positions[i][j] = Vertex(Vector2f(i, j));
			}
		}
		foreach (i; (this.size.x / 2) - 10 .. (this.size.x / 2) + 10)
			foreach (j; (this.size.y / 2) - 10 .. (this.size.y / 2) + 10)
				this.cells[i][j].b = 1.0;
	}

	void run()
	{
		while (this.window.isOpen())
		{
			this.getEvents();
			this.window.clear(this.color);
			foreach (i; 1 .. this.size.x - 1)
			{
				foreach (j; 1 .. this.size.y - 1)
				{
					float a = this.cells[i][j].a;
					float b = this.cells[i][j].b;
					this.next[i][j].a = a +
							      		(this.da * this.laplaceA(i, j)) - 
							  	  		(a * b * b) + 
							  	  		(this.f * (1 - a)) * this.t;
					this.next[i][j].b = b + 
							  	  		(this.db * this.laplaceB(i, j)) +
							  	  		(a * b * b) -
							  	  		((this.k + this.f) * b) * this.t;
					this.next[i][j].a = constrain(this.next[i][j].a, 0.0, 1.0);
					this.next[i][j].b = constrain(this.next[i][j].b, 0.0, 1.0);
				}
			}
			foreach (i; 0 .. this.size.x)
			{
				foreach (j; 0 .. this.size.y)
				{
					float a = this.next[i][j].a;
					float b = this.next[i][j].b;
					ubyte au = to!ubyte(constrain(a * 255, 0, 255));
					ubyte bu = to!ubyte(constrain(b * 255, 0, 255));
					ubyte color = to!ubyte(constrain((a - b) * 255, 0, 255));
					this.positions[i][j].color = Color(bu, color, color, au);
				}
			}
			foreach (i; 0 .. this.positions.length)
				this.window.draw(this.positions[i], PrimitiveType.Points);
			this.window.display();
			this.swap();
		}
	}

	void getEvents()
	{
		Event event;
		while (this.window.pollEvent(event))
		{
			if (event.type == Event.EventType.Closed)
				window.close();
		}
	}

	void swap()
	{
		auto tmp = this.cells.dup;
		this.cells = this.next.dup;
		this.next = tmp;
	}

	float laplaceA(int i, int j)
	{
		float sumA = 0;

		sumA += this.cells[i][j].a * -1;
		sumA += this.cells[i - 1][j].a * 0.2;
		sumA += this.cells[i + 1][j].a * 0.2;
		sumA += this.cells[i][j + 1].a * 0.2;
		sumA += this.cells[i][j - 1].a * 0.2;
		sumA += this.cells[i - 1][j - 1].a * 0.05;
		sumA += this.cells[i + 1][j - 1].a * 0.05;
		sumA += this.cells[i + 1][j + 1].a * 0.05;
		sumA += this.cells[i - 1][j + 1].a * 0.05;
		
		return sumA;
	}

	float laplaceB(int i, int j)
	{
		float sumB = 0;

		sumB += this.cells[i][j].b * -1;
		sumB += this.cells[i - 1][j].b * 0.2;
		sumB += this.cells[i + 1][j].b * 0.2;
		sumB += this.cells[i][j + 1].b * 0.2;
		sumB += this.cells[i][j - 1].b * 0.2;
		sumB += this.cells[i - 1][j - 1].b * 0.05;
		sumB += this.cells[i + 1][j - 1].b * 0.05;
		sumB += this.cells[i + 1][j + 1].b * 0.05;
		sumB += this.cells[i - 1][j + 1].b * 0.05;
		
		return sumB;
	}
}