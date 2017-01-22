char listGetType(register *p) {
  return p->type;
}

char listSetType(register *p)

rplaca(p, q)
  register LIST *p, *q;
{
  p->left = q;
}

rplacd(p, q)
  register LIST *p, *q;
{
  p->right = q;
}

rplact(register LIST *p, int t)
{
  p->htype = t;
}

LIST *car(p)
  register LIST *p;
{
  return((p == NULL) ? NULL : p->left);
}

LIST *cdr(p)
  register LIST *p;
{
  return((p == NULL) ? NULL : p->right);
}

LIST *cons(p, q)
  register LIST *p, *q;
{
  register LIST *x;

  x = new();
  rplaca(x, p);
  rplacd(x, q);
  rplact(x, LST);
  return(x);
}

LIST *listEq(register LIST *x, register LIST *y)
{
  if (x == NULL && y == NULL) {
    return(TRU);
  } else if (type(x) == SATOM && type(y) == SATOM && car(x) == car(y))
    return(TRU);
  return(NULL);
}
