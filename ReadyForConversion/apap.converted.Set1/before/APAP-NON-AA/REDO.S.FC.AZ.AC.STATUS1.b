*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.S.FC.AZ.AC.STATUS1(AC.ID, AC.REC)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
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
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
* Gopala Krishnan R - DEFECT-2388655 - 29-DEC-2017
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

    RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.REV.RT.TYPE.POS = LOC.REF.POS<1,1>

    IF Y.REV.RT.TYPE.POS GT 0 THEN
        Y.AC.STATUS1 = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.REV.RT.TYPE.POS>   ;* This hold the Value in the local field
        AC.REC = Y.AC.STATUS1
    END
    RETURN
*------------------------
INITIALISE:
*=========

    PROCESS.GOAHEAD = 1
    LOC.REF.APPL="AZ.ACCOUNT"
    LOC.REF.FIELDS="L.AC.STATUS1"
    LOC.REF.POS=" "
    AC.REC = 'NULO'
    RETURN

*------------------------
OPEN.FILES:
*=========

    FN.AZ.ACCOUNT = "F.AZ.ACCOUNT"
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    CALL F.READ(FN.AZ.ACCOUNT,AC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,"")
    RETURN
*------------
END
