Stream<int> Function() fibonnaciNumbers(int n) {

  // Function to return
  return () async* {

    // Initialize values and yield them.
       int a = 0;
       int b = 1;
       yield a;
       await Future.delayed(const Duration(seconds: 1));
        yield b;
       await Future.delayed(const Duration(seconds: 1));

      // Logic loop for fibonacci sequence
       for(int i = 2; i < n; i ++)
          {
            int temp = b;
            b = a + b;
            a = temp;
            yield b;
            await Future.delayed(const Duration(seconds: 1));

          }



     };
}
//
Stream<int> Function() streamFilter(Stream<int> stream, bool Function(int) f) {

// stream to return
  final Stream<int> Function() func = (() async* {

    // awaiting the given stream
    await for(final number in stream)
      {

        if (f(number))
          {
            yield number;
          }
      }

  });
  return func;


}
//
Stream<int> Function() streamAccumulation(Stream<int> stream, int Function(int, int) f, initial) {
  final Stream<int> Function() func = (() async* {
    // awaiting the given stream
    await for(final number in stream)
    {

      yield f(number, initial);
      // set initial to previously number yielded
      initial = f(number,initial);
    }

  });
  return func;
}

Stream<int> Function() generateNumbers(int n) {
  final Stream<int> Function() func = (() async* {
    for (int i = 1; i <= n; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield i;
    }
  });
  return func;
}

void main(List<String> arguments) async {
  print( 'flattening [[0,1], [2]] yields ${flatten([[0,1], [2]])}');
  print( 'flattening [[0,1], [2], null] yields ${flatten([[0,1], [2], null])}');
  print( 'flattening [[0,1, null], [2]] yields ${flatten([[0,1, null], [2]])}');
  print( 'flattening null yields ${flatten(null)}');
  print( 'flattening [null] yields ${flatten([null])}');
  print( 'deepening [0,1,2] yields ${deepen([0,1,2])}');
  print( 'deepening [0,null,2] yields ${deepen([0,null,2])}');
  print( 'deepening [0] yields ${deepen([0])}');
  print( 'deepening [] yields ${deepen([])}');
  print( 'deepening null yields ${deepen(null)}');
  await for (final number in fibonnaciNumbers(7)()) {
    print ('fibonnaci number is ${number}');
  }
  await for (final number in streamFilter(generateNumbers(10)(), ((a) {return a % 2 == 0;}))()) {
    print ('filtered number is $number');
  }
  //
  await for (final number in streamAccumulation(generateNumbers(10)(),((a,b) {return a+b;}),0)()) {
    print ('cumulative number is $number.');
  }
}
List<dynamic>?  deepen(List<int?>? list) {
  if (list == null) {
    return null;
  }
  if (list.length <= 1)
    {
      return list;
    }
  List<dynamic> tempList = [];

  for (int i = 0; i < list.length; i++)
  {
    tempList.add(list[i]);
  }
  List<dynamic> newList = [];
  newList.add(list[0]);
  tempList.removeAt(0);

  for (int i = tempList.length - 1; i >= 0; i --)
    {
      List<dynamic> subList = tempList.sublist(i);
      for(int j = i; j < tempList.length; j ++)
      {
        tempList.removeAt(j);
        j --;

      }
      tempList.add(subList);

    }
  newList.add(tempList[0]);
  return newList;

}



List<int>? flatten(List<List<int?>?>? list) {
  if (list == null){
    return null;
  }

  List<int> newList = [];
  for (int i = 0; i < list.length; i ++)
    {
      if (list[i] != null){
          for(int? j in list[i]!)
            {
              if (j != null)
                {
                  newList.add(j);
                }
            }
      }
    }
  return newList;
}


