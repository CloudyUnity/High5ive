import java.util.function.Function;

interface IChart<T> {
  public void addData(T[] data, Function<T, String> getKey);
  public <I extends Iterable<T>> void addData(I data, Function<T, String> getKey);
  public void removeData();
}
