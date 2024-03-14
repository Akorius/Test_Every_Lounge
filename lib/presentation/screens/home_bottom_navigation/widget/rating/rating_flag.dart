enum RateFlag {
  //не менять порядок
  before,

  ///0 До показа флага не показывать
  showFirst,

  ///1 Показать флаг
  dontShow,

  ///2 Не показывать
  after,

  ///3 Показать позже
  showSecond,

  ///4 Показать второй раз
  afterSecond,

  ///5 Показать позже (последний раз)
  showLast,

  ///6 Показать флаг (последний раз)
}

//если rateflag = 1 - показать окно
//если нажали оценить: ставить 2, если нажали позже - ставить 3
//
//если rateflag = 4 - показать окно
//если нажали оценить: ставить 2, если нажали позже - ставить 5
//
//если rateflag = 6 - показать окно
//если нажали оценить: ставить 2, если нажали позже - ставить 2

int handleFlagByType(RateFlag? flags) {
  switch (flags) {
    case RateFlag.showFirst:
      return RateFlag.after.index;
    case RateFlag.showSecond:
      return RateFlag.afterSecond.index;
    case RateFlag.showLast:
    case RateFlag.dontShow:
    default:
      return RateFlag.dontShow.index;
  }
}
