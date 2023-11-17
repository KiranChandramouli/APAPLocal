* @ValidationCode : MjotMTQxNDM1NTUyODpDcDEyNTI6MTY5MDE2NzU1NjQwMDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>90</Rating>
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   INSERT FILE MISSING
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.CREDIT.CARD.UPD.SELECT

* One time routine update the REDO.APAP.CREDIT.CARD.DET table
* Ashokkumar
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT  I_F.REDO.APAP.CREDIT.CARD.DET
    $INSERT  I_REDO.APAP.CREDIT.CARD.UPD.COMMON ;* R22 MANUAL CONVERSION


    GOSUB PROCESS
RETURN


PROCESS:
********
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT ":FN.SAVELST
    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)

    READ R.SAVELST FROM F.SAVELST,SEL.REC ELSE RETURN
    CALL BATCH.BUILD.LIST('',R.SAVELST)
RETURN
END
