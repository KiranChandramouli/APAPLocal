* @ValidationCode : MjoyMDY1MTEyOTIxOkNwMTI1MjoxNjgwNjkwNDYxNzE1OklUU1M6LTE6LTE6Mjg2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:57:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 286
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BLD.USER.ACCT.SIGN(ENQ.DATA)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Riyas
*Program   Name    :REDO.BLD.USER.ACCT.SIGN
*---------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool   R22 Auto conversion         if condition added
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.IM.DOCUMENT.IMAGE
    $INSERT I_System
    $INSERT I_F.ACCOUNT

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

OPEN.FILES:
*----------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

PROCESS:
*-------

    Y.ACCOUNT.ID = System.getVariable("CURRENT.ACCOUNT.NUM")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - Start
        Y.ACCOUNT.ID = ""
    END			;*R22 Auto conversion - End

    LOCATE 'IMAGE.REFERENCE' IN ENQ.DATA<2,1> SETTING POS1 THEN
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            ENQ.DATA<4,POS1> = Y.ACCOUNT.ID :' ':R.ACCOUNT<AC.CUSTOMER>
        END ELSE
            ENQ.DATA<4,POS1> = Y.ACCOUNT.ID
        END
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            ENQ.DATA<2,-1> = 'IMAGE.REFERENCE'
            ENQ.DATA<3,-1> = 'EQ'
            ENQ.DATA<4,-1> = Y.ACCOUNT.ID :' ':R.ACCOUNT<AC.CUSTOMER>
        END ELSE

            ENQ.DATA<2,-1> = 'IMAGE.REFERENCE'
            ENQ.DATA<3,-1> = 'EQ'
            ENQ.DATA<4,-1> = Y.ACCOUNT.ID
        END
    END

RETURN

END
