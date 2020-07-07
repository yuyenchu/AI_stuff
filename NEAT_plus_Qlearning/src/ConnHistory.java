import java.util.List;

public class ConnHistory {
	public final int from, to, id;
	public List<Integer> innoNums;
	
	public ConnHistory(int from, int to, int id, List<Integer> innoNums) {
		this.from = from;
		this.to = to;
		this.id = id;
		this.innoNums = innoNums;
	}
	
	public boolean match(List<Connection> genes, Neuron f, Neuron t) {
		if (genes.size() == innoNums.size() && f.id == from && t.id == to) {
			for (Connection c: genes) {
				if (!innoNums.contains(c.innoNum)) {
					return false;
				}
			}
			return true;
		}
		return false;
	}
}
