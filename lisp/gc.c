#define haveGC
enum listFlags {
  GARBAGE=1,USED=2,RUNNING=4
}; 

void listMark(LIST *p)
{
  if (p != NULL) {
    if (type(p) == LST) {
      listMark(car(p));   
      listMark(cdr(p));
    }
    p->gcbit = USED;
  }
}
