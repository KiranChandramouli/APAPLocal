* @ValidationCode : MjotMjA4MjYxMTM5MzpDcDEyNTI6MTY5NjgyODQ4MzQ3MTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Oct 2023 10:44:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
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
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*06/10/2023                VIGNESHWARI       MANUAL R22 CODE CONVERSION                VM TO @VM,SM TO @SM,FM TO @FM, call rtn modified
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
    APAP.REDOAPAP.redoUpdAccountStatusDate(ACCOUNT.ID,STATUS.SEQ) ;*MANUAL R22 CODE CONVERSION-call rtn is modified
    

    RETURN
END
