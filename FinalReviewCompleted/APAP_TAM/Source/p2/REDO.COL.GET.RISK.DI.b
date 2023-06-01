$PACKAGE APAP.TAM
SUBROUTINE REDO.COL.GET.RISK.DI (Y.AA.PROD.CUR,Y.RISK.PERC)
*-----------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : COLLATERAL
* Attached as     : API ROUTINE
* Primary Purpose : GET BACK THE BALANCE OF AMOUNT
* Incoming:
* ---------
* Y.AA.PROD.CUR <1> --> AA ID PRODUCT
* Y.AA.PROD.CUR <2> --> AA PRODUCT CURRENCY
* Outgoing:
* ---------
* Y.RISK.PREC --> RISK PERC.
* Error Variables:
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo - TAM Latin America
* Date            : February 26 2013
*
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.TERM.AMOUNT

    IF NOT(Y.AA.PROD.CUR) THEN
        Y.RISK.PERC = 'ERROR'
    END
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

* =========
INITIALISE:
* =========
    FN.AA.PRD.CAT.TERM.AMOUNT = 'F.AA.PRD.CAT.TERM.AMOUNT'
    F.AA.PRD.CAT.TERM.AMOUNT  = ''
    R.AA.PRD.CAT.TERM.AMOUNT  = ''

    AA.PRD.CAT.TERM.AMOUNT.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''

    LOC.REF.APPLICATION = 'AA.PRD.CAT.TERM.AMOUNT'
    LOC.REF.FIELDS      = 'L.AA.RISK.PER'
    LOC.REF.POS         = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    TXN.REF.ID.POS = LOC.REF.POS<1,1>     ;*AA.PRD.CAT.TERM.AMOUNT L.FIELD.POS

RETURN

* =========
OPEN.FILES:
* =========
    CALL OPF(FN.AA.PRD.CAT.TERM.AMOUNT,F.AA.PRD.CAT.TERM.AMOUNT)

RETURN
* ======
PROCESS:
* ======
    Y.ID.ARR.PRD.CAT.TERM.AMOUNT = Y.AA.PROD.CUR <1>:'-COMMITMENT':'-':Y.AA.PROD.CUR <2>:'...'
    SELECT.STATEMENT = 'SELECT ':FN.AA.PRD.CAT.TERM.AMOUNT:' ':'WITH @ID LIKE ':Y.ID.ARR.PRD.CAT.TERM.AMOUNT

    CALL EB.READLIST(SELECT.STATEMENT,AA.PRD.CAT.TERM.AMOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    REMOVE Y.ID.AA.PRD FROM AA.PRD.CAT.TERM.AMOUNT.LIST SETTING POS

    CALL F.READ(FN.AA.PRD.CAT.TERM.AMOUNT, Y.ID.AA.PRD, R.ARR.PRD.CAT.TERM.AMOUNT,F.AA.PRD.CAT.TERM.AMOUNT, Y.ERR)

    Y.RISK.PERC = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.LOCAL.REF,TXN.REF.ID.POS>


RETURN

END
