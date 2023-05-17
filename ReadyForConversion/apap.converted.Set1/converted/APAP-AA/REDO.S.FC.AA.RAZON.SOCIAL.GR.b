SUBROUTINE REDO.S.FC.AA.RAZON.SOCIAL.GR(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.FC.ENQPARMS
* Attached as     : ROUTINE
* Primary Purpose :
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
* Date            : 9/27/2001
*
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


        Y.CUS.TIPO = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSUGRPRISK>
        Y.CUS.NAME1 = R.CUSTOMER<EB.CUS.NAME.1>
        Y.CUS.NAME2 = R.CUSTOMER<EB.CUS.NAME.2>
        Y.CUS.FAMILY.NAME = R.CUSTOMER<EB.CUS.FAMILY.NAME>

        IF Y.CUS.TIPO EQ "PERSONA FISICA" THEN
            AA.ARR=Y.CUS.NAME1:" ":Y.CUS.NAME2:" ":Y.CUS.FAMILY.NAME
        END
        IF Y.CUS.TIPO EQ "PERSONA JURIDICA" THEN
            AA.ARR=Y.CUS.NAME1:Y.CUS.NAME2
        END


        RETURN
*------------------------
INITIALISE:
*=========
        PROCESS.GOAHEAD = 1

        FN.CUSTOMER="F.CUSTOMER"
        F.CUSTOMER=""
        Y.CUS.ID = AA.ID
        WCAMPOU = "L.CU.TIPO.CL"
        WCAMPOU = CHANGE(WCAMPOU,@FM,@VM)
        YPOSU=''
        CALL MULTI.GET.LOC.REF("CUSTOMER",WCAMPOU,YPOSU)
        WPOSUGRPRISK  = YPOSU<1,1>



        RETURN

*------------------------
OPEN.FILES:
*=========

        RETURN
*------------
    END
