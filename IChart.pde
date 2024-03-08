import java.util.function.Function;

interface IChart<T> {
  public void addData(T[] data, Function<T, String> getKey);
  public <I extends Iterable<T>> void addData(I data, Function<T, String> getKey);
  public void removeData();
}

// Code authorship:
// A. Robertson, Added IChart<T> interface for charts, 12am 08/03/2024
