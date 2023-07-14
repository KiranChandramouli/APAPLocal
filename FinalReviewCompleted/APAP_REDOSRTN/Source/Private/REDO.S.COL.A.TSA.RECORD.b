* @ValidationCode : MjotMTQzMTMyMjgzOkNwMTI1MjoxNjgyNDE1MTM4ODE2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 15:02:18
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
SUBROUTINE REDO.S.COL.A.TSA.RECORD
*------------------------------------------------------------------------------------------------------------------
* Developer    : jvalarezoulloa@temenos.com
* Date         : 2012-04-16
* Description  : Store comments in history Local fields
* Input/Output:
* -------------
* In  :
*
* Out :
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

*------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TSA.SERVICE

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------------------
    R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,1>> = R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,1>> : @SM : R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,3>>        ;*COL.INPUTTER.HIS
    R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,2>> = R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,2>> : @SM : R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,4>>        ;*COL.COMMENTS.HIS
    R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,3>> = ''          ;*COL.INPUTTER
    R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,4>>  = ''         ;*COL.COMMENTS
RETURN

*------------------------------------------------------------------------------------------------------------------
GET.LOCAL.FIELD:
*------------------------------------------------------------------------------------------------------------------

    L.FLD<1,1> = "COL.INPUT.HIS"
    L.FLD<1,2> = "COL.COMM.HIS"
    L.FLD<1,3> = "COL.INPUTTER"
    L.FLD<1,4> = "COL.COMMENTS"
    LOC.REF.APPLICATION = 'TSA.SERVICE'
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,L.FLD,LOC.REF.POS)

RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------------------------------------
    L.FLD = ''
    TXN.REF.ID.POS=''
    LOC.REF.POS = ''
    GOSUB GET.LOCAL.FIELD
    FN.TSA.SERVICE = 'F.TSA.SERVICE'
    F.TSA.SERVICE = ''
    R.TSA.SERVICE = ''
    YERR = ''
RETURN
*------------------------------------------------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------------------------------------------------
    CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)

RETURN
*------------------------------------------------------------------------------------------------------------------
END
