* @ValidationCode : Mjo2MjE0MTY1MzA6Q3AxMjUyOjE2ODExOTEyMDU0ODQ6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:03:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.EMAIL.EXP.LIMIT.SELECT
*-----------------------------------------------------------------------------
* Company Name  : APAP
* Developed By  : Balagurunathan
*-----------------------------------------------------------------
* Description :
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* PACS00242938        23-Jan-2013           Cob job to raise email
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT
    $INSERT I_F.REDO.APAP.FX.BRN.COND
    $INSERT I_F.REDO.APAP.FX.BRN.POSN
    $INSERT I_F.REDO.APAP.USER.LIMITS
    $INSERT I_REDO.B.EMAIL.EXP.LIMIT.COMMON

    $INSERT I_F.REDO.MM.CUST.LIMIT

    SEL.CMD1='SELECT ' : FN.REDO.APAP.FX.BRN.COND :' SAVING EVAL ': '"@ID : ' : "'*REDO.APAP.FX.BRN.COND'" : '"'
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',SEL.ID,ERR)

    SEL.CMD2='SELECT ' : FN.REDO.APAP.FX.BRN.POSN :' SAVING EVAL ': '"@ID : ' : "'*REDO.APAP.FX.BRN.POSN'" : '"'
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',SEL.ID,ERR)

    SEL.CMD3='SELECT ' : FN.REDO.APAP.USER.LIMITS :' SAVING EVAL ': '"@ID : ' : "'*REDO.APAP.USER.LIMITS'" : '"'
    CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',SEL.ID,ERR)

    SEL.CMD4='SELECT ' :  FN.REDO.MM.CUST.LIMIT :' SAVING EVAL ': '"@ID : ' : "'*REDO.MM.CUST.LIMIT'" : '"'
    CALL EB.READLIST(SEL.CMD4,SEL.LIST4,'',SEL.ID,ERR)

    SEL.IDS<-1>=SEL.LIST1
    SEL.IDS<-1>=SEL.LIST2
    SEL.IDS<-1>=SEL.LIST3
    SEL.IDS<-1>=SEL.LIST4

    CALL BATCH.BUILD.LIST('',SEL.IDS)


RETURN
END
