SUBROUTINE REDO.TFS.PROCESS.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.TFS.PROCESS.AUTORTN
* ODR NO      : ODR-2009-10-0322
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TFS.REJECT to
* default the value for the REDO.TFS.PROCESS application from REDO.TFS.REJECT
* It is AUTOM NEW CONTENT routine

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TFS.REJECT
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.05.2010  S SUDHARSANAN   ODR-2009-10-0322   INITIAL CREATION
*15-02-2010  Prabhu.N          N.78               HD1103429-CONCEPT is modified as multi value field
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TFS.REJECT
    $INSERT I_F.REDO.TFS.PROCESS


    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------


    FN.REDO.TFS.REJECT = 'F.REDO.TFS.REJECT'
    F.REDO.TFS.REJECT = ''
    CALL OPF(FN.REDO.TFS.REJECT,F.REDO.TFS.REJECT)

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.DATA = ""
    CALL BUILD.USER.VARIABLES(Y.DATA)
    Y.REDO.TFS.REJECT.ID=FIELD(Y.DATA,"*",2)
    CALL F.READ(FN.REDO.TFS.REJECT,Y.REDO.TFS.REJECT.ID,R.REDO.TFS.REJECT,F.REDO.TFS.REJECT,REJ.ERR)
    R.NEW(TFS.PRO.PRIMARY.ACCT)<1,1>=R.REDO.TFS.REJECT<TFS.REJ.PRIMARY.ACCT>
    R.NEW(TFS.PRO.ACCOUNT.NAME)=R.REDO.TFS.REJECT<TFS.REJ.ACCOUNT.NAME>
    Y.CNT=DCOUNT(R.REDO.TFS.REJECT<TFS.REJ.TRANSACTION>,@VM)
    FOR Y.COUNT=1 TO Y.CNT
        R.NEW(TFS.PRO.TRANSACTION)<1,Y.COUNT>=R.REDO.TFS.REJECT<TFS.PRO.TRANSACTION,Y.COUNT>
        R.NEW(TFS.PRO.CURRENCY)<1,Y.COUNT>=R.REDO.TFS.REJECT<TFS.PRO.CURRENCY,Y.COUNT>
        R.NEW(TFS.PRO.ACCOUNT)<1,Y.COUNT>=R.REDO.TFS.REJECT<TFS.PRO.ACCOUNT,Y.COUNT>
        R.NEW(TFS.PRO.AMOUNT)<1,Y.COUNT>=R.REDO.TFS.REJECT<TFS.PRO.AMOUNT,Y.COUNT>
        R.NEW(TFS.PRO.CONCEPT)<1,Y.COUNT>=R.REDO.TFS.REJECT<TFS.REJ.CONCEPT,Y.COUNT>
    NEXT Y.COUNT
RETURN

END
