* @ValidationCode : MjotOTc1MjExODY5OkNwMTI1MjoxNjgwNjkwNDYwOTcwOklUU1M6LTE6LTE6LTk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:57:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UP.TRANS.PROCESS.SELECT
*-----------------------------------------------------------------------------
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Sakthi Sellappillai
* PROGRAM NAME : REDO.B.UP.TRANS.PROCESS.SELECT
* ODR          : ODR-2010-08-0031
*------------------------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------------------------
* DATE             WHO                     REFERENCE               DESCRIPTION
*===========      =================        =================       ================
*07.10.2010       Sakthi Sellappillai      ODR-2010-09-0171        INITIAL CREATION
* 04-APR-2023     Conversion tool   	 R22 Auto conversion       No changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.ISSUE.MAIL
    $INSERT I_REDO.B.UP.TRANS.PROCESS.COMMON
    $INSERT I_F.REDO.SUPPLIER.PAYMENT
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_F.REDO.SUPPLIER.PAY.DATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.EXTERNAL.USER
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------

    Y.TODAY = TODAY
*TODAY
    SEL.CMD   = "SELECT " :FN.REDO.FILE.DATE.PROCESS: " WITH @ID LIKE " :" ...":Y.TODAY:" AND MAIL.STATUS EQ '' AND OFS.PROCESS EQ 'COMPLETED'"
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
END
*-------------------------------------*END OF SUBROUTINE*----------------------------------
