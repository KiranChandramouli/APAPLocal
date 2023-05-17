SUBROUTINE REDO.TFS.REJECT.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.TFS.REJECT.AUTORTN
* ODR NO      : ODR-2009-10-0322
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TFS.PROCESS to
* default the value for the REDO.TFS.REJECT application from REDO.TFS.PROCESS
* It is AUTOM NEW CONTENT routine

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TFS.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.05.2010  S SUDHARSANAN     ODR-2009-10-0322   INITIAL CREATION
*15-02-2010      Prabhu.N          N.78               HD1103429-CONCEPT is modified as multi value field
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.REDO.TFS.PROCESS
    $INSERT I_F.REDO.TFS.REJECT


    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------


    FN.REDO.TFS.PROCESS = 'F.REDO.TFS.PROCESS'
    F.REDO.TFS.PROCESS = ''
    CALL OPF(FN.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS)
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

*Y.DATA = ""
*CALL BUILD.USER.VARIABLES(Y.DATA)
*Y.REDO.TFS.PROCESS.ID=FIELD(Y.DATA,"*",2)
    Y.REDO.TFS.PROCESS.ID = FIELD(System.getVariable("CURRENT.ID"),"*",1)

    CALL F.READ(FN.REDO.TFS.PROCESS,Y.REDO.TFS.PROCESS.ID,R.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS,PRO.ERR)
    R.NEW(TFS.REJ.PRIMARY.ACCT)<1,1>=R.REDO.TFS.PROCESS<TFS.PRO.PRIMARY.ACCT>
    R.NEW(TFS.REJ.ACCOUNT.NAME)=R.REDO.TFS.PROCESS<TFS.PRO.ACCOUNT.NAME>
    Y.CNT=DCOUNT(R.REDO.TFS.PROCESS<TFS.PRO.TRANSACTION>,@VM)
    FOR Y.COUNT=1 TO Y.CNT
        R.NEW(TFS.REJ.TRANSACTION)<1,Y.COUNT>=R.REDO.TFS.PROCESS<TFS.PRO.TRANSACTION,Y.COUNT>
        R.NEW(TFS.REJ.CURRENCY)<1,Y.COUNT>=R.REDO.TFS.PROCESS<TFS.PRO.CURRENCY,Y.COUNT>
        R.NEW(TFS.REJ.ACCOUNT)<1,Y.COUNT>=R.REDO.TFS.PROCESS<TFS.PRO.ACCOUNT,Y.COUNT>
        R.NEW(TFS.REJ.AMOUNT)<1,Y.COUNT>=R.REDO.TFS.PROCESS<TFS.PRO.AMOUNT,Y.COUNT>
        R.NEW(TFS.REJ.CONCEPT)<1,Y.COUNT>=R.REDO.TFS.PROCESS<TFS.PRO.CONCEPT,Y.COUNT>
    NEXT Y.COUNT
RETURN

END
