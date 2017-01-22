enum listTypes {
  IATOM=0,FLATOM,SATOM,LATOM,LST, //value types
  NILL,T, //special values 'nil' and 'true'	
  VAR,QUOTE,COND,	
  DEFUN,FCAR,FCDR,FCONS,FEQ,	
  FATOM,FQUOTE,FSETQ,FUSER,PLUS,	
  DIFF,TIMES,QUOTIENT,ADD1,SUB1,	
  ZEROP,NUMBERP,GREATERP,LESSP,PRINT,	
  NUL,FUNCALL,PROG,GO,RETRN,	
  LABL,FREAD,FREPLACA,FREPLACD,FEVAL,
  FAPPLY,FAND,FOR,FNOT,FLIST
};

typedef struct list {
  char type;
#ifdef haveGC
  char gcFlags;
#endif
  union {
    int    ia; //integer atom
    float  fla; //float atom
    char * sa; //string atom
    char fa; //lisp built-in function atom
    struct list *lst; //list
  } st; //storage
  struct list *next;
} list;

LIST *listNew()
{
  register LIST *p;
  p = (struct LIST *) malloc(sizeof(LIST));
#ifdef haveGC
  (p->gcFlags)&=RUNNING;
#endif
}
