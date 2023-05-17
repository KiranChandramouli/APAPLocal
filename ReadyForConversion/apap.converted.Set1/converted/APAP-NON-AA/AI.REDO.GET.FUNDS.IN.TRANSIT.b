SUBROUTINE AI.REDO.GET.FUNDS.IN.TRANSIT
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Martin Macias
* Program Name :
*-----------------------------------------------------------------------------
* Description    :  This routine will get all funds in transit for a Customer Acct
* Linked with    :
* In Parameter   :
* Out Parameter  :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    $INSERT I_F.REDO.CLEARING.OUTWARD

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*----------*
INITIALISE:
*----------*

    FN.REDO.CLEARING.OUTWARD = "F.REDO.CLEARING.OUTWARD"
    F.REDO.CLEARING.OUTWARD = ''

    ACCT.NO = O.DATA
    AMT.FUNDS = 0

RETURN

*----------*
OPEN.FILES:
*----------*

    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

RETURN

*--------*
PROCESS:
*--------*

    SEL.CMD = "SELECT ":FN.REDO.CLEARING.OUTWARD:" WITH CHQ.STATUS EQ 'DEPOSITED' AND ACCOUNT EQ ":ACCT.NO
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.ERR)


    I.VAR = 1
    LOOP
    WHILE I.VAR LE NO.OF.REC
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,SEL.LIST<I.VAR>,R.FUNDS,F.REDO.CLEARING.OUTWARD,FUNDS.ERR)
        AMT.FUNDS += R.FUNDS<CLEAR.OUT.AMOUNT>
        I.VAR += 1
    REPEAT

    O.DATA = AMT.FUNDS

RETURN

END
