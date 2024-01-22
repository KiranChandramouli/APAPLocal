* @ValidationCode : MjoxNzQwNzg3ODgxOkNwMTI1MjoxNzAzNjc5OTc5MTkwOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Dec 2023 17:56:19
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
$PACKAGE APAP.AA
SUBROUTINE REDO.B.AA.CHEQUE.AMOUNT.SELECT
*-------------------------------------------------------------------------------------------------
* Description: This routine is a Select routine of batch routine to update the cheque amount among the transaction.
*-----------------------------------------------------------------------------------------------
* Input  Arg: N/A
* Output Arg: N/A
*---------------------------------------------------------------------------------------------
* Modification History:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 29-MAR-2023      Conversion Tool    R22 Auto conversion       No changes
* 29-MAR-2023      Harishvikram C     Manual R22 conversion     No changes
*27-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION       call rtn modified
*------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AA.CHEQUE.AMOUNT.COMMON
    $USING EB.Service
    

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    SEL.CMD = 'SELECT ':FN.REDO.CONCAT.CHQ.TXN
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
  *  CALL BATCH.BUILD.LIST('',SEL.LIST)
  EB.Service.BatchBuildList('',SEL.LIST) ;*R22 MANUAL CODE CONVERSION-CALL RTN MODIFIED

RETURN
END
