SUBROUTINE REDO.S.FC.AA.MATDAT(AA.ID, AA.ARR)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ACCOUNT.DETAILS>MATURITY.DAT field
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
* case 1.- AA.STATUS = EXPIRED
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ID,R.AA.ARRANGEMENT ,F.AA.ARRANGEMENT,'')
    IF R.AA.ARRANGEMENT THEN
        Y.AA.STATUS = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    END

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,'')
    IF R.AA.ACCOUNT.DETAILS THEN
        Y.COUNT.AC = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE>, @VM)
        Y.PAYOFF.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE, Y.COUNT.AC>
    END
*TUS AA changes 20161021
*  IF Y.AA.STATUS EQ 'EXPIRED' OR Y.AA.STATUS EQ  'MATURED' THEN
    IF Y.AA.STATUS EQ 'EXPIRED' OR Y.AA.STATUS EQ  'PENDING.CLOSURE' THEN
*TUS END
* LOOKING FOR A PAYOFF ACCOUNT DETAILS  in property account, AA.BD.PROPERTY
        LOCATE 'PAYOFF' IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,1> SETTING POS.Y THEN
            Y.PAYOFF.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE, POS.Y>
        END ELSE
            Y.COUNT.AC = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE>, @VM)
            Y.PAYOFF.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE, Y.COUNT.AC>
        END
        AA.ARR = Y.PAYOFF.DATE
    END ELSE
        AA.ARR = R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE>
    END

RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    AA.ARR = 'NULO'
RETURN

*------------------------
OPEN.FILES:
*=========
    FN.AA.ACCOUNT.DETAILS= 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    R.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS= 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    R.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    R.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)


RETURN
*------------
END
