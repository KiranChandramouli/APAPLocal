SUBROUTINE REDO.S.FC.AA.NOMBREGR(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.FC.ENQPARMS
* Attached as     : ROUTINE
* Primary Purpose : Get the value of RISK.GRP.DESC
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
    $INSERT I_F.REDO.RISK.GROUP




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

    CALL F.READ(FN.REDO.RISK.GROUP,Y.RISK,R.REDO.RISK.GROUP,F.REDO.RISK.GROUP,Y.ERR.RISK.GROUP)

    IF Y.ERR.RISK.GROUP THEN
        AA.ARR = Y.ERR.RISK.GROUP
        RETURN
    END ELSE
        AA.ARR = R.REDO.RISK.GROUP<RG.RISK.GRP.DESC>
    END



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

    FN.REDO.RISK.GROUP="F.REDO.RISK.GROUP"
    F.REDO.RISK.GROUP=""

RETURN
*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
