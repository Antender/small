debug(LIST *p)
{
  puts("!--DEBUG INFO:\n");
  debug(p);
  puts("!--\n");
}

debugList(LIST *p)
{
  int t;
  if (p != NULL) {
    if ((t = type(p)) == LST) {
      putchar('(');  
      debugList(car(p));  
      debugList(cdr(p)); 
      putchar(')');
    }
    else if (t == RATOM) printf("RATOM %f ", p->u.num);
    else if (t == IATOM) printf("IATOM %d ", (int) p->u.num);
    else if (t == SATOM) printf("SATOM %s ", getname(car(p)));
    else printf("FUNC %d ", type(p));
  }
}
