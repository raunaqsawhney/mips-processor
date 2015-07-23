#include <stdio.h>
int main() {

  int arr[10] ;
  int i = 0;
  int doh[10];
  int sum = 0;

  for (i = 0; i < 10; i++) {
    arr[i] = i+1;
    doh[i] = 0;
  }


  for (i = 0; i < 10; i++) {
    doh[i] = arr[i] / (arr[i] );
    sum += doh[i];
  }


  // Debug
  // for (i = 0; i < 10; i++) {
  //   printf("arr i: %d\n", arr[i]);
  //   printf("doh i: %d\n", doh[i]);
  // }

  // printf("sum: %d\n", sum);
  
  return sum;
}
