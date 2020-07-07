import java.util.ArrayList;
import java.util.List;

public class Neuron {
	public final int id;
	private float inputSum, output;
	public int layer;
	private List<Connection> connections;
	
	public Neuron(int number, int layer, boolean relu) {
		this.id = number;
		this.layer = layer;
		inputSum = 0;
		output = 0;
		connections = new ArrayList<>();
	}
	
	public Neuron(int number, int layer) {
		this(number, layer, false);
	}
	
	private float sigmoid(float f) {
		return (float)(1/(1+Math.pow(Math.E, -4.9*(double)f)));
	}
	
	private float relu(float f) {
		return f >= 0 ? f : 0;
	}
	
	public boolean isConnectedTo(Neuron node) {
	    if (node.layer == this.layer) {	//nodes in the same layer cannot be connected
	      return false;
	    }

	    //checking connections based on layer
	    if (node.layer < this.layer) {
	      for (Connection c: node.connections) {
	        if (c.getTo().id == this.id) {
	          return true;
	        }
	      }
	    } else {
	      for (Connection c: this.connections) {
	        if (c.getTo().id == node.id) {
	          return true;
	        }
	      }
	    }
	    return false;
	 }
	
	public void addIn(float in) {
		inputSum += in;
	}
	
	public void addConn(Connection c) {
		connections.add(c);
	}
	
	public void clearIO() {
		inputSum = 0;
		output = 0;
	}
	
	public void clearConn() {
		connections.clear();
	}
	
	public void engage() {
		output = layer == 0 ? inputSum : sigmoid(inputSum);
		output = sigmoid(inputSum);
		for (Connection c: connections) {
			if (c.isEnable()) {
				c.getTo().addIn(output * c.weight());
			}
		}
	}
	
	public float getOutput() {
		return output;
	}	
	
	public float getInput() {
		return inputSum;
	}
	
	public Neuron clone() {
		return new Neuron(id, layer);
	}
}
