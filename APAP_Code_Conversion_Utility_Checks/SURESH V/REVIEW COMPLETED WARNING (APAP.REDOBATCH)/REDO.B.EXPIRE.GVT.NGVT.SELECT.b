* @ValidationCode : MjotMTg3Njc1NjkzNzpDcDEyNTI6MTcwMzU5Mjk1MTA5MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 17:45:51
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
SUBROUTINE REDO.B.EXPIRE.GVT.NGVT.SELECT
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.NON.CONFIRM.PAY.SELECT
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.EXPIRE.GVT.NGVT

* In parameter : None
* out parameter : None
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                 R22 Manual Conversion    CALL routine modified, Add $USING
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_REDO.B.EXPIRE.GVT.NGVT.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion

    SEL.CMD=''
    SEL.LIST=''
    NO.OF.REC=''
    ERR=''

    SEL.CMD="SELECT ":FN.REDO.ADMIN.CHQ.DETAILS:" WITH (CHEQUE.INT.ACCT EQ ":NON.GVMNT.ACCT:" OR CHEQUE.INT.ACCT EQ ":GVMNT.ACCT:") AND ISSUE.DATE LT ":BEFORE.X.MNTHS:" AND STATUS EQ ISSUED"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 Manual Conversion
RETURN
END
