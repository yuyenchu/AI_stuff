import java.util.ArrayList;
import java.util.List;

public class Population {
	List<Player> people;
	Player bestPlayer;
	int score, gen;
	
	public Population(int in, int out, int size, Controller game) {
		people = new ArrayList<Player>(size);
		for (int i = 0; i < size; i++) {
			people.add(new Player(game.clone(), in, out));
		}
	}
	
	public boolean isAllDead() {
		for (Player p: people) {
			if (!p.isDead()) {
				return false;
			}
		}
		return true;
	}
	
	public void move() {
		for (Player p: people) {
			if (!p.isDead()) {
				p.move();
			}
		}
	}
	
	
}
