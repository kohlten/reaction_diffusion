import dsfml.system;

import std.random;
import std.stdio;
import std.math;

//https://github.com/SFML/SFML/wiki/Source%3A-Simple-Collision-Detection

/**
 * randomVector returns a new random vector the length of one
 * using degrees or radians or a longer length
 */
V randomVector(V)(bool degrees = true, int length = 1)
{
	float angle;

	if (degrees)
		angle = uniform(0.0, 360.0);
	else
		angle = uniform(0.0, PI * 2);
	return V(length * cos(angle), length * sin(angle));
}

/**
 * rotateCenter takes a object that uses dsfml.graphics.transformable,
 * and rotates it by degrees and then returns that object.
 * See also http://dsfml.com/dsfml/graphics/transformable.html
 */

O rotateCenter(O)(O object, float degrees)
{
	if (isNaN(degrees))
		degrees = 0;
	object.origin(object.size / 2);
	object.rotation(degrees);
	return object;
}


/**
 * getHeading returns the current direction of a vector in
 * degrees or radians. 
 */
float getHeading(V)(V vector, bool degrees = true)
{
	if (degrees)
		return atan2(vector.y, vector.x) * 180 / PI;
	else
		return atan2(vector.y, vector.x);
}

/**
 * getMag returns the current magnitude of a vector.
 */
float getMag(V)(V pos)
{
	return sqrt(pos.x * pos.x + pos.y * pos.y);
}

/**
 * normalize returns the vector as a length of one.
 */
V normalize(V)(V pos)
{
	float mag = getMag!(V)(pos);
	if (mag == 0)
		return pos;
	return pos / mag; 
}

/**
 * setMag normalizes a vector and then times it by n.
 */
V setMag(V)(V pos, float n)
{
	return pos.normalize!(V)() * n;
}

/**
 * dist the distance between two vectors.
 */
float dist(V)(V v1, V v2)
{
	return hypot(v2.x - v1.x, v2.y - v1.y);
}

/**
 * constrain takes a number and a low and a high to return a number in between that range.
 */
N constrain(N)(N n, N low, N high)
{
	return fmax(fmin(n, high), low);
}

/**
 * map returns a number between a range of start 1 and stop 1 to a range of start2 and stop2.
 * if constrain is true, will make sure that value is between the ending range.
 */
N map(N)(N n, N start1, N stop1, N start2, N stop2, bool withinBounds = false)
{
	N newval = (n - start1) / (stop1 - start1) * (stop2 - start2) + start2;
	if (!withinBounds)
		return newval;
	if (start2 < stop2)
		return constrain!(N)(newval, start2, stop2);
	else
		return constrain!(N)(newval, stop2, start2);
}

/**
 * getRandomObject returns a random object from the list objects.
 */
O getRandomObject(O)(O[] objects)
{
	ulong index = uniform(0, objects.length);
	return (objects[index]);
}

/**
 * getRandomObject returns a random object from the list objects using suppilied rng.
 */
O getRandomObject(O)(O[] objects, Random rng)
{
	ulong index = uniform(0, objects.length, rng);
	return objects[index];
}

/**
 * rotatePoint takes and vector and an angle and converts the angle to 
 * radians (if it is in degrees) and then rotates that point. 
 * Returns the rotated vector.
 */
V rotatePoint(V)(V point, float angle, bool radians = false)
{
	V rotated;
	
	if (!radians)
		angle *= 0.0174533;
	
	rotated.x = point.x * cos(angle) + point.y * sin(angle);
	rotated.y = -point.x * sin(angle) + point.y * cos(angle);

	return rotated;
}

/**
 * collidesRect takes two shapes and checks if they are intersecting in any way.
 * Returns a true if they are and false otherwise. Not to be used when you want perfect collisions,
 * look at pixelPerfectCollision for that.
 * Also look at http://dsfml.com/dsfml/graphics/transformable.html
 */
bool collidesRect(ShapeOne, ShapeTwo)(ShapeOne shapeone, ShapeTwo shapetwo)
{
	if (shapeone.getGlobalBounds().intersects(shapetwo.getGlobalBounds()))
		return true;
	return false;
}
