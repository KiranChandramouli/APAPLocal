* @ValidationCode : Mjo2MjI4MzQ3ODI6Q3AxMjUyOjE2ODA3OTAxMDg1ODU6SVRTUzotMTotMToxOTg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 198
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CYCLE.CUS.AGE(Y.ID)
*-----------------------------------------------------------------------------------
* Description: Subroutine to cycle the age of the customers for whom the b'day falls
* on today or the number of calendar days before the last working day
* Programmer: M.MURALI (Temenos Application Management)
* Creation Date: 03 Jul 09
*-----------------------------------------------------------------------------------
* Modification History:
** DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_REDO.B.CYCLE.CUS.AGE.COMMON

    R.CUSTOMER = ''
    Y.READ.ERR = ''
    CALL F.READ(FN.CUSTOMER, Y.ID, R.CUSTOMER, F.CUSTOMER, Y.READ.ERR)
    IF R.CUSTOMER AND NOT(Y.READ.ERR) THEN
        R.CUSTOMER<EB.CUS.LOCAL.REF, Y.LR.CU.AGE.POS> += 1
        CALL F.WRITE(FN.CUSTOMER, Y.ID, R.CUSTOMER)
    END

RETURN
*-----------------------------------------------------------------------------------
END
*-----------------------------------------------------------------------------------
