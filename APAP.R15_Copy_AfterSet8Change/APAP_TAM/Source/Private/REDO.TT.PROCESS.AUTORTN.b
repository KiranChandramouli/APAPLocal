$PACKAGE APAP.TAM
SUBROUTINE REDO.TT.PROCESS.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.PART.TT.PROCESS.AUTORTN
* ODR NO      : ODR-2009-11-0157
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TELLER.REJECT to
* default the value for the REDO.TELLER.PROCESS application from REDO.TELLER.REJECT
* It is AUTOM NEW CONTENT routine



*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.PART.TT.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*30.06.2010  S SUDHARSANAN      B.12        INITIAL CREATION
*11-11-2010  JEEVA T            B.12        Baselined after few logic changes
** 18-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 18-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TT.PROCESS
    $INSERT I_F.REDO.TT.REJECT

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------


    FN.REDO.TT.REJECT = 'F.REDO.TT.REJECT'
    F.REDO.TT.REJECT = ''
    CALL OPF(FN.REDO.TT.REJECT,F.REDO.TT.REJECT)

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.DATA = ""
    CALL BUILD.USER.VARIABLES(Y.DATA)
    Y.REDO.PART.TT.REJECT.ID=FIELD(Y.DATA,"*",2)
    CALL F.READ(FN.REDO.TT.REJECT,Y.REDO.PART.TT.REJECT.ID,R.REDO.TT.REJECT,F.REDO.TT.REJECT,REJ.ERR)

    Y.AA.ID               = R.REDO.TT.REJECT<TT.REJ.ARRANGEMENT.ID>
    Y.CURRENCY            = R.REDO.TT.REJECT<TT.REJ.CURRENCY>
    Y.TRAN.TYPE           = R.REDO.TT.REJECT<TT.REJ.TRAN.TYPE>
    Y.TRAN.CODE           = R.REDO.TT.REJECT<TT.REJ.TRAN.CODE>
    Y.AMOUNT              = R.REDO.TT.REJECT<TT.REJ.AMOUNT>
    Y.VALUE.DATE          = R.REDO.TT.REJECT<TT.REJ.VALUE.DATE>
    Y.NOF.BILLS           = R.REDO.TT.REJECT<TT.REJ.NO.OF.OD.BILLS>
    Y.TOT.AMT.OVRDUE      = R.REDO.TT.REJECT<TT.REJ.TOT.AMT.OVRDUE>
    Y.REMARKS             = R.REDO.TT.REJECT<TT.REJ.REMARKS>
    Y.LOAN.STAT           = R.REDO.TT.REJECT<TT.REJ.LOAN.STATUS.1>
    Y.LOAN.STAT.CNT       = DCOUNT(Y.LOAN.STAT,@VM)
    Y.LOAN.COND           = R.REDO.TT.REJECT<TT.REJ.LOAN.CONDITION>
    Y.LOAN.COND.CNT       =  DCOUNT(Y.LOAN.COND,@VM)

    R.NEW(TT.PRO.ARRANGEMENT.ID)= Y.AA.ID
    R.NEW(TT.PRO.CURRENCY)      = Y.CURRENCY
    R.NEW(TT.PRO.TRAN.TYPE)     = Y.TRAN.TYPE
    R.NEW(TT.PRO.TRAN.CODE)     = Y.TRAN.CODE
    R.NEW(TT.PRO.AMOUNT)        = Y.AMOUNT
    R.NEW(TT.PRO.VALUE.DATE)    = Y.VALUE.DATE
    R.NEW(TT.PRO.NO.OF.OD.BILLS)= Y.NOF.BILLS
    R.NEW(TT.PRO.TOT.AMT.OVRDUE)= Y.TOT.AMT.OVRDUE
    R.NEW(TT.PRO.REMARKS)       = Y.REMARKS
    FOR STAT = 1 TO Y.LOAN.STAT.CNT
        R.NEW(TT.PRO.LOAN.STATUS)<1,STAT>    = Y.LOAN.STAT<1,STAT>
    NEXT STAT
    FOR COND = 1 TO Y.LOAN.COND.CNT
        R.NEW(TT.PRO.LOAN.CONDITION)<1,COND> = Y.LOAN.COND<1,COND>
    NEXT COND
RETURN
*--------------------------------------------------------------------------
END
