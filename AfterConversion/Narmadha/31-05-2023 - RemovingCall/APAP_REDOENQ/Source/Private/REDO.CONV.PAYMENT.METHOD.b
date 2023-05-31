* @ValidationCode : MjotMTAzNTc0OTYxOTpVVEYtODoxNjg1NTMwMTgxMTg3OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 16:19:41
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.PAYMENT.METHOD
*--------------------------------------------------------
*Description: This conversion routine is to get the payment method
*             for a loan in overview screen.
*--------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.DYNAMIC.TEXT

    GOSUB PROCESS
RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------


    LOCATE "ARRANGEMENT.ID" IN ENQ.SELECTION<2,1> SETTING POS1 THEN
        Y.ARR.ID = ENQ.SELECTION<4,POS1>
    END ELSE
        RETURN
    END


    LOC.REF.APPLICATION   = "AA.PRD.DES.PAYMENT.SCHEDULE"
    LOC.REF.FIELDS        = 'L.AA.PAY.METHD'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.PAY.METHD    = LOC.REF.POS<1,1>

    EFF.DATE   = ''
    PROP.CLASS ='PAYMENT.SCHEDULE'
    PROPERTY   = ''
    R.CONDITION= ''
    ERR.MSG    = ''
    APAP.TAM.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG);*R22 Manual Conversion
    Y.PAYMENT.METHOD = R.CONDITION<AA.PS.LOCAL.REF,POS.L.AA.PAY.METHD>
    GOSUB GET.TEXT
RETURN
*------------------------------------------
GET.TEXT:
*------------------------------------------
    FN.DYNAMIC.TEXT = 'F.DYNAMIC.TEXT'
    F.DYNAMIC.TEXT  = ''
    CALL OPF(FN.DYNAMIC.TEXT,F.DYNAMIC.TEXT)

    CHANGE ' ' TO '.' IN Y.PAYMENT.METHOD
    CALL F.READ(FN.DYNAMIC.TEXT,Y.PAYMENT.METHOD,R.DYNAMIC.TXT,F.DYNAMIC.TEXT,DY.ERR)
    IF R.DYNAMIC.TXT THEN
        IF R.DYNAMIC.TXT<LNGG> THEN
            O.DATA = R.DYNAMIC.TXT<LNGG>
        END ELSE
*    O.DATA = R.DYNAMIC.TXT<1> ;*Tus Start
            O.DATA = R.DYNAMIC.TXT<EB.DYNAMIC.TEXT.1> ;*Tus End
        END
    END

RETURN
END
