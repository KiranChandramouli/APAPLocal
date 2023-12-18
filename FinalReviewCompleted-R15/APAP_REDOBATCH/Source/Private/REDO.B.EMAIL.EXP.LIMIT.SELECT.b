* @ValidationCode : MjoxNTEwMDIxNzgyOkNwMTI1MjoxNzAyNjU4MzEzNzc2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjNfU1A0LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Dec 2023 22:08:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R23_SP4.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2023. All rights reserved.
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
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-05-2023              Edwin D                  R22 Code conversion
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT
    $INSERT I_F.REDO.APAP.FX.BRN.COND
    $INSERT I_F.REDO.APAP.FX.BRN.POSN
    $INSERT I_F.REDO.APAP.USER.LIMITS
    $INSERT I_REDO.B.EMAIL.EXP.LIMIT.COMMON

    $INSERT I_F.REDO.MM.CUST.LIMIT

*    SEL.CMD1='SELECT ' : FN.REDO.APAP.FX.BRN.COND :' SAVING EVAL ': '"@ID : ' : "'*REDO.APAP.FX.BRN.COND'" : '"' ; * R22 code conversion
   
    SEL.CMD1='SELECT ' : FN.REDO.APAP.FX.BRN.COND
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',SEL.ID,ERR)
    SEL.LIST1 = SPLICE(SEL.LIST1,'*REDO.APAP.FX.BRN.COND', '')

*    SEL.CMD2='SELECT ' : FN.REDO.APAP.FX.BRN.POSN :' SAVING EVAL ': '"@ID : ' : "'*REDO.APAP.FX.BRN.POSN'" : '"' ; * R22 code conversion
    SEL.CMD2='SELECT ' : FN.REDO.APAP.FX.BRN.POSN
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',SEL.ID,ERR)
    SEL.LIST2 = SPLICE(SEL.LIST2,'*REDO.APAP.FX.BRN.POSN', '')
    
*    SEL.CMD3='SELECT ' : FN.REDO.APAP.USER.LIMITS :' SAVING EVAL ': '"@ID : ' : "'*REDO.APAP.USER.LIMITS'" : '"' ; * R22 code conversion
    SEL.CMD3='SELECT ' : FN.REDO.APAP.USER.LIMITS
    CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',SEL.ID,ERR)
    SEL.LIST3 = SPLICE(SEL.LIST3,'*REDO.APAP.FX.BRN.POSN', '')
 
*    SEL.CMD4='SELECT ' :  FN.REDO.MM.CUST.LIMIT :' SAVING EVAL ': '"@ID : ' : "'*REDO.MM.CUST.LIMIT'" : '"' ; * R22 code conversion
    SEL.CMD4='SELECT ' :  FN.REDO.MM.CUST.LIMIT
    CALL EB.READLIST(SEL.CMD4,SEL.LIST4,'',SEL.ID,ERR)
    SEL.LIST4 = SPLICE(SEL.LIST4,'*FN.REDO.MM.CUST.LIMIT', '')

    SEL.IDS<-1>=SEL.LIST1
    SEL.IDS<-1>=SEL.LIST2
    SEL.IDS<-1>=SEL.LIST3
    SEL.IDS<-1>=SEL.LIST4

    CALL BATCH.BUILD.LIST('',SEL.IDS)


RETURN
END
