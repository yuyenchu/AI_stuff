import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Genome {
	private List<Connection> genes;
	private List<Neuron> neurons;
	private List<List<Neuron>> network;
	//network are in order of layers, network[i] = i layer
	
	public final int inputs, outputs;
	private int layers, nextNeuronNo, nextConnNo, biasNode;
	private Random rand;
	
	public Genome(int in, int out) {
	    //set input number and output number
		inputs = in;
		outputs = out;
		nextNeuronNo = 0;
		nextConnNo = 0;
		layers = 2;
		genes = new ArrayList<>();
		neurons = new ArrayList<>();
		rand = new Random();
		network = new ArrayList<List<Neuron>>(layers);
		
	    //create input nodes
		List<Neuron> inLayer = new ArrayList<Neuron>();
	    for (int i = 0; i < inputs; i++) {
	    	Neuron temp = new Neuron(i, 0);
	    	neurons.add(temp);
	    	inLayer.add(temp);
	    }
	    network.add(inLayer);

	    //create output nodes
	    List<Neuron> outLayer = new ArrayList<Neuron>();
	    for (int i = 0; i < outputs; i++) {
	    	Neuron temp = new Neuron(i+inputs, 1);
	    	neurons.add(temp);
	    	outLayer.add(temp);
	    }
	    network.add(outLayer);
	    
	    //create bias node
	    biasNode = inputs + outputs; 
	    Neuron bias = new Neuron(biasNode, 0);
	    neurons.add(bias);
	    network.get(0).add(bias);
	    
	    nextNeuronNo = inputs + outputs + 1;
	}
	
	public Genome(int in, int out, int layers, int nextNeuron, int biasNeuron) {
		inputs = in;
		outputs = out;
		this.layers = layers;
		nextNeuronNo = nextNeuron;
		biasNode = biasNeuron;
		genes = new ArrayList<>();
		neurons = new ArrayList<>();
		rand = new Random();
		network = new ArrayList<List<Neuron>>();
	}
	
	public Neuron getNode(int nodeNumber) {
	    for (Neuron n: neurons) {
	    	if (n.id == nodeNumber) {
	    		return n;
	    	}
	    }
	    return null;
	}
	
	public void connect() {
		for (Neuron n: neurons) {
			n.clearConn();
		}
		for (Connection c: genes) {
			c.connect();
		}
	}
	
	public void generateNetwork() {
		connect();
		network = new ArrayList<List<Neuron>>(layers);
		for (int i = 0; i < layers; i++) {
			network.add(new ArrayList<Neuron>());
		}
		
		for (Neuron n: neurons) {
			network.get(n.layer).add(n);
		}
	}
	
	public void mutate(List<ConnHistory> innoHistory) {
		if (genes.isEmpty()) {
			mutateConnection(innoHistory);
		}
		if (rand.nextFloat() < 0.8) {
			for (Connection c: genes) {
				c.mutateWeight();
			}
		}
		if (rand.nextFloat() < 0.08) {
			mutateConnection(innoHistory);
		}
		if (rand.nextFloat() < 0.02) {
			mutateNeuron(innoHistory);
		}
	}
	
	@SuppressWarnings("serial")
	public void mutateNeuron(List<ConnHistory> innoHistory) {
		if (genes.isEmpty()) {
			mutateConnection(innoHistory);
			return;
		}
		int randConn = rand.nextInt(genes.size());
		while (genes.get(randConn).getFrom().id == biasNode && genes.size() > 1) {
			randConn = rand.nextInt(genes.size());
		}
		
		Connection randomConn = genes.get(randConn);
		randomConn.disabble();
		Neuron newNode = new Neuron(nextNeuronNo, randomConn.getFrom().layer+1);
		neurons.add(newNode);
		nextNeuronNo++;
		
		genes.add(new Connection(randomConn.getFrom(), newNode, 1, getInnoNum(innoHistory, randomConn.getFrom(), newNode)));
		randomConn.getFrom().addConn(genes.get(genes.size()-1));
		
		genes.add(new Connection(newNode, randomConn.getTo(), 1, getInnoNum(innoHistory, newNode, randomConn.getTo())));
		newNode.addConn(genes.get(genes.size()-1));
		
		genes.add(new Connection(neurons.get(biasNode), newNode, 0, getInnoNum(innoHistory, neurons.get(biasNode), newNode)));
		neurons.get(biasNode).addConn(genes.get(genes.size()-1));
		
		if (newNode.layer == randomConn.getTo().layer) {
			network.add(newNode.layer, new ArrayList<Neuron>() {{add(newNode);}});
			for (int i = newNode.layer+1; i < network.size(); i++) {
				for (Neuron n: network.get(i)) {
					n.layer++;
				}
			}
			layers++;
		}
		
	}
	
	public void mutateConnection(List<ConnHistory> innoHistory) {
		if (!fullyConnected()) {
			//get random nodes
		    int randomNode1 = rand.nextInt(neurons.size()); 
		    int randomNode2 = rand.nextInt(neurons.size());
		    while (isConnected(randomNode1, randomNode2)) {//while the random nodes are no good
		    	//get new ones
		    	randomNode1 = rand.nextInt(neurons.size()); 
		    	randomNode2 = rand.nextInt(neurons.size());
		    }
		    Neuron n1 = neurons.get(randomNode1);
		    Neuron n2 = neurons.get(randomNode2);
		    if (n1.layer < n2.layer) {
		    	genes.add(new Connection(n1, n2, rand.nextFloat() * 2 - 1, getInnoNum(innoHistory, n1, n2)));
				n1.addConn(genes.get(genes.size()-1));
		    } else {
		    	genes.add(new Connection(n2, n1, rand.nextFloat() * 2 - 1, getInnoNum(innoHistory, n2, n1)));
				n2.addConn(genes.get(genes.size()-1));
		    }
		}
	}
	
	public boolean isConnected(int n1, int n2) {
		return neurons.get(n1).layer == neurons.get(n2).layer || neurons.get(n1).isConnectedTo(neurons.get(n2)); 
	}
	
	public boolean fullyConnected() {
		int maxConns = 0;
		int[] neuronInLayer = new int[layers];
		
		for (Neuron n: neurons) {
			neuronInLayer[n.layer]++;
		}
		
		for (int i = 0; i < layers-1; i++) {
			int nodesInFront = 0;
			for (int j = i+1; j < layers; j++) {	//for each layer infront of this layer
				nodesInFront += neuronInLayer[j];	//add up nodes
			}

			maxConns += neuronInLayer[i] * nodesInFront;
	    }
		return genes.size() >= maxConns;
	}
	
	public int getInnoNum(List<ConnHistory> innoHistory, Neuron from, Neuron to) {
		for (ConnHistory h: innoHistory) {
			if (h.match(genes, from, to)) {
				return h.id;
			}
		}
		
		List<Integer> innoNums = new ArrayList<Integer>();
		for (Connection c: genes) {
			innoNums.add(c.innoNum);
		}
		innoHistory.add(new ConnHistory(from.id, to.id, nextConnNo, innoNums));
		nextConnNo++;
		
		return nextConnNo-1;
	}
	
	public Genome crossover(Genome parent2) {
		Genome child = new Genome(inputs, outputs, layers, nextNeuronNo, biasNode);
		//since all excess and disjoint genes are inherited from the more fit parent (this Genome) 
		//the child's structure is no different from this parent | with exception of dormant 
		//connections being enabled but this won't effect nodes
	    //so all the nodes can be inherited from this parent
		for (Neuron n: neurons) {
			child.neurons.add(n.clone());
		}
		//clone all the inherited connections to child's genes
		List<Connection> childGenes = child.genes;
		for (Connection c: this.genes) {
			Connection parent2gene = matchingGene(parent2, c.innoNum);
			//if the genes match
			if (parent2gene != null) {	
				//get gene from one of the parent
				if (rand.nextFloat() < 0.5) {	
					childGenes.add(c.clone(child.getNode(c.getFrom().id), child.getNode(c.getTo().id)));
				} else {
					childGenes.add(parent2gene.clone(child.getNode(c.getFrom().id), child.getNode(c.getTo().id)));
				}
				//if either of the matching genes is disabled, 75% chance disable it in child's genes
				if ((!c.isEnable() || !parent2gene.isEnable()) && rand.nextFloat() < 0.75) {
					childGenes.get(childGenes.size()-1).disabble();
				}
			//disjoint or excess gene
			} else {
				childGenes.add(c.clone(child.getNode(c.getFrom().id), child.getNode(c.getTo().id)));
			}
		}
		child.generateNetwork();
		return child;
	}
	
	public Connection matchingGene(Genome parent2, int innovationNumber) {
	    for (Connection c: parent2.genes) {
	    	if (c.innoNum == innovationNumber) {
	    		return c;	//return matching gene
	    	}
	    }
	    return null; 		//no matching gene found
	}
	
	public List<Connection> getGenes() {
		return genes;
	}
	
	public List<Neuron> getNeurons() {
		return neurons;
	}

	public float[] feedForward(float[] inValues) {
		for(int i = 0; i < inputs; i++) {
			neurons.get(i).addIn(inValues[i]);
		}
		for(int i = 0; i < network.size(); i++) {
			for (Neuron n: network.get(i)) {
				n.engage();
			}
		}
		float[] outs = new float[outputs];
	    for (int i = 0; i < outputs; i++) {
	      outs[i] = neurons.get(inputs + i).getOutput();
	    }
	    for (Neuron n: neurons) {
			n.clearIO();
		}
	    
		return outs;
	}
	
	public Genome clone() {
		Genome clone = new Genome(inputs, outputs);

	    for (int i = 0; i < neurons.size(); i++) {
	    	//copy nodes
	    	clone.neurons.add(neurons.get(i).clone());
	    }

	    //copy all the connections so that they connect the clone new nodes

	    for ( int i = 0; i < genes.size(); i++) {
	    	//copy genes
	    	clone.genes.add(genes.get(i).clone(clone.getNode(genes.get(i).getFrom().id), clone.getNode(genes.get(i).getTo().id)));
	    }

	    clone.layers = layers;
	    clone.nextNeuronNo = this.nextNeuronNo;
	    clone.biasNode = this.biasNode;
	    clone.connect();

	    return clone;
  }
}
