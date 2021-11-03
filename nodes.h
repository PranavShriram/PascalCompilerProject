typedef enum { typeCon, typeId, typeOpr, typeData, typeString} nodeEnum;

/* constants */
typedef struct {
    int value; /* value of constant */
} conNodeType;

/* identifiers */
typedef struct {
    char *i; /* subscript to sym array */
} idNodeType;

/* types */
typedef struct {
    int dataType; /* Type of data type*/
} dataType;

/* String */
typedef struct {
    char *stringVal; /* Type of data type*/
} stringType;

/* operators */
typedef struct {
 int oper; /* operator */
 int nops; /* number of operands */
 struct nodeTypeTag **op; /* operands */
} oprNodeType;

typedef struct nodeTypeTag {
 nodeEnum type; /* type of node */
 union {
    conNodeType con; /* constants */
    idNodeType id; /* identifiers */
    oprNodeType opr; /* operators */
    dataType dType;
    stringType str;
 };
} nodeType; 