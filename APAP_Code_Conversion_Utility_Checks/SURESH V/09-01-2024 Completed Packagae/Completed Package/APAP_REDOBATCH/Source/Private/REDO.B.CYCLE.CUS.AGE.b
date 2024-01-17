* @ValidationCode : MjotMTA2NTU5OTAwMDpDcDEyNTI6MTcwMzU3NjE5ODcxNTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 13:06:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
*26/12/2023         Suresh          R22 Manual Conversion      CALL routine modified

*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_REDO.B.CYCLE.CUS.AGE.COMMON

    R.CUSTOMER = ''
    Y.READ.ERR = ''
*    CALL F.READ(FN.CUSTOMER, Y.ID, R.CUSTOMER, F.CUSTOMER, Y.READ.ERR)
    CALL F.READU(FN.CUSTOMER, Y.ID, R.CUSTOMER, F.CUSTOMER, Y.READ.ERR,"") ;*R22 Manual Conversion
    IF R.CUSTOMER AND NOT(Y.READ.ERR) THEN
        R.CUSTOMER<EB.CUS.LOCAL.REF, Y.LR.CU.AGE.POS> += 1
        CALL F.WRITE(FN.CUSTOMER, Y.ID, R.CUSTOMER)
    END

RETURN
*-----------------------------------------------------------------------------------
END
*-----------------------------------------------------------------------------------
