public interface Controller {
	public void doMove(float[] move);
	public float response();
	public float[] getEnv();
	public Controller clone();
	public boolean isEnd();
	public void show();
}
