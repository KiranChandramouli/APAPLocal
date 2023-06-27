* @ValidationCode : MjotMzM5MzU2NDM1OkNwMTI1MjoxNjgxMjAyMzY1MDg1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 14:09:25
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
$PACKAGE APAP.TAM
SUBROUTINE V.INP.DATECAL
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : PRJESH
* Program Name  : V.INP.DATECAL
* ODR Number    : ODR-2011-02-0099
*-------------------------------------------------------------------------

* Description :This validation routine used to update the field grace date
* in AZ.ACCOUNT

* Linked with: AZ.ACCOUNT
* In parameter : None
* out parameter : None
***---------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*--------------
INIT:
*---------------
    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    LOC.REF.APPLICATION="AZ.ACCOUNT"
    LOC.REF.FIELDS='L.AZ.GRACE.DAYS':@VM:'L.AZ.GR.END.DAT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    Y.GARCE.DAYS=LOC.REF.POS<1,1>
    Y.GRACE.DATE=LOC.REF.POS<1,2>
RETURN
*--------------
PROCESS:
*--------------
*    Y.ACCT.NO=ID.NEW
*   CALL F.READ(FN.AZ.ACCOUNT,Y.ACCT.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
*    R.NEW(AZ.MATURITY.DATE)=Y.MAT.DATE
    Y.MAT.DATE=R.NEW(AZ.MATURITY.DATE)
    Y.DAY=COMI

* Added the condition to check if maturity date is specified - Vignesh 25th Mar 2013

    IF Y.MAT.DATE THEN
        CALL CDT('',Y.MAT.DATE,Y.DAY)
        R.NEW(AZ.LOCAL.REF)<1,Y.GRACE.DATE>=Y.MAT.DATE
    END
RETURN
END
