//#include<stdio.h>
void swap(int *p, int *q);
int main(void)
{
   int a=5;
  int b=9;
  int *p ;
  int *q ;
  p = &a;
  q = &b;
  swap(p,q);
  // v0 should have a = 9
  a = *p;
  // v1 should have b = 5
  b = *q;
  // v0 stores the sum 14
  //  printf("a: %d, b: %d\n", a, b);
  return a + b;
}

void swap(int *p, int *q)
{
  int temp;
  temp = *p;
  *p=*q;
  *q=temp;
}
