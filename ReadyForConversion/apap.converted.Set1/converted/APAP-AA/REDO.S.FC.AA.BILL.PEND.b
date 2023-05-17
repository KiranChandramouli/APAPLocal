SUBROUTINE REDO.S.FC.AA.BILL.PEND(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.INTEREST>L.AA.REV.RT.TY  field
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
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_ENQUIRY.COMMON
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

*another way
    CALL AA.SCHEDULE.PROJECTOR(Y.ARRG.ID, SIM.REF, "",CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)        ;* Routine to Project complete schedules

    Y.CONT = COUNT(DUE.DATES,@FM) +1
    IF Y.CONT GT 0 THEN
        FOR I.VAR=1 TO Y.CONT
            IF DUE.DATES<I.VAR> GE TODAY THEN
                AA.ARR = Y.CONT - I.VAR
                AA.ARR += 1
                BREAK
            END
        NEXT
    END
RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    Y.ARRG.ID = AA.ID
    AA.ARR = 'NULO'

    DUE.DATES = ''    ;* Holds the list of Schedule due dates
    DUE.TYPES = ''    ;* Holds the list of Payment Types for the above dates
    DUE.TYPE.AMTS = ''          ;* Holds the Payment Type amounts
    DUE.PROPS = ''    ;* Holds the Properties due for the above type
    DUE.PROP.AMTS = ''          ;* Holds the Property Amounts for the Properties above
    DUE.OUTS = ''     ;* Oustanding Bal for the date
    DUE.METHODS = ""
    TOT.PAYMENT = ''
    DATE.REQD = ''
    CYCLE.DATE = ''
    SIM.REF = ''

    V.POS = ''

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
