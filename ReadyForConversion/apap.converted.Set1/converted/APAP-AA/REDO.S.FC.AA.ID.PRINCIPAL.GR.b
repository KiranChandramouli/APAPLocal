SUBROUTINE REDO.S.FC.AA.ID.PRINCIPAL.GR(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.FC.ENQPARMS
* Attached as     : ROUTINE
* Primary Purpose : Get all clients that match with the group of risk
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
* Development by  : Bryan Torres- TAM Latin America
* Date            : 9/26/2001
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======



    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUSTOMER)
    IF Y.ERR.CUSTOMER THEN
        AA.ARR = Y.ERR.CUSTOMER
        RETURN
    END ELSE
        Y.RISK = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSUGRPRISK>
    END

    SELECT.STATEMENT = 'SELECT ':FN.CUSTOMER :' WITH L.CU.GRP.RIESGO ':'EQ ':Y.RISK
    LOCK.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,LOCK.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    LOOP
        REMOVE Y.ID.CUS FROM LOCK.LIST SETTING POS
    WHILE Y.ID.CUS:POS
        CALL CACHE.READ(FN.CUSTOMER, Y.ID.CUS, R.CUS, Y.ERR.CUS)
        IF Y.ERR.CUS THEN
            AA.ARR = Y.ERR.CUS
            RETURN
        END ELSE
            Y.RELATION.CODE = R.CUS<EB.CUS.RELATION.CODE>
            GOSUB ADD.ARR
        END



    REPEAT
RETURN
*-----------------------------------------------------------------------------------
ADD.ARR:
*======

    LOCATE "100" IN Y.RELATION.CODE<1,1> SETTING YPOS.RELATION THEN
        AA.ARR<-1>=Y.ID.CUS
    END ELSE
        LOCATE "102" IN Y.RELATION.CODE<1,1> SETTING YPOS.RELATION THEN
            AA.ARR<-1>=Y.ID.CUS
        END
    END

    AA.ARR = CHANGE(AA.ARR,@FM," ")



RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1

    FN.CUSTOMER="F.CUSTOMER"
    F.CUSTOMER=""
    Y.CUS.ID = AA.ID
    WCAMPOU = "L.CU.GRP.RIESGO"
    WCAMPOU = CHANGE(WCAMPOU,@FM,@VM)
    YPOSU=''
    CALL MULTI.GET.LOC.REF("CUSTOMER",WCAMPOU,YPOSU)
    WPOSUGRPRISK  = YPOSU<1,1>
    AA.ARR=""



RETURN
*------------------------
OPEN.FILES:
*=========
    CALL OPF (FN.CUSTOMER,F.CUSTOMER)

RETURN
*------------
END
