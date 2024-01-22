* @ValidationCode : Mjo0MDQ0NjI3OTI6Q3AxMjUyOjE3MDM2ODI1NTc5MDc6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Dec 2023 18:39:17
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
SUBROUTINE REDO.B.AA.OVERPAYMENT.SELECT

*-------------------------------------------------
*Description: This batch routine is to post the FT OFS messages for overpayment
*             and also to credit the interest in loan..
*-------------------------------------------------
* Modification History:
* DATE              WHO                REFERENCE                 DESCRIPTION
* 29-MAR-2023      Conversion Tool    R22 Auto conversion       No changes
* 29-MAR-2023      Harishvikram C     Manual R22 conversion   No changes
*27-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION       call rtn modified
*-------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.AA.OVERPAYMENT.COMMON
    $USING EB.Service


    GOSUB PROCESS
RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    SEL.CMD = "SELECT ":FN.REDO.AA.OVERPAYMENT:" WITH STATUS EQ PENDIENTE AND NEXT.DUE.DATE GT ":R.DATES(EB.DAT.LAST.WORKING.DAY):" AND NEXT.DUE.DATE LE ":TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
   * CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 MANUAL CONVERSTION-call rtn modified


RETURN
END
