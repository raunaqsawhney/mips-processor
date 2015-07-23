#include <stdio.h>
int main() {

  int arr[10] ;
  int i = 0;
  int sum = 0;

  for (i = 0; i < 10; i++) {
    arr[i] = i;
  }


  for (i = 0; i < 10; i++) {
    sum = sum + arr[i];
  }

  return sum;
}
