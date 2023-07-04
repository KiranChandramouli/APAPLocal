* @ValidationCode : MjotMTkxMTMxMjA1NjpDcDEyNTI6MTY4NTA3OTc2ODE0MTpJVFNTOi0xOi0xOi0zOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 May 2023 11:12:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.V.AUTH.NEW.ACCT.STATUS
*-------------------------------------------------------------------------------------------
*This is auth routine to update ACTIVE status in new account creation
*-------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By     : Jayasurya H
*Program   Name    : REDO.V.AUTH.NEW.ACCT.STATUS
*---------------------------------------------------------------------------------
* LINKED WITH:
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
* MODIFICATION DETAILS:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   call routine modified
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    ACCOUNT.ID = ID.NEW

    STATUS.SEQ = 'ACTIVE'

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.STATUS'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    Y.L.AC.STATUS.POS = LREF.POS<1,1>
    R.NEW(AC.LOCAL.REF)<1,Y.L.AC.STATUS.POS> = 'AC'

*CALL REDO.UPD.ACCOUNT.STATUS.DATE(ACCOUNT.ID,STATUS.SEQ)          ;*  To update new account active status
    APAP.REDOAPAP.redoUpdAccountStatusDate(ACCOUNT.ID,STATUS.SEQ) ;*R22 MANUAL CONVERSION
RETURN
END
