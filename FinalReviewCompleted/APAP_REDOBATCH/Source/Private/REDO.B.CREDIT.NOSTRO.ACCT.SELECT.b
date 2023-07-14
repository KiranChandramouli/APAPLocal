* @ValidationCode : MjoxMzMxMDY0OTk0OkNwMTI1MjoxNjg0ODU0MzgzNzQ4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CREDIT.NOSTRO.ACCT.SELECT
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CREDIT.NOSTRO.ACCT.SELECT
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.CREDIT.NOSTRO.ACCT

* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.DETAILS
    $INSERT I_REDO.B.CREDIT.NOSTRO.ACCT.COMMON


    SEL.CMD=''
    SEL.LIST=''
    NO.OF.REC=''
    ERR=''
    SEL.CMD="SELECT ":FN.REDO.MANAGER.CHQ.DETAILS:" WITH ISSUE.DATE EQ ":LAST.WORK.DATE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
