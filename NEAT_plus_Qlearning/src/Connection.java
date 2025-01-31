import java.util.Random;

public class Connection {
	private Neuron from, to;
	private float weight;
	private boolean enabled;
	private Random rand = new Random();
	private final float mutate = 0.1f;
	public final int innoNum;
	
	
	public Connection(Neuron from, Neuron to, float weight, int inno) {
		this.from = from;
		this.to = to;
		this.weight = weight;
		innoNum = inno;
		enabled = true;
	}
	
	public void mutateWeight() {
		if (rand.nextFloat() < mutate) {
			weight = rand.nextFloat() * 2 - 1;	//range from -1(inclusive) to 1(exclusive)
		} else {
			weight += (float) rand.nextGaussian() / 0.5f;
		}
		if (weight > 1) {
			weight = 1;
		} else if (weight < -1) {
			weight = -1;
		}
	}
	
	public Neuron getFrom() {
		return from;
	}
	
	public Neuron getTo() {
		return to;
	}
	
	public float weight() {
		return weight;
	}
	
	public boolean isEnable() {
		return enabled;
	}
	
	public void connect() {
		from.addConn(this);
	}
	
	public void setFrom(Neuron n) {
		from = n;
	}
	
	public void setTo(Neuron n) {
		to = n;
	}
	
	public void setWeight(float w) {
		weight = w;
		if (weight > 1) {
			weight = 1;
		} else if (weight < -1) {
			weight = -1;
		}
	}
	
	public void enable() {
		enabled = true;
	}
	
	public void disabble() {
		enabled = false;
	}
	
	public void clear() {
		from = null;
		to = null;
		weight = 0f;
		enabled = false;
	}
	
	public Connection clone(Neuron f, Neuron t) {
		return new Connection(f, t, weight, innoNum);
	}
	
	public Connection clone() {
		return new Connection(from.clone(), to.clone(), weight, innoNum);
	}
}
