//#include <stdio.h>

int main()
{
  int i = 0;
  int j = 0;
  char ch[20] = "CheckVowel!\n";

  for (i=0;i<20;i++) {
    if (ch[i] == 'a' || ch[i] == 'A' || ch[i] == 'e' || ch[i] == 'E' || ch[i] == 'i' || ch[i] == 'I' || ch[i] =='o' || ch[i]=='O' || ch[i] == 'u' || ch[i] == 'U')
      ++j;
      //    printf("%c is a vowel.\n", ch[i]);
    //    printf("%c is not a vowel.\n", ch[i]);
  }

  return 0;
}
