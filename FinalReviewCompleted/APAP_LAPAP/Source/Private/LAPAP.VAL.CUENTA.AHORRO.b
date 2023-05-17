* @ValidationCode : MjotMzExMTYxMTAzOkNwMTI1MjoxNjg0MjIyODE4Njg4OklUU1M6LTE6LTE6MTg0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 184
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Item ID        : CN009003
*-------------------------------------------------------------------------------------
* Description :
* ------------
*This program raise error if Account doesnt belong to Saving Account
*-------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018/11/14     Raquel P.S.         Initial development
*-------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Versions  : TELLER,L.APAP.NOMINA
* EB record : LAPAP.VAL.CUENTA.AHORRO
*-------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------

SUBROUTINE LAPAP.VAL.CUENTA.AHORRO

    $INSERT I_COMMON   ;*R22 AUTO CODE COVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_F.ACCOUNT    ;*R22 AUTO CODE COVERSION.END


**Tables Loading
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

**Getting initial variables
    Y.ID.AC=COMI

**Evaluation of Account Category
    CALL F.READ(FN.ACCOUNT ,Y.ID.AC,R.ACCOUNT, F.ACCOUNT, AC.ERR)
    Y.CATEGORY   = R.ACCOUNT<AC.CATEGORY>

    IF Y.CATEGORY NE '' AND Y.ID.AC NE ''
    THEN
        GOSUB EVALUATE.CATEG
    END ELSE
        RETURN
    END

***************
EVALUATE.CATEG:
***************
    IF (Y.CATEGORY GE 6001 AND Y.CATEGORY LT 6011 ) OR (Y.CATEGORY GE 6021 AND Y.CATEGORY LT 6099) OR (Y.CATEGORY GE 6500 AND Y.CATEGORY LT 6599)
    THEN
        RETURN
    END ELSE
        GOSUB RAISE.ERROR
    END
RETURN

***************
RAISE.ERROR:
***************
    ETEXT='ERROR: CUENTA NO CORRESPONDE A CATEGORIA DE AHORRO'
    CALL STORE.END.ERROR
RETURN

END
