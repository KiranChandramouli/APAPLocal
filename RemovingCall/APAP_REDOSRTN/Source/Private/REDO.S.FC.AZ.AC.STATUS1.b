* @ValidationCode : MjoxNjc4MTIwNTczOkNwMTI1MjoxNjgyNDE1MTQxMTA2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 15:02:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
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
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

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
