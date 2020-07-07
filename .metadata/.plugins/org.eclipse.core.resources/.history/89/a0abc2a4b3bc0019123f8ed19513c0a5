public class Player {
	private Genome brain;
	private int in , out;
	private float[] decision;
	private boolean isDead;
	private float fitness;
	private Controller game;
	public float score;
	public int gen;
	
	public Player (Controller game, int in, int out) {
		brain = new Genome(in, out);
		this.game = game;
		isDead = false;
		fitness = 0f;
		score = 0f;
	}
	
	public void move() {
	    decision = brain.feedForward(game.getEnv());
	    game.doMove(decision);
	    score = game.response();
	    isDead = game.isEnd();
	}
	
	public void show() {
		game.show();
	}
	
	public Player clone() {
	    Player clone = new Player(game.clone(), in, out);
	    clone.brain = (Genome) brain.clone();
	    clone.fitness = fitness;
	    clone.brain.generateNetwork(); 
	    clone.gen = gen;
	    return clone;
	}

	public boolean isDead() {
		return isDead;
	}
	
	public float[] getDecision() {
		return decision;
	}

	public Player crossover(Player parent2) {
	    Player child = new Player(game.clone(), in, out);
	    child.brain = brain.crossover(parent2.brain);
	    child.brain.generateNetwork();
	    return child;
	}
}
