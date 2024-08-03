abstract class BaseDataMapper<E, M> {
  E mapToEntity(M? data);

  List<E> mapToListEntity(List<M>? listData) {
    return listData?.map(mapToEntity).toList() ?? List.empty();
  }
}