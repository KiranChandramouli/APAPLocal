* @ValidationCode : MjotMTM3NTU1MTI2NjpDcDEyNTI6MTY4MjA3ODg3MTMzMjpJVFNTOi0xOi0xOjIwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.PARENT.COMMENT.DET
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 07-03-2012         RIYAS      ODR-2012-03-0162     Initial Creation
* 18-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.EB.SECURE.MESSAGE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.AUT.INP.VERSION.NAME
    $INSERT I_ENQUIRY.COMMON

    FN.EB.SECURE.MESSAGE = 'F.EB.SECURE.MESSAGE'
    F.EB.SECURE.MESSAGE  = ''
    CALL OPF(FN.EB.SECURE.MESSAGE,F.EB.SECURE.MESSAGE)

    APPL.ARRAY = "EB.SECURE.MESSAGE"
    FIELD.ARRAY = "L.ESM.MSG.REP"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    Y.L.ESM.MSG.REP = FIELD.POS<1,1>

    CALL F.READ(FN.EB.SECURE.MESSAGE,O.DATA,R.EB.SECURE.MESSAGE,F.EB.SECURE.MESSAGE,EB.SECURE.MESSAGE.ERR)
    Y.PARENT.MSG.ID = R.EB.SECURE.MESSAGE<EB.SM.PARENT.MESSAGE.ID>
    O.DATA = R.EB.SECURE.MESSAGE<EB.SM.LOCAL.REF,Y.L.ESM.MSG.REP>
    IF Y.PARENT.MSG.ID THEN
        O.DATA = R.EB.SECURE.MESSAGE<EB.SM.MESSAGE>
        Y.CUS.REPLY =  R.EB.SECURE.MESSAGE<EB.SM.LOCAL.REF,Y.L.ESM.MSG.REP>
        IF O.DATA AND Y.CUS.REPLY THEN
            O.DATA = Y.CUS.REPLY
        END
    END


RETURN
