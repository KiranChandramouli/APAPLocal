SUBROUTINE REDO.FC.S.DOC.VALIDATE
*------------------------------------------------------------------------------------------------------------------
* Developer    : jvalarezoulloa@temenos.com
* Date         : 2011-11-23
* Description  : This routine validate if all Mandatory doc were recived
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
* Out :
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.1              2011-11-23    Jorge Valarezo   First Version
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.REDO.LOAN.DOCUMENTATION
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT


    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*==================
INITIALISE:
*==================
    F.REDO.LOAN.DOCUMENTATION    =  ''
    FN.REDO.LOAN.DOCUMENTATION   =  'F.REDO.LOAN.DOCUMENTATION'
    R.REDO.LOAN.DOCUMENTATION    =  ''
    ID.DOC                       =  ''
    Y.POS                        =  ''
    Y.ERR                        =  ''
    Y.PRODUCT.POS                =  ''


    Y.PRODUCT.RCA                =  R.NEW(REDO.FC.PRODUCT)
    Y.DOCS.IDS                   =  R.NEW(REDO.FC.LOAN.DOC)
    Y.DOCS.RECVD                 =  R.NEW(REDO.FC.DOCS.RECVD)

    Y.OVERRIDES                  =  ''
    Y.NUM.OVERRIDES              =  0
    Y.OVERRIDE                   =  ''
    Y.OVERRIDE.POS               =  0

    SELECT.STATEMENT             =  'SELECT ':FN.REDO.LOAN.DOCUMENTATION :' WITH PRODUCT EQ ':Y.PRODUCT.RCA: ' AND PRODUCT.INPUT EQ MANDATORIO'
    SELECT.STATEMENT1             =  'SELECT ':FN.REDO.LOAN.DOCUMENTATION :' WITH PRODUCT EQ ':Y.PRODUCT.RCA
    REDO.LOAN.DOCUMENTATION.LIST =  ''
    LIST.NAME                    =  ''
    SELECTED                     =  ''
    SYSTEM.RETURN.CODE           =  ''
    Y.ITR                        =  1
    YT.DOUBLE                    =  ''
RETURN

*==================
OPENFILES:
*==================
    CALL OPF(FN.REDO.LOAN.DOCUMENTATION,F.REDO.LOAN.DOCUMENTATION)

RETURN


*==================
PROCESS:
*==================
    CALL EB.READLIST(SELECT.STATEMENT,REDO.LOAN.DOCUMENTATION.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)


    LOOP
        REMOVE ID.DOC FROM REDO.LOAN.DOCUMENTATION.LIST SETTING Y.POS
    WHILE ID.DOC:Y.POS

        CALL CACHE.READ(FN.REDO.LOAN.DOCUMENTATION, ID.DOC, R.REDO.LOAN.DOCUMENTATION, Y.ERR)

        LOCATE ID.DOC IN Y.DOCS.IDS<1,1> SETTING Y.PRODUCT.POS THEN
            IF Y.DOCS.RECVD<1,Y.PRODUCT.POS> NE "RECIBIDO" THEN
                GOSUB THROW.OVERRIDE
            END

        END ELSE
            GOSUB THROW.OVERRIDE
        END


    REPEAT

    GOSUB VALIDATE.DOCS
RETURN

*==============
THROW.OVERRIDE:
*==============

    TEXT = 'EB.FC.MANDATORY.DOC':@FM:R.REDO.LOAN.DOCUMENTATION<LN.DOC.NAME.DOC>
    M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
    CALL STORE.OVERRIDE(M.CONT)

RETURN
*==============
VALIDATE.DOCS:
*==============
    CALL EB.READLIST(SELECT.STATEMENT1,REDO.LOAN.DOCUMENTATION.LIST1,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    Y.POS = DCOUNT(Y.DOCS.IDS,@VM)


    FOR Y.ITR = 1 TO Y.POS
        IF NOT (Y.DOCS.IDS<1,Y.ITR>) THEN
            AF = REDO.FC.LOAN.DOC
            AV = Y.ITR
            ETEXT  = 'EB-FC-MANDOTORY.FIELD'
            CALL STORE.END.ERROR
        END
        LOCATE Y.DOCS.IDS<1,Y.ITR> IN REDO.LOAN.DOCUMENTATION.LIST1<1> SETTING Y.PRODUCT.POS ELSE
            AF = REDO.FC.LOAN.DOC
            AV = Y.ITR
            ETEXT  = 'EB-FC-NO.VALUE.ALWD'
            CALL STORE.END.ERROR
            Y.ITR += 1
        END
        Y.PRODUCT.POS = ""
        LOCATE Y.DOCS.IDS<1,Y.ITR> IN YT.DOUBLE<1> SETTING Y.PRODUCT.POS THEN
            IF Y.PRODUCT.POS THEN
                AF = REDO.FC.LOAN.DOC
                AV = Y.ITR
                ETEXT ="EB-FC-NO.VALUE.DUP"
                CALL STORE.END.ERROR
            END
        END
        ELSE
            YT.DOUBLE<-1> = Y.DOCS.IDS<1,Y.ITR>

        END

    NEXT Y.ITR


RETURN
END
