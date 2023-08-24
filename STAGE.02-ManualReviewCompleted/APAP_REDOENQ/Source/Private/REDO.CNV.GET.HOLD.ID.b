* @ValidationCode : MjoxNzk5ODM5MDU3OkNwMTI1MjoxNjgyMDczMzc5NTY2OklUU1M6LTE6LTE6MTgzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 183
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CNV.GET.HOLD.ID
*********************************************************************************************************
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 17-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
***Input argument extract first 6 charcter from date.time field

    FN.DEP.REPRINT = 'F.REDO.DEP.REPRINT.DETAILS'
    F.DEP.REPRINT = ''
    CALL OPF(FN.DEP.REPRINT,F.DEP.REPRINT)

    AZ.ID = O.DATA

    CALL F.READ(FN.DEP.REPRINT,AZ.ID,R.HOLD.ID,F.DEP.REPRINT,DEP.ERR)

    O.DATA = R.HOLD.ID

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
