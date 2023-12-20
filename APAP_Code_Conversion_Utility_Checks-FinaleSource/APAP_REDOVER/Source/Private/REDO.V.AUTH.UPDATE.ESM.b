* @ValidationCode : MjoxMzEwNDAwMzcxOkNwMTI1MjoxNjgyNDEyMzQwNjUyOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.UPDATE.ESM
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.V.ACH.POP.DETAILS
*-----------------------------------------------------------------------------
* Description :
* Linked with :
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*21/09/11      PACS00106561           PRABHU N                   MODIFICATION
*Modification history
*Date                Who               Reference                  Description
*13-04-2023      conversion tool     R22 Auto code conversion    IF Condition Added
*13-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.EB.SECURE.MESSAGE


    GOSUB OPEN.FILES
    GOSUB UPDATE.EB.SEC.MSG
RETURN
*-----------*
OPEN.FILES:
*-----------*

    FN.ARCIB.PARAM='F.AI.REDO.ARCIB.PARAMETER'
    F.ARCIB.PARAM=''
    CALL OPF(FN.ARCIB.PARAM,F.ARCIB.PARAM)
    Y.CUSTOMER.ID=System.getVariable('EXT.CUSTOMER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto code conversion-START
        Y.CUSTOMER.ID = ""
    END ;*R22 Auto code conversion-END

* FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
* F.FT.COMMISSION.TYPE=''
* CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

RETURN

*------------*
UPDATE.EB.SEC.MSG:
*------------*
    R.SECURE.MSG=''
    R.SECURE.MSG<EB.SM.FROM.CUSTOMER> =Y.CUSTOMER.ID
    R.SECURE.MSG<EB.SM.SUBJECT>=R.NEW(FT.PAYMENT.DETAILS)<1,1>
    R.SECURE.MSG<EB.SM.MESSAGE,1>=R.NEW(FT.PAYMENT.DETAILS)<1,1>
    TRANS.FUNC.VAL = 'I'
    APPLICATION.ID = ''
    APPLICATION.NAME.VERSION = 'EB.SECURE.MESSAGE,MSG.INPUT'
    OFS.SOURCE.ID = 'REDO.MSG.UPD'
    APPLICATION.NAME = 'EB.SECURE.MESSAGE'
    TRANS.OPER.VAL = 'PROCESS'
    NO.AUT = ''
    OFS.MSG.ID = ''
    OFS.REQ.MSG = ''
    CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.SECURE.MSG,OFS.REQ.MSG)
    CALL OFS.POST.MESSAGE(OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN

END
